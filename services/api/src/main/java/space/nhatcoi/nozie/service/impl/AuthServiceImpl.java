package space.nhatcoi.nozie.service.impl;

import jakarta.annotation.PostConstruct;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.dto.request.GoogleLoginRequest;
import space.nhatcoi.nozie.dto.request.LoginRequest;
import space.nhatcoi.nozie.dto.request.RefreshTokenRequest;
import space.nhatcoi.nozie.dto.request.RegisterRequest;
import space.nhatcoi.nozie.dto.response.AuthResponse;
import space.nhatcoi.nozie.entity.User;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.mapper.UserMapper;
import space.nhatcoi.nozie.repository.UserRepository;
import space.nhatcoi.nozie.security.GoogleTokenVerifier;
import space.nhatcoi.nozie.security.GoogleTokenVerifier.GoogleIdentity;
import space.nhatcoi.nozie.security.JwtService;
import space.nhatcoi.nozie.service.AuthService;
import space.nhatcoi.nozie.service.RefreshTokenService;
import space.nhatcoi.nozie.util.ClientInfo;

@Service
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final RefreshTokenService refreshTokenService;
    private final GoogleTokenVerifier googleVerifier;
    private final UserMapper userMapper;

    /** Compared against when the email is unknown so login timing does not reveal which emails exist. */
    private String dummyHash;

    public AuthServiceImpl(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService,
            RefreshTokenService refreshTokenService, GoogleTokenVerifier googleVerifier, UserMapper userMapper) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.refreshTokenService = refreshTokenService;
        this.googleVerifier = googleVerifier;
        this.userMapper = userMapper;
    }

    @PostConstruct
    void init() {
        dummyHash = passwordEncoder.encode("nozie-dummy-password");
    }

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request, ClientInfo client) {
        String email = normalize(request.email());
        if (userRepository.existsByEmail(email)) {
            throw new ApiException(ErrorCode.EMAIL_TAKEN);
        }
        User user = User.withPassword(email, passwordEncoder.encode(request.password()), request.fullName().trim());
        try {
            user = userRepository.saveAndFlush(user);
        } catch (DataIntegrityViolationException e) {
            throw new ApiException(ErrorCode.EMAIL_TAKEN);
        }
        return issue(user, client);
    }

    @Override
    @Transactional
    public AuthResponse login(LoginRequest request, ClientInfo client) {
        User user = userRepository.findByEmail(normalize(request.email())).orElse(null);
        String hash = user != null && user.getPasswordHash() != null ? user.getPasswordHash() : dummyHash;
        boolean passwordOk = passwordEncoder.matches(request.password(), hash);
        if (user == null || user.getPasswordHash() == null || !passwordOk) {
            throw new ApiException(ErrorCode.INVALID_CREDENTIALS);
        }
        assertEnabled(user);
        return issue(user, client);
    }

    @Override
    @Transactional
    public AuthResponse loginWithGoogle(GoogleLoginRequest request, ClientInfo client) {
        GoogleIdentity identity = googleVerifier.verify(request.idToken());
        if (!identity.emailVerified() || identity.email() == null) {
            throw new ApiException(ErrorCode.INVALID_GOOGLE_TOKEN);
        }
        String email = normalize(identity.email());
        User user = userRepository.findByGoogleSub(identity.subject())
                .or(() -> userRepository.findByEmail(email))
                .orElse(null);
        if (user == null) {
            user = userRepository.save(User.fromGoogle(email, identity.subject(), identity.name()));
        } else if (user.getGoogleSub() == null) {
            user.linkGoogle(identity.subject());
        }
        assertEnabled(user);
        return issue(user, client);
    }

    @Override
    @Transactional(noRollbackFor = ApiException.class)
    public AuthResponse refresh(RefreshTokenRequest request, ClientInfo client) {
        RefreshTokenService.Rotation rotation = refreshTokenService.rotate(request.refreshToken(), client);
        User user = userRepository.findById(rotation.userId())
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_TOKEN));
        assertEnabled(user);
        return AuthResponse.of(jwtService.createAccessToken(user.getId(), user.getRole().name()),
                rotation.newRawToken(), jwtService.accessTtlSeconds(), userMapper.toResponse(user));
    }

    @Override
    public void logout(RefreshTokenRequest request) {
        refreshTokenService.revoke(request.refreshToken());
    }

    private AuthResponse issue(User user, ClientInfo client) {
        return AuthResponse.of(jwtService.createAccessToken(user.getId(), user.getRole().name()),
                refreshTokenService.issue(user, client), jwtService.accessTtlSeconds(), userMapper.toResponse(user));
    }

    private static void assertEnabled(User user) {
        if (!user.isEnabled()) {
            throw new ApiException(ErrorCode.ACCOUNT_DISABLED);
        }
    }

    private static String normalize(String email) {
        return email.trim().toLowerCase();
    }
}
