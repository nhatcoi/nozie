package space.nhatcoi.nozie.integration.storage;

import java.util.Optional;
import java.util.UUID;

/** Where avatar bytes live. The database implementation can be replaced by S3/R2 without touching callers. */
public interface AvatarStorage {

    void store(UUID userId, String contentType, byte[] data);

    Optional<StoredAvatar> load(UUID userId);

    void delete(UUID userId);

    record StoredAvatar(String contentType, byte[] data) {
    }
}
