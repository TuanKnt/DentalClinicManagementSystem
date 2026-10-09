package com.dcms.service.exception;

/**
 * Thrown when a business rule invariant is violated (e.g. Iron Rules 1-10).
 */
public class BusinessRuleViolationException extends RuntimeException {
    public BusinessRuleViolationException(String message) {
        super(message);
    }

    public BusinessRuleViolationException(String message, Throwable cause) {
        super(message, cause);
    }
}
