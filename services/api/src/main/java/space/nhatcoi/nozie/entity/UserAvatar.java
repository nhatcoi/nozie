package space.nhatcoi.nozie.entity;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "user_avatars")
public class UserAvatar {

    @Id
    @Column(name = "user_id")
    private UUID userId;

    @Column(name = "content_type", nullable = false, length = 32)
    private String contentType;

    @JdbcTypeCode(SqlTypes.VARBINARY)
    @Column(nullable = false, columnDefinition = "bytea")
    private byte[] data;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();

    protected UserAvatar() {
    }

    public UserAvatar(UUID userId, String contentType, byte[] data) {
        this.userId = userId;
        replace(contentType, data);
    }

    public void replace(String contentType, byte[] data) {
        this.contentType = contentType;
        this.data = data;
        this.updatedAt = Instant.now();
    }

    public String getContentType() {
        return contentType;
    }

    public byte[] getData() {
        return data;
    }
}
