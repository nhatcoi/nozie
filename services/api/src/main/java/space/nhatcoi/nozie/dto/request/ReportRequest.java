package space.nhatcoi.nozie.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** A playback problem report. {@code errorMessage} is the player's own error text, kept for debugging. */
public record ReportRequest(
        @NotBlank @Size(max = 64) String issueType,
        @Size(max = 800) String description,
        @Size(max = 300) String errorMessage) {
}
