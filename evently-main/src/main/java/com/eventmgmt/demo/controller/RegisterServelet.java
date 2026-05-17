package com.eventmgmt.demo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

import com.eventmgmt.demo.DAO.OrganiserDAO;
import com.eventmgmt.demo.DAO.UserDAO;
import com.eventmgmt.demo.model.Organiser;
import com.eventmgmt.demo.model.User;
import com.eventmgmt.demo.util.PasswordUtil;

@WebServlet("/registerProcess")
public class RegisterServelet extends HttpServlet {
    private  UserDAO userDAO = new UserDAO();
    private  OrganiserDAO organiserDAO = new OrganiserDAO();

    private String toUserMessage(SQLException e) {
        String sqlState = e.getSQLState();
        if ("23505".equals(sqlState)) {
            return "Registration failed. This email is already registered.";
        }
        if ("42P01".equals(sqlState)) {
            return "Registration failed. Database migration is missing (table organisers not found). Run SQL migrations 001 and 002.";
        }
        return "Registration failed: " + e.getMessage();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        String district = request.getParameter("district");
        String accountType = request.getParameter("accountType");

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        String hashedPassword = PasswordUtil.hashPassword(pass);
        newUser.setPassword(hashedPassword);
        newUser.setDistrict(district);

        boolean isOrganiser = "ORGANISER".equalsIgnoreCase(accountType);
        newUser.setRole(isOrganiser ? "ORG_PENDING" : "MEMBER");

        try {
            int userId = userDAO.registerUserAndGetId(newUser);

            if (isOrganiser) {
                String orgName = request.getParameter("orgName");
                String orgPhone = request.getParameter("orgPhone");
                String orgAddress = request.getParameter("orgAddress");

                Organiser organiser = new Organiser();
                organiser.setUserId(userId);
                organiser.setName(orgName == null || orgName.isBlank() ? username : orgName);
                organiser.setEmail(email);
                organiser.setPassword(hashedPassword);
                organiser.setPhone(orgPhone);
                organiser.setDistrict(district);
                organiser.setAddress(orgAddress);
                organiserDAO.registerOrganiser(organiser);

                request.setAttribute("successMessage", "Organisation account submitted. Wait for SUPER_ADMIN approval.");
            } else {
                request.setAttribute("successMessage", "Registration successful! Please login.");
            }
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", toUserMessage(e));
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

}
