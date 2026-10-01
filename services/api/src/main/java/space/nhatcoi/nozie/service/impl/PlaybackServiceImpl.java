package space.nhatcoi.nozie.service.impl;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.response.AccessResponse;
import space.nhatcoi.nozie.dto.response.EpisodeResponse;
import space.nhatcoi.nozie.dto.response.StreamResponse;
import space.nhatcoi.nozie.entity.Episode;
import space.nhatcoi.nozie.entity.Movie;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.mapper.LibraryMapper;
import space.nhatcoi.nozie.repository.EpisodeRepository;
import space.nhatcoi.nozie.repository.MovieRepository;
import space.nhatcoi.nozie.service.PlaybackService;
import space.nhatcoi.nozie.service.PurchaseService;

@Service
@Transactional(readOnly = true)
public class PlaybackServiceImpl implements PlaybackService {

    private final EpisodeRepository episodeRepository;
    private final MovieRepository movieRepository;
    private final PurchaseService purchaseService;
    private final LibraryMapper mapper;

    public PlaybackServiceImpl(EpisodeRepository episodeRepository, MovieRepository movieRepository,
            PurchaseService purchaseService, LibraryMapper mapper) {
        this.episodeRepository = episodeRepository;
        this.movieRepository = movieRepository;
        this.purchaseService = purchaseService;
        this.mapper = mapper;
    }

    @Override
    public List<EpisodeResponse> listEpisodes(UUID movieId) {
        if (!movieRepository.existsById(movieId)) {
            throw new ApiException(ErrorCode.MOVIE_NOT_FOUND);
        }
        return episodeRepository.findByMovieIdOrderByPositionAsc(movieId).stream().map(mapper::toResponse).toList();
    }

    @Override
    public AccessResponse access(UUID userId, UUID movieId) {
        Movie movie = movieRepository.findById(movieId).orElseThrow(() -> new ApiException(ErrorCode.MOVIE_NOT_FOUND));
        boolean free = movie.getPriceCents() == 0;
        boolean owned = !free && purchaseService.owns(userId, movieId);
        return new AccessResponse(free || owned, free, owned);
    }

    @Override
    @Transactional
    public StreamResponse resolveStream(UUID userId, UUID movieId, UUID episodeId) {
        Movie movie = movieRepository.findById(movieId).orElseThrow(() -> new ApiException(ErrorCode.MOVIE_NOT_FOUND));
        if (!purchaseService.canWatch(userId, movie)) {
            throw new ApiException(ErrorCode.PURCHASE_REQUIRED);
        }
        Episode episode = episodeId != null
                ? episodeRepository.findByIdAndMovieId(episodeId, movieId).orElseThrow(() -> new ApiException(ErrorCode.EPISODE_NOT_FOUND))
                : episodeRepository.findByMovieIdOrderByPositionAsc(movieId).stream().findFirst()
                        .orElseThrow(() -> new ApiException(ErrorCode.EPISODE_NOT_FOUND));
        movieRepository.incrementViews(movieId);
        return new StreamResponse(episode.getStreamUrl(), episode.getEmbedUrl());
    }
}
