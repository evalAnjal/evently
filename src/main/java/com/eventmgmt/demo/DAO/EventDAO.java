package com.eventmgmt.demo.DAO;

import com.eventmgmt.demo.model.Event;
import com.eventmgmt.demo.util.DBconnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// this is a new feature
public class EventDAO {
    public List<Event> getAllApprovedEvents(){
        List<Event> events = new ArrayList<>();


        String sql = "SELECT * FROM events WHERE status = 'APPROVED'";

        try(
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
        ){
            ResultSet rs = st.executeQuery();

            while(rs.next()){
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setLocation(rs.getString("location"));
                e.setEventDate(rs.getTimestamp("event_date"));
                e.setStatus(rs.getString("status"));

                events.add(e);

            }
        }
        catch(SQLException e){
            throw new Error("EventDAO ERROR");
        }
        return events;
    }
}
