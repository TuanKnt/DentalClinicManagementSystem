package com.dcms.service.exception;

public class PatientValidationException extends RuntimeException {
    public PatientValidationException(String message) {
        super(message);
    }
}
