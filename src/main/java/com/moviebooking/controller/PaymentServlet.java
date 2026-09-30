package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req,HttpServletResponse res)
            throws IOException {
        int bookingId=Integer.parseInt(req.getParameter("bookingId"));
        String method=req.getParameter("method");
        try(Connection c=DBConnection.getConnection();
            PreparedStatement p=c.prepareStatement(
                "SELECT total_amount FROM bookings WHERE booking_id=?")) {
            p.setInt(1,bookingId); ResultSet r=p.executeQuery();
            double amount=0; if(r.next()) amount=r.getDouble(1);
            PreparedStatement q=c.prepareStatement(
                "INSERT INTO payments(booking_id,amount,payment_method,payment_status) VALUES(?,?,?,'SUCCESS')");
            q.setInt(1,bookingId); q.setDouble(2,amount); q.setString(3,method);
            q.executeUpdate();
            res.sendRedirect("ticket.jsp?bookingId="+bookingId);
        } catch(Exception e){ e.printStackTrace(); res.sendRedirect("payment.jsp?error=1"); }
    }
}
