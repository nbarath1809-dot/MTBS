<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.moviebooking.util.DBConnection" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if(!"MANAGER".equals(role) && !"ADMIN".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Show | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">🗓️</div>
            <span>CinePass</span>
        </div>
        <ul class="nav-links">
            <li><a href="manager.jsp" class="nav-link">Manager Dashboard</a></li>
            <li><a href="movies" class="nav-link">Movies Catalog</a></li>
            <li><a href="addMovie.jsp" class="nav-link">Add Movie</a></li>
            <li><a href="addShow.jsp" class="nav-link active">Add Show</a></li>
            <li><a href="reports.jsp" class="nav-link">Sales Report</a></li>
            <% if(userName != null) { %>
                <li><span class="user-badge">🛠️ <%=userName%></span></li>
                <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container" style="max-width: 680px;">
        <div class="page-header">
            <div class="page-title">
                <h1>Schedule New Showtime</h1>
                <p class="page-subtitle">Assign a movie to a screen hall and pick date & time slots.</p>
            </div>
            <a href="manager.jsp" class="btn btn-secondary">&larr; Back to Dashboard</a>
        </div>

        <% if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                <span>⚠️ Failed to schedule showtime. Please check inputs and try again.</span>
            </div>
        <% } %>

        <div class="glass-card">
            <form action="addShow" method="post">
                <div class="form-group">
                    <label class="form-label">Select Movie</label>
                    <select name="movieId" required>
                        <%
                            try (Connection c = DBConnection.getConnection();
                                 Statement s = c.createStatement();
                                 ResultSet r = s.executeQuery("SELECT movie_id, title FROM movies ORDER BY title ASC")) {
                                while (r.next()) {
                        %>
                            <option value="<%=r.getInt("movie_id")%>"><%=r.getString("title")%></option>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Screen Hall</label>
                    <select name="screen">
                        <option value="1">Screen 1 (IMAX 4K)</option>
                        <option value="2">Screen 2 (Dolby Atmos)</option>
                        <option value="3">Screen 3 (VIP Lounge)</option>
                    </select>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label">Show Date</label>
                        <input type="date" name="show_date" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Show Time</label>
                        <input type="time" name="show_time" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Base Ticket Price (₹)</label>
                    <input type="number" name="price" value="150" min="50" step="10" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Schedule Showtime</button>
            </form>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Management Console.</p>
    </footer>
</body>
</html>