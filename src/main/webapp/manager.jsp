<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.moviebooking.util.DBConnection" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if(!"MANAGER".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    int totalMovies = 0;
    int totalShows = 0;
    int totalBookings = 0;
    double totalRevenue = 0.0;

    try(Connection c = DBConnection.getConnection()) {
        if(c != null) {
            try(Statement s = c.createStatement()) {
                ResultSet r1 = s.executeQuery("SELECT COUNT(*) FROM movies");
                if(r1.next()) totalMovies = r1.getInt(1);

                ResultSet r2 = s.executeQuery("SELECT COUNT(*) FROM shows");
                if(r2.next()) totalShows = r2.getInt(1);

                ResultSet r3 = s.executeQuery("SELECT COUNT(*), COALESCE(SUM(total_amount), 0) FROM bookings WHERE status='CONFIRMED'");
                if(r3.next()) {
                    totalBookings = r3.getInt(1);
                    totalRevenue = r3.getDouble(2);
                }
            }
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Portal | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">📽️</div>
            <span>CinePass <span style="font-size: 0.75rem; color: var(--accent); text-transform: uppercase; letter-spacing: 0.1em; margin-left: 0.25rem;">Manager</span></span>
        </div>
        <ul class="nav-links">
            <li><a href="manager.jsp" class="nav-link active">Dashboard</a></li>
            <li><a href="movies" class="nav-link">Movies Catalog</a></li>
            <li><a href="addMovie.jsp" class="nav-link">Add Movie</a></li>
            <li><a href="addShow.jsp" class="nav-link">Add Show</a></li>
            <li><a href="reports.jsp" class="nav-link">Sales Report</a></li>
            <li><span class="user-badge">🛠️ <%=userName%></span></li>
            <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header">
            <div class="page-title">
                <h1>Theater Manager Control Center</h1>
                <p class="page-subtitle">Welcome back, <%=userName%>. Oversee movie schedules, ticket bookings, and sales revenue.</p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="reports.jsp" class="btn btn-primary">📊 View Sales Report</a>
                <a href="addMovie.jsp" class="btn btn-secondary">➕ Add Movie</a>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-icon">🎬</div>
                <div class="stat-info">
                    <h4>Movie Catalog</h4>
                    <div class="stat-value"><%=totalMovies%> Active</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⏰</div>
                <div class="stat-info">
                    <h4>Showtimes</h4>
                    <div class="stat-value"><%=totalShows%> Scheduled</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">💰</div>
                <div class="stat-info">
                    <h4>Total Sales</h4>
                    <div class="stat-value" style="color: var(--accent);">₹<%=String.format("%.0f", totalRevenue)%></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎟️</div>
                <div class="stat-info">
                    <h4>Tickets Sold</h4>
                    <div class="stat-value"><%=totalBookings%></div>
                </div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem;">
            <div class="glass-card">
                <h3 style="margin-bottom: 0.5rem;">📽️ Add Movie</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.25rem;">Register a new movie title into the cinema system with duration and description.</p>
                <a href="addMovie.jsp" class="btn btn-secondary btn-block">Add Movie Form &rarr;</a>
            </div>

            <div class="glass-card">
                <h3 style="margin-bottom: 0.5rem;">🎬 Manage Movies</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.25rem;">View catalog, check details, or remove outdated movies from circulation.</p>
                <a href="movies" class="btn btn-secondary btn-block">View Movie List &rarr;</a>
            </div>

            <div class="glass-card">
                <h3 style="margin-bottom: 0.5rem;">🗓️ Schedule Show</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.25rem;">Create new showtime slots, assign theater halls, and set screen pricing.</p>
                <a href="addShow.jsp" class="btn btn-secondary btn-block">Create Show Slot &rarr;</a>
            </div>

            <div class="glass-card">
                <h3 style="margin-bottom: 0.5rem;">📊 Sales & Revenue Reports</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.25rem;">Analyze total ticket revenue, view recent booking transactions, and audit payment methods.</p>
                <a href="reports.jsp" class="btn btn-primary btn-block">Open Sales Report &rarr;</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Management Console. All rights reserved.</p>
    </footer>
</body>
</html>