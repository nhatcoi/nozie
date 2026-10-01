package space.nhatcoi.nozie.mapper;

import org.springframework.stereotype.Component;

import space.nhatcoi.nozie.dto.response.EpisodeResponse;
import space.nhatcoi.nozie.dto.response.NotificationResponse;
import space.nhatcoi.nozie.dto.response.ReviewResponse;
import space.nhatcoi.nozie.dto.response.TransactionResponse;
import space.nhatcoi.nozie.entity.Episode;
import space.nhatcoi.nozie.entity.Notification;
import space.nhatcoi.nozie.entity.PaymentTransaction;
import space.nhatcoi.nozie.entity.Rating;
import space.nhatcoi.nozie.entity.User;

/** Small response mappers for user-activity records. */
@Component
public class LibraryMapper {

    private final UserMapper userMapper;

    public LibraryMapper(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    public TransactionResponse toResponse(PaymentTransaction t) {
        return new TransactionResponse(t.getId(), t.getMovieId(), t.getAmountCents(), t.getCurrency(),
                t.getStatus().name(), t.getErrorMessage(), t.getCreatedAt(), t.getPaidAt());
    }

    public NotificationResponse toResponse(Notification n) {
        return new NotificationResponse(n.getId(), n.getType(), n.getTitle(), n.getDescription(), n.getDeepLink(),
                n.getMetadata(), n.isRead(), n.getCreatedAt());
    }

    public ReviewResponse toResponse(Rating r, User author, long likes, boolean likedByMe) {
        return new ReviewResponse(r.getId().userId(), author == null ? "" : author.getFullName(),
                author == null ? null : userMapper.avatarUrl(author), r.getRating(), r.getReview(),
                likes, likedByMe, r.getCreatedAt(), r.getUpdatedAt());
    }

    public EpisodeResponse toResponse(Episode e) {
        return new EpisodeResponse(e.getId(), e.getServerName(), e.getName(), e.getSlug(), e.getPosition());
    }
}
