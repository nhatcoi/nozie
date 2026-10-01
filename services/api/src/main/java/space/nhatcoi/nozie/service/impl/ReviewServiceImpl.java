package space.nhatcoi.nozie.service.impl;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.request.RatingRequest;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.RatingSummaryResponse;
import space.nhatcoi.nozie.dto.response.ReviewResponse;
import space.nhatcoi.nozie.entity.Movie;
import space.nhatcoi.nozie.entity.Rating;
import space.nhatcoi.nozie.entity.ReviewLike;
import space.nhatcoi.nozie.entity.User;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.mapper.LibraryMapper;
import space.nhatcoi.nozie.repository.MovieRepository;
import space.nhatcoi.nozie.repository.RatingRepository;
import space.nhatcoi.nozie.repository.ReviewLikeRepository;
import space.nhatcoi.nozie.repository.UserRepository;
import space.nhatcoi.nozie.service.ReviewService;

@Service
@Transactional
public class ReviewServiceImpl implements ReviewService {

    private final RatingRepository ratingRepository;
    private final ReviewLikeRepository likeRepository;
    private final MovieRepository movieRepository;
    private final UserRepository userRepository;
    private final LibraryMapper mapper;

    public ReviewServiceImpl(RatingRepository ratingRepository, ReviewLikeRepository likeRepository,
            MovieRepository movieRepository, UserRepository userRepository, LibraryMapper mapper) {
        this.ratingRepository = ratingRepository;
        this.likeRepository = likeRepository;
        this.movieRepository = movieRepository;
        this.userRepository = userRepository;
        this.mapper = mapper;
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<ReviewResponse> list(UUID movieId, UUID viewerIdOrNull, Pageable pageable) {
        requireMovie(movieId);
        Page<Rating> page = ratingRepository.findByMovie(movieId, pageable);
        List<UUID> authorIds = page.getContent().stream().map(r -> r.getId().userId()).toList();
        Map<UUID, User> authors = userRepository.findAllById(authorIds).stream()
                .collect(Collectors.toMap(User::getId, Function.identity()));
        Map<UUID, Long> likes = new HashMap<>();
        Set<UUID> likedByViewer = Set.of();
        if (!authorIds.isEmpty()) {
            for (Object[] row : likeRepository.countByReviews(movieId, authorIds)) {
                likes.put((UUID) row[0], (Long) row[1]);
            }
            if (viewerIdOrNull != null) {
                likedByViewer = Set.copyOf(likeRepository.likedBy(movieId, viewerIdOrNull, authorIds));
            }
        }
        Set<UUID> liked = likedByViewer;
        return PageResponse.of(page.map(r -> mapper.toResponse(r, authors.get(r.getId().userId()),
                likes.getOrDefault(r.getId().userId(), 0L), liked.contains(r.getId().userId()))));
    }

    @Override
    @Transactional(readOnly = true)
    public RatingSummaryResponse summary(UUID movieId) {
        requireMovie(movieId);
        Map<Integer, Long> distribution = new java.util.TreeMap<>();
        for (int star = 1; star <= 5; star++) {
            distribution.put(star, 0L);
        }
        for (Object[] row : ratingRepository.distributionFor(movieId)) {
            distribution.put(((Number) row[0]).intValue(), (Long) row[1]);
        }
        return new RatingSummaryResponse(Math.round(ratingRepository.averageFor(movieId) * 10) / 10.0,
                ratingRepository.countFor(movieId), distribution);
    }

    @Override
    public ReviewResponse upsert(UUID userId, UUID movieId, RatingRequest request) {
        Movie movie = requireMovie(movieId);
        String review = request.review() == null || request.review().isBlank() ? null : request.review().trim();
        Rating rating = ratingRepository.findById(new Rating.Id(userId, movieId)).orElse(null);
        if (rating == null) {
            rating = new Rating(userId, movieId, request.rating(), review);
        } else {
            rating.update(request.rating(), review);
        }
        Rating saved = ratingRepository.saveAndFlush(rating);
        syncMovieRating(movie);
        return mapper.toResponse(saved, userRepository.findById(userId).orElse(null),
                likeRepository.countFor(movieId, userId), false);
    }

    @Override
    public void delete(UUID userId, UUID movieId) {
        Movie movie = requireMovie(movieId);
        ratingRepository.deleteById(new Rating.Id(userId, movieId));
        ratingRepository.flush();
        syncMovieRating(movie);
    }

    @Override
    public void like(UUID userId, UUID movieId, UUID reviewUserId) {
        if (!ratingRepository.existsById(new Rating.Id(reviewUserId, movieId))) {
            throw new ApiException(ErrorCode.REVIEW_NOT_FOUND);
        }
        ReviewLike.Id id = new ReviewLike.Id(userId, movieId, reviewUserId);
        if (!likeRepository.existsById(id)) {
            try {
                likeRepository.saveAndFlush(new ReviewLike(userId, movieId, reviewUserId));
            } catch (DataIntegrityViolationException ignored) {
                // concurrent like: already there
            }
        }
    }

    @Override
    public void unlike(UUID userId, UUID movieId, UUID reviewUserId) {
        likeRepository.deleteById(new ReviewLike.Id(userId, movieId, reviewUserId));
    }

    /** Viewer reviews override the imported TMDB vote; with none left the imported value returns. */
    private void syncMovieRating(Movie movie) {
        long count = ratingRepository.countFor(movie.getId());
        if (count > 0) {
            movie.applyUserRating(ratingRepository.averageFor(movie.getId()), (int) count);
        } else {
            movie.restoreBaselineRating();
        }
        movieRepository.save(movie);
    }

    private Movie requireMovie(UUID movieId) {
        return movieRepository.findById(movieId).orElseThrow(() -> new ApiException(ErrorCode.MOVIE_NOT_FOUND));
    }
}
