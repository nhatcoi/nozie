package space.nhatcoi.nozie.dto.response;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/** Public movie detail. Deliberately has no stream/embed URLs — those come from the playback endpoint. */
public record MovieDetailResponse(
        UUID id,
        String slug,
        String name,
        String originName,
        String type,
        String status,
        String content,
        String trailerUrl,
        String posterUrl,
        String thumbUrl,
        String quality,
        String duration,
        String lang,
        Short year,
        long viewCount,
        Double rating,
        int ratingCount,
        String episodeCurrent,
        String episodeTotal,
        boolean cinema,
        boolean subExclusive,
        List<String> directors,
        List<String> actors,
        List<Map<String, Object>> countries,
        List<GenreResponse> genres,
        int priceCents,
        String currency,
        boolean free) {
}
