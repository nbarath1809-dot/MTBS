package com.moviebooking.dao;

import com.moviebooking.model.Movie;
import com.moviebooking.util.DBConnection;
import java.sql.*;
import java.util.*;

public class MovieDAO {
    public List<Movie> getAllMovies() {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM movies";
        try(Connection c=DBConnection.getConnection();
            PreparedStatement p=c.prepareStatement(sql);
            ResultSet r=p.executeQuery()) {
            while(r.next()) {
                Movie m=new Movie();
                m.setMovieId(r.getInt("movie_id"));
                m.setTitle(r.getString("title"));
                m.setGenre(r.getString("genre"));
                m.setLanguage(r.getString("language"));
                m.setDuration(r.getInt("duration"));
                m.setDescription(r.getString("description"));
                list.add(m);
            }
        } catch(Exception e){ e.printStackTrace(); }
        return list;
    }
    public boolean deleteMovie(int id) {
        try(Connection c=DBConnection.getConnection();
            PreparedStatement p=c.prepareStatement(
                "DELETE FROM movies WHERE movie_id=?")) {
            p.setInt(1,id);
            return p.executeUpdate()>0;
        } catch(Exception e){ e.printStackTrace(); return false; }
    }
}
