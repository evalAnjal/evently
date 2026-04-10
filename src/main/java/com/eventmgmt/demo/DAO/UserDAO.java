package com.eventmgmt.demo.DAO;

import com.eventmgmt.demo.model.User;
import com.eventmgmt.demo.util.DBconnection;
import java.sql.*;

public class UserDAO {
    public User validateUser (String email, String password){
        User user = null;
        String sql = "select * from users where email =? and password = ?";

        try(Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql)        
    ){
        st.setString(1,email);
        st.setString(2,password);
        

        ResultSet rs = st.executeQuery();

        if(rs.next()){
            user = new User();
            user.setId(rs.getInt("id"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getString(("role")));
            user.setUsername(rs.getString(("username")));
        }


        
    }
    catch(SQLException e){
        e.printStackTrace();
    }
    return user;
    }

    public void registerUser(User user) throws SQLException {
       
        String sql = "INSERT INTO users(username,email,password) VALUES(?,?,?)";
        try(Connection conn = DBconnection.getConnection();
            PreparedStatement st = conn.prepareStatement(sql)){
                st.setString(1, user.getUsername());
                st.setString(2, user.getEmail());
                st.setString(3, user.getPassword());

                int rowsAffected = st.executeUpdate();
                if (rowsAffected <= 0) {
                    throw new SQLException("No row inserted for registration.");
                }
            }
    }
}
