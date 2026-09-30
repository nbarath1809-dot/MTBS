package com.moviebooking.controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse res)
            throws IOException {
        HttpSession s=req.getSession(false);
        if(s!=null) s.invalidate();
        res.sendRedirect("login.jsp");
    }
}
