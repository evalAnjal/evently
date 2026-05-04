package com.eventmgmt.demo.controller;

import com.eventmgmt.demo.DAO.*;
import com.eventmgmt.demo.DAO.OrganiserDAO;
import com.eventmgmt.demo.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/loginProcess") 
public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private OrganiserDAO organiserDAO = new OrganiserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
       
        String email = request.getParameter("email");
        String password = request.getParameter("password");

       
        User user = userDAO.validateUser(email, password);

        if (user != null) {
            if ("ORG_PENDING".equals(user.getRole())) {
                boolean verified = false;
                var organiser = organiserDAO.getOrganiserByUserId(user.getId());
                if (organiser != null) {
                    verified = organiser.isVerified();
                } else {
                    organiser = organiserDAO.validateOrganiser(email, password);
                    verified = organiser != null && organiser.isVerified();
                }

                if (!verified) {
                    request.setAttribute("errorMessage", "Your organisation is pending SUPER_ADMIN approval.");
                    request.getRequestDispatcher("/index.jsp").forward(request, response);
                    return;
                }

                userDAO.promoteUserToAdmin(user.getId());
                user.setRole("ADMIN");
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("SUPER_ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/super-admin/organisers");
            } else if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/Member-dashboard");
            }
        } else {
           
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}