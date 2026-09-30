package com.moviebooking.controller;

import com.moviebooking.dao.MovieDAO;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteMovie")
public class DeleteMovieServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse res)
            throws IOException {
        new MovieDAO().deleteMovie(Integer.parseInt(req.getParameter("id")));
        res.sendRedirect("movies");
    }
}
