package space.nhatcoi.nozie.service.impl;

import java.util.UUID;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.response.MovieSummaryResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.entity.WishlistItem;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.mapper.MovieMapper;
import space.nhatcoi.nozie.repository.MovieRepository;
import space.nhatcoi.nozie.repository.WishlistRepository;
import space.nhatcoi.nozie.service.WishlistService;
import space.nhatcoi.nozie.util.LikePattern;

@Service
@Transactional
public class WishlistServiceImpl implements WishlistService {

    private final WishlistRepository wishlistRepository;
    private final MovieRepository movieRepository;
    private final MovieMapper movieMapper;

    public WishlistServiceImpl(WishlistRepository wishlistRepository, MovieRepository movieRepository, MovieMapper movieMapper) {
        this.wishlistRepository = wishlistRepository;
        this.movieRepository = movieRepository;
        this.movieMapper = movieMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<MovieSummaryResponse> list(UUID userId, String query, Pageable pageable) {
        return PageResponse.of(wishlistRepository.findMoviesByUser(userId, pattern(query), pageable).map(movieMapper::toSummary));
    }

    @Override
    @Transactional(readOnly = true)
    public java.util.List<UUID> ids(UUID userId) {
        return wishlistRepository.findMovieIds(userId);
    }

    private static String pattern(String query) {
        return query == null || query.isBlank() ? LikePattern.any() : LikePattern.contains(query);
    }

    @Override
    public void add(UUID userId, UUID movieId) {
        if (!movieRepository.existsById(movieId)) {
            throw new ApiException(ErrorCode.MOVIE_NOT_FOUND);
        }
        WishlistItem.Id id = new WishlistItem.Id(userId, movieId);
        if (!wishlistRepository.existsById(id)) {
            try {
                wishlistRepository.saveAndFlush(new WishlistItem(userId, movieId));
            } catch (DataIntegrityViolationException ignored) {
                // concurrent add of the same item: already there, which is the goal
            }
        }
    }

    @Override
    public void remove(UUID userId, UUID movieId) {
        wishlistRepository.deleteById(new WishlistItem.Id(userId, movieId));
    }
}
