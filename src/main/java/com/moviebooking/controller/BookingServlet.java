package com.moviebooking.controller;

import com.moviebooking.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession s = req.getSession(false);
        Integer userId = s == null ? null : (Integer) s.getAttribute("userId");
        String[] seats = req.getParameterValues("seats");
        
        int showId = 1;
        try {
            String showIdStr = req.getParameter("showId");
            if (showIdStr != null && !showIdStr.trim().isEmpty()) {
                showId = Integer.parseInt(showIdStr.trim());
            }
        } catch (Exception ignored) {}

        if (userId == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        if (seats == null || seats.length == 0) {
            res.sendRedirect("seats.jsp?showId=" + showId + "&error=1");
            return;
        }

        Connection c = null;
        try {
            c = DBConnection.getConnection();
            if (c == null) {
                res.sendRedirect("seats.jsp?showId=" + showId + "&error=failed");
                return;
            }
            c.setAutoCommit(false);

            // 1. Ensure show exists in shows table to prevent foreign key violation
            PreparedStatement psCheckShow = c.prepareStatement("SELECT show_id, price FROM shows WHERE show_id = ?");
            psCheckShow.setInt(1, showId);
            ResultSet rsCheckShow = psCheckShow.executeQuery();
            double price = 150.0;
            if (rsCheckShow.next()) {
                double p = rsCheckShow.getDouble("price");
                if (p > 0) price = p;
            } else {
                int movieId = 1;
                Statement st = c.createStatement();
                ResultSet rsM = st.executeQuery("SELECT movie_id FROM movies LIMIT 1");
                if (rsM.next()) {
                    movieId = rsM.getInt(1);
                }
                int screenId = 1;
                ResultSet rsS = st.executeQuery("SELECT screen_id FROM screens LIMIT 1");
                if (rsS.next()) {
                    screenId = rsS.getInt(1);
                }

                PreparedStatement insShow = c.prepareStatement(
                    "INSERT INTO shows(show_id, movie_id, screen_id, show_date, show_time, price) VALUES(?, ?, ?, CURDATE(), '18:00:00', 150.00)");
                insShow.setInt(1, showId);
                insShow.setInt(2, movieId);
                insShow.setInt(3, screenId);
                insShow.executeUpdate();
            }

            double total = price * seats.length;

            // 2. Insert booking record
            PreparedStatement p = c.prepareStatement(
                "INSERT INTO bookings(user_id, show_id, total_amount, status) VALUES(?, ?, ?, 'CONFIRMED')",
                Statement.RETURN_GENERATED_KEYS);
            p.setInt(1, userId);
            p.setInt(2, showId);
            p.setDouble(3, total);
            p.executeUpdate();

            ResultSet k = p.getGeneratedKeys();
            if (!k.next()) {
                c.rollback();
                res.sendRedirect("seats.jsp?showId=" + showId + "&error=failed");
                return;
            }
            int bookingId = k.getInt(1);

            // 3. Mark selected seats as BOOKED and record in booking_seats
            PreparedStatement seatCheck = c.prepareStatement("SELECT status FROM seats WHERE seat_id = ?");
            PreparedStatement seatUpdate = c.prepareStatement(
                "UPDATE seats SET status = 'BOOKED' WHERE seat_id = ? AND status = 'AVAILABLE'");
            PreparedStatement bs = c.prepareStatement(
                "INSERT INTO booking_seats(booking_id, seat_id) VALUES(?, ?)");

            for (String x : seats) {
                int seatId = Integer.parseInt(x);

                seatCheck.setInt(1, seatId);
                ResultSet rsSeat = seatCheck.executeQuery();
                if (rsSeat.next()) {
                    String status = rsSeat.getString("status");
                    if ("BOOKED".equalsIgnoreCase(status)) {
                        c.rollback();
                        res.sendRedirect("seats.jsp?showId=" + showId + "&error=booked");
                        return;
                    }
                    seatUpdate.setInt(1, seatId);
                    int updatedRows = seatUpdate.executeUpdate();
                    if (updatedRows == 0) {
                        c.rollback();
                        res.sendRedirect("seats.jsp?showId=" + showId + "&error=booked");
                        return;
                    }
                } else {
                    PreparedStatement insSeat = c.prepareStatement(
                        "INSERT INTO seats(seat_id, screen_id, seat_number, status) VALUES(?, 1, ?, 'BOOKED')");
                    insSeat.setInt(1, seatId);
                    insSeat.setString(2, "S" + seatId);
                    insSeat.executeUpdate();
                }

                bs.setInt(1, bookingId);
                bs.setInt(2, seatId);
                bs.executeUpdate();
            }

            c.commit();
            res.sendRedirect("payment.jsp?bookingId=" + bookingId);
        } catch (Exception e) {
            e.printStackTrace();
            if (c != null) {
                try { c.rollback(); } catch (Exception ignored) {}
            }
            res.sendRedirect("seats.jsp?showId=" + showId + "&error=failed");
        } finally {
            if (c != null) {
                try { c.setAutoCommit(true); c.close(); } catch (Exception ignored) {}
            }
        }
    }
}
