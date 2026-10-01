package space.nhatcoi.nozie.dto.request;

import java.util.List;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

/**
 * Query-string filters for {@code GET /movies}. All optional; null/blank means "no filter".
 * Genres match by slug or (case-insensitive) name. Prices are integer cents.
 */
public record MovieSearchCriteria(
        @Size(max = 100) String q,
        @Size(max = 80) String genre,
        @Size(max = 10) List<@Size(max = 80) String> genres,
        @Min(1888) @Max(2200) Short year,
        @Min(1888) @Max(2200) Short minYear,
        @Size(max = 32) String type,
        Boolean free,
        Boolean cinema,
        @Min(0) @Max(5) Double ratingMin,
        @Min(0) Integer priceMinCents,
        @Min(0) Integer priceMaxCents,
        @Size(max = 32) String excludeStatus,
        @Size(max = 100) String slugPrefix) {
}
