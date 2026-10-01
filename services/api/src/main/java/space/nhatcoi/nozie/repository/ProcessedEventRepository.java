package space.nhatcoi.nozie.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.entity.ProcessedEvent;

public interface ProcessedEventRepository extends JpaRepository<ProcessedEvent, String> {

    /** @return 1 when this event is new, 0 when it was already processed (Stripe redelivery). */
    @Transactional
    @Modifying
    @Query(value = "insert into processed_events (event_id, type) values (:id, :type) on conflict do nothing", nativeQuery = true)
    int tryInsert(@Param("id") String eventId, @Param("type") String type);
}
