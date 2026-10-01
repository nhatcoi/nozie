package space.nhatcoi.nozie.mapper;

import org.springframework.stereotype.Component;

import space.nhatcoi.nozie.dto.response.UserResponse;
import space.nhatcoi.nozie.entity.User;

@Component
public class UserMapper {

    /** Relative to the server origin; {@code ?v=} busts client image caches when the avatar changes. */
    public String avatarUrl(User u) {
        return u.getAvatarKey() == null ? null : "/api/v1/users/" + u.getId() + "/avatar?v=" + u.getAvatarKey();
    }

    public UserResponse toResponse(User u) {
        return new UserResponse(u.getId(), u.getEmail(), u.isEmailVerified(), u.getFullName(), u.getUsername(),
                u.getPhone(), u.getDateOfBirth(), u.getGender(), u.getCountry(), avatarUrl(u),
                u.getRole().name(), u.getCreatedAt());
    }
}
