<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    if(userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">🎬</div>
            <span>CinePass</span>
        </div>
        <ul class="nav-links">
            <li><a href="customer.jsp" class="nav-link active">Dashboard</a></li>
            <li><a href="movies" class="nav-link">Browse Movies</a></li>
            <li><a href="bookingHistory.jsp" class="nav-link">My Bookings</a></li>
            <li><span class="user-badge">👤 <%=userName%></span></li>
            <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header">
            <div class="page-title">
                <h1>Welcome back, <span class="gradient-title"><%=userName%></span> 👋</h1>
                <p class="page-subtitle">Ready to experience cinema on the big screen today?</p>
            </div>
            <a href="movies" class="btn btn-primary">🍿 Browse Now Showing</a>
        </div>

        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-icon">🎞️</div>
                <div class="stat-info">
                    <h4>Available Movies</h4>
                    <div class="stat-value">Now Showing</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎟️</div>
                <div class="stat-info">
                    <h4>Active Bookings</h4>
                    <div class="stat-value">Instant Ticket</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⭐</div>
                <div class="stat-info">
                    <h4>Member Status</h4>
                    <div class="stat-value">VIP Pass</div>
                </div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
            <div class="glass-card" style="display: flex; flex-direction: column; justify-content: space-between;">
                <div>
                    <h3 style="font-size: 1.3rem; margin-bottom: 0.5rem;">Browse Latest Movies</h3>
                    <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 1.5rem;">Explore upcoming releases, check showtimes, and select your favorite seats.</p>
                </div>
                <a href="movies" class="btn btn-primary btn-block">Explore Movies &rarr;</a>
            </div>

            <div class="glass-card" style="display: flex; flex-direction: column; justify-content: space-between;">
                <div>
                    <h3 style="font-size: 1.3rem; margin-bottom: 0.5rem;">My Booking History</h3>
                    <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 1.5rem;">View your confirmed tickets, digital receipts, or manage your bookings.</p>
                </div>
                <a href="bookingHistory.jsp" class="btn btn-secondary btn-block">View History &rarr;</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Movie Ticket Booking System. All rights reserved.</p>
    </footer>
</body>
</html>