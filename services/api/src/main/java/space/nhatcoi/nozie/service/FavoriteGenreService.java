package space.nhatcoi.nozie.service;

import java.util.List;
import java.util.UUID;

import space.nhatcoi.nozie.dto.response.GenreResponse;

public interface FavoriteGenreService {

    List<GenreResponse> list(UUID userId);

    /** Replaces the whole set. Accepts genre slugs or names; unknown values are ignored. */
    List<GenreResponse> replace(UUID userId, List<String> genres);
}
