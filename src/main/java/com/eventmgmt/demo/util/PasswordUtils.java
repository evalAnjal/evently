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
        // Support legacy plaintext passwords stored in DB: if the stored value
        // doesn't look like a bcrypt hash, fall back to plain equality.
        try {
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$") || hashedPassword.startsWith("$2x$")) {
                return BCrypt.checkpw(plainPassword, hashedPassword);
            }
        } catch (IllegalArgumentException e) {
            // Invalid salt/version in stored hash. Fall back to plaintext compare below.
        }

        return plainPassword.equals(hashedPassword);
    }
}
