package space.nhatcoi.nozie.dto.response;

import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

public record UserResponse(
        UUID id,
        String email,
        boolean emailVerified,
        String fullName,
        String username,
        String phone,
        LocalDate dateOfBirth,
        String gender,
        String country,
        String avatarUrl,
        String role,
        Instant createdAt) {
}
