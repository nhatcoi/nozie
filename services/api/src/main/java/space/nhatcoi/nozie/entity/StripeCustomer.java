package space.nhatcoi.nozie.entity;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "stripe_customers")
public class StripeCustomer {

    @Id
    @Column(name = "user_id")
    private UUID userId;

    @Column(name = "stripe_customer_id", nullable = false, unique = true)
    private String stripeCustomerId;

    protected StripeCustomer() {
    }

    public StripeCustomer(UUID userId, String stripeCustomerId) {
        this.userId = userId;
        this.stripeCustomerId = stripeCustomerId;
    }

    public String getStripeCustomerId() {
        return stripeCustomerId;
    }
}
