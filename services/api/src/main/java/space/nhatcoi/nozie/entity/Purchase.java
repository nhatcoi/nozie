package space.nhatcoi.nozie.entity;

import java.io.Serializable;
import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

/** Entitlement to watch a movie. Written only by the payment webhook (or an admin grant), never by a client request. */
@Entity
@Table(name = "purchases")
public class Purchase {

    @Embeddable
    public record Id(@Column(name = "user_id") UUID userId, @Column(name = "movie_id") UUID movieId) implements Serializable {
    }

    @EmbeddedId
    private Id id;

    @Column(name = "transaction_id")
    private UUID transactionId;

    @Column(name = "purchased_at", nullable = false)
    private Instant purchasedAt = Instant.now();

    protected Purchase() {
    }

    public Purchase(UUID userId, UUID movieId, UUID transactionId) {
        this.id = new Id(userId, movieId);
        this.transactionId = transactionId;
    }

    public Id getId() {
        return id;
    }

    public UUID getTransactionId() {
        return transactionId;
    }

    public Instant getPurchasedAt() {
        return purchasedAt;
    }
}
