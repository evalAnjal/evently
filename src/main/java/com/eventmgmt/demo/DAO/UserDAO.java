package com.eventmgmt.demo.DAO;

import com.eventmgmt.demo.model.User;
import com.eventmgmt.demo.util.DBconnection;
import java.sql.*;

public class UserDAO {
    public User validateUser (String email, String password){
        User user = null;
        String sql = "select * from users where email =? and password = ?";

        try(Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql)        
    ){
        st.setString(1,email);
        st.setString(2,password);
        

        ResultSet rs = st.executeQuery();

        if(rs.next()){
            user = new User();
            user.setId(rs.getInt("id"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getString(("role")));
            user.setUsername(rs.getString(("username")));
            if (hasColumn(rs, "district")) {
                user.setDistrict(rs.getString("district"));
            }
        }


        
    }
    catch(SQLException e){
        e.printStackTrace();
    }
    return user;
    }

    public int registerUserAndGetId(User user) throws SQLException {
        String role = (user.getRole() == null || user.getRole().isBlank()) ? "MEMBER" : user.getRole();
        String sql = "INSERT INTO users(username,email,password,role,district) VALUES(?,?,?,?,?) RETURNING id";
        try(Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql)){
                st.setString(1, user.getUsername());
                st.setString(2, user.getEmail());
                st.setString(3, user.getPassword());
                st.setString(4, role);
                st.setString(5, user.getDistrict());

                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
                throw new SQLException("No row inserted for registration.");
            } catch (SQLException e) {
                // Backward compatibility for DBs that don't have users.district yet.
                if ("42703".equals(e.getSQLState())) {
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
        String sql = "INSERT INTO users(username,email,password,role) VALUES(?,?,?,?) RETURNING id";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, user.getUsername());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPassword());
            st.setString(4, role);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            throw new SQLException("No row inserted for registration.");
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
}
