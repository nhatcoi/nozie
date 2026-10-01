package space.nhatcoi.nozie.repository;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.PasswordReset;

public interface PasswordResetRepository extends JpaRepository<PasswordReset, UUID> {

    Optional<PasswordReset> findFirstByUserIdAndConsumedAtIsNullOrderByCreatedAtDesc(UUID userId);

    @Query("select r from PasswordReset r where r.resetTokenHash = :hash")
    Optional<PasswordReset> findByResetTokenHash(@Param("hash") String hash);

    @Query("select count(r) from PasswordReset r where r.userId = :userId and r.createdAt > :since")
    long countRecent(@Param("userId") UUID userId, @Param("since") Instant since);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("update PasswordReset r set r.attempts = r.attempts + 1 where r.id = :id")
    void incrementAttempts(@Param("id") UUID id);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("update PasswordReset r set r.consumedAt = current_timestamp where r.userId = :userId and r.consumedAt is null")
    void consumeAllForUser(@Param("userId") UUID userId);
}
