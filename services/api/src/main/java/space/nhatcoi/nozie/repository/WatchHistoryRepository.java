package space.nhatcoi.nozie.repository;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.WatchHistory;

public interface WatchHistoryRepository extends JpaRepository<WatchHistory, WatchHistory.Id> {

    @Query("select h from WatchHistory h where h.id.userId = :userId order by h.updatedAt desc")
    Page<WatchHistory> findByUser(@Param("userId") UUID userId, Pageable pageable);
}
