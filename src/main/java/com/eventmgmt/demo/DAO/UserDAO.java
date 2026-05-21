package com.eventmgmt.demo.DAO;

import com.eventmgmt.demo.model.User;
import com.eventmgmt.demo.util.DBconnection;
import com.eventmgmt.demo.util.PasswordUtils;
import java.sql.*;

public class UserDAO {
    public User validateUser(String email, String password) {
        User user = null;
        String sql = "select * from users where email = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, email);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                String stored = rs.getString("password");
                if (PasswordUtils.verifyPassword(password, stored)) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setUsername(rs.getString("username"));
                    if (hasColumn(rs, "district")) {
                        user.setDistrict(rs.getString("district"));
                    }

                    // If the stored password looked like a legacy plaintext value,
                    // upgrade it to a bcrypt hash so future logins use bcrypt.
                    if (stored != null && !stored.startsWith("$2")) {
                        String newHash = PasswordUtils.hashPassword(password);
                        try (PreparedStatement up = conn.prepareStatement("UPDATE users SET password = ? WHERE id = ?")) {
                            up.setString(1, newHash);
                            up.setInt(2, user.getId());
                            up.executeUpdate();
                        } catch (SQLException ignored) {
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public int registerUserAndGetId(User user) throws SQLException {
        String role = (user.getRole() == null || user.getRole().isBlank()) ? "MEMBER" : user.getRole();
        String sql = "INSERT INTO users(username,email,password,role,district) VALUES(?,?,?,?,?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, user.getUsername());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPassword());
            st.setString(4, role);
            st.setString(5, user.getDistrict());

            int rows = st.executeUpdate();
            try (ResultSet keys = st.getGeneratedKeys()) {
                if (keys != null && keys.next()) {
                    return keys.getInt(1);
                }
            }
            if (rows == 0) throw new SQLException("No row inserted for registration.");
            throw new SQLException("Failed to obtain generated id for registration.");
        } catch (SQLException e) {
            // Backward compatibility for DBs that don't have users.district yet.
            String state = e.getSQLState();
            String msg = e.getMessage() == null ? "" : e.getMessage();
            if ("42703".equals(state) || "42S22".equals(state) || msg.contains("Unknown column")) {
                return registerUserWithoutDistrict(user, role);
            }
            throw e;
        }
    }

    // Backward-compatible signature used by older compiled servlets.
    public void registerUser(User user) throws SQLException {
        registerUserAndGetId(user);
    }

    private int registerUserWithoutDistrict(User user, String role) throws SQLException {
        String sql = "INSERT INTO users(username,email,password,role) VALUES(?,?,?,?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, user.getUsername());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPassword());
            st.setString(4, role);

            int rows = st.executeUpdate();
            try (ResultSet keys = st.getGeneratedKeys()) {
                if (keys != null && keys.next()) {
                    return keys.getInt(1);
                }
            }
            if (rows == 0) throw new SQLException("No row inserted for registration.");
            throw new SQLException("Failed to obtain generated id for registration.");
        }
    }

    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            ResultSetMetaData meta = rs.getMetaData();
            int cols = meta.getColumnCount();
            for (int i = 1; i <= cols; i++) {
                if (columnName.equalsIgnoreCase(meta.getColumnLabel(i))) {
                    return true;
                }
            }
        } catch (SQLException ignored) {
        }
        return false;
    }

    public boolean promoteUserToAdmin(int userId) {
        String sql = "UPDATE users SET role = 'ADMIN' WHERE id = ? AND role = 'ORG_PENDING'";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalUsersCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
