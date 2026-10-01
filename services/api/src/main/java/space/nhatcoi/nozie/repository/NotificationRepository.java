package space.nhatcoi.nozie.repository;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.Notification;

public interface NotificationRepository extends JpaRepository<Notification, UUID> {

    @Query("select n from Notification n where n.userId = :userId order by n.createdAt desc")
    Page<Notification> findByUser(@Param("userId") UUID userId, Pageable pageable);

    long countByUserIdAndReadFalse(UUID userId);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("update Notification n set n.read = true where n.id = :id and n.userId = :userId")
    int markRead(@Param("id") UUID id, @Param("userId") UUID userId);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("update Notification n set n.read = true where n.userId = :userId and n.read = false")
    int markAllRead(@Param("userId") UUID userId);
}
