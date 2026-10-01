package space.nhatcoi.nozie.dto.request;

import java.util.UUID;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

public record WatchProgressRequest(
        UUID episodeId,
        @Min(0) @Max(86_400) int positionSeconds,
        @Min(0) @Max(86_400) int durationSeconds) {
}
