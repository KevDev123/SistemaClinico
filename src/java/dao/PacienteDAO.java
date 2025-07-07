/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import interfaces.IConexion;
import interfaces.IGenericoDAO;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ConexionBD;
import model.Paciente;

/**
 *
 * @author Hello
 */
public class PacienteDAO implements  IGenericoDAO<Paciente> {
    
    private final IConexion conexion;

 
    
    public PacienteDAO(IConexion conexion) {
        this.conexion = conexion;
    }
    
    
     @Override
    public void guardar(Paciente p) {
        
            Connection con = null;
            PreparedStatement pst = null;

        
        try{
         con = conexion.getConexion();
             
        pst = con.prepareStatement("INSERT INTO pacientes(nombre_paciente, apellido_paciente, fecha_nacimiento, genero, direccion, telefono_paciente, detalles) VALUES (?,?,?,?,?,?,?)");
                pst.setString(1, p.getNombre());
                pst.setString(2, p.getApellido());
                pst.setString(3, p.getFechaNacimiento());
                pst.setString(4, p.getGenero());
                pst.setString(5, p.getDireccion());
                pst.setString(6, p.getTelefono());
                pst.setString(7, p.getDetalles());
                pst.executeUpdate();
                
        }catch (SQLException e) {
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {  
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }finally {     
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }  
        
        
    }
    

    @Override
    public void actualizar(Paciente p) {
        
        
            Connection con = null;
            PreparedStatement pst = null;

       try{
         con = conexion.getConexion();
        
         pst = con.prepareStatement("UPDATE pacientes SET nombre_paciente=?, apellido_paciente=?, fecha_nacimiento=?, genero=?, direccion=?, telefono_paciente=?, detalles=? WHERE id_paciente=?");
                pst.setString(1, p.getNombre());
                pst.setString(2, p.getApellido());
                pst.setString(3, p.getFechaNacimiento());
                pst.setString(4, p.getGenero());
                pst.setString(5, p.getDireccion());
                pst.setString(6, p.getTelefono());
                pst.setString(7, p.getDetalles());
                pst.setInt(8, p.getId());
                pst.executeUpdate();
                
        }catch (SQLException e) {
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {  
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {     
        try { if (pst != null) pst.close(); } catch (SQLException e) {}
        try { if (con != null) con.close(); } catch (SQLException e) {}
    }    
    }

    @Override
    public void eliminar(int id) {
        
           Connection con = null;
            PreparedStatement pst = null;

         try {
              con = conexion.getConexion();

             pst = con.prepareStatement("delete from pacientes where id_paciente=?");
            pst.setString(1,String.valueOf(id));
            pst.executeUpdate();
             
         } catch (Exception ex) {
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }finally {     
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
         }  
       
        
        
    }
    
    
    @Override
    public Paciente enviarDatosID(int id){
        
         Paciente p = new Paciente();
         Connection con = null;
          PreparedStatement pst = null;
          ResultSet rs = null;
        
         try {
             con = conexion.getConexion();
                      
             pst = con.prepareStatement("select * from pacientes where id_paciente=?");
             pst.setString(1,String.valueOf(id));
             rs = pst.executeQuery();
             
             while(rs.next()){
                p.setId(rs.getInt("id_paciente"));
                p.setNombre(rs.getString("nombre_paciente"));
                p.setApellido(rs.getString("apellido_paciente"));
                p.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                p.setGenero(rs.getString("genero"));
                p.setDireccion(rs.getString("direccion"));
                p.setTelefono(rs.getString("telefono_paciente"));
                p.setDetalles(rs.getString("detalles"));               
             }
                     
         } catch (Exception ex) {
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        } 
        
         return p;
         
        
    }
    
    

        @Override
    public List<Paciente> listarTodos(String nombre) {


               List<Paciente> pacientes = new ArrayList<>();
              Connection con = null;
              PreparedStatement pst = null;
              ResultSet rs = null;

        String sql = "SELECT * FROM pacientes";

        if (nombre != null && !nombre.trim().isEmpty()) {
            sql += " WHERE nombre_paciente LIKE ?"
                 + " OR apellido_paciente LIKE ?"
                 + " OR genero LIKE ?"
                 + " OR direccion LIKE ?"
                 + " OR telefono_paciente LIKE ?";
        }

        try {
              con = conexion.getConexion();
              pst = con.prepareStatement(sql);

            // Si hay filtro, establecer los parámetros con %palabra%
            if (nombre != null && !nombre.trim().isEmpty()) {
                String filtro = "%" + nombre + "%";
                for (int i = 1; i <= 5; i++) {
                    pst.setString(i, filtro);
                }
            }

             rs = pst.executeQuery();
            while (rs.next()) {
                Paciente p = new Paciente();
                p.setId(rs.getInt("id_paciente"));
                p.setNombre(rs.getString("nombre_paciente"));
                p.setApellido(rs.getString("apellido_paciente"));
                p.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                p.setGenero(rs.getString("genero"));
                p.setDireccion(rs.getString("direccion"));
                p.setTelefono(rs.getString("telefono_paciente"));
                p.setDetalles(rs.getString("detalles"));
                pacientes.add(p);
            }

        } catch (SQLException e) {
            System.out.println("Error en listarTodos: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) {}
                try { if (pst != null) pst.close(); } catch (SQLException e) {}
                try { if (con != null) con.close(); } catch (SQLException e) {}
        } 


        return pacientes;
    }

    
    
}
