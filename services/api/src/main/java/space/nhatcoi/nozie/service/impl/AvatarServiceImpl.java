package space.nhatcoi.nozie.service.impl;

import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.response.UserResponse;
import space.nhatcoi.nozie.entity.User;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.integration.storage.AvatarStorage;
import space.nhatcoi.nozie.integration.storage.AvatarStorage.StoredAvatar;
import space.nhatcoi.nozie.mapper.UserMapper;
import space.nhatcoi.nozie.repository.UserRepository;
import space.nhatcoi.nozie.service.AvatarService;

@Service
@Transactional
public class AvatarServiceImpl implements AvatarService {

    static final int MAX_BYTES = 2 * 1024 * 1024;

    private final AvatarStorage storage;
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public AvatarServiceImpl(AvatarStorage storage, UserRepository userRepository, UserMapper userMapper) {
        this.storage = storage;
        this.userRepository = userRepository;
        this.userMapper = userMapper;
    }

    @Override
    public UserResponse upload(UUID userId, byte[] bytes) {
        if (bytes == null || bytes.length == 0) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED, "No file uploaded");
        }
        if (bytes.length > MAX_BYTES) {
            throw new ApiException(ErrorCode.FILE_TOO_LARGE);
        }
        String type = sniff(bytes);
        if (type == null) {
            throw new ApiException(ErrorCode.UNSUPPORTED_FILE_TYPE, "Only JPEG, PNG or WebP images are accepted");
        }
        User user = load(userId);
        storage.store(userId, type, bytes);
        user.setAvatarKey(Long.toString(System.currentTimeMillis()));
        return userMapper.toResponse(userRepository.save(user));
    }

    @Override
    public UserResponse remove(UUID userId) {
        User user = load(userId);
        storage.delete(userId);
        user.setAvatarKey(null);
        return userMapper.toResponse(userRepository.save(user));
    }

    @Override
    @Transactional(readOnly = true)
    public StoredAvatar loadAvatar(UUID userId) {
        return storage.load(userId).orElseThrow(() -> new ApiException(ErrorCode.NOT_FOUND));
    }

    private User load(UUID userId) {
        return userRepository.findById(userId).orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));
    }

    /** JPEG, PNG and WebP signatures. SVG/GIF/HTML are rejected so a stored avatar can never carry script. */
    static String sniff(byte[] b) {
        if (b.length >= 3 && (b[0] & 0xFF) == 0xFF && (b[1] & 0xFF) == 0xD8 && (b[2] & 0xFF) == 0xFF) {
            return "image/jpeg";
        }
        if (b.length >= 8 && (b[0] & 0xFF) == 0x89 && b[1] == 'P' && b[2] == 'N' && b[3] == 'G'
                && b[4] == 0x0D && b[5] == 0x0A && b[6] == 0x1A && b[7] == 0x0A) {
            return "image/png";
        }
        if (b.length >= 12 && b[0] == 'R' && b[1] == 'I' && b[2] == 'F' && b[3] == 'F'
                && b[8] == 'W' && b[9] == 'E' && b[10] == 'B' && b[11] == 'P') {
            return "image/webp";
        }
        return null;
    }
}
