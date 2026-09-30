<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | CinePass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <div class="brand-icon">🍿</div>
                <h2>Create Account</h2>
                <p class="page-subtitle">Join CinePass for seamless movie tickets</p>
            </div>

            <% if("1".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger">
                    <span>⚠️ Registration failed. Email may already exist.</span>
                </div>
            <% } %>

            <form action="register" method="post">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" placeholder="John Doe" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" placeholder="john@example.com" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phone" placeholder="+1 (555) 000-0000" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Register Account</button>
            </form>

            <div style="margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-muted);">
                Already registered? <a href="login.jsp" style="font-weight: 600;">Sign In</a>
            </div>
        </div>
    </div>
</body>
</html>