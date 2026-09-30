package com.moviebooking.controller;

import com.moviebooking.dao.MovieDAO;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/movies")
public class MovieServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse res)
            throws ServletException,IOException {
        req.setAttribute("movies",new MovieDAO().getAllMovies());
        req.getRequestDispatcher("movies.jsp").forward(req,res);
    }
}
