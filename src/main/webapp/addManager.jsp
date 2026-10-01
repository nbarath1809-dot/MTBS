<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    
    // Admin access security check
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
    <title>Create Manager Account | CinePass Admin</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">📽️</div>
            <span>CinePass <span style="font-size: 0.75rem; color: var(--gold); text-transform: uppercase; letter-spacing: 0.1em; margin-left: 0.25rem;">Admin</span></span>
        </div>
        <ul class="nav-links">
            <li><a href="admin.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="userDirectory.jsp" class="nav-link">User Directory</a></li>
            <li><a href="addManager.jsp" class="nav-link active">Add Manager</a></li>
            <% if(userName != null) { %>
                <li><span class="user-badge">🛡️ <%=userName%></span></li>
                <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container" style="max-width: 720px;">
        <div class="page-header">
            <div class="page-title">
                <h1>Create Manager Account</h1>
                <p class="page-subtitle">Provision theater staff credentials with administrative permissions to manage movies and show schedules.</p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="userDirectory.jsp" class="btn btn-secondary">👥 View Directory</a>
                <a href="admin.jsp" class="btn btn-secondary">&larr; Dashboard</a>
            </div>
        </div>

        <% if("1".equals(request.getParameter("added"))) { %>
            <div class="alert alert-success">
                <span>🎉 New Manager account created successfully!</span>
                <a href="userDirectory.jsp" class="btn btn-primary" style="margin-left: 1rem; padding: 0.35rem 0.8rem; font-size: 0.85rem;">Open User Directory &rarr;</a>
            </div>
        <% } %>

        <% if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                <span>⚠️ Failed to create manager account. Please check details or ensure the email address is not already in use.</span>
            </div>
        <% } %>

        <!-- Add Manager Form Container -->
        <div class="glass-card" style="margin-bottom: 2rem;">
            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.5rem;">
                <div class="brand-icon" style="width: 44px; height: 44px; font-size: 1.3rem;">📽️</div>
                <div>
                    <h3 style="font-size: 1.35rem;">New Theater Manager Details</h3>
                    <p style="color: var(--text-muted); font-size: 0.85rem;">Account will be granted the MANAGER role upon creation.</p>
                </div>
            </div>

            <form action="addManager" method="post">
                <div class="form-group">
                    <label class="form-label">Manager Full Name</label>
                    <input type="text" name="name" placeholder="e.g. Sarah Connor" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" placeholder="sarah.manager@cinema.com" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" placeholder="••••••••" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" placeholder="+91 00000 00000" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block">➕ Create Manager Account</button>
            </form>
        </div>

        <!-- Manager Role Info Box -->
        <div class="glass-card" style="border-left: 4px solid var(--primary); padding: 1.25rem 1.5rem;">
            <h4 style="margin-bottom: 0.5rem; font-size: 1rem; color: #fff;">💡 Manager Role Privileges</h4>
            <ul style="color: var(--text-muted); font-size: 0.85rem; padding-left: 1.2rem; line-height: 1.7;">
                <li>Full access to add, update, and manage movies in the catalog</li>
                <li>Ability to schedule showtimes, assign screen halls, and adjust ticket prices</li>
                <li>Access to the Manager Dashboard and real-time screen occupancy overview</li>
            </ul>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Administration Module.</p>
    </footer>
</body>
</html>
