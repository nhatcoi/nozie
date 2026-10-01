package space.nhatcoi.nozie.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import space.nhatcoi.nozie.entity.StripeCustomer;

public interface StripeCustomerRepository extends JpaRepository<StripeCustomer, UUID> {
}
