package space.nhatcoi.nozie.controller;

import java.util.UUID;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.constant.PaginationConstants;
import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.NotificationResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;
import space.nhatcoi.nozie.dto.response.UnreadCountResponse;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.NotificationService;
import space.nhatcoi.nozie.util.PageUtils;

@RestController
@RequestMapping("/users/me/notifications")
@Tag(name = "Notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @GetMapping
    public ApiResponse<PageResponse<NotificationResponse>> list(@AuthenticationPrincipal AuthenticatedUser user,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "" + PaginationConstants.DEFAULT_PAGE_SIZE) int size) {
        return ApiResponse.ok(notificationService.list(user.id(), PageUtils.of(page, size)));
    }

    @GetMapping("/unread-count")
    public ApiResponse<UnreadCountResponse> unreadCount(@AuthenticationPrincipal AuthenticatedUser user) {
        return ApiResponse.ok(notificationService.unreadCount(user.id()));
    }

    @PatchMapping("/{id}/read")
    public ApiResponse<Void> markRead(@AuthenticationPrincipal AuthenticatedUser user, @PathVariable UUID id) {
        notificationService.markRead(user.id(), id);
        return ApiResponse.ok("Marked as read");
    }

    @PostMapping("/read-all")
    public ApiResponse<Void> markAllRead(@AuthenticationPrincipal AuthenticatedUser user) {
        notificationService.markAllRead(user.id());
        return ApiResponse.ok("All marked as read");
    }
}
