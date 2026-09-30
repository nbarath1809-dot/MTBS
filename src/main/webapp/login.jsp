<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | CinePass Movie Booking</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <div class="brand-icon">🎬</div>
                <h2>Welcome Back</h2>
                <p class="page-subtitle">Sign in to your CinePass account</p>
            </div>

            <% if("1".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger">
                    <span>⚠️ Invalid email or password. Please try again.</span>
                </div>
            <% } %>

            <% if("1".equals(request.getParameter("registered"))) { %>
                <div class="alert alert-success">
                    <span>🎉 Registration successful! Please log in below.</span>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" placeholder="name@example.com" required autocomplete="email">
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Sign In</button>
            </form>

            <div style="margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-muted);">
                Don't have an account? <a href="register.jsp" style="font-weight: 600;">Create Account</a>
            </div>
        </div>
    </div>
</body>
</html>