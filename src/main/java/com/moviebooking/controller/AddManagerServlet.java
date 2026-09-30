package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/addManager")
public class AddManagerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;
        
        // Security check: Only ADMIN can add managers
        if (!"ADMIN".equals(role)) {
            res.sendRedirect("login.jsp");
            return;
        }

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");

        if (name == null || email == null || password == null) {
            res.sendRedirect("addManager.jsp?error=1");
            return;
        }

        String sql = "INSERT INTO users(name, email, password, phone, role) VALUES(?, ?, ?, ?, 'MANAGER')";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, name);
            p.setString(2, email);
            p.setString(3, password);
            p.setString(4, phone != null ? phone : "");
            p.executeUpdate();
            res.sendRedirect("userDirectory.jsp?added=1");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("addManager.jsp?error=1");
        }
    }
}
