<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Movie | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">📽️</div>
            <span>CinePass</span>
        </div>
        <ul class="nav-links">
            <li><a href="manager.jsp" class="nav-link">Manager Dashboard</a></li>
            <li><a href="movies" class="nav-link">Movies Catalog</a></li>
            <li><a href="addMovie.jsp" class="nav-link active">Add Movie</a></li>
            <li><a href="addShow.jsp" class="nav-link">Add Show</a></li>
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
                <h1>Add New Movie</h1>
                <p class="page-subtitle">Fill in details to add a movie title to the active theater schedule.</p>
            </div>
            <a href="movies" class="btn btn-secondary">&larr; Back to Movies</a>
        </div>

        <% if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                <span>⚠️ Failed to add movie. Please check your inputs and try again.</span>
            </div>
        <% } %>

        <div class="glass-card">
            <form action="addMovie" method="post">
                <div class="form-group">
                    <label class="form-label">Movie Title</label>
                    <input type="text" name="title" placeholder="e.g. Inception 2" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label">Genre</label>
                        <input type="text" name="genre" placeholder="Action / Sci-Fi" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Language</label>
                        <input type="text" name="language" placeholder="English / Hindi" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Duration (in Minutes)</label>
                    <input type="number" name="duration" placeholder="148" min="1" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Synopsis / Description</label>
                    <textarea name="description" placeholder="Enter movie storyline summary, cast details..." required></textarea>
                </div>

                <button type="submit" class="btn btn-primary btn-block">➕ Add Movie to Catalog</button>
            </form>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Management Console.</p>
    </footer>
</body>
</html>