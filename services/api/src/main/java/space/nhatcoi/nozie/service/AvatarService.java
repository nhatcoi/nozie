package space.nhatcoi.nozie.service;

import java.util.UUID;

import space.nhatcoi.nozie.dto.response.UserResponse;
import space.nhatcoi.nozie.integration.storage.AvatarStorage.StoredAvatar;

public interface AvatarService {

    /** Validates size and real image type (by magic bytes, never by the client's header), then stores it. */
    UserResponse upload(UUID userId, byte[] bytes);

    UserResponse remove(UUID userId);

    StoredAvatar loadAvatar(UUID userId);
}
