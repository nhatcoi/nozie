package space.nhatcoi.nozie.service.impl;

import java.util.Map;
import java.util.UUID;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.response.NotificationResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.UnreadCountResponse;
import space.nhatcoi.nozie.entity.Notification;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.mapper.LibraryMapper;
import space.nhatcoi.nozie.repository.NotificationRepository;
import space.nhatcoi.nozie.service.NotificationService;

@Service
@Transactional
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepository repository;
    private final LibraryMapper mapper;

    public NotificationServiceImpl(NotificationRepository repository, LibraryMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<NotificationResponse> list(UUID userId, Pageable pageable) {
        return PageResponse.of(repository.findByUser(userId, pageable).map(mapper::toResponse));
    }

    @Override
    @Transactional(readOnly = true)
    public UnreadCountResponse unreadCount(UUID userId) {
        return new UnreadCountResponse(repository.countByUserIdAndReadFalse(userId));
    }

    @Override
    public void markRead(UUID userId, UUID notificationId) {
        if (repository.markRead(notificationId, userId) == 0) {
            throw new ApiException(ErrorCode.NOTIFICATION_NOT_FOUND);
        }
    }

    @Override
    public void markAllRead(UUID userId) {
        repository.markAllRead(userId);
    }

    @Override
    public void create(UUID userId, String type, String title, String description, String deepLink, Map<String, Object> metadata) {
        repository.save(new Notification(userId, type, title, description, deepLink, metadata));
    }
}
