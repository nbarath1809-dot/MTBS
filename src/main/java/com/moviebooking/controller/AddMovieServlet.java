package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/addMovie")
public class AddMovieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        String sql = "INSERT INTO movies(title, genre, language, duration, description) VALUES(?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            p.setString(1, req.getParameter("title"));
            p.setString(2, req.getParameter("genre"));
            p.setString(3, req.getParameter("language"));
            p.setInt(4, Integer.parseInt(req.getParameter("duration")));
            p.setString(5, req.getParameter("description"));
            p.executeUpdate();

            ResultSet keys = p.getGeneratedKeys();
            if (keys.next()) {
                int newMovieId = keys.getInt(1);
                PreparedStatement psShow = c.prepareStatement(
                    "INSERT INTO shows(movie_id, screen_id, show_date, show_time, price) VALUES(?, 1, CURDATE(), '18:00:00', 150.00)");
                psShow.setInt(1, newMovieId);
                psShow.executeUpdate();
            }
            res.sendRedirect("movies");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("addMovie.jsp?error=1");
        }
    }
}
