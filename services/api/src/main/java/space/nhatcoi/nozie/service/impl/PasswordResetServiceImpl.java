package space.nhatcoi.nozie.service.impl;

import java.time.Duration;
import java.time.Instant;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import space.nhatcoi.nozie.configuration.AppProperties;
import space.nhatcoi.nozie.dto.request.ForgotPasswordRequest;
import space.nhatcoi.nozie.dto.request.ResetPasswordRequest;
import space.nhatcoi.nozie.dto.request.VerifyOtpRequest;
import space.nhatcoi.nozie.dto.response.ResetTokenResponse;
import space.nhatcoi.nozie.entity.PasswordReset;
import space.nhatcoi.nozie.entity.User;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;
import space.nhatcoi.nozie.repository.PasswordResetRepository;
import space.nhatcoi.nozie.repository.UserRepository;
import space.nhatcoi.nozie.service.MailService;
import space.nhatcoi.nozie.service.PasswordResetService;
import space.nhatcoi.nozie.service.RefreshTokenService;
import space.nhatcoi.nozie.util.HashUtils;

@Service
public class PasswordResetServiceImpl implements PasswordResetService {

    private static final Duration REQUEST_WINDOW = Duration.ofMinutes(10);
    private static final int OTP_DIGITS = 6;

    private final UserRepository userRepository;
    private final PasswordResetRepository resetRepository;
    private final RefreshTokenService refreshTokenService;
    private final MailService mailService;
    private final PasswordEncoder passwordEncoder;
    private final AppProperties.Otp otp;
    private final String pepper;

    public PasswordResetServiceImpl(UserRepository userRepository, PasswordResetRepository resetRepository,
            RefreshTokenService refreshTokenService, MailService mailService, PasswordEncoder passwordEncoder,
            AppProperties properties) {
        this.userRepository = userRepository;
        this.resetRepository = resetRepository;
        this.refreshTokenService = refreshTokenService;
        this.mailService = mailService;
        this.passwordEncoder = passwordEncoder;
        this.otp = properties.otp();
        this.pepper = properties.jwt().secret();
    }

    @Override
    @Transactional
    public void requestOtp(ForgotPasswordRequest request) {
        User user = userRepository.findByEmail(normalize(request.email())).orElse(null);
        if (user == null || !user.isEnabled()) {
            return;
        }
        if (resetRepository.countRecent(user.getId(), Instant.now().minus(REQUEST_WINDOW)) >= otp.maxRequests()) {
            return; // throttled: stay silent so the endpoint cannot be used to probe or spam
        }
        resetRepository.consumeAllForUser(user.getId());
        String code = HashUtils.randomDigits(OTP_DIGITS);
        resetRepository.save(new PasswordReset(user.getId(), hashOtp(user, code), Instant.now().plus(otp.ttl())));
        mailService.sendPasswordResetOtp(user.getEmail(), code, otp.ttl().toMinutes());
    }

    /** noRollbackFor: failed-attempt counter must persist when we throw. */
    @Override
    @Transactional(noRollbackFor = ApiException.class)
    public ResetTokenResponse verifyOtp(VerifyOtpRequest request) {
        User user = userRepository.findByEmail(normalize(request.email()))
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_OTP));
        PasswordReset reset = resetRepository.findFirstByUserIdAndConsumedAtIsNullOrderByCreatedAtDesc(user.getId())
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_OTP));
        if (reset.getVerifiedAt() != null || reset.getExpiresAt().isBefore(Instant.now())
                || reset.getAttempts() >= otp.maxAttempts()) {
            throw new ApiException(ErrorCode.INVALID_OTP);
        }
        if (!HashUtils.constantTimeEquals(reset.getOtpHash(), hashOtp(user, request.code()))) {
            resetRepository.incrementAttempts(reset.getId());
            throw new ApiException(ErrorCode.INVALID_OTP);
        }
        String resetToken = HashUtils.randomToken(32);
        reset.markVerified(HashUtils.sha256Hex(resetToken), Instant.now().plus(otp.ttl()));
        resetRepository.save(reset);
        return new ResetTokenResponse(resetToken);
    }

    @Override
    @Transactional
    public void resetPassword(ResetPasswordRequest request) {
        PasswordReset reset = resetRepository.findByResetTokenHash(HashUtils.sha256Hex(request.resetToken()))
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_RESET_TOKEN));
        if (reset.getVerifiedAt() == null || reset.getConsumedAt() != null
                || reset.getExpiresAt().isBefore(Instant.now())) {
            throw new ApiException(ErrorCode.INVALID_RESET_TOKEN);
        }
        User user = userRepository.findById(reset.getUserId())
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_RESET_TOKEN));
        user.setPasswordHash(passwordEncoder.encode(request.newPassword()));
        reset.consume();
        resetRepository.save(reset);
        refreshTokenService.revokeAllForUser(user.getId());
    }

    private String hashOtp(User user, String code) {
        return HashUtils.hmacSha256Hex(pepper, user.getId() + ":" + code);
    }

    private static String normalize(String email) {
        return email.trim().toLowerCase();
    }
}
