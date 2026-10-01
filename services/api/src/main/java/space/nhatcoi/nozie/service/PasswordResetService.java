package space.nhatcoi.nozie.service;

import space.nhatcoi.nozie.dto.request.ForgotPasswordRequest;
import space.nhatcoi.nozie.dto.request.ResetPasswordRequest;
import space.nhatcoi.nozie.dto.request.VerifyOtpRequest;
import space.nhatcoi.nozie.dto.response.ResetTokenResponse;

public interface PasswordResetService {

    /** Always completes silently, whether or not the email has an account. */
    void requestOtp(ForgotPasswordRequest request);

    ResetTokenResponse verifyOtp(VerifyOtpRequest request);

    void resetPassword(ResetPasswordRequest request);
}
