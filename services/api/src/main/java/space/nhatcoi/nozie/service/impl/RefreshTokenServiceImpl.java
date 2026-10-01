package space.nhatcoi.nozie.service.impl;

import java.time.Instant;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.configuration.AppProperties;
import space.nhatcoi.nozie.entity.RefreshToken;
import space.nhatcoi.nozie.entity.User;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.repository.RefreshTokenRepository;
import space.nhatcoi.nozie.service.RefreshTokenService;
import space.nhatcoi.nozie.util.ClientInfo;
import space.nhatcoi.nozie.util.HashUtils;

@Service
public class RefreshTokenServiceImpl implements RefreshTokenService {

    private final RefreshTokenRepository repository;
    private final AppProperties.Jwt jwtProps;

    public RefreshTokenServiceImpl(RefreshTokenRepository repository, AppProperties properties) {
        this.repository = repository;
        this.jwtProps = properties.jwt();
    }

    @Override
    @Transactional
    public String issue(User user, ClientInfo client) {
        return create(user.getId(), UUID.randomUUID(), client);
    }

    /** noRollbackFor: the family revocation on replay must persist even though we then throw. */
    @Override
    @Transactional(noRollbackFor = ApiException.class)
    public Rotation rotate(String rawToken, ClientInfo client) {
        RefreshToken current = repository.findByTokenHashForUpdate(HashUtils.sha256Hex(rawToken))
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_TOKEN));
        if (current.isRevoked()) {
            repository.revokeFamily(current.getFamilyId());
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }
        if (current.getExpiresAt().isBefore(Instant.now())) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }
        current.revoke();
        return new Rotation(current.getUserId(), create(current.getUserId(), current.getFamilyId(), client));
    }

    @Override
    @Transactional
    public void revoke(String rawToken) {
        repository.findByTokenHashForUpdate(HashUtils.sha256Hex(rawToken))
                .ifPresent(t -> repository.revokeFamily(t.getFamilyId()));
    }

    @Override
    @Transactional
    public void revokeAllForUser(UUID userId) {
        repository.revokeAllForUser(userId);
    }

    private String create(UUID userId, UUID familyId, ClientInfo client) {
        String raw = HashUtils.randomToken(32);
        repository.save(new RefreshToken(userId, familyId, HashUtils.sha256Hex(raw),
                Instant.now().plus(jwtProps.refreshTtl()), client.userAgent(), client.ip()));
        return raw;
    }
}
