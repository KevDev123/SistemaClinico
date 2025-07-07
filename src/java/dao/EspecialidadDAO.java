/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import interfaces.IConexion;
import interfaces.IGenericoDAO;
import model.Especialidad;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Hello
 */
public class EspecialidadDAO implements IGenericoDAO<Especialidad>{
    private final IConexion conexion;

    public EspecialidadDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    @Override
    public void guardar(Especialidad es) {
        
        
       
        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = conexion.getConexion();
            pst = con.prepareStatement("INSERT INTO especialidades(nombre_especialidad) VALUES (?)");
            pst.setString(1,es.getNombre());
            pst.executeUpdate();
  
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
            
        }catch (Exception ex) {
            Logger.getLogger(EspecialidadDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {     
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
         }
          
        
        
    }

    @Override
    public void actualizar(Especialidad es) {
        
        
        
        Connection con = null;
        PreparedStatement pst = null;
        
        try {
            con = conexion.getConexion();
           pst = con.prepareStatement("UPDATE especialidades SET nombre_especialidad=? where id_especialidad=?");
            pst.setString(1,es.getNombre());
            pst.setInt(2,es.getId());
            pst.executeUpdate();
  
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
            
        }catch (Exception ex) {
            Logger.getLogger(EspecialidadDAO.class.getName()).log(Level.SEVERE, null, ex);
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
            pst = con.prepareStatement("delete from especialidades where id_especialidad=?");
            pst.setString(1,String.valueOf(id));
            pst.executeUpdate();
  
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
            
        }catch (Exception ex) {
            Logger.getLogger(EspecialidadDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {     
        try { if (pst != null) pst.close(); } catch (SQLException e) {}
        try { if (con != null) con.close(); } catch (SQLException e) {}
         }
        
        
        
    }

    @Override
    public Especialidad enviarDatosID(int id) {
        
        
             Especialidad es = new Especialidad();
            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
        
         try {
              con = conexion.getConexion();
         
             pst = con.prepareStatement("SELECT * FROM especialidades where id_especialidad =?");
             pst.setInt(1,id);
             rs = pst.executeQuery();
             
             if(rs.next()){
                  es.setId(rs.getInt("id_especialidad"));
                  es.setNombre(rs.getString("nombre_especialidad"));
             }
                     
         } catch (Exception ex) {
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
         } 
         
         return es;    
         
    }

    
    
    @Override
    public List<Especialidad> listarTodos(String nombre) {
        
        
        List<Especialidad> especialidades = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        // Consulta base
        String sql = "SELECT * FROM especialidades";

        // Agregar filtros si se proporciona texto de búsqueda
        if (nombre != null && !nombre.trim().isEmpty()) {
            sql += " WHERE nombre_especialidad LIKE ?";
        }

        try {
            con = conexion.getConexion();
            pst = con.prepareStatement(sql);

            if (nombre != null && !nombre.trim().isEmpty()) {
                String filtro = "%" + nombre + "%";
                pst.setString(1, filtro);
            }

            rs = pst.executeQuery();
            while (rs.next()) {
                Especialidad e = new Especialidad();
                e.setId(rs.getInt("id_especialidad"));
                e.setNombre(rs.getString("nombre_especialidad"));
                especialidades.add(e);
            }

        } catch (SQLException e) {
            System.out.println("Error en listarTodosEspecialidades: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(EspecialidadDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
         } 

        return especialidades;
        
        
    }

 
}
