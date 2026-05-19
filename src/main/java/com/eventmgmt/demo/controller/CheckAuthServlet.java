package com.eventmgmt.demo.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/CheckAuthServlet")
public class CheckAuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // don't create a new session

        boolean isLoggedIn = session != null && session.getAttribute("user") != null;

        if (isLoggedIn) {
            response.sendRedirect(request.getContextPath() + "/member-dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}