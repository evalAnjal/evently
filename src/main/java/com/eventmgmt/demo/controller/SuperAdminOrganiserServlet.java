package com.eventmgmt.demo.controller;

import com.eventmgmt.demo.DAO.OrganiserDAO;
import com.eventmgmt.demo.DAO.UserDAO;
import com.eventmgmt.demo.model.Organiser;
import com.eventmgmt.demo.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/super-admin/organisers")
public class SuperAdminOrganiserServlet extends HttpServlet {
    private final OrganiserDAO organiserDAO = new OrganiserDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        if (user == null || !"SUPER_ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Organiser> pending = organiserDAO.getUnverifiedOrganisers();
        List<Organiser> verified = organiserDAO.getVerifiedOrganisers();
        request.setAttribute("pendingOrganisers", pending);
        request.setAttribute("verifiedOrganisers", verified);
        request.getRequestDispatcher("/super-admin-organisers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        if (user == null || !"SUPER_ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        String organiserIdStr = request.getParameter("organiserId");
        if (organiserIdStr == null || organiserIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/super-admin/organisers?error=missing");
            return;
        }

        try {
            int organiserId = Integer.parseInt(organiserIdStr);
            Organiser organiser = organiserDAO.getOrganiserById(organiserId);
            if (organiser == null) {
                response.sendRedirect(request.getContextPath() + "/super-admin/organisers?error=not_found");
                return;
            }

            if ("approve".equals(action)) {
                organiserDAO.verifyOrganiser(organiserId);
                if (organiser.getUserId() != null) {
                    userDAO.promoteUserToAdmin(organiser.getUserId());
                }
                response.sendRedirect(request.getContextPath() + "/super-admin/organisers?success=approved");
            } else if ("reject".equals(action)) {
                organiserDAO.rejectOrganiser(organiserId);
                response.sendRedirect(request.getContextPath() + "/super-admin/organisers?success=rejected");
            } else if ("deactivate".equals(action)) {
                organiserDAO.deactivateOrganiser(organiserId);
                response.sendRedirect(request.getContextPath() + "/super-admin/organisers?success=deactivated");
            } else {
                response.sendRedirect(request.getContextPath() + "/super-admin/organisers?error=action");
            }
        } catch (NumberFormatException | SQLException e) {
            response.sendRedirect(request.getContextPath() + "/super-admin/organisers?error=server");
        }
    }
}
