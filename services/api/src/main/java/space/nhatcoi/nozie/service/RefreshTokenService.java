package space.nhatcoi.nozie.service;

import java.util.UUID;

import space.nhatcoi.nozie.entity.User;
import space.nhatcoi.nozie.util.ClientInfo;

public interface RefreshTokenService {

    /** Starts a new session (new rotation family) and returns the raw opaque token. */
    String issue(User user, ClientInfo client);

    /** Single-use rotation. Replaying an already-used token revokes the whole family. */
    Rotation rotate(String rawToken, ClientInfo client);

    void revoke(String rawToken);

    void revokeAllForUser(UUID userId);

    record Rotation(UUID userId, String newRawToken) {
    }
}
