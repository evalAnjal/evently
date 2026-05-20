package com.eventmgmt.demo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBconnection { 
    
    private static final String URL = "jdbc:postgresql://ep-small-pond-a19ayax8-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require";
    
  
    private static final String USER = "neondb_owner";
    private static final String PASS = "npg_Np6gayB4KfUJ";

    public static Connection getConnection() throws SQLException {
        try {
           
            Class.forName("org.postgresql.Driver");
            
           
            return DriverManager.getConnection(URL, USER, PASS);
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Postgres Driver not found! Check your pom.xml.", e);
        }
    }
}