package com.eventmgmt.demo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.eventmgmt.demo.DAO.EventDAO;
import com.eventmgmt.demo.model.Event;

@WebServlet("/Member-dashboard")
public class EventServelet extends HttpServlet{
    private EventDAO eventDAO = new EventDAO();

    protected void doGet(HttpServletRequest request , HttpServletResponse response) throws ServletException, IOException{
        List<Event> eventList = eventDAO.getAllApprovedEvents();

        request.setAttribute("events", eventList);

       request.getRequestDispatcher("/member-dashboard.jsp").forward(request, response);
       //redirecting to member-dashboard.jsp
        //response.sendRedirect(request.getContextPath() + "/member-dashboard.jsp");

    }
}
