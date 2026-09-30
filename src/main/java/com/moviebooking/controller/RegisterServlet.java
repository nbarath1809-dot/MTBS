package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req,HttpServletResponse res)
            throws IOException {
        String sql="INSERT INTO users(name,email,password,phone,role) VALUES(?,?,?,?,?)";
        try(Connection c=DBConnection.getConnection();
            PreparedStatement p=c.prepareStatement(sql)) {
            p.setString(1,req.getParameter("name"));
            p.setString(2,req.getParameter("email"));
            p.setString(3,req.getParameter("password"));
            p.setString(4,req.getParameter("phone"));
            p.setString(5,"CUSTOMER");
            p.executeUpdate();
            res.sendRedirect("login.jsp?registered=1");
        } catch(Exception e){ e.printStackTrace(); res.sendRedirect("register.jsp?error=1"); }
    }
}
