package space.nhatcoi.nozie.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.Purchase;

public interface PurchaseRepository extends JpaRepository<Purchase, Purchase.Id> {

    @Query(value = "select p from Purchase p, Movie m where m.id = p.id.movieId and p.id.userId = :userId "
            + "and (lower(m.name) like :pattern escape '\\' or lower(m.originName) like :pattern escape '\\') order by p.purchasedAt desc",
            countQuery = "select count(p) from Purchase p, Movie m where m.id = p.id.movieId and p.id.userId = :userId "
                    + "and (lower(m.name) like :pattern escape '\\' or lower(m.originName) like :pattern escape '\\')")
    Page<Purchase> findByUser(@Param("userId") UUID userId, @Param("pattern") String pattern, Pageable pageable);

    @Query("select p.id.movieId from Purchase p where p.id.userId = :userId")
    List<UUID> findMovieIds(@Param("userId") UUID userId);
}
