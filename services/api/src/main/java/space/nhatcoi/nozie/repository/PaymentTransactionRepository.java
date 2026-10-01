package space.nhatcoi.nozie.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import space.nhatcoi.nozie.entity.PaymentTransaction;

public interface PaymentTransactionRepository extends JpaRepository<PaymentTransaction, UUID> {

    Optional<PaymentTransaction> findByIdAndUserId(UUID id, UUID userId);

    Optional<PaymentTransaction> findByStripePaymentIntentId(String paymentIntentId);

    @Query("select t from PaymentTransaction t where t.userId = :userId order by t.createdAt desc")
    Page<PaymentTransaction> findByUser(@Param("userId") UUID userId, Pageable pageable);
}
