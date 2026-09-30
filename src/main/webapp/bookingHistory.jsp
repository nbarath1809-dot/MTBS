<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.moviebooking.util.DBConnection" %>
<%@ page session="true" %>
<%
    Integer uid = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("name");
    if(uid == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking History | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">📜</div>
            <span>CinePass</span>
        </div>
        <ul class="nav-links">
            <li><a href="customer.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="movies" class="nav-link">Browse Movies</a></li>
            <li><a href="bookingHistory.jsp" class="nav-link active">My Bookings</a></li>
            <% if(userName != null) { %>
                <li><span class="user-badge">👤 <%=userName%></span></li>
                <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header">
            <div class="page-title">
                <h1>My Booking History</h1>
                <p class="page-subtitle">Track your movie tickets, booking statuses, and digital passes.</p>
            </div>
            <a href="movies" class="btn btn-primary">🎟️ Book New Ticket</a>
        </div>

        <% if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                <span>⚠️ Action failed. Unable to cancel booking. Please try again.</span>
            </div>
        <% } %>

        <div class="glass-card">
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Movie Title</th>
                            <th>Show Date</th>
                            <th>Show Time</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            boolean hasBookings = false;
                            try(Connection c = DBConnection.getConnection(); 
                                PreparedStatement p = c.prepareStatement(
                                    "SELECT b.booking_id, m.title, s.show_date, s.show_time, b.total_amount, b.status " +
                                    "FROM bookings b " +
                                    "JOIN shows s ON b.show_id = s.show_id " +
                                    "JOIN movies m ON s.movie_id = m.movie_id " +
                                    "WHERE b.user_id = ? ORDER BY b.booking_id DESC")) {
                                p.setInt(1, uid);
                                ResultSet r = p.executeQuery();
                                while(r.next()) {
                                    hasBookings = true;
                                    int bId = r.getInt(1);
                                    String mTitle = r.getString(2);
                                    Date sDate = r.getDate(3);
                                    Time sTime = r.getTime(4);
                                    double amt = r.getDouble(5);
                                    String st = r.getString(6);
                        %>
                            <tr>
                                <td style="font-weight: 700; color: #fff;">#<%=bId%></td>
                                <td style="font-weight: 600;"><%=mTitle%></td>
                                <td><%=sDate%></td>
                                <td><%=sTime%></td>
                                <td style="font-weight: 700; color: var(--accent);">₹<%=amt%></td>
                                <td>
                                    <% if("CONFIRMED".equalsIgnoreCase(st)) { %>
                                        <span class="status-pill confirmed">CONFIRMED</span>
                                    <% } else { %>
                                        <span class="status-pill cancelled">CANCELLED</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if("CONFIRMED".equalsIgnoreCase(st)) { %>
                                        <a href="ticket.jsp?bookingId=<%=bId%>" class="btn btn-secondary" style="padding: 0.35rem 0.75rem; font-size: 0.8rem;">View Ticket</a>
                                        <a href="cancelBooking?id=<%=bId%>" class="btn btn-danger" style="padding: 0.35rem 0.75rem; font-size: 0.8rem;" onclick="return confirm('Are you sure you want to cancel this booking?');">Cancel</a>
                                    <% } else { %>
                                        <span style="color: var(--text-dim); font-size: 0.85rem;">None</span>
                                    <% } %>
                                </td>
                            </tr>
                        <%
                                }
                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                            if(!hasBookings) {
                        %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 3rem 1rem; color: var(--text-muted);">
                                    <div>🎟️ No booking history found. <a href="movies">Browse movies</a> to make your first booking!</div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Movie Ticket Booking Platform.</p>
    </footer>
</body>
</html>