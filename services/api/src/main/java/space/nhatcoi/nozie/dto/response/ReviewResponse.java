package space.nhatcoi.nozie.dto.response;

import java.time.Instant;
import java.util.UUID;

public record ReviewResponse(UUID userId, String userName, String avatarUrl, short rating, String review,
        long likes, boolean likedByMe, Instant createdAt, Instant updatedAt) {
}
