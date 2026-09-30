<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.moviebooking.util.DBConnection" %>
<%@ page session="true" %>
<%
    String bookingIdParam = request.getParameter("bookingId");
    String userName = (String) session.getAttribute("name");
    Integer userId = (Integer) session.getAttribute("userId");
    if(userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    double totalAmount = 0.0;
    String movieTitle = "Movie";
    List<String> seatNumbers = new ArrayList<>();

    if (bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
        try (Connection c = DBConnection.getConnection()) {
            if (c != null) {
                int bId = Integer.parseInt(bookingIdParam.trim());
                PreparedStatement ps = c.prepareStatement(
                    "SELECT b.total_amount, m.title " +
                    "FROM bookings b " +
                    "LEFT JOIN shows s ON b.show_id = s.show_id " +
                    "LEFT JOIN movies m ON s.movie_id = m.movie_id " +
                    "WHERE b.booking_id = ?");
                ps.setInt(1, bId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    totalAmount = rs.getDouble(1);
                    if (rs.getString(2) != null) movieTitle = rs.getString(2);
                }

                PreparedStatement psSeats = c.prepareStatement(
                    "SELECT s.seat_number FROM booking_seats bs " +
                    "JOIN seats s ON bs.seat_id = s.seat_id " +
                    "WHERE bs.booking_id = ? ORDER BY s.seat_number ASC");
                psSeats.setInt(1, bId);
                ResultSet rsSeats = psSeats.executeQuery();
                while (rsSeats.next()) {
                    seatNumbers.add(rsSeats.getString(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Checkout | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">💳</div>
            <span>CinePass</span>
        </div>
        <ul class="nav-links">
            <li><a href="customer.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="movies" class="nav-link">Browse Movies</a></li>
            <li><a href="bookingHistory.jsp" class="nav-link">My Bookings</a></li>
            <% if(userName != null) { %>
                <li><span class="user-badge">👤 <%=userName%></span></li>
                <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container" style="max-width: 680px;">
        <div class="page-header" style="text-align: center; display: block;">
            <h1>Complete Your Payment</h1>
            <p class="page-subtitle">Booking Reference: #<%=bookingIdParam != null ? bookingIdParam : "---"%> &bull; <%=movieTitle%></p>
        </div>

        <% if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                <span>⚠️ Payment failed. Please select a valid payment method and try again.</span>
            </div>
        <% } %>

        <div class="glass-card">
            <form action="payment" method="post">
                <input type="hidden" name="bookingId" value="<%=bookingIdParam%>">

                <div class="form-group">
                    <label class="form-label">Select Payment Method</label>
                    <select name="method" id="paymentMethod" style="font-size: 1.05rem; padding: 1rem;">
                        <option value="UPI">📱 UPI / QR Code (Google Pay, PhonePe, Paytm)</option>
                        <option value="CARD">💳 Credit / Debit Card (Visa, Mastercard, RuPay)</option>
                        <option value="NETBANKING">🏦 Net Banking (HDFC, SBI, ICICI, Axis)</option>
                    </select>
                </div>

                <div style="background: rgba(15, 23, 42, 0.6); padding: 1.5rem; border-radius: var(--radius-md); margin: 1.5rem 0; border: 1px dashed var(--border-glass);">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem; color: var(--text-muted);">
                        <span>Movie</span>
                        <span style="font-weight: 600; color: #fff;"><%=movieTitle%></span>
                    </div>
                    <% if (!seatNumbers.isEmpty()) { %>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem; color: var(--text-muted);">
                        <span>Seats Reserved (<%=seatNumbers.size()%>)</span>
                        <span style="font-weight: 600; color: var(--gold);"><%=String.join(", ", seatNumbers)%></span>
                    </div>
                    <% } %>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem; color: var(--text-muted);">
                        <span>Booking Reference</span>
                        <span style="font-weight: 600; color: #fff;">#<%=bookingIdParam%></span>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem; color: var(--text-muted);">
                        <span>Convenience Fee</span>
                        <span style="color: var(--success); font-weight: 600;">FREE</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-top: 1rem; padding-top: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.1); font-size: 1.2rem; font-weight: 800;">
                        <span>Total Payable</span>
                        <span style="color: var(--accent);">₹<%=totalAmount > 0 ? String.format("%.2f", totalAmount) : "150.00"%></span>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="font-size: 1.1rem; padding: 1rem;">🔒 Pay & Issue Ticket Now</button>
            </form>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Secure Payment Gateway.</p>
    </footer>
</body>
</html>