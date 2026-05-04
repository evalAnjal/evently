package com.eventmgmt.demo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.eventmgmt.demo.DAO.EventDAO;
import com.eventmgmt.demo.DAO.registrationDAO;
import com.eventmgmt.demo.model.Event;
import com.eventmgmt.demo.model.User;

@WebServlet("/Member-dashboard")
public class EventServelet extends HttpServlet{
    private final EventDAO eventDAO = new EventDAO();
    private final registrationDAO regDAO = new registrationDAO();

    protected void doGet(HttpServletRequest request , HttpServletResponse response) throws ServletException, IOException{
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String view = request.getParameter("view"); // if view=past show past joined events
        List<Integer> joinedIds = regDAO.getJoinedEventIds(user.getId());

        if ("past".equals(view)) {
            // show only events that the user joined and are in the past
            List<Event> pastJoined = new java.util.ArrayList<>();
            long now = System.currentTimeMillis();
            for (Integer id : joinedIds) {
                Event e = eventDAO.getEventById(id);
                if (e != null && e.getEventDate() != null && e.getEventDate().getTime() < now) {
                    pastJoined.add(e);
                }
            }
            request.setAttribute("events", pastJoined);
            request.setAttribute("showPast", true);
        } else {
            // default - show upcoming/ongoing approved events only
            List<Event> all;
            if (user.getDistrict() != null && !user.getDistrict().isBlank()) {
                all = eventDAO.getAllApprovedEventsByDistrict(user.getDistrict());
            } else {
                all = eventDAO.getAllApprovedEvents();
            }
            long now = System.currentTimeMillis();
            List<Event> upcoming = new java.util.ArrayList<>();
            for (Event e : all) {
                if (e.getEventDate() == null || e.getEventDate().getTime() >= now) {
                    upcoming.add(e);
                }
            }
            request.setAttribute("events", upcoming);
            request.setAttribute("showPast", false);
        }

        request.setAttribute("joinedIds", joinedIds);
        request.getRequestDispatcher("/member-dashboard.jsp").forward(request, response);
    }
}
