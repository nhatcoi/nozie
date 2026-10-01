package space.nhatcoi.nozie.mapper;

import java.util.Comparator;

import org.springframework.stereotype.Component;

import space.nhatcoi.nozie.dto.response.MovieDetailResponse;
import space.nhatcoi.nozie.dto.response.MovieSummaryResponse;
import space.nhatcoi.nozie.entity.Genre;
import space.nhatcoi.nozie.entity.Movie;

@Component
public class MovieMapper {

    private final GenreMapper genreMapper;

    public MovieMapper(GenreMapper genreMapper) {
        this.genreMapper = genreMapper;
    }

    public MovieSummaryResponse toSummary(Movie m) {
        return new MovieSummaryResponse(
                m.getId(), m.getSlug(), m.getName(), m.getOriginName(), m.getType(),
                m.getPosterUrl(), m.getThumbUrl(), m.getQuality(), m.getYear(), m.getViewCount(),
                rating(m), m.getRatingCount(), m.getEpisodeCurrent(),
                m.getGenres().stream().map(Genre::getName).sorted().toList(),
                m.getPriceCents(), m.getCurrency(), m.getPriceCents() == 0);
    }

    public MovieDetailResponse toDetail(Movie m) {
        return new MovieDetailResponse(
                m.getId(), m.getSlug(), m.getName(), m.getOriginName(), m.getType(), m.getStatus(),
                m.getContent(), m.getTrailerUrl(), m.getPosterUrl(), m.getThumbUrl(), m.getQuality(),
                m.getDuration(), m.getLang(), m.getYear(), m.getViewCount(), rating(m), m.getRatingCount(), m.getEpisodeCurrent(),
                m.getEpisodeTotal(), m.isCinema(), m.isSubExclusive(), m.getDirectors(), m.getActors(),
                m.getCountries(),
                m.getGenres().stream().sorted(Comparator.comparing(Genre::getName)).map(genreMapper::toResponse).toList(),
                m.getPriceCents(), m.getCurrency(), m.getPriceCents() == 0);
    }

    private static Double rating(Movie m) {
        return m.getRating() == null ? null : m.getRating().doubleValue();
    }
}
