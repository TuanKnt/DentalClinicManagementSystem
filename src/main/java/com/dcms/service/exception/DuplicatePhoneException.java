package com.dcms.service.exception;

public class DuplicatePhoneException extends PatientValidationException {
    public DuplicatePhoneException(String message) {
        super(message);
    }
}
