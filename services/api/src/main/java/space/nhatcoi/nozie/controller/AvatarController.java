package space.nhatcoi.nozie.controller;

import java.io.IOException;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import io.swagger.v3.oas.annotations.tags.Tag;

import space.nhatcoi.nozie.dto.response.ApiResponse;
import space.nhatcoi.nozie.dto.response.UserResponse;
import space.nhatcoi.nozie.integration.storage.AvatarStorage.StoredAvatar;
import space.nhatcoi.nozie.security.AuthenticatedUser;
import space.nhatcoi.nozie.service.AvatarService;

@RestController
@RequestMapping("/users")
@Tag(name = "User")
public class AvatarController {

    private final AvatarService avatarService;

    public AvatarController(AvatarService avatarService) {
        this.avatarService = avatarService;
    }

    @PutMapping(value = "/me/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<UserResponse> upload(@AuthenticationPrincipal AuthenticatedUser user,
            @RequestParam("file") MultipartFile file) throws IOException {
        return ApiResponse.ok(avatarService.upload(user.id(), file.getBytes()));
    }

    @DeleteMapping("/me/avatar")
    public ApiResponse<UserResponse> remove(@AuthenticationPrincipal AuthenticatedUser user) {
        return ApiResponse.ok(avatarService.remove(user.id()));
    }

    /** Public (avatars are shown next to reviews). The URL carries a version, so it can be cached hard. */
    @GetMapping("/{userId}/avatar")
    public ResponseEntity<byte[]> get(@PathVariable UUID userId) {
        StoredAvatar avatar = avatarService.loadAvatar(userId);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(avatar.contentType()))
                .cacheControl(CacheControl.maxAge(7, TimeUnit.DAYS).cachePublic().immutable())
                .body(avatar.data());
    }
}
