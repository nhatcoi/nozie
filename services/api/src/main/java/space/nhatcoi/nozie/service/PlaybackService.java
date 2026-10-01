package space.nhatcoi.nozie.service;

import java.util.List;
import java.util.UUID;

import space.nhatcoi.nozie.dto.response.AccessResponse;
import space.nhatcoi.nozie.dto.response.EpisodeResponse;
import space.nhatcoi.nozie.dto.response.StreamResponse;

public interface PlaybackService {

    List<EpisodeResponse> listEpisodes(UUID movieId);

    AccessResponse access(UUID userId, UUID movieId);

    /** @throws space.nhatcoi.nozie.exception.ApiException PURCHASE_REQUIRED unless the movie is free or owned by the user */
    StreamResponse resolveStream(UUID userId, UUID movieId, UUID episodeId);
}
