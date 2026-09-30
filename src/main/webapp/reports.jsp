<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.moviebooking.util.DBConnection" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    
    // Security check: Only MANAGER can access the sales report
    if(!"MANAGER".equals(role)) {
        if("ADMIN".equals(role)) {
            response.sendRedirect("admin.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
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
    <title>Sales Report | CinePass Manager</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">📊</div>
            <span>CinePass <span style="font-size: 0.75rem; color: var(--accent); text-transform: uppercase; letter-spacing: 0.1em; margin-left: 0.25rem;">Manager</span></span>
        </div>
        <ul class="nav-links">
            <li><a href="manager.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="movies" class="nav-link">Movies Catalog</a></li>
            <li><a href="addMovie.jsp" class="nav-link">Add Movie</a></li>
            <li><a href="addShow.jsp" class="nav-link">Add Show</a></li>
            <li><a href="reports.jsp" class="nav-link active">Sales Report</a></li>
            <% if(userName != null) { %>
                <li><span class="user-badge">🛠️ <%=userName%></span></li>
                <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header">
            <div class="page-title">
                <h1>Theater Sales & Revenue Report</h1>
                <p class="page-subtitle">Real-time box office performance metrics, ticket revenue logs, and transaction audit.</p>
            </div>
            <a href="manager.jsp" class="btn btn-secondary">&larr; Back to Manager Dashboard</a>
        </div>

        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-icon">💰</div>
                <div class="stat-info">
                    <h4>Total Revenue</h4>
                    <div class="stat-value" style="color: var(--accent);">₹<%=String.format("%.2f", totalRevenue)%></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">🎟️</div>
                <div class="stat-info">
                    <h4>Confirmed Bookings</h4>
                    <div class="stat-value"><%=totalBookings%></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">🎬</div>
                <div class="stat-info">
                    <h4>Active Movies</h4>
                    <div class="stat-value"><%=totalMovies%></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">⏰</div>
                <div class="stat-info">
                    <h4>Scheduled Shows</h4>
                    <div class="stat-value"><%=totalShows%></div>
                </div>
            </div>
        </div>

        <div class="glass-card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem; flex-wrap: wrap; gap: 1rem;">
                <div>
                    <h3 style="margin-bottom: 0.25rem;">Recent Sales & Transactions</h3>
                    <p style="color: var(--text-muted); font-size: 0.85rem;">Audit log of ticket purchases and payments received.</p>
                </div>
            </div>
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Transaction ID</th>
                            <th>Booking Ref</th>
                            <th>Amount Paid</th>
                            <th>Payment Method</th>
                            <th>Payment Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            boolean foundPayments = false;
                            try(Connection c = DBConnection.getConnection();
                                Statement s = c.createStatement();
                                ResultSet r = s.executeQuery("SELECT payment_id, booking_id, amount, payment_method, payment_status, payment_date FROM payments ORDER BY payment_id DESC LIMIT 20")) {
                                while(r.next()) {
                                    foundPayments = true;
                                    int payId = r.getInt(1);
                                    int bId = r.getInt(2);
                                    double amt = r.getDouble(3);
                                    String method = r.getString(4);
                                    String status = r.getString(5);
                                    Timestamp pDate = r.getTimestamp(6);
                        %>
                            <tr>
                                <td style="font-weight: 700; color: #fff;">#PAY-<%=payId%></td>
                                <td>#<%=bId%></td>
                                <td style="font-weight: 700; color: var(--accent);">₹<%=String.format("%.2f", amt)%></td>
                                <td><%=method != null ? method : "ONLINE"%></td>
                                <td><%=pDate != null ? pDate.toString().substring(0, 19) : "N/A"%></td>
                                <td><span class="status-pill confirmed"><%=status%></span></td>
                            </tr>
                        <%
                                }
                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                            if(!foundPayments) {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 2rem; color: var(--text-muted);">
                                    No sales transactions recorded yet.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CinePass Theater Management System.</p>
    </footer>
</body>
</html>