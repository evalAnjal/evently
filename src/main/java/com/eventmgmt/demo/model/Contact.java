package com.eventmgmt.demo.model;


public class Contact {

    private int id;
    private String email;
    private String message;

    public Contact() {}

    public Contact(String email, String message) {
        this.email = email;
        this.message = message;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}