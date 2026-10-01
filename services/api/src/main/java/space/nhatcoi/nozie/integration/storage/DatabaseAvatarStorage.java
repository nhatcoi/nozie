package space.nhatcoi.nozie.integration.storage;

import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.entity.UserAvatar;
import space.nhatcoi.nozie.repository.UserAvatarRepository;

@Component
public class DatabaseAvatarStorage implements AvatarStorage {

    private final UserAvatarRepository repository;

    public DatabaseAvatarStorage(UserAvatarRepository repository) {
        this.repository = repository;
    }

    @Override
    @Transactional
    public void store(UUID userId, String contentType, byte[] data) {
        UserAvatar avatar = repository.findById(userId).orElse(null);
        if (avatar == null) {
            repository.save(new UserAvatar(userId, contentType, data));
        } else {
            avatar.replace(contentType, data);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<StoredAvatar> load(UUID userId) {
        return repository.findById(userId).map(a -> new StoredAvatar(a.getContentType(), a.getData()));
    }

    @Override
    @Transactional
    public void delete(UUID userId) {
        repository.deleteById(userId);
    }
}
