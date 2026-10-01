package space.nhatcoi.nozie.entity;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/** {@code streamUrl}/{@code embedUrl} are private: only the playback endpoint, after an entitlement check, may expose them. */
@Entity
@Table(name = "episodes")
public class Episode {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "movie_id", nullable = false)
    private UUID movieId;

    @Column(name = "server_name", nullable = false, length = 120)
    private String serverName = "";

    @Column(nullable = false, length = 120)
    private String name;

    @Column(nullable = false, length = 120)
    private String slug;

    @Column(name = "stream_url", length = 2048)
    private String streamUrl;

    @Column(name = "embed_url", length = 2048)
    private String embedUrl;

    @Column(nullable = false)
    private int position;

    protected Episode() {
    }

    public UUID getId() {
        return id;
    }

    public UUID getMovieId() {
        return movieId;
    }

    public String getServerName() {
        return serverName;
    }

    public String getName() {
        return name;
    }

    public String getSlug() {
        return slug;
    }

    public String getStreamUrl() {
        return streamUrl;
    }

    public String getEmbedUrl() {
        return embedUrl;
    }

    public int getPosition() {
        return position;
    }
}
