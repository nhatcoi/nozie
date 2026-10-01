package space.nhatcoi.nozie.dto.response;

import java.time.Instant;
import java.util.UUID;

public record WatchHistoryResponse(MovieSummaryResponse movie, UUID episodeId, int positionSeconds,
        int durationSeconds, Instant updatedAt) {
}
