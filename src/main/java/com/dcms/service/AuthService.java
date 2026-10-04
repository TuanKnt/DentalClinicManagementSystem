package com.dcms.service;

import com.dcms.dao.UserDAO;
import com.dcms.model.User;
import com.dcms.service.exception.AccountDisabledException;
import com.dcms.service.exception.InvalidCredentialsException;
import org.mindrot.jbcrypt.BCrypt;

/**
 * AuthService handles business logic for authentication, security validation and password hashing.
 */
public class AuthService {

    private final UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public AuthService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Authenticates user against stored credentials.
     * @param username non-blank username
     * @param rawPassword non-blank raw password
     * @return User entity on success
     * @throws InvalidCredentialsException if username not found or password incorrect
     * @throws AccountDisabledException if account isActive is false
     */
    public User authenticate(String username, String rawPassword) {
        if (username == null || username.trim().isEmpty() || rawPassword == null || rawPassword.trim().isEmpty()) {
            throw new InvalidCredentialsException("Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu");
        }

        User user = userDAO.findByUsername(username.trim());
        if (user == null) {
            throw new InvalidCredentialsException("Tên đăng nhập hoặc mật khẩu không chính xác");
        }

        if (!user.isActive()) {
            throw new AccountDisabledException("Tài khoản đã bị tạm khóa. Vui lòng liên hệ Quản trị viên phòng khám.");
        }

        boolean passwordMatches = false;
        try {
            passwordMatches = BCrypt.checkpw(rawPassword, user.getPasswordHash());
        } catch (IllegalArgumentException ex) {
            // In case of malformed hash
            throw new InvalidCredentialsException("Tên đăng nhập hoặc mật khẩu không chính xác");
        }

        if (!passwordMatches) {
            throw new InvalidCredentialsException("Tên đăng nhập hoặc mật khẩu không chính xác");
        }

        return user;
    }

    /**
     * Hashes raw password using BCrypt with salt rounds = 10.
     */
    public String hashPassword(String rawPassword) {
        if (rawPassword == null || rawPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống");
        }
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));
    }
}
