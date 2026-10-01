package space.nhatcoi.nozie.dto.request;

import java.util.Set;

import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;

/** Whitelisted sort for the catalog. Nullable fields always list NULL values last, in either direction. */
public record MovieSort(String field, boolean ascending) {

    private static final Set<String> SORTABLE = Set.of("createdAt", "viewCount", "year", "name", "priceCents", "rating");
    private static final Set<String> NULLABLE = Set.of("year", "rating");

    public static MovieSort parse(String field, String direction) {
        if (!SORTABLE.contains(field)) {
            throw new ApiException(ErrorCode.INVALID_SORT);
        }
        return new MovieSort(field, "asc".equalsIgnoreCase(direction));
    }

    public static MovieSort mostViewed() {
        return new MovieSort("viewCount", false);
    }

    public boolean nullable() {
        return NULLABLE.contains(field);
    }
}
