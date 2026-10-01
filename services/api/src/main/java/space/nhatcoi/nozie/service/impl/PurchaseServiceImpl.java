package space.nhatcoi.nozie.service.impl;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.PurchaseResponse;
import space.nhatcoi.nozie.dto.response.TransactionResponse;
import space.nhatcoi.nozie.entity.Movie;
import space.nhatcoi.nozie.entity.Purchase;
import space.nhatcoi.nozie.mapper.LibraryMapper;
import space.nhatcoi.nozie.mapper.MovieMapper;
import space.nhatcoi.nozie.repository.MovieRepository;
import space.nhatcoi.nozie.repository.PaymentTransactionRepository;
import space.nhatcoi.nozie.repository.PurchaseRepository;
import space.nhatcoi.nozie.service.PurchaseService;
import space.nhatcoi.nozie.util.LikePattern;

@Service
@Transactional
public class PurchaseServiceImpl implements PurchaseService {

    private final PurchaseRepository purchaseRepository;
    private final PaymentTransactionRepository transactionRepository;
    private final MovieRepository movieRepository;
    private final MovieMapper movieMapper;
    private final LibraryMapper libraryMapper;

    public PurchaseServiceImpl(PurchaseRepository purchaseRepository, PaymentTransactionRepository transactionRepository,
            MovieRepository movieRepository, MovieMapper movieMapper, LibraryMapper libraryMapper) {
        this.purchaseRepository = purchaseRepository;
        this.transactionRepository = transactionRepository;
        this.movieRepository = movieRepository;
        this.movieMapper = movieMapper;
        this.libraryMapper = libraryMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<PurchaseResponse> listPurchases(UUID userId, String query, Pageable pageable) {
        String pattern = query == null || query.isBlank() ? LikePattern.any() : LikePattern.contains(query);
        Page<Purchase> page = purchaseRepository.findByUser(userId, pattern, pageable);
        List<UUID> ids = page.getContent().stream().map(p -> p.getId().movieId()).toList();
        Map<UUID, Movie> movies = movieRepository.findAllById(ids).stream()
                .collect(Collectors.toMap(Movie::getId, Function.identity()));
        return PageResponse.of(page.map(p -> new PurchaseResponse(
                movieMapper.toSummary(movies.get(p.getId().movieId())), p.getPurchasedAt())));
    }

    @Override
    @Transactional(readOnly = true)
    public java.util.List<UUID> purchasedMovieIds(UUID userId) {
        return purchaseRepository.findMovieIds(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<TransactionResponse> listTransactions(UUID userId, Pageable pageable) {
        return PageResponse.of(transactionRepository.findByUser(userId, pageable).map(libraryMapper::toResponse));
    }

    @Override
    @Transactional(readOnly = true)
    public boolean owns(UUID userId, UUID movieId) {
        return purchaseRepository.existsById(new Purchase.Id(userId, movieId));
    }

    @Override
    @Transactional(readOnly = true)
    public boolean canWatch(UUID userId, Movie movie) {
        return movie.getPriceCents() == 0 || owns(userId, movie.getId());
    }

    @Override
    public void grant(UUID userId, UUID movieId, UUID transactionId) {
        if (!purchaseRepository.existsById(new Purchase.Id(userId, movieId))) {
            purchaseRepository.save(new Purchase(userId, movieId, transactionId));
        }
    }
}
