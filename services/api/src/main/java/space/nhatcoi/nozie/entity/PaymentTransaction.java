package space.nhatcoi.nozie.entity;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import space.nhatcoi.nozie.enums.TransactionStatus;

@Entity
@Table(name = "transactions")
public class PaymentTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "movie_id", nullable = false)
    private UUID movieId;

    @Column(name = "amount_cents", nullable = false)
    private long amountCents;

    @JdbcTypeCode(SqlTypes.CHAR)
    @Column(nullable = false, length = 3)
    private String currency;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private TransactionStatus status = TransactionStatus.PENDING;

    @Column(name = "stripe_payment_intent_id")
    private String stripePaymentIntentId;

    @Column(name = "stripe_charge_id")
    private String stripeChargeId;

    @Column(name = "error_message", length = 512)
    private String errorMessage;

    @Column(name = "created_at", nullable = false, insertable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "paid_at")
    private Instant paidAt;

    @Column(name = "failed_at")
    private Instant failedAt;

    @Column(name = "canceled_at")
    private Instant canceledAt;

    protected PaymentTransaction() {
    }

    public PaymentTransaction(UUID userId, UUID movieId, long amountCents, String currency) {
        this.userId = userId;
        this.movieId = movieId;
        this.amountCents = amountCents;
        this.currency = currency;
    }

    public UUID getId() {
        return id;
    }

    public UUID getUserId() {
        return userId;
    }

    public UUID getMovieId() {
        return movieId;
    }

    public long getAmountCents() {
        return amountCents;
    }

    public String getCurrency() {
        return currency;
    }

    public TransactionStatus getStatus() {
        return status;
    }

    public String getStripePaymentIntentId() {
        return stripePaymentIntentId;
    }

    public void setStripePaymentIntentId(String id) {
        this.stripePaymentIntentId = id;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getPaidAt() {
        return paidAt;
    }

    public void markSucceeded(String chargeId) {
        this.status = TransactionStatus.SUCCEEDED;
        this.stripeChargeId = chargeId;
        this.paidAt = Instant.now();
    }

    public void markFailed(String message) {
        this.status = TransactionStatus.FAILED;
        this.errorMessage = message == null ? null : message.substring(0, Math.min(message.length(), 512));
        this.failedAt = Instant.now();
    }

    public void markCanceled() {
        this.status = TransactionStatus.CANCELED;
        this.canceledAt = Instant.now();
    }
}
