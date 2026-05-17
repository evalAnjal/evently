package com.eventmgmt.demo.controller;

import com.eventmgmt.demo.DAO.registrationDAO;
import com.eventmgmt.demo.model.User;
import java.util.List;
import com.eventmgmt.demo.model.Event;
import com.eventmgmt.demo.DAO.EventDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/joinEvent")
public class joinEventServlet extends HttpServlet {
    private final registrationDAO regDAO = new registrationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        String userIdStr = request.getParameter("userId");
        String phone = request.getParameter("phone");
        String ageStr = request.getParameter("age");
        String preference = request.getParameter("preference");

        if (eventIdStr == null || userIdStr == null || phone == null || ageStr == null || preference == null
                || phone.trim().isEmpty() || ageStr.trim().isEmpty() || preference.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Member-dashboard?error=missing");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            int userId = Integer.parseInt(userIdStr);
            int age = Integer.parseInt(ageStr);

            // Server-side validation: do not allow joining past events
            EventDAO eDAO = new EventDAO();
            Event event = eDAO.getEventById(eventId);
            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/Member-dashboard?error=not_found");
                return;
            }
            Timestamp eventTs = event.getEventDate();
            if (eventTs != null && eventTs.getTime() < System.currentTimeMillis()) {
                response.sendRedirect(request.getContextPath() + "/Member-dashboard?error=past_event");
                return;
            }

            Integer capacity = event.getCapacity();
            if (capacity != null && capacity > 0) {
                int currentRegistrationCount = eDAO.getRegistrationCountForEvent(eventId);
                if (currentRegistrationCount >= capacity) {
                    response.sendRedirect(request.getContextPath() + "/Member-dashboard?error=event_full");
                    return;
                }
            }

            boolean success = regDAO.joinEvent(userId, eventId, phone.trim(), age, preference.trim());
            if (success) {
                response.sendRedirect(request.getContextPath() + "/Member-dashboard?success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/Member-dashboard?error=registration_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Member-dashboard?error=invalid_id");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        // 1. Fetch all events
        EventDAO eDAO = new EventDAO();
        List<Event> allEvents = eDAO.getAllApprovedEvents();

        registrationDAO regDAO = new registrationDAO();
        List<Integer> joinedIds = regDAO.getJoinedEventIds(user.getId());

        java.util.Map<Integer, Integer> registrationCounts = new java.util.HashMap<>();
        for (Event event : allEvents) {
            if (event.getCapacity() != null && event.getCapacity() > 0) {
                registrationCounts.put(event.getId(), eDAO.getRegistrationCountForEvent(event.getId()));
            }
        }

        request.setAttribute("events", allEvents);
        request.setAttribute("joinedIds", joinedIds);
        request.setAttribute("registrationCounts", registrationCounts);

        request.getRequestDispatcher("/Member-dashboard").forward(request, response);
    }
}


