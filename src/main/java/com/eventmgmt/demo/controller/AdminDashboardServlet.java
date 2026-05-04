package com.eventmgmt.demo.controller;

import com.eventmgmt.demo.DAO.EventDAO;
import com.eventmgmt.demo.DAO.OrganiserDAO;
import com.eventmgmt.demo.model.Event;
import com.eventmgmt.demo.model.Organiser;
import com.eventmgmt.demo.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final EventDAO eventDAO = new EventDAO();
    private final OrganiserDAO organiserDAO = new OrganiserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        Organiser organiser = organiserDAO.getOrganiserByUserId(user.getId());
        if (organiser != null) {
            request.setAttribute("organiserDistrict", organiser.getDistrict());
        }

        List<Event> events = eventDAO.getAllEventsByCreatorEmail(user.getEmail());
        int totalEvents = eventDAO.getTotalEventsCountByCreatorEmail(user.getEmail());
        int approvedEvents = eventDAO.getTotalApprovedEventsCountByCreatorEmail(user.getEmail());
        int totalMembers = eventDAO.getTotalMembersCount();
        int totalRegistrations = eventDAO.getTotalRegistrationsCountByCreatorEmail(user.getEmail());
        Map<Integer, Integer> registrationCounts = eventDAO.getRegistrationCountByEventByCreatorEmail(user.getEmail());
        Map<Integer, Integer> participantCounts = eventDAO.getParticipantCountByEventByCreatorEmail(user.getEmail());

        String selectedEventIdStr = request.getParameter("eventId");
        if (selectedEventIdStr != null && !selectedEventIdStr.isBlank()) {
            try {
                int selectedEventId = Integer.parseInt(selectedEventIdStr);
                Event selectedEvent = null;
                for (Event event : events) {
                    if (event.getId() == selectedEventId) {
                        selectedEvent = event;
                        break;
                    }
                }

                if (selectedEvent != null) {
                    request.setAttribute("selectedEventId", selectedEventId);
                    request.setAttribute("selectedEvent", selectedEvent);
                    request.setAttribute("selectedEventMembers", eventDAO.getJoinedMembersByEvent(selectedEventId));
                }
            } catch (NumberFormatException ignored) {
                // Ignore invalid event id and render dashboard normally.
            }
        }

        request.setAttribute("events", events);
        request.setAttribute("totalEvents", totalEvents);
        request.setAttribute("approvedEvents", approvedEvents);
        request.setAttribute("totalMembers", totalMembers);
        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("registrationCounts", registrationCounts);
        request.setAttribute("participantCounts", participantCounts);
        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
