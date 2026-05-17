package com.eventmgmt.demo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import com.eventmgmt.demo.DAO.ContactDAO;
import com.eventmgmt.demo.model.Contact;     


@WebServlet(name = "ContactServlet", urlPatterns = {"/ContactServlet"})
public class ContactServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{

        String email = request.getParameter("email");
        String message = request.getParameter("message");

        Contact contact = new Contact();
        contact.setEmail(email);
        contact.setMessage(message);

        ContactDAO dao = new ContactDAO();
        boolean isSaved = dao.saveMessage(contact);

        if (isSaved) {
            response.sendRedirect("about.jsp?success=true");
        } else {
            response.sendRedirect("about.jsp?error=true");
        }
        

      
    }
}

