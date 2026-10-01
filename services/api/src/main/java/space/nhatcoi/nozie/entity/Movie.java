package space.nhatcoi.nozie.entity;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

/** Catalog entry. Stream sources live in {@code episodes} and are never mapped here. */
@Entity
@Table(name = "movies")
public class Movie extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "original_id", length = 64)
    private String originalId;

    @Column(nullable = false, unique = true)
    private String slug;

    @Column(nullable = false)
    private String name;

    @Column(name = "origin_name")
    private String originName;

    @Column(nullable = false, length = 32)
    private String type;

    @Column(length = 32)
    private String status;

    @Column(columnDefinition = "text")
    private String content;

    @Column(name = "trailer_url", length = 1024)
    private String trailerUrl;

    @Column(name = "poster_url", length = 1024)
    private String posterUrl;

    @Column(name = "thumb_url", length = 1024)
    private String thumbUrl;

    @Column(length = 32)
    private String quality;

    @Column(length = 64)
    private String duration;

    @Column(length = 64)
    private String lang;

    private Short year;

    @Column(name = "view_count", nullable = false)
    private long viewCount;

    @Column(name = "episode_current", length = 64)
    private String episodeCurrent;

    @Column(name = "episode_total", length = 64)
    private String episodeTotal;

    @Column(name = "is_cinema", nullable = false)
    private boolean cinema;

    @Column(name = "sub_exclusive", nullable = false)
    private boolean subExclusive;

    @Column(name = "is_copyright", nullable = false)
    private boolean copyright;

    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(nullable = false, columnDefinition = "text[]")
    private List<String> directors = List.of();

    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(nullable = false, columnDefinition = "text[]")
    private List<String> actors = List.of();

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    private List<Map<String, Object>> countries = List.of();

    @Column(name = "price_cents", nullable = false)
    private int priceCents;

    @JdbcTypeCode(SqlTypes.CHAR)
    @Column(nullable = false, length = 3)
    private String currency = "USD";

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Map<String, Object> tmdb;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Map<String, Object> imdb;

    @Column(precision = 3, scale = 1)
    private BigDecimal rating;

    @Column(name = "rating_count", nullable = false)
    private int ratingCount;

    @Column(name = "original_created_at")
    private Instant originalCreatedAt;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "movie_genres",
            joinColumns = @JoinColumn(name = "movie_id"),
            inverseJoinColumns = @JoinColumn(name = "genre_id"))
    private Set<Genre> genres = new LinkedHashSet<>();

    protected Movie() {
    }

    public UUID getId() {
        return id;
    }

    public String getSlug() {
        return slug;
    }

    public String getName() {
        return name;
    }

    public String getOriginName() {
        return originName;
    }

    public String getType() {
        return type;
    }

    public String getStatus() {
        return status;
    }

    public String getContent() {
        return content;
    }

    public String getTrailerUrl() {
        return trailerUrl;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public String getThumbUrl() {
        return thumbUrl;
    }

    public String getQuality() {
        return quality;
    }

    public String getDuration() {
        return duration;
    }

    public String getLang() {
        return lang;
    }

    public Short getYear() {
        return year;
    }

    public long getViewCount() {
        return viewCount;
    }

    public String getEpisodeCurrent() {
        return episodeCurrent;
    }

    public String getEpisodeTotal() {
        return episodeTotal;
    }

    public boolean isCinema() {
        return cinema;
    }

    public boolean isSubExclusive() {
        return subExclusive;
    }

    public boolean isCopyright() {
        return copyright;
    }

    public List<String> getDirectors() {
        return directors;
    }

    public List<String> getActors() {
        return actors;
    }

    public List<Map<String, Object>> getCountries() {
        return countries;
    }

    public int getPriceCents() {
        return priceCents;
    }

    public String getCurrency() {
        return currency;
    }

    public Set<Genre> getGenres() {
        return genres;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public int getRatingCount() {
        return ratingCount;
    }

    /** Viewer reviews take over the displayed rating as soon as there is at least one. */
    public void applyUserRating(double average, int count) {
        this.rating = BigDecimal.valueOf(average).setScale(1, RoundingMode.HALF_UP);
        this.ratingCount = count;
    }

    /** With no viewer reviews left, fall back to the imported TMDB/IMDB vote (0-10 scale halved to 0-5). */
    public void restoreBaselineRating() {
        for (Map<String, Object> source : java.util.Arrays.asList(tmdb, imdb)) {
            if (source != null && source.get("vote_average") instanceof Number avg) {
                this.rating = BigDecimal.valueOf(Math.min(5.0, avg.doubleValue() / 2.0)).setScale(1, RoundingMode.HALF_UP);
                this.ratingCount = source.get("vote_count") instanceof Number c ? c.intValue() : 0;
                return;
            }
        }
        this.rating = null;
        this.ratingCount = 0;
    }
}
