package com.moviebooking.model;

public class User {
    private int userId;
    private String name, email, password, phone, role;

    public int getUserId(){ return userId; }
    public void setUserId(int v){ userId=v; }
    public String getName(){ return name; }
    public void setName(String v){ name=v; }
    public String getEmail(){ return email; }
    public void setEmail(String v){ email=v; }
    public String getPassword(){ return password; }
    public void setPassword(String v){ password=v; }
    public String getPhone(){ return phone; }
    public void setPhone(String v){ phone=v; }
    public String getRole(){ return role; }
    public void setRole(String v){ role=v; }
}
