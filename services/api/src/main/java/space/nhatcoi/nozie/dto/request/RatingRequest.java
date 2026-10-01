package space.nhatcoi.nozie.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

public record RatingRequest(@Min(1) @Max(5) short rating, @Size(max = 2000) String review) {
}
