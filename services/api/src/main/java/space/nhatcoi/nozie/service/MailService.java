package space.nhatcoi.nozie.service;

public interface MailService {

    void sendPasswordResetOtp(String to, String code, long ttlMinutes);
}
