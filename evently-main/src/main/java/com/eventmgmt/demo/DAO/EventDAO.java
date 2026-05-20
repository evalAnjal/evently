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
                events.add(mapEvent(rs));

            }
        }
        catch(SQLException e){
            e.printStackTrace();
        }
        return events;
    }

    public List<Event> getAllApprovedEventsByDistrict(String district) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE status = 'APPROVED' AND district = ?";

        try(
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
        ){
            st.setString(1, district);
            ResultSet rs = st.executeQuery();

            while(rs.next()){
                events.add(mapEvent(rs));
            }
        }
        catch(SQLException e){
            // 42703: undefined_column. Fallback for DBs not yet migrated with district column.
            if ("42703".equals(e.getSQLState())) {
                return getAllApprovedEvents();
            }
            e.printStackTrace();
        }
        return events;
    }

    public boolean createEvent(Event event) {
        String sql = "INSERT INTO events (title, description, location, event_date, status, organiser_id, district, created_by_email, event_type, capacity) VALUES (?, ?, ?, ?, 'APPROVED', ?, ?, ?, ?, ?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, event.getTitle());
            st.setString(2, event.getDescription());
            st.setString(3, event.getLocation());
            st.setTimestamp(4, event.getEventDate());
            st.setObject(5, event.getOrganiserId(), Types.INTEGER);
            st.setString(6, event.getDistrict());
            st.setString(7, event.getCreatedByEmail());
            if (event.getEventType() != null) {
                st.setString(8, event.getEventType());
            } else {
                st.setNull(8, Types.VARCHAR);
            }
            if (event.getCapacity() != null) {
                st.setInt(9, event.getCapacity());
            } else {
                st.setNull(9, Types.INTEGER);
            }

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0; // Return true if the event was created successfully
        } catch (SQLException e) {
            if ("42703".equals(e.getSQLState())) {
                return createEventWithoutEventType(event);
            }
            e.printStackTrace();
            return false; // Return false if there was an error
        }
    }

    private boolean createEventWithoutEventType(Event event) {
        String sql = "INSERT INTO events (title, description, location, event_date, status, organiser_id, district, created_by_email, capacity) VALUES (?, ?, ?, ?, 'APPROVED', ?, ?, ?, ?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, event.getTitle());
            st.setString(2, event.getDescription());
            st.setString(3, event.getLocation());
            st.setTimestamp(4, event.getEventDate());
            st.setObject(5, event.getOrganiserId(), Types.INTEGER);
            st.setString(6, event.getDistrict());
            st.setString(7, event.getCreatedByEmail());
            if (event.getCapacity() != null) {
                st.setInt(8, event.getCapacity());
            } else {
                st.setNull(8, Types.INTEGER);
            }

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            if ("42703".equals(ex.getSQLState())) {
                return createEventWithoutCapacity(event);
            }
            ex.printStackTrace();
            return false;
        }
    }

    private boolean createEventWithoutCapacity(Event event) {
        String sql = "INSERT INTO events (title, description, location, event_date, status, organiser_id, district, created_by_email) VALUES (?, ?, ?, ?, 'APPROVED', ?, ?, ?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, event.getTitle());
            st.setString(2, event.getDescription());
            st.setString(3, event.getLocation());
            st.setTimestamp(4, event.getEventDate());
            st.setObject(5, event.getOrganiserId(), Types.INTEGER);
            st.setString(6, event.getDistrict());
            st.setString(7, event.getCreatedByEmail());

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
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
                events.add(mapEvent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return events;
    }

    public List<Event> getAllEventsByCreatorEmail(String creatorEmail) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT e.* FROM events e WHERE e.created_by_email = ? "
                + "OR e.organiser_id IN (SELECT o.id FROM organisers o WHERE o.email = ?) "
                + "ORDER BY e.event_date DESC";

        try (
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql)
        ) {
            st.setString(1, creatorEmail);
            st.setString(2, creatorEmail);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                events.add(mapEvent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return events;
    }

    public int getTotalEventsCount() {
        return getSingleCount("SELECT COUNT(*) FROM events");
    }

    public int getTotalEventsCountByCreatorEmail(String creatorEmail) {
        return getSingleCountByCreator(
                "SELECT COUNT(*) FROM events e WHERE e.created_by_email = ? OR e.organiser_id IN (SELECT o.id FROM organisers o WHERE o.email = ?)",
                creatorEmail);
    }

    public int getTotalApprovedEventsCount() {
        return getSingleCount("SELECT COUNT(*) FROM events WHERE status = 'APPROVED'");
    }

    public int getTotalApprovedEventsCountByCreatorEmail(String creatorEmail) {
        return getSingleCountByCreator(
                "SELECT COUNT(*) FROM events e WHERE e.status = 'APPROVED' AND (e.created_by_email = ? OR e.organiser_id IN (SELECT o.id FROM organisers o WHERE o.email = ?))",
                creatorEmail);
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

    public int getTotalRegistrationsCountByCreatorEmail(String creatorEmail) {
        String sql = "SELECT COUNT(*) FROM registrations r JOIN events e ON e.id = r.event_id "
                + "WHERE e.created_by_email = ? OR e.organiser_id IN (SELECT o.id FROM organisers o WHERE o.email = ? )";
        return getSingleCountByCreator(sql, creatorEmail);
    }

    public Map<Integer, Integer> getRegistrationCountByEvent() {
        String[] fallbackQueries = new String[] {
            "SELECT event_id, COUNT(*) FROM event_registrations GROUP BY event_id",
            "SELECT event_id, COUNT(*) FROM registrations GROUP BY event_id"
        };
        return runFallbackGroupedCountQueries(fallbackQueries);
    }

    public Map<Integer, Integer> getRegistrationCountByEventByCreatorEmail(String creatorEmail) {
        String sql = "SELECT e.id, COUNT(*) FROM registrations r JOIN events e ON e.id = r.event_id "
                + "WHERE e.created_by_email = ? OR e.organiser_id IN (SELECT o.id FROM organisers o WHERE o.email = ?) GROUP BY e.id";
        return executeGroupedCountQueryByCreator(sql, creatorEmail);
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

    public Map<Integer, Integer> getParticipantCountByEventByCreatorEmail(String creatorEmail) {
        String sql = "SELECT e.id, COUNT(DISTINCT r.user_id) FROM registrations r JOIN events e ON e.id = r.event_id "
                + "WHERE e.created_by_email = ? OR e.organiser_id IN (SELECT o.id FROM organisers o WHERE o.email = ?) GROUP BY e.id";
        return executeGroupedCountQueryByCreator(sql, creatorEmail);
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

    private int getSingleCountByCreator(String sql, String creatorEmail) {
        try (
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
        ) {
            st.setString(1, creatorEmail);
            st.setString(2, creatorEmail);
            ResultSet rs = st.executeQuery();
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

    private Map<Integer, Integer> executeGroupedCountQueryByCreator(String sql, String creatorEmail) {
        Map<Integer, Integer> counts = new HashMap<>();
        try (
            Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql);
        ) {
            st.setString(1, creatorEmail);
            st.setString(2, creatorEmail);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                counts.put(rs.getInt(1), rs.getInt(2));
            }
        } catch (SQLException e) {
            return new HashMap<>();
        }
        return counts;
    }

    /**
     * Retrieve a single Event by id.
     * Returns null if not found or on error.
     */
    public Event getEventById(int id) {
        String sql = "SELECT * FROM events WHERE id = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapEvent(rs);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public int getRegistrationCountForEvent(int eventId) {
        String[] queries = new String[] {
            "SELECT COUNT(*) FROM registrations WHERE event_id = ?",
            "SELECT COUNT(*) FROM event_registrations WHERE event_id = ?"
        };
        for (String query : queries) {
            try (Connection conn = DBconnection.getConnection();
                 PreparedStatement st = conn.prepareStatement(query)) {
                st.setInt(1, eventId);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            } catch (SQLException e) {
                if ("42703".equals(e.getSQLState())) {
                    continue;
                }
            }
        }
        return 0;
    }

    private Event mapEvent(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setId(rs.getInt("id"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        e.setLocation(rs.getString("location"));
        e.setEventDate(rs.getTimestamp("event_date"));
        e.setStatus(rs.getString("status"));
        if (hasColumn(rs, "created_by_email")) {
            e.setCreatedByEmail(rs.getString("created_by_email"));
        }
        if (hasColumn(rs, "organiser_id")) {
            e.setOrganiserId((Integer) rs.getObject("organiser_id"));
        }
        if (hasColumn(rs, "district")) {
            e.setDistrict(rs.getString("district"));
        }
        if (hasColumn(rs, "event_type")) {
            e.setEventType(rs.getString("event_type"));
        }
        if (hasColumn(rs, "capacity")) {
            e.setCapacity((Integer) rs.getObject("capacity"));
        }
        return e;
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
}
