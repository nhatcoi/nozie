package space.nhatcoi.nozie.dto.response;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

public record NotificationResponse(UUID id, String type, String title, String description, String deepLink,
        Map<String, Object> metadata, boolean read, Instant createdAt) {
}
