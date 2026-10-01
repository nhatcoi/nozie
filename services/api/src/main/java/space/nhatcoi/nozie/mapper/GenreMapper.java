package space.nhatcoi.nozie.mapper;

import org.springframework.stereotype.Component;

import space.nhatcoi.nozie.dto.response.GenreResponse;
import space.nhatcoi.nozie.entity.Genre;

@Component
public class GenreMapper {

    public GenreResponse toResponse(Genre g) {
        return new GenreResponse(g.getId(), g.getSlug(), g.getName());
    }
}
