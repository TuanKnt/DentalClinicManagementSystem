package com.dcms.service;

import com.dcms.dao.UserDAO;
import com.dcms.model.User;
import com.dcms.service.exception.AccountDisabledException;
import com.dcms.service.exception.InvalidCredentialsException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mindrot.jbcrypt.BCrypt;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AuthServiceTest {

    @Mock
    private UserDAO userDAO;

    private AuthService authService;

    private User sampleUser;
    private final String rawPassword = "Password123@";
    private String hashedPassword;

    @BeforeEach
    public void setUp() {
        authService = new AuthService(userDAO);
        hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));

        sampleUser = new User();
        sampleUser.setUserId(1);
        sampleUser.setUsername("letan01");
        sampleUser.setPasswordHash(hashedPassword);
        sampleUser.setFullName("Nguyễn Thị Thu");
        sampleUser.setRoleId(2);
        sampleUser.setRoleName("Receptionist");
        sampleUser.setActive(true);
    }

    @Test
    @DisplayName("TC_AUTH_01: Login Success with valid username and password")
    public void testAuthenticateSuccess() {
        when(userDAO.findByUsername("letan01")).thenReturn(sampleUser);

        User result = authService.authenticate("letan01", rawPassword);

        assertNotNull(result, "Authenticated user should not be null");
        assertEquals("letan01", result.getUsername());
        assertEquals("Receptionist", result.getRoleName());
        verify(userDAO, times(1)).findByUsername("letan01");
    }

    @Test
    @DisplayName("TC_AUTH_02: Login Failure with incorrect password")
    public void testAuthenticateWrongPassword() {
        when(userDAO.findByUsername("letan01")).thenReturn(sampleUser);

        assertThrows(InvalidCredentialsException.class, () -> {
            authService.authenticate("letan01", "WrongPassword999");
        }, "Should throw InvalidCredentialsException when password does not match");
    }

    @Test
    @DisplayName("TC_AUTH_03: Login Failure with nonexistent username")
    public void testAuthenticateUserNotFound() {
        when(userDAO.findByUsername("unknown_user")).thenReturn(null);

        assertThrows(InvalidCredentialsException.class, () -> {
            authService.authenticate("unknown_user", rawPassword);
        }, "Should throw InvalidCredentialsException when user not found");
    }

    @Test
    @DisplayName("TC_AUTH_04: Login Blocked when account is inactive / disabled")
    public void testAuthenticateUserDisabled() {
        sampleUser.setActive(false);
        when(userDAO.findByUsername("letan01")).thenReturn(sampleUser);

        assertThrows(AccountDisabledException.class, () -> {
            authService.authenticate("letan01", rawPassword);
        }, "Should throw AccountDisabledException when isActive is false");
    }

    @Test
    @DisplayName("TC_AUTH_05: Validation Error on null or blank input")
    public void testAuthenticateBlankInput() {
        assertThrows(InvalidCredentialsException.class, () -> authService.authenticate("", "pass"));
        assertThrows(InvalidCredentialsException.class, () -> authService.authenticate("user", "  "));
        assertThrows(InvalidCredentialsException.class, () -> authService.authenticate(null, "pass"));
    }

    @Test
    @DisplayName("TC_AUTH_06: Password Hashing with BCrypt")
    public void testHashPassword() {
        String hash = authService.hashPassword("secret123");
        assertNotNull(hash);
        assertTrue(BCrypt.checkpw("secret123", hash), "Hashed password must match raw string");
    }
}
