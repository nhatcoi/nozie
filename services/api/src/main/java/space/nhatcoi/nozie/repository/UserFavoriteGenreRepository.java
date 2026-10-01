package space.nhatcoi.nozie.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.UserFavoriteGenre;

public interface UserFavoriteGenreRepository extends JpaRepository<UserFavoriteGenre, UserFavoriteGenre.Id> {

    @Query("select f.id.genreId from UserFavoriteGenre f where f.id.userId = :userId")
    List<Short> findGenreIds(@Param("userId") UUID userId);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("delete from UserFavoriteGenre f where f.id.userId = :userId")
    void deleteAllForUser(@Param("userId") UUID userId);
}
