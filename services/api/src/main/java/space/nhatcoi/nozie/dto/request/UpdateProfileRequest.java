package space.nhatcoi.nozie.dto.request;

import java.time.LocalDate;

import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/** PATCH semantics: null fields are left unchanged. */
public record UpdateProfileRequest(
        @Size(min = 1, max = 120) String fullName,
        @Pattern(regexp = "^[A-Za-z0-9_.]{3,40}$", message = "3-40 chars: letters, digits, '_' or '.'") String username,
        @Size(max = 32) String phone,
        @Past LocalDate dateOfBirth,
        @Size(max = 16) String gender,
        @Size(max = 64) String country) {
}
