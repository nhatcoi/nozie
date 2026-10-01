package space.nhatcoi.nozie.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record ChangePasswordRequest(
        @Size(max = 128) String currentPassword,
        @NotBlank @Size(min = 8, max = 128)
        @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d).+$", message = "must contain a letter and a digit") String newPassword) {
}
