<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.moviebooking.util.DBConnection" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("name");
    Integer userId = (Integer) session.getAttribute("userId");
    if(userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String showIdParam = request.getParameter("showId");
    String movieIdParam = request.getParameter("movieId");
    int showId = 1;
    String movieTitle = "Movie";
    double ticketPrice = 150.0;

    class SeatInfo {
        int id;
        String number;
        String status;
        SeatInfo(int id, String number, String status) {
            this.id = id;
            this.number = number;
            this.status = status;
        }
    }
    List<SeatInfo> seatList = new ArrayList<>();

    try (Connection c = DBConnection.getConnection()) {
        if (c != null) {
            // If movieId provided, resolve showId and movie title
            if (movieIdParam != null && !movieIdParam.trim().isEmpty()) {
                int mId = Integer.parseInt(movieIdParam.trim());
                PreparedStatement psShow = c.prepareStatement(
                    "SELECT show_id, price FROM shows WHERE movie_id = ? ORDER BY show_id ASC LIMIT 1");
                psShow.setInt(1, mId);
                ResultSet rsShow = psShow.executeQuery();
                if (rsShow.next()) {
                    showId = rsShow.getInt("show_id");
                    double p = rsShow.getDouble("price");
                    if (p > 0) ticketPrice = p;
                } else {
                    PreparedStatement insShow = c.prepareStatement(
                        "INSERT INTO shows(movie_id, screen_id, show_date, show_time, price) VALUES(?, 1, CURDATE(), '18:00:00', 150.00)",
                        Statement.RETURN_GENERATED_KEYS);
                    insShow.setInt(1, mId);
                    insShow.executeUpdate();
                    ResultSet gk = insShow.getGeneratedKeys();
                    if (gk.next()) showId = gk.getInt(1);
                }

                PreparedStatement psMovie = c.prepareStatement("SELECT title FROM movies WHERE movie_id = ?");
                psMovie.setInt(1, mId);
                ResultSet rsMovie = psMovie.executeQuery();
                if (rsMovie.next()) movieTitle = rsMovie.getString("title");
            } else if (showIdParam != null && !showIdParam.trim().isEmpty()) {
                showId = Integer.parseInt(showIdParam.trim());
                PreparedStatement psShow = c.prepareStatement(
                    "SELECT m.title, s.price FROM shows s LEFT JOIN movies m ON s.movie_id = m.movie_id WHERE s.show_id = ?");
                psShow.setInt(1, showId);
                ResultSet rsShow = psShow.executeQuery();
                if (rsShow.next()) {
                    if (rsShow.getString("title") != null) movieTitle = rsShow.getString("title");
                    double p = rsShow.getDouble("price");
                    if (p > 0) ticketPrice = p;
                }
            } else {
                // Default show
                PreparedStatement psShow = c.prepareStatement(
                    "SELECT s.show_id, m.title, s.price FROM shows s LEFT JOIN movies m ON s.movie_id = m.movie_id ORDER BY s.show_id ASC LIMIT 1");
                ResultSet rsShow = psShow.executeQuery();
                if (rsShow.next()) {
                    showId = rsShow.getInt("show_id");
                    if (rsShow.getString("title") != null) movieTitle = rsShow.getString("title");
                    double p = rsShow.getDouble("price");
                    if (p > 0) ticketPrice = p;
                }
            }

            // Load seats from database
            Statement stSeats = c.createStatement();
            ResultSet rsSeats = stSeats.executeQuery("SELECT seat_id, seat_number, status FROM seats ORDER BY seat_id ASC");
            while (rsSeats.next()) {
                seatList.add(new SeatInfo(rsSeats.getInt("seat_id"), rsSeats.getString("seat_number"), rsSeats.getString("status")));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Fallback default 8 seats if table was empty
    if (seatList.isEmpty()) {
        seatList.add(new SeatInfo(1, "A1", "AVAILABLE"));
        seatList.add(new SeatInfo(2, "A2", "AVAILABLE"));
        seatList.add(new SeatInfo(3, "A3", "AVAILABLE"));
        seatList.add(new SeatInfo(4, "A4", "AVAILABLE"));
        seatList.add(new SeatInfo(5, "B1", "AVAILABLE"));
        seatList.add(new SeatInfo(6, "B2", "AVAILABLE"));
        seatList.add(new SeatInfo(7, "B3", "AVAILABLE"));
        seatList.add(new SeatInfo(8, "B4", "AVAILABLE"));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Seats | <%=movieTitle%> | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">🎟️</div>
            <span>CinePass</span>
        </div>
        <ul class="nav-links">
            <li><a href="customer.jsp" class="nav-link">Dashboard</a></li>
            <li><a href="movies" class="nav-link">Browse Movies</a></li>
            <li><a href="bookingHistory.jsp" class="nav-link">My Bookings</a></li>
            <% if(userName != null) { %>
                <li><span class="user-badge">👤 <%=userName%></span></li>
                <li><a href="logout" class="btn btn-secondary" style="padding: 0.4rem 0.9rem; font-size: 0.85rem;">Logout</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="app-container">
        <div class="page-header" style="text-align: center; display: block;">
            <h1>Select Your Seats</h1>
            <p class="page-subtitle"><%=movieTitle%> &bull; Screen 1 &bull; Standard Ticket Price: ₹<%=String.format("%.0f", ticketPrice)%> / seat</p>
        </div>

        <% if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" style="max-width: 600px; margin: 0 auto 1.5rem auto;">
                <span>⚠️ Please select at least one seat to proceed.</span>
            </div>
        <% } else if("booked".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" style="max-width: 600px; margin: 0 auto 1.5rem auto;">
                <span>⚠️ One or more selected seats are already booked. Please select available seats.</span>
            </div>
        <% } else if("failed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" style="max-width: 600px; margin: 0 auto 1.5rem auto;">
                <span>⚠️ Unable to process booking. Please try again.</span>
            </div>
        <% } %>

        <div class="seat-selection-container glass-card">
            <div class="cinema-screen-container">
                <div class="cinema-screen">CINEMA SCREEN</div>
            </div>

            <div class="seat-legend">
                <div class="legend-item">
                    <div class="seat-sample available"></div>
                    <span>Available</span>
                </div>
                <div class="legend-item">
                    <div class="seat-sample selected"></div>
                    <span>Selected</span>
                </div>
                <div class="legend-item">
                    <div class="seat-sample booked"></div>
                    <span>Booked</span>
                </div>
            </div>

            <form action="booking" method="post" id="seatForm">
                <input type="hidden" name="showId" value="<%=showId%>">

                <div class="seat-grid">
                    <% for (SeatInfo s : seatList) { 
                        boolean isBooked = "BOOKED".equalsIgnoreCase(s.status);
                    %>
                        <div class="seat-item">
                            <% if (isBooked) { %>
                                <input type="checkbox" name="seats" value="<%=s.id%>" id="seat-<%=s.id%>" disabled>
                                <label for="seat-<%=s.id%>" class="seat-checkbox-card" style="opacity: 0.45; cursor: not-allowed; background: rgba(51, 65, 85, 0.4); border-color: transparent;" title="Seat <%=s.number%> is already booked">
                                    <span>🚫</span>
                                    <span style="font-size: 0.8rem;"><%=s.number%></span>
                                </label>
                            <% } else { %>
                                <input type="checkbox" name="seats" value="<%=s.id%>" id="seat-<%=s.id%>" onchange="updateSummary()">
                                <label for="seat-<%=s.id%>" class="seat-checkbox-card">
                                    <span>💺</span>
                                    <span style="font-size: 0.8rem;"><%=s.number%></span>
                                </label>
                            <% } %>
                        </div>
                    <% } %>
                </div>

                <div style="background: rgba(15, 23, 42, 0.6); padding: 1.25rem 2rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-size: 0.85rem; color: var(--text-muted);">SELECTED SEATS</div>
                        <div id="seatCount" style="font-size: 1.2rem; font-weight: 700; color: #fff;">0 seats</div>
                    </div>
                    <div>
                        <div style="font-size: 0.85rem; color: var(--text-muted);">TOTAL AMOUNT</div>
                        <div id="totalPrice" style="font-size: 1.5rem; font-weight: 800; color: var(--accent);">₹0</div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="font-size: 1.1rem; padding: 1rem;">Proceed to Checkout &rarr;</button>
            </form>
        </div>
    </main>

    <script>
        const pricePerSeat = <%=ticketPrice%>;
        function updateSummary() {
            const checkedBoxes = document.querySelectorAll('input[name="seats"]:checked:not(:disabled)');
            const count = checkedBoxes.length;
            const total = count * pricePerSeat;
            
            document.getElementById('seatCount').innerText = count + (count === 1 ? ' seat' : ' seats');
            document.getElementById('totalPrice').innerText = '₹' + Math.round(total);
        }
    </script>

    <footer class="footer">
        <p>&copy; 2026 CinePass Movie Ticket Booking Platform.</p>
    </footer>
</body>
</html>