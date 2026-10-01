package space.nhatcoi.nozie.service.impl;

import java.util.UUID;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.request.ChangePasswordRequest;
import space.nhatcoi.nozie.dto.request.UpdateProfileRequest;
import space.nhatcoi.nozie.dto.response.UserResponse;
import space.nhatcoi.nozie.entity.User;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.mapper.UserMapper;
import space.nhatcoi.nozie.repository.UserRepository;
import space.nhatcoi.nozie.service.RefreshTokenService;
import space.nhatcoi.nozie.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final RefreshTokenService refreshTokenService;

    public UserServiceImpl(UserRepository userRepository, UserMapper userMapper, PasswordEncoder passwordEncoder,
            RefreshTokenService refreshTokenService) {
        this.userRepository = userRepository;
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
        this.refreshTokenService = refreshTokenService;
    }

    @Override
    @Transactional(readOnly = true)
    public UserResponse getProfile(UUID userId) {
        return userMapper.toResponse(load(userId));
    }

    @Override
    @Transactional
    public UserResponse updateProfile(UUID userId, UpdateProfileRequest r) {
        User user = load(userId);
        if (r.username() != null && !r.username().equalsIgnoreCase(user.getUsername())) {
            if (userRepository.usernameTakenByOther(r.username(), userId)) {
                throw new ApiException(ErrorCode.USERNAME_TAKEN);
            }
            user.setUsername(r.username());
        }
        if (r.fullName() != null) {
            user.setFullName(r.fullName().trim());
        }
        if (r.phone() != null) {
            user.setPhone(r.phone());
        }
        if (r.dateOfBirth() != null) {
            user.setDateOfBirth(r.dateOfBirth());
        }
        if (r.gender() != null) {
            user.setGender(r.gender());
        }
        if (r.country() != null) {
            user.setCountry(r.country());
        }
        return userMapper.toResponse(userRepository.save(user));
    }

    @Override
    @Transactional
    public void changePassword(UUID userId, ChangePasswordRequest r) {
        User user = load(userId);
        if (user.getPasswordHash() != null
                && (r.currentPassword() == null || !passwordEncoder.matches(r.currentPassword(), user.getPasswordHash()))) {
            throw new ApiException(ErrorCode.INVALID_CREDENTIALS);
        }
        user.setPasswordHash(passwordEncoder.encode(r.newPassword()));
        userRepository.save(user);
        refreshTokenService.revokeAllForUser(userId);
    }

    private User load(UUID userId) {
        return userRepository.findById(userId).orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));
    }
}
