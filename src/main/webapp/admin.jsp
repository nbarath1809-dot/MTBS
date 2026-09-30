<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if(!"ADMIN".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">⚡</div>
            <span>CinePass <span style="font-size: 0.75rem; color: var(--gold); text-transform: uppercase; letter-spacing: 0.1em; margin-left: 0.25rem;">Admin</span></span>
        </div>
        <ul class="nav-links">
            <li><a href="admin.jsp" class="nav-link active">Dashboard</a></li>
            <li><a href="userDirectory.jsp" class="nav-link">User Directory</a></li>
            <li><a href="addManager.jsp" class="nav-link">Add Manager</a></li>
            <li><span class="user-badge">🛡️ Admin (<%=userName%>)</span></li>
            <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header">
            <div class="page-title">
                <h1>System Administrator Dashboard</h1>
                <p class="page-subtitle">Manage manager accounts, user permissions, and platform configuration.</p>
            </div>
            <a href="addManager.jsp" class="btn btn-primary">➕ Add New Manager</a>
        </div>

        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-info">
                    <h4>User System</h4>
                    <div class="stat-value">Accounts</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📽️</div>
                <div class="stat-info">
                    <h4>Theater Managers</h4>
                    <div class="stat-value">Staff</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🛡️</div>
                <div class="stat-info">
                    <h4>Security & Roles</h4>
                    <div class="stat-value">Control</div>
                </div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 1.5rem;">
            <div class="glass-card">
                <h3 style="margin-bottom: 0.5rem;">👥 User Directory</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 1.5rem;">View all user accounts, remove outdated manager or customer accounts, and audit roles.</p>
                <a href="userDirectory.jsp" class="btn btn-primary btn-block">Open User Directory &rarr;</a>
            </div>

            <div class="glass-card">
                <h3 style="margin-bottom: 0.5rem;">➕ Add New Manager</h3>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 1.5rem;">Provision a new theater manager account with full access to add movies and showtimes.</p>
                <a href="addManager.jsp" class="btn btn-secondary btn-block">Create Manager Account &rarr;</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Enterprise Administration Panel.</p>
    </footer>
</body>
</html>