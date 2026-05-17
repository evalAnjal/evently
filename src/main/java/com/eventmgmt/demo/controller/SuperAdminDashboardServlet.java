package com.eventmgmt.demo.controller;

import com.eventmgmt.demo.DAO.EventDAO;
import com.eventmgmt.demo.DAO.OrganiserDAO;
import com.eventmgmt.demo.DAO.UserDAO;
import com.eventmgmt.demo.model.Event;
import com.eventmgmt.demo.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/super-admin/dashboard")
public class SuperAdminDashboardServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final EventDAO eventDAO = new EventDAO();
    private final OrganiserDAO organiserDAO = new OrganiserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        if (user == null || !"SUPER_ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        int totalUsers = userDAO.getTotalUsersCount();
        int totalEvents = eventDAO.getTotalEventsCount();
        int verifiedOrganisers = organiserDAO.getVerifiedOrganisers().size();
        int pendingOrganisers = organiserDAO.getUnverifiedOrganisers().size();

        List<Event> recentEvents = eventDAO.getAllEvents();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalEvents", totalEvents);
        request.setAttribute("verifiedOrganisersCount", verifiedOrganisers);
        request.setAttribute("pendingOrganisersCount", pendingOrganisers);
        request.setAttribute("recentEvents", recentEvents);

        request.getRequestDispatcher("/super-admin-dashboard.jsp").forward(request, response);
    }
}
