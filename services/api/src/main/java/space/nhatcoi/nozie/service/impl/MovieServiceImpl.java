package space.nhatcoi.nozie.service.impl;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.request.MovieSearchCriteria;
import space.nhatcoi.nozie.dto.request.MovieSort;
import space.nhatcoi.nozie.dto.response.MovieDetailResponse;
import space.nhatcoi.nozie.dto.response.MovieSummaryResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.entity.Genre;
import space.nhatcoi.nozie.entity.Movie;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.mapper.MovieMapper;
import space.nhatcoi.nozie.repository.MovieRepository;
import space.nhatcoi.nozie.repository.UserFavoriteGenreRepository;
import space.nhatcoi.nozie.service.MovieService;
import space.nhatcoi.nozie.specification.MovieSpecifications;
import space.nhatcoi.nozie.util.LikePattern;

@Service
@Transactional(readOnly = true)
public class MovieServiceImpl implements MovieService {

    private static final Sort MOST_VIEWED = Sort.by(Sort.Direction.DESC, "viewCount").and(Sort.by("id"));

    private final MovieRepository movieRepository;
    private final UserFavoriteGenreRepository favoriteGenreRepository;
    private final MovieMapper movieMapper;

    public MovieServiceImpl(MovieRepository movieRepository, UserFavoriteGenreRepository favoriteGenreRepository,
            MovieMapper movieMapper) {
        this.movieRepository = movieRepository;
        this.favoriteGenreRepository = favoriteGenreRepository;
        this.movieMapper = movieMapper;
    }

    @Override
    public PageResponse<MovieSummaryResponse> search(MovieSearchCriteria criteria, MovieSort sort, Pageable pageable) {
        // The sort lives in the specification (see MovieSpecifications.orderedBy); the pageable carries paging only.
        Pageable paging = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize());
        return PageResponse.of(movieRepository.findAll(MovieSpecifications.from(criteria).and(MovieSpecifications.orderedBy(sort)), paging)
                .map(movieMapper::toSummary));
    }

    @Override
    public MovieDetailResponse getById(UUID id) {
        return movieMapper.toDetail(movieRepository.findById(id).orElseThrow(MovieServiceImpl::notFound));
    }

    @Override
    public MovieDetailResponse getBySlug(String slug) {
        return movieMapper.toDetail(movieRepository.findBySlug(slug).orElseThrow(MovieServiceImpl::notFound));
    }

    @Override
    public List<MovieSummaryResponse> similar(UUID movieId, int limit) {
        Movie movie = movieRepository.findById(movieId).orElseThrow(MovieServiceImpl::notFound);
        List<Short> genreIds = movie.getGenres().stream().map(Genre::getId).toList();
        Pageable page = PageRequest.of(0, clamp(limit), MOST_VIEWED);
        List<Movie> found = genreIds.isEmpty()
                ? movieRepository.findAll(page).getContent().stream().filter(m -> !m.getId().equals(movieId)).toList()
                : movieRepository.findAll(MovieSpecifications.inGenreIds(genreIds, movieId), page).getContent();
        return found.stream().map(movieMapper::toSummary).toList();
    }

    @Override
    public List<MovieSummaryResponse> recommended(UUID userIdOrNull, int limit) {
        Pageable page = PageRequest.of(0, clamp(limit), MOST_VIEWED);
        List<Short> favourites = userIdOrNull == null ? List.of() : favoriteGenreRepository.findGenreIds(userIdOrNull);
        List<Movie> found = favourites.isEmpty()
                ? movieRepository.findAll(page).getContent()
                : movieRepository.findAll(MovieSpecifications.inGenreIds(favourites, null), page).getContent();
        if (found.isEmpty()) {
            found = movieRepository.findAll(page).getContent();
        }
        return found.stream().map(movieMapper::toSummary).toList();
    }

    @Override
    public List<String> suggest(String text, int limit) {
        if (text == null || text.isBlank()) {
            return List.of();
        }
        int size = Math.min(Math.max(limit, 1), 10);
        return List.copyOf(new LinkedHashSet<>(
                movieRepository.suggestNames(LikePattern.contains(text), PageRequest.of(0, size * 3))))
                .stream().limit(size).toList();
    }

    private static int clamp(int limit) {
        return Math.min(Math.max(limit, 1), 50);
    }

    private static ApiException notFound() {
        return new ApiException(ErrorCode.MOVIE_NOT_FOUND);
    }
}
