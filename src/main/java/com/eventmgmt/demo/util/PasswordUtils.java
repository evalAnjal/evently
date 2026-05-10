package com.eventmgmt.demo.util;

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtils {

    private static final int WORKLOAD = 12;

    private PasswordUtils() {
        // Utility class
    }

    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORKLOAD));
    }

    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.isBlank()) {
            return false;
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
