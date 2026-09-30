<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.moviebooking.model.Movie" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    List<Movie> movies = (List<Movie>) request.getAttribute("movies");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movies Catalog | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">🍿</div>
            <span>CinePass</span>
        </div>
        <ul class="nav-links">
            <% if("ADMIN".equals(role)) { %>
                <li><a href="admin.jsp" class="nav-link">Admin Dashboard</a></li>
            <% } else if("MANAGER".equals(role)) { %>
                <li><a href="manager.jsp" class="nav-link">Manager Dashboard</a></li>
            <% } else { %>
                <li><a href="customer.jsp" class="nav-link">Dashboard</a></li>
            <% } %>
            <li><a href="movies" class="nav-link active">Browse Movies</a></li>
            <% if("CUSTOMER".equals(role) || role == null) { %>
                <li><a href="bookingHistory.jsp" class="nav-link">My Bookings</a></li>
            <% } %>
            <% if(userName != null) { %>
                <li><span class="user-badge">👤 <%=userName%></span></li>
                <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
            <% } else { %>
                <li><a href="login.jsp" class="btn btn-primary" style="padding: 0.4rem 1rem; font-size: 0.85rem;">Sign In</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header">
            <div class="page-title">
                <h1>Now Showing Movies</h1>
                <p class="page-subtitle">Select a movie to pick your seats and book tickets instantly.</p>
            </div>
            <% if("MANAGER".equals(role) || "ADMIN".equals(role)) { %>
                <a href="addMovie.jsp" class="btn btn-primary">➕ Add New Movie</a>
            <% } %>
        </div>

        <% if(movies == null || movies.isEmpty()) { %>
            <div class="glass-card" style="text-align: center; padding: 4rem 2rem;">
                <div style="font-size: 3rem; margin-bottom: 1rem;">🎬</div>
                <h3 style="margin-bottom: 0.5rem;">No Movies Available Currently</h3>
                <p style="color: var(--text-muted); margin-bottom: 1.5rem;">Check back soon or add new movies to the catalog.</p>
                <% if("MANAGER".equals(role) || "ADMIN".equals(role)) { %>
                    <a href="addMovie.jsp" class="btn btn-primary">Add Movie Now</a>
                <% } %>
            </div>
        <% } else { %>
            <div class="movie-grid">
                <% for(Movie m : movies) { %>
                    <div class="movie-card">
                        <div class="movie-poster-placeholder">
                            🎥
                            <span class="movie-badge-lang"><%=m.getLanguage() != null ? m.getLanguage() : "EN"%></span>
                        </div>
                        <div class="movie-content">
                            <h3 class="movie-title"><%=m.getTitle()%></h3>
                            <div class="movie-meta">
                                <span class="meta-chip">🎭 <%=m.getGenre() != null ? m.getGenre() : "Action"%></span>
                                <span class="meta-chip">⏱️ <%=m.getDuration()%> mins</span>
                            </div>
                            <p class="movie-desc"><%=m.getDescription() != null ? m.getDescription() : "Experience this blockbuster hit in IMAX sound and 4K display."%></p>
                            
                            <div class="movie-actions">
                                <a href="seats.jsp?showId=1&movieId=<%=m.getMovieId()%>" class="btn btn-primary" style="flex: 1;">🎟️ Select Seats</a>
                                <% if("MANAGER".equals(role) || "ADMIN".equals(role)) { %>
                                    <a href="deleteMovie?id=<%=m.getMovieId()%>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this movie?');">🗑️</a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Movie Ticket Booking Platform.</p>
    </footer>
</body>
</html>