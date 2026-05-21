package com.eventmgmt.demo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBconnection { 
    
    private static final String URL = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/eventdb?useSSL=false&serverTimezone=UTC";

    private static final String USER = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
    private static final String PASS = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "password";

    public static Connection getConnection() throws SQLException {
        try {
           
            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(URL, USER, PASS);

        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found! Check your pom.xml.", e);
        }
    }
}