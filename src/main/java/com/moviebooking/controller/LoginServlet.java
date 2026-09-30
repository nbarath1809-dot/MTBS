package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req,HttpServletResponse res)
            throws ServletException,IOException {
        String email=req.getParameter("email");
        String password=req.getParameter("password");
        try(Connection c=DBConnection.getConnection();
            PreparedStatement p=c.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?")) {
            p.setString(1,email); p.setString(2,password);
            ResultSet r=p.executeQuery();
            if(r.next()){
                HttpSession s=req.getSession();
                s.setAttribute("userId",r.getInt("user_id"));
                s.setAttribute("name",r.getString("name"));
                s.setAttribute("role",r.getString("role"));
                String role=r.getString("role");
                if("ADMIN".equals(role)) res.sendRedirect("admin.jsp");
                else if("MANAGER".equals(role)) res.sendRedirect("manager.jsp");
                else res.sendRedirect("customer.jsp");
            } else res.sendRedirect("login.jsp?error=1");
        } catch(Exception e){ e.printStackTrace(); res.sendRedirect("login.jsp?error=1"); }
    }
}
