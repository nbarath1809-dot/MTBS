package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/cancelBooking")
public class CancelBookingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse res)
            throws IOException {
        int id=Integer.parseInt(req.getParameter("id"));
        try(Connection c=DBConnection.getConnection()){
            c.setAutoCommit(false);
            PreparedStatement p=c.prepareStatement(
                "UPDATE bookings SET status='CANCELLED' WHERE booking_id=?");
            p.setInt(1,id); p.executeUpdate();
            PreparedStatement q=c.prepareStatement(
                "UPDATE seats s JOIN booking_seats bs ON s.seat_id=bs.seat_id SET s.status='AVAILABLE' WHERE bs.booking_id=?");
            q.setInt(1,id); q.executeUpdate();
            c.commit(); res.sendRedirect("bookingHistory.jsp");
        } catch(Exception e){ e.printStackTrace(); res.sendRedirect("bookingHistory.jsp?error=1"); }
    }
}
