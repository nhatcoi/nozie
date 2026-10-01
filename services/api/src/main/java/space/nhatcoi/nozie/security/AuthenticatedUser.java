package space.nhatcoi.nozie.security;

import java.util.UUID;

/** Principal placed in the SecurityContext for every authenticated request. */
public record AuthenticatedUser(UUID id, String role) {
}
