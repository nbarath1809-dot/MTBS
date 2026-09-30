<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.moviebooking.util.DBConnection" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    Integer currentUserId = (Integer) session.getAttribute("userId");
    
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
    <title>User Directory | CinePass Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.3rem 0.75rem;
            border-radius: var(--radius-full);
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.04em;
        }
        .role-admin {
            background: rgba(245, 158, 11, 0.15);
            color: var(--gold);
            border: 1px solid rgba(245, 158, 11, 0.3);
        }
        .role-manager {
            background: rgba(236, 72, 153, 0.15);
            color: #f472b6;
            border: 1px solid rgba(236, 72, 153, 0.3);
        }
        .role-customer {
            background: rgba(139, 92, 246, 0.15);
            color: #c4b5fd;
            border: 1px solid rgba(139, 92, 246, 0.3);
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">👥</div>
            <span>CinePass <span style="font-size: 0.75rem; color: var(--gold); text-transform: uppercase; letter-spacing: 0.1em; margin-left: 0.25rem;">Admin</span></span>
        </div>
        <ul class="nav-links">
            <li><a href="admin.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="userDirectory.jsp" class="nav-link active">User Directory</a></li>
            <li><a href="addManager.jsp" class="nav-link">Add Manager</a></li>
            <% if(userName != null) { %>
                <li><span class="user-badge">🛡️ <%=userName%></span></li>
                <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header">
            <div class="page-title">
                <h1>System User Directory</h1>
                <p class="page-subtitle">View all registered accounts, audit user roles, and manage system access permissions.</p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="addManager.jsp" class="btn btn-primary">➕ Add New Manager</a>
                <a href="admin.jsp" class="btn btn-secondary">&larr; Back to Dashboard</a>
            </div>
        </div>

        <% if("1".equals(request.getParameter("added"))) { %>
            <div class="alert alert-success">
                <span>🎉 New Manager account created successfully!</span>
            </div>
        <% } %>

        <% if("1".equals(request.getParameter("deleted"))) { %>
            <div class="alert alert-success">
                <span>🗑️ Account removed successfully.</span>
            </div>
        <% } %>

        <% if("self_delete".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                <span>⚠️ You cannot delete your own active Admin account.</span>
            </div>
        <% } else if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                <span>⚠️ Operation failed. Please check details and try again.</span>
            </div>
        <% } %>

        <!-- Users Directory Table -->
        <div class="glass-card" style="margin-bottom: 2.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem; flex-wrap: wrap; gap: 1rem;">
                <div>
                    <h3 style="margin-bottom: 0.25rem;">Registered System Accounts</h3>
                    <p style="color: var(--text-muted); font-size: 0.85rem;">Comprehensive directory of Customers, Theater Managers, and Administrators.</p>
                </div>
            </div>
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            boolean foundUsers = false;
                            try(Connection c = DBConnection.getConnection();
                                Statement s = c.createStatement();
                                ResultSet r = s.executeQuery("SELECT user_id, name, email, phone, role FROM users ORDER BY user_id ASC")) {
                                while(r.next()) {
                                    foundUsers = true;
                                    int uId = r.getInt(1);
                                    String uName = r.getString(2);
                                    String uEmail = r.getString(3);
                                    String uPhone = r.getString(4);
                                    String uRole = r.getString(5);
                        %>
                            <tr>
                                <td style="font-weight: 700; color: #fff;">#<%=uId%></td>
                                <td style="font-weight: 600;"><%=uName%></td>
                                <td><%=uEmail%></td>
                                <td><%=uPhone != null && !uPhone.isEmpty() ? uPhone : "N/A"%></td>
                                <td>
                                    <% if("ADMIN".equalsIgnoreCase(uRole)) { %>
                                        <span class="role-badge role-admin">🛡️ ADMIN</span>
                                    <% } else if("MANAGER".equalsIgnoreCase(uRole)) { %>
                                        <span class="role-badge role-manager">📽️ MANAGER</span>
                                    <% } else { %>
                                        <span class="role-badge role-customer">🎟️ CUSTOMER</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if(currentUserId != null && currentUserId == uId) { %>
                                        <span style="color: var(--text-dim); font-size: 0.85rem;">Current Account</span>
                                    <% } else { %>
                                        <a href="deleteUser?id=<%=uId%>" class="btn btn-danger" style="padding: 0.35rem 0.8rem; font-size: 0.8rem;" onclick="return confirm('Are you sure you want to remove user <%=uName%> (<%=uRole%>)?');">🗑️ Remove</a>
                                    <% } %>
                                </td>
                            </tr>
                        <%
                                }
                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                            if(!foundUsers) {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 2rem; color: var(--text-muted);">
                                    No user records found in the database.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Administration Module.</p>
    </footer>
</body>
</html>
