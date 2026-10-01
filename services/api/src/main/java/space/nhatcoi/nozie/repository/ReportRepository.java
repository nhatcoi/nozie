package space.nhatcoi.nozie.repository;

import java.time.Instant;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.Report;

public interface ReportRepository extends JpaRepository<Report, UUID> {

    @Query("select count(r) from Report r where r.userId = :userId and r.createdAt > :since")
    long countRecent(@Param("userId") UUID userId, @Param("since") Instant since);
}
