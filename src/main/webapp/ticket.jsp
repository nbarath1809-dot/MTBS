<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.moviebooking.util.DBConnection" %>
<%@ page session="true" %>
<%
    String bookingIdParam = request.getParameter("bookingId");
    int id = 0;
    if(bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
        try { id = Integer.parseInt(bookingIdParam); } catch(Exception ignored) {}
    }
    
    String movie = "N/A";
    String date = "N/A";
    String time = "N/A";
    double amount = 0.0;
    
    if(id > 0) {
        try(Connection c = DBConnection.getConnection(); 
            PreparedStatement p = c.prepareStatement(
                "SELECT m.title, s.show_date, s.show_time, b.total_amount " +
                "FROM bookings b " +
                "JOIN shows s ON b.show_id = s.show_id " +
                "JOIN movies m ON s.movie_id = m.movie_id " +
                "WHERE b.booking_id = ?")) {
            p.setInt(1, id);
            ResultSet r = p.executeQuery();
            if(r.next()) {
                movie = r.getString(1);
                date = r.getString(2);
                time = r.getString(3);
                amount = r.getDouble(4);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
    String userName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed | Ticket #<%=id%></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">🎟️</div>
            <span>CinePass</span>
        </div>
        <ul class="nav-links">
            <li><a href="customer.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="bookingHistory.jsp" class="nav-link">My Bookings</a></li>
            <% if(userName != null) { %>
                <li><span class="user-badge">👤 <%=userName%></span></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header" style="text-align: center; display: block;">
            <div style="font-size: 3rem; margin-bottom: 0.5rem;">🎉</div>
            <h1>Booking Confirmed!</h1>
            <p class="page-subtitle">Your ticket has been generated and confirmed successfully.</p>
        </div>

        <div class="ticket-receipt">
            <div class="ticket-header">
                <div style="font-size: 0.85rem; letter-spacing: 0.15em; font-weight: 700; text-transform: uppercase;">CinePass Digital Ticket</div>
                <h2 style="font-size: 1.6rem; margin-top: 0.25rem;"><%=movie%></h2>
            </div>

            <div class="ticket-body">
                <div style="display: flex; justify-content: space-between; margin-bottom: 1rem;">
                    <div>
                        <div style="font-size: 0.8rem; color: var(--text-muted);">BOOKING ID</div>
                        <div style="font-size: 1.1rem; font-weight: 800; color: #fff;">#<%=id%></div>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-size: 0.8rem; color: var(--text-muted);">STATUS</div>
                        <span class="status-pill confirmed">✓ CONFIRMED</span>
                    </div>
                </div>

                <div class="summary-row">
                    <span>Show Date</span>
                    <span style="color: #fff; font-weight: 600;"><%=date%></span>
                </div>
                <div class="summary-row">
                    <span>Show Time</span>
                    <span style="color: #fff; font-weight: 600;"><%=time%></span>
                </div>
                <div class="summary-row">
                    <span>Screen Hall</span>
                    <span style="color: #fff; font-weight: 600;">Screen 1 (IMAX)</span>
                </div>
                <div class="summary-row total">
                    <span>Amount Paid</span>
                    <span style="color: var(--accent);">₹<%=amount%></span>
                </div>

                <hr class="ticket-stub-divider">

                <div style="text-align: center; margin-top: 1rem;">
                    <div style="font-size: 3.5rem; letter-spacing: 0.2em; color: rgba(255,255,255,0.7); font-family: monospace;">||| | |||| ||| ||</div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 0.25rem;">Scan QR / Barcode at Cinema Entrance</div>
                </div>
            </div>
        </div>

        <div style="display: flex; justify-content: center; gap: 1rem; margin-top: 1.5rem;">
            <a href="customer.jsp" class="btn btn-primary">Return to Dashboard</a>
            <button onclick="window.print()" class="btn btn-secondary">🖨️ Print Ticket</button>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Digital Ticketing System.</p>
    </footer>
</body>
</html>