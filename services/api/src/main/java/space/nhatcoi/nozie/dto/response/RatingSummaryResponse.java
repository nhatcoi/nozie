package space.nhatcoi.nozie.dto.response;

import java.util.Map;

/** @param distribution star (1-5) to number of reviews; every star is present, zero when nobody gave it */
public record RatingSummaryResponse(double average, long count, Map<Integer, Long> distribution) {
}
