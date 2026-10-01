package space.nhatcoi.nozie.specification;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Order;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import jakarta.persistence.criteria.Subquery;

import org.springframework.data.jpa.domain.Specification;

import space.nhatcoi.nozie.dto.request.MovieSearchCriteria;
import space.nhatcoi.nozie.dto.request.MovieSort;
import space.nhatcoi.nozie.entity.Genre;
import space.nhatcoi.nozie.entity.Movie;
import space.nhatcoi.nozie.util.LikePattern;

/** Composable filters for the movie catalog. Null/blank criteria are ignored. */
public final class MovieSpecifications {

    private MovieSpecifications() {
    }

    public static Specification<Movie> from(MovieSearchCriteria c) {
        List<String> genreKeys = new java.util.ArrayList<>();
        if (c.genre() != null && !c.genre().isBlank()) {
            genreKeys.add(c.genre().trim().toLowerCase());
        }
        if (c.genres() != null) {
            c.genres().stream().filter(g -> g != null && !g.isBlank()).map(g -> g.trim().toLowerCase()).forEach(genreKeys::add);
        }
        return Specification.where(textMatches(c.q()))
                .and(hasAnyGenre(genreKeys))
                .and(hasYear(c.year()))
                .and(minYear(c.minYear()))
                .and(hasType(c.type()))
                .and(freeOnly(c.free()))
                .and(cinema(c.cinema()))
                .and(ratingMin(c.ratingMin()))
                .and(priceBetween(c.priceMinCents(), c.priceMaxCents()))
                .and(statusNot(c.excludeStatus()))
                .and(slugPrefix(c.slugPrefix()));
    }

    /** Movies that share at least one of the given genre ids. Used for "similar" and "recommended". */
    public static Specification<Movie> inGenreIds(List<Short> genreIds, UUID excludeMovieId) {
        return (root, query, cb) -> {
            Subquery<Integer> sub = query.subquery(Integer.class);
            Root<Movie> m = sub.correlate(root);
            Join<Movie, Genre> g = m.join("genres", JoinType.INNER);
            sub.select(cb.literal(1)).where(g.get("id").in(genreIds));
            Predicate p = cb.exists(sub);
            return excludeMovieId == null ? p : cb.and(p, cb.notEqual(root.get("id"), excludeMovieId));
        };
    }

    /**
     * Applies the ORDER BY inside the specification because Spring Data cannot express NULLS LAST for criteria
     * queries. Skipped for the count query. Ties fall back to popularity, then id, so paging is stable.
     */
    public static Specification<Movie> orderedBy(MovieSort sort) {
        return (root, query, cb) -> {
            if (query.getResultType() == Long.class || query.getResultType() == long.class) {
                return cb.conjunction();
            }
            List<Order> orders = new ArrayList<>();
            Path<Object> field = root.get(sort.field());
            if (sort.nullable()) {
                orders.add(cb.asc(cb.<Integer>selectCase().when(cb.isNull(field), 1).otherwise(0)));
            }
            orders.add(sort.ascending() ? cb.asc(field) : cb.desc(field));
            if (!"viewCount".equals(sort.field())) {
                orders.add(cb.desc(root.get("viewCount")));
            }
            orders.add(cb.asc(root.get("id")));
            query.orderBy(orders);
            return cb.conjunction();
        };
    }

    private static Specification<Movie> textMatches(String q) {
        if (q == null || q.isBlank()) {
            return null;
        }
        String pattern = LikePattern.contains(q);
        return (root, query, cb) -> cb.or(
                cb.like(cb.lower(root.get("name")), pattern, LikePattern.ESCAPE),
                cb.like(cb.lower(root.get("originName")), pattern, LikePattern.ESCAPE));
    }

    private static Specification<Movie> hasAnyGenre(List<String> keys) {
        if (keys.isEmpty()) {
            return null;
        }
        return (root, query, cb) -> {
            Subquery<Integer> sub = query.subquery(Integer.class);
            Root<Movie> m = sub.correlate(root);
            Join<Movie, Genre> g = m.join("genres", JoinType.INNER);
            sub.select(cb.literal(1)).where(cb.or(cb.lower(g.<String>get("slug")).in(keys), cb.lower(g.<String>get("name")).in(keys)));
            return cb.exists(sub);
        };
    }

    private static Specification<Movie> hasYear(Short year) {
        return year == null ? null : (root, query, cb) -> cb.equal(root.get("year"), year);
    }

    private static Specification<Movie> minYear(Short year) {
        return year == null ? null : (root, query, cb) -> cb.greaterThanOrEqualTo(root.<Short>get("year"), year);
    }

    private static Specification<Movie> hasType(String type) {
        return type == null || type.isBlank() ? null : (root, query, cb) -> cb.equal(root.get("type"), type);
    }

    private static Specification<Movie> freeOnly(Boolean free) {
        if (free == null) {
            return null;
        }
        return (root, query, cb) -> free
                ? cb.equal(root.get("priceCents"), 0)
                : cb.greaterThan(root.<Integer>get("priceCents"), 0);
    }

    private static Specification<Movie> cinema(Boolean cinema) {
        return cinema == null ? null : (root, query, cb) -> cb.equal(root.get("cinema"), cinema);
    }

    private static Specification<Movie> ratingMin(Double min) {
        return min == null ? null : (root, query, cb) -> cb.greaterThanOrEqualTo(root.<BigDecimal>get("rating"), BigDecimal.valueOf(min));
    }

    private static Specification<Movie> priceBetween(Integer min, Integer max) {
        if (min == null && max == null) {
            return null;
        }
        return (root, query, cb) -> {
            Predicate p = cb.conjunction();
            if (min != null) {
                p = cb.and(p, cb.greaterThanOrEqualTo(root.<Integer>get("priceCents"), min));
            }
            if (max != null) {
                p = cb.and(p, cb.lessThanOrEqualTo(root.<Integer>get("priceCents"), max));
            }
            return p;
        };
    }

    private static Specification<Movie> statusNot(String status) {
        if (status == null || status.isBlank()) {
            return null;
        }
        return (root, query, cb) -> cb.or(cb.isNull(root.get("status")), cb.notEqual(root.get("status"), status));
    }

    private static Specification<Movie> slugPrefix(String prefix) {
        if (prefix == null || prefix.isBlank()) {
            return null;
        }
        String pattern = LikePattern.startsWith(prefix);
        return (root, query, cb) -> cb.like(cb.lower(root.get("slug")), pattern, LikePattern.ESCAPE);
    }
}
