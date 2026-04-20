/*
@author Anjal Sharma Phuyal
@version 1.0

@param eventDAO - An instance of EventDAO to interact with the database for event-related operations.
@doGet - Handles GET requests to retrieve and display approved events on the member dashboard.
    - Retrieves a list of approved events from the database using the EventDAO.
    - Sets the list of events as a request attribute to be accessed in the JSP.
    - Forwards the request to member-dashboard.jsp to display the events.
@params
    - request: The HttpServletRequest object that contains the request the client made to the servlet.
    - response: The HttpServletResponse object that contains the response the servlet returns to the client.
@throws ServletException - If a servlet-specific error occurs.
@throws IOException - If an I/O error occurs while handling the request or response.

*/

package com.eventmgmt.demo.DAO;

import com.eventmgmt.demo.model.Event;
import com.eventmgmt.demo.util.DBconnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    public boolean createEvent(Event event) {
        String sql = "INSERT INTO events (title, description, location, event_date, status) VALUES (?, ?, ?, ?, 'APPROVED')";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, event.getTitle());
            st.setString(2, event.getDescription());
            st.setString(3, event.getLocation());
            st.setTimestamp(4, event.getEventDate());

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0; // Return true if the event was created successfully
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Return false if there was an error
        }
    }

    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY event_date DESC";

        try (
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery()
        ) {
            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setLocation(rs.getString("location"));
                e.setEventDate(rs.getTimestamp("event_date"));
                e.setStatus(rs.getString("status"));
                events.add(e);
            }
        } catch (SQLException e) {
            throw new Error("EventDAO ERROR while loading all events");
        }

        return events;
    }

    public int getTotalEventsCount() {
        return getSingleCount("SELECT COUNT(*) FROM events");
    }

    public int getTotalApprovedEventsCount() {
        return getSingleCount("SELECT COUNT(*) FROM events WHERE status = 'APPROVED'");
    }

    public int getTotalMembersCount() {
        return getSingleCount("SELECT COUNT(*) FROM users WHERE role = 'MEMBER'");
    }

    public int getTotalRegistrationsCount() {
        String[] fallbackQueries = new String[] {
            "SELECT COUNT(*) FROM event_registrations",
            "SELECT COUNT(*) FROM registrations"
        };
        return runFallbackCountQueries(fallbackQueries);
    }

    public Map<Integer, Integer> getRegistrationCountByEvent() {
        String[] fallbackQueries = new String[] {
            "SELECT event_id, COUNT(*) FROM event_registrations GROUP BY event_id",
            "SELECT event_id, COUNT(*) FROM registrations GROUP BY event_id"
        };
        return runFallbackGroupedCountQueries(fallbackQueries);
    }

    public Map<Integer, Integer> getParticipantCountByEvent() {
        String[] fallbackQueries = new String[] {
            "SELECT event_id, COUNT(DISTINCT user_id) FROM event_registrations GROUP BY event_id",
            "SELECT event_id, COUNT(DISTINCT member_id) FROM registrations GROUP BY event_id",
            "SELECT event_id, COUNT(*) FROM event_registrations GROUP BY event_id",
            "SELECT event_id, COUNT(*) FROM registrations GROUP BY event_id"
        };
        return runFallbackGroupedCountQueries(fallbackQueries);
    }

    public List<Map<String, Object>> getJoinedMembersByEvent(int eventId) {
        List<Map<String, Object>> members = new ArrayList<>();
        String sql = "SELECT u.id AS user_id, u.username, u.email, r.phone, r.age, r.preference "
                + "FROM registrations r "
                + "JOIN users u ON u.id = r.user_id "
                + "WHERE r.event_id = ? "
                + "ORDER BY u.username";

        try (
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql)
        ) {
            st.setInt(1, eventId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Map<String, Object> member = new HashMap<>();
                member.put("userId", rs.getInt("user_id"));
                member.put("username", rs.getString("username"));
                member.put("email", rs.getString("email"));
                member.put("phone", rs.getString("phone"));
                member.put("age", rs.getObject("age"));
                member.put("preference", rs.getString("preference"));
                members.add(member);
            }
        } catch (SQLException e) {
            return new ArrayList<>();
        }

        return members;
    }

    private int getSingleCount(String sql) {
        try (
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            return 0;
        }
        return 0;
    }

    private int runFallbackCountQueries(String[] queries) {
        for (String query : queries) {
            int count = getSingleCount(query);
            if (count > 0) {
                return count;
            }
        }
        return 0;
    }

    private Map<Integer, Integer> runFallbackGroupedCountQueries(String[] queries) {
        for (String query : queries) {
            Map<Integer, Integer> result = executeGroupedCountQuery(query);
            if (!result.isEmpty()) {
                return result;
            }
        }
        return new HashMap<>();
    }

    private Map<Integer, Integer> executeGroupedCountQuery(String sql) {
        Map<Integer, Integer> counts = new HashMap<>();

        try (
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery()
        ) {
            while (rs.next()) {
                counts.put(rs.getInt(1), rs.getInt(2));
            }
        } catch (SQLException e) {
            return new HashMap<>();
        }

        return counts;
    }
}
