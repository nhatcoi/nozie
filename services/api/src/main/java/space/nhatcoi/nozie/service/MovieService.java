package space.nhatcoi.nozie.service;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Pageable;

import space.nhatcoi.nozie.dto.request.MovieSearchCriteria;
import space.nhatcoi.nozie.dto.request.MovieSort;
import space.nhatcoi.nozie.dto.response.MovieDetailResponse;
import space.nhatcoi.nozie.dto.response.MovieSummaryResponse;
import space.nhatcoi.nozie.dto.response.PageResponse;

public interface MovieService {

    PageResponse<MovieSummaryResponse> search(MovieSearchCriteria criteria, MovieSort sort, Pageable pageable);

    MovieDetailResponse getById(UUID id);

    MovieDetailResponse getBySlug(String slug);

    /** Movies sharing a genre with the given one, most viewed first. */
    List<MovieSummaryResponse> similar(UUID movieId, int limit);

    /** Based on the user's favourite genres; anonymous users and users without favourites get the most viewed. */
    List<MovieSummaryResponse> recommended(UUID userIdOrNull, int limit);

    /** Up to {@code limit} movie titles containing the text, for search-as-you-type. */
    List<String> suggest(String text, int limit);
}
