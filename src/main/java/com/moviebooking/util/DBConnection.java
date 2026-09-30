package com.moviebooking.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL = "jdbc:mysql://127.0.0.1:3306/movie_ticket_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            // Fallback try without timezone param
            try {
                return DriverManager.getConnection("jdbc:mysql://localhost:3306/movie_ticket_db", USER, PASSWORD);
            } catch (Exception ex) {
                ex.printStackTrace();
                return null;
            }
        }
    }
}