/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Hello
 */
public class ConexionBD {
    
    private static final String URL = "jdbc:mysql://localhost/clinica?useSSL=false";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    
    private static Connection con = null;
    
      public static Connection conectar() throws Exception {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL,USER,PASSWORD);      
        }catch (ClassNotFoundException e) {
            System.out.println("Error: No se encontró el driver de MySQL.");
            e.printStackTrace();
        }catch (SQLException e) {
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        }     
        
        return con;
    }
    
}
