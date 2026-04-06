package com.eventmgmt.demo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

import com.eventmgmt.demo.DAO.UserDAO;
import com.eventmgmt.demo.model.User;

@WebServlet("/registerProcess")
public class RegisterServelet extends HttpServlet {
    private  UserDAO userDAO = new UserDAO();

    private String toUserMessage(SQLException e) {
        String sqlState = e.getSQLState();
        if ("23505".equals(sqlState)) {
            return "Registration failed. This email is already registered.";
        }
        return "Registration failed: " + e.getMessage();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");

        System.out.println("got it POST");

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword(pass);

        try {
            userDAO.registerUser(newUser);
            request.setAttribute("successMessage", "Registration successful! Please login.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", toUserMessage(e));
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

}
