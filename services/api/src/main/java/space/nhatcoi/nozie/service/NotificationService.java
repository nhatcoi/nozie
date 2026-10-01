package space.nhatcoi.nozie.service;

import java.util.Map;
import java.util.UUID;

import org.springframework.data.domain.Pageable;

import space.nhatcoi.nozie.dto.response.NotificationResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.UnreadCountResponse;

public interface NotificationService {

    PageResponse<NotificationResponse> list(UUID userId, Pageable pageable);

    UnreadCountResponse unreadCount(UUID userId);

    void markRead(UUID userId, UUID notificationId);

    void markAllRead(UUID userId);

    /** Internal: other services (payments) raise notifications through this. */
    void create(UUID userId, String type, String title, String description, String deepLink, Map<String, Object> metadata);
}
