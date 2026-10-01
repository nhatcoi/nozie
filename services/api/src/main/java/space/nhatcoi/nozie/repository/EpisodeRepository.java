package space.nhatcoi.nozie.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import space.nhatcoi.nozie.entity.Episode;

public interface EpisodeRepository extends JpaRepository<Episode, UUID> {

    List<Episode> findByMovieIdOrderByPositionAsc(UUID movieId);

    Optional<Episode> findByIdAndMovieId(UUID id, UUID movieId);
}
