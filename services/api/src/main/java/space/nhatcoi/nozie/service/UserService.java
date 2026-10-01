package space.nhatcoi.nozie.service;

import java.util.UUID;

import space.nhatcoi.nozie.dto.request.ChangePasswordRequest;
import space.nhatcoi.nozie.dto.request.UpdateProfileRequest;
import space.nhatcoi.nozie.dto.response.UserResponse;

public interface UserService {

    UserResponse getProfile(UUID userId);

    UserResponse updateProfile(UUID userId, UpdateProfileRequest request);

    /** Changes the password and signs the user out of every session. */
    void changePassword(UUID userId, ChangePasswordRequest request);
}
