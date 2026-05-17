package com.eventmgmt.demo.DAO;

import com.eventmgmt.demo.model.Contact;
import com.eventmgmt.demo.util.DBconnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ContactDAO {

    public boolean saveMessage(Contact msg) {

        boolean result = false;

        try (Connection con = DBconnection.getConnection()) {

            String sql = "INSERT INTO contact_messages(email, message) VALUES (?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, msg.getEmail());
            ps.setString(2, msg.getMessage());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                result = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}