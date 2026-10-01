package space.nhatcoi.nozie.entity;

import java.time.LocalDate;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import space.nhatcoi.nozie.enums.Role;

@Entity
@Table(name = "users")
public class User extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 320)
    private String email;

    @Column(name = "password_hash")
    private String passwordHash;

    @Column(name = "google_sub", length = 64)
    private String googleSub;

    @Column(name = "email_verified", nullable = false)
    private boolean emailVerified;

    @Column(name = "full_name", nullable = false, length = 120)
    private String fullName = "";

    @Column(length = 40)
    private String username;

    @Column(length = 32)
    private String phone;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(length = 16)
    private String gender;

    @Column(length = 64)
    private String country;

    @Column(name = "avatar_key")
    private String avatarKey;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private Role role = Role.USER;

    @Column(nullable = false)
    private boolean enabled = true;

    protected User() {
    }

    public static User withPassword(String email, String passwordHash, String fullName) {
        User u = new User();
        u.email = email;
        u.passwordHash = passwordHash;
        u.fullName = fullName == null ? "" : fullName;
        return u;
    }

    public static User fromGoogle(String email, String googleSub, String fullName) {
        User u = new User();
        u.email = email;
        u.googleSub = googleSub;
        u.emailVerified = true;
        u.fullName = fullName == null ? "" : fullName;
        return u;
    }

    public UUID getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getGoogleSub() {
        return googleSub;
    }

    public void linkGoogle(String googleSub) {
        this.googleSub = googleSub;
        this.emailVerified = true;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getAvatarKey() {
        return avatarKey;
    }

    public void setAvatarKey(String avatarKey) {
        this.avatarKey = avatarKey;
    }

    public Role getRole() {
        return role;
    }

    public boolean isEnabled() {
        return enabled;
    }
}
