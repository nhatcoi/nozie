package space.nhatcoi.nozie.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import space.nhatcoi.nozie.configuration.AppProperties;
import space.nhatcoi.nozie.service.MailService;

/** Sent asynchronously so response time never reveals whether the address belongs to an account. */
@Service
public class SmtpMailService implements MailService {

    private static final Logger log = LoggerFactory.getLogger(SmtpMailService.class);

    private final JavaMailSender mailSender;
    private final String from;

    public SmtpMailService(JavaMailSender mailSender, AppProperties properties) {
        this.mailSender = mailSender;
        this.from = properties.mail().from();
    }

    @Async
    @Override
    public void sendPasswordResetOtp(String to, String code, long ttlMinutes) {
        SimpleMailMessage msg = new SimpleMailMessage();
        msg.setFrom(from);
        msg.setTo(to);
        msg.setSubject("Your Nozie password reset code");
        msg.setText("Your verification code is " + code + ". It expires in " + ttlMinutes
                + " minutes. If you did not request this, ignore this email.");
        try {
            mailSender.send(msg);
        } catch (Exception e) {
            log.error("Failed to send password reset email", e);
        }
    }
}
