package space.nhatcoi.nozie.entity;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "password_resets")
public class PasswordReset {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "otp_hash", nullable = false)
    private String otpHash;

    @Column(nullable = false)
    private short attempts;

    @Column(name = "expires_at", nullable = false)
    private Instant expiresAt;

    @Column(name = "verified_at")
    private Instant verifiedAt;

    @JdbcTypeCode(SqlTypes.CHAR)
    @Column(name = "reset_token_hash", length = 64)
    private String resetTokenHash;

    @Column(name = "consumed_at")
    private Instant consumedAt;

    @Column(name = "created_at", nullable = false, insertable = false, updatable = false)
    private Instant createdAt;

    protected PasswordReset() {
    }

    public PasswordReset(UUID userId, String otpHash, Instant expiresAt) {
        this.userId = userId;
        this.otpHash = otpHash;
        this.expiresAt = expiresAt;
    }

    public UUID getId() {
        return id;
    }

    public UUID getUserId() {
        return userId;
    }

    public String getOtpHash() {
        return otpHash;
    }

    public short getAttempts() {
        return attempts;
    }

    public Instant getExpiresAt() {
        return expiresAt;
    }

    public Instant getVerifiedAt() {
        return verifiedAt;
    }

    public Instant getConsumedAt() {
        return consumedAt;
    }

    public void markVerified(String resetTokenHash, Instant newExpiry) {
        this.verifiedAt = Instant.now();
        this.resetTokenHash = resetTokenHash;
        this.expiresAt = newExpiry;
    }

    public void consume() {
        this.consumedAt = Instant.now();
    }
}
