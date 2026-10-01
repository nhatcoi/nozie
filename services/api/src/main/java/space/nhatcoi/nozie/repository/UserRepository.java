package space.nhatcoi.nozie.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.User;

public interface UserRepository extends JpaRepository<User, UUID> {

    @Query("select u from User u where lower(u.email) = lower(:email)")
    Optional<User> findByEmail(@Param("email") String email);

    Optional<User> findByGoogleSub(String googleSub);

    @Query("select count(u) > 0 from User u where lower(u.email) = lower(:email)")
    boolean existsByEmail(@Param("email") String email);

    @Query("select count(u) > 0 from User u where lower(u.username) = lower(:username) and u.id <> :excludeId")
    boolean usernameTakenByOther(@Param("username") String username, @Param("excludeId") UUID excludeId);
}
