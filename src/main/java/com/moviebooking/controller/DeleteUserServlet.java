package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;
        Integer currentUserId = session != null ? (Integer) session.getAttribute("userId") : null;

        // Security check: Only ADMIN can delete user accounts
        if (!"ADMIN".equals(role)) {
            res.sendRedirect("login.jsp");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null) {
            res.sendRedirect("userDirectory.jsp");
            return;
        }

        int targetId = Integer.parseInt(idParam);

        // Prevent admin from self-deleting
        if (currentUserId != null && currentUserId == targetId) {
            res.sendRedirect("userDirectory.jsp?error=self_delete");
            return;
        }

        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
            p.setInt(1, targetId);
            p.executeUpdate();
            res.sendRedirect("userDirectory.jsp?deleted=1");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("userDirectory.jsp?error=1");
        }
    }
}
