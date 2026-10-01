package space.nhatcoi.nozie.dto.request;

import java.util.List;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record FavoriteGenresRequest(@NotNull @Size(max = 30) List<@Size(max = 80) String> genres) {
}
