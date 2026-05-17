package com.eventmgmt.demo.DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.eventmgmt.demo.util.DBconnection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;



public class registrationDAO {

    public boolean joinEvent(int userId, int eventID, String phone, int age, String preference){
        String sql = "INSERT INTO registrations(user_id, event_id, phone, age, preference) VALUES(?,?,?,?,?)";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, eventID);
            st.setString(3, phone);
            st.setInt(4, age);
            st.setString(5, preference);

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

    public List<Integer> getJoinedEventIds(int userId) {
    List<Integer> joinedIds = new ArrayList<>();
    String sql = "SELECT event_id FROM registrations WHERE user_id = ?";
    
    try (Connection conn = DBconnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            joinedIds.add(rs.getInt("event_id"));
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return joinedIds;
}
}