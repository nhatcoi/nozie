package space.nhatcoi.nozie.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import space.nhatcoi.nozie.entity.Movie;

public interface MovieRepository extends JpaRepository<Movie, UUID>, JpaSpecificationExecutor<Movie> {

    Optional<Movie> findBySlug(String slug);

    @Query("select m.name from Movie m where lower(m.name) like :pattern escape '\\' order by m.viewCount desc")
    List<String> suggestNames(@Param("pattern") String pattern, Pageable pageable);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("update Movie m set m.viewCount = m.viewCount + 1 where m.id = :id")
    void incrementViews(@Param("id") UUID id);
}
