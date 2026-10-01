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

import space.nhatcoi.nozie.dto.request.WatchProgressRequest;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.WatchHistoryResponse;
import space.nhatcoi.nozie.entity.Movie;
import space.nhatcoi.nozie.entity.WatchHistory;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.mapper.MovieMapper;
import space.nhatcoi.nozie.repository.EpisodeRepository;
import space.nhatcoi.nozie.repository.MovieRepository;
import space.nhatcoi.nozie.repository.WatchHistoryRepository;
import space.nhatcoi.nozie.service.WatchHistoryService;

@Service
@Transactional
public class WatchHistoryServiceImpl implements WatchHistoryService {

    private final WatchHistoryRepository repository;
    private final MovieRepository movieRepository;
    private final EpisodeRepository episodeRepository;
    private final MovieMapper movieMapper;

    public WatchHistoryServiceImpl(WatchHistoryRepository repository, MovieRepository movieRepository,
            EpisodeRepository episodeRepository, MovieMapper movieMapper) {
        this.repository = repository;
        this.movieRepository = movieRepository;
        this.episodeRepository = episodeRepository;
        this.movieMapper = movieMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<WatchHistoryResponse> list(UUID userId, Pageable pageable) {
        Page<WatchHistory> page = repository.findByUser(userId, pageable);
        List<UUID> ids = page.getContent().stream().map(h -> h.getId().movieId()).toList();
        Map<UUID, Movie> movies = movieRepository.findAllById(ids).stream()
                .collect(Collectors.toMap(Movie::getId, Function.identity()));
        return PageResponse.of(page.map(h -> new WatchHistoryResponse(
                movieMapper.toSummary(movies.get(h.getId().movieId())), h.getEpisodeId(),
                h.getPositionSeconds(), h.getDurationSeconds(), h.getUpdatedAt())));
    }

    @Override
    public void record(UUID userId, UUID movieId, WatchProgressRequest request) {
        if (!movieRepository.existsById(movieId)) {
            throw new ApiException(ErrorCode.MOVIE_NOT_FOUND);
        }
        if (request.episodeId() != null && episodeRepository.findByIdAndMovieId(request.episodeId(), movieId).isEmpty()) {
            throw new ApiException(ErrorCode.EPISODE_NOT_FOUND);
        }
        WatchHistory history = repository.findById(new WatchHistory.Id(userId, movieId))
                .orElseGet(() -> new WatchHistory(userId, movieId));
        history.record(request.episodeId(), request.positionSeconds(), request.durationSeconds());
        repository.save(history);
    }
}
