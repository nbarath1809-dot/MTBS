package com.moviebooking.model;

public class Movie {
    private int movieId, duration;
    private String title, genre, language, description;

    public int getMovieId(){ return movieId; }
    public void setMovieId(int v){ movieId=v; }
    public int getDuration(){ return duration; }
    public void setDuration(int v){ duration=v; }
    public String getTitle(){ return title; }
    public void setTitle(String v){ title=v; }
    public String getGenre(){ return genre; }
    public void setGenre(String v){ genre=v; }
    public String getLanguage(){ return language; }
    public void setLanguage(String v){ language=v; }
    public String getDescription(){ return description; }
    public void setDescription(String v){ description=v; }
}
