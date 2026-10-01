package space.nhatcoi.nozie.dto.response;

import java.util.List;
import java.util.UUID;

public record MovieSummaryResponse(
        UUID id,
        String slug,
        String name,
        String originName,
        String type,
        String posterUrl,
        String thumbUrl,
        String quality,
        Short year,
        long viewCount,
        Double rating,
        int ratingCount,
        String episodeCurrent,
        List<String> genres,
        int priceCents,
        String currency,
        boolean free) {
}
