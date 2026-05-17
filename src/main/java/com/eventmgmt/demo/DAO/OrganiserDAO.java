package com.eventmgmt.demo.DAO;

import com.eventmgmt.demo.model.Organiser;
import com.eventmgmt.demo.util.DBconnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrganiserDAO {
    
    /**
     * Register a new organiser
     */
    public boolean registerOrganiser(Organiser org) throws SQLException {
        String sql = "INSERT INTO organisers (user_id, name, email, password, phone, district, address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, org.getUserId(), Types.INTEGER);
            st.setString(2, org.getName());
            st.setString(3, org.getEmail());
            st.setString(4, org.getPassword());
            st.setString(5, org.getPhone());
            st.setString(6, org.getDistrict());
            st.setString(7, org.getAddress());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Validate organiser login (email + password)
     */
    public Organiser validateOrganiser(String email, String password) {
        Organiser org = null;
        String sql = "SELECT * FROM organisers WHERE email = ? AND password = ?";
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, email);
            st.setString(2, password);
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                org = mapResultSetToOrganiser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return org;
    }

    /**
     * Get organiser by ID
     */
    public Organiser getOrganiserById(int id) {
        String sql = "SELECT * FROM organisers WHERE id = ?";
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToOrganiser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public Organiser getOrganiserByUserId(int userId) {
        String sql = "SELECT * FROM organisers WHERE user_id = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToOrganiser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all unverified organisers (for SUPER_ADMIN review)
     */
    public List<Organiser> getUnverifiedOrganisers() {
        List<Organiser> organisers = new ArrayList<>();
        String sql = "SELECT * FROM organisers WHERE verified = FALSE ORDER BY created_at ASC";
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                organisers.add(mapResultSetToOrganiser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return organisers;
    }

    /**
     * Get all verified organisers
     */
    public List<Organiser> getVerifiedOrganisers() {
        List<Organiser> organisers = new ArrayList<>();
        String sql = "SELECT * FROM organisers WHERE verified = TRUE ORDER BY name ASC";
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                organisers.add(mapResultSetToOrganiser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return organisers;
    }

    /**
     * Verify an organiser by SUPER_ADMIN
     */
    public boolean verifyOrganiser(int organiserId) throws SQLException {
        String sql = "UPDATE organisers SET verified = TRUE, updated_at = now() WHERE id = ?";
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, organiserId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Deactivate a verified organiser (set verified = FALSE)
     */
    public boolean deactivateOrganiser(int organiserId) throws SQLException {
        String sql = "UPDATE organisers SET verified = FALSE, updated_at = now() WHERE id = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, organiserId);

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Reject/delete an organiser application
     */
    public boolean rejectOrganiser(int organiserId) throws SQLException {
        String sql = "DELETE FROM organisers WHERE id = ? AND verified = FALSE";
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, organiserId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Get organisers by district
     */
    public List<Organiser> getOrganisersByDistrict(String district) {
        List<Organiser> organisers = new ArrayList<>();
        String sql = "SELECT * FROM organisers WHERE district = ? AND verified = TRUE ORDER BY name ASC";
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, district);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                organisers.add(mapResultSetToOrganiser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return organisers;
    }

    /**
     * Check if email already exists
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM organisers WHERE email = ?";
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, email);
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    /**
     * Helper method to map ResultSet to Organiser object
     */
    private Organiser mapResultSetToOrganiser(ResultSet rs) throws SQLException {
        Organiser org = new Organiser();
        org.setId(rs.getInt("id"));
        org.setUserId((Integer) rs.getObject("user_id"));
        org.setName(rs.getString("name"));
        org.setEmail(rs.getString("email"));
        org.setPassword(rs.getString("password"));
        org.setPhone(rs.getString("phone"));
        org.setDistrict(rs.getString("district"));
        org.setAddress(rs.getString("address"));
        org.setVerified(rs.getBoolean("verified"));
        org.setCreatedAt(rs.getTimestamp("created_at"));
        org.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return org;
    }
}
