package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/addShow")
public class AddShowServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        String movieIdStr = req.getParameter("movieId");
        String screenIdStr = req.getParameter("screen");
        String showDate = req.getParameter("show_date");
        String showTime = req.getParameter("show_time");
        String priceStr = req.getParameter("price");

        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(
                "INSERT INTO shows(movie_id, screen_id, show_date, show_time, price) VALUES(?, ?, ?, ?, ?)")) {
            p.setInt(1, Integer.parseInt(movieIdStr));
            p.setInt(2, Integer.parseInt(screenIdStr));
            p.setDate(3, Date.valueOf(showDate));
            p.setTime(4, Time.valueOf(showTime.length() == 5 ? showTime + ":00" : showTime));
            p.setDouble(5, Double.parseDouble(priceStr));
            p.executeUpdate();
            res.sendRedirect("manager.jsp?showAdded=1");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("addShow.jsp?error=1");
        }
    }
}
