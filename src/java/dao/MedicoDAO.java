/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import interfaces.IConexion;
import interfaces.IGenericoDAO;
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
import model.Medico;

/**
 *
 * @author Hello
 */
public class MedicoDAO implements IGenericoDAO<Medico> {
    
     private final IConexion conexion;

    public MedicoDAO(IConexion conexion) {
        this.conexion = conexion;
    }
    

    @Override
    public void guardar(Medico m) {
        
        try{
            
            Connection con = conexion.getConexion();
            PreparedStatement pst;
            pst = null;
        
         pst = con.prepareStatement("INSERT INTO medicos(nombre_medico, apellido_medico, id_especialidad, telefono_medico) VALUES (?,?,?,?)");
        
         pst.setString(1, m.getNombre());
         pst.setString(2, m.getApellido());
         pst.setInt(3, m.getEspecialidad());
         pst.setString(4, m.getTelefono());                  
         pst.executeUpdate();
        
        
        }catch (SQLException e) {
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {  
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }  
        
    }

    @Override
    public void actualizar(Medico m) {
        
        try{           
            Connection con = conexion.getConexion();
            PreparedStatement pst = null;
        
         pst = con.prepareStatement("UPDATE medicos SET nombre_medico=?, apellido_medico=?, id_especialidad=?, telefono_medico=? where id_medico=?");
        
         pst.setString(1, m.getNombre());
         pst.setString(2, m.getApellido());
         pst.setInt(3, m.getEspecialidad());
         pst.setString(4, m.getTelefono());
         pst.setInt(5, m.getId());
         pst.executeUpdate();
        
        
        }catch (SQLException e) {
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {  
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }  
        
        
    }

    @Override
    public void eliminar(int id) {
         try {
             
           Connection con = conexion.getConexion();
            PreparedStatement pst;                 
            pst = con.prepareStatement("delete from medicos where id_medico=?");
            pst.setString(1,String.valueOf(id));
            pst.executeUpdate();
             
         } catch (Exception ex) {
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }
    }

    @Override
    public Medico enviarDatosID(int id) {
        
        Medico m = new Medico();
        
         try {
             Connection con = conexion.getConexion();
             PreparedStatement pst;
             ResultSet rs;
             
             
             pst = con.prepareStatement("SELECT m.*,es.nombre_especialidad FROM medicos m INNER JOIN especialidades es ON es.id_especialidad = m.id_especialidad");
             rs = pst.executeQuery();
             
             while(rs.next()){
                  m.setId(rs.getInt("id_medico"));
                  m.setNombre(rs.getString("nombre_medico"));
                  m.setApellido(rs.getString("apellido_medico"));
                  m.setEspecialidad(rs.getInt("id_especialidad"));
                  m.setTelefono(rs.getString("telefono_medico"));
                  m.setNombreEspecialidad(rs.getString("nombre_especialidad"));
             }
                     
         } catch (Exception ex) {
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }
        System.out.println(m);
         return m;
       
    }

        @Override
    public List<Medico> listarTodos(String nombre) {
        List<Medico> medicos = new ArrayList<>();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

           // Base de la consulta con JOIN
              String sql = "SELECT m.*, es.nombre_especialidad FROM medicos m "
               + "INNER JOIN especialidades es ON es.id_especialidad = m.id_especialidad";

            // Agregar filtros si se proporciona texto de búsqueda
            if (nombre != null && !nombre.trim().isEmpty()) {
                sql += " WHERE m.nombre_medico LIKE ?"
                     + " OR m.apellido_medico LIKE ?"
                     + " OR m.telefono_medico LIKE ?"
                     + " OR es.nombre_especialidad LIKE ?";
            }

        try {
             con = conexion.getConexion();
            pst = con.prepareStatement(sql);

            if (nombre != null && !nombre.trim().isEmpty()) {
                String filtro = "%" + nombre + "%";
                pst.setString(1, filtro);
                pst.setString(2, filtro);
                pst.setString(3, filtro);
                pst.setString(4, filtro);
            }

            rs = pst.executeQuery();
            while (rs.next()) {
                Medico m = new Medico();
                m.setId(rs.getInt("id_medico"));
                m.setNombre(rs.getString("nombre_medico"));
                m.setApellido(rs.getString("apellido_medico"));
                m.setEspecialidad(rs.getInt("id_especialidad"));
                m.setTelefono(rs.getString("telefono_medico"));
                m.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                medicos.add(m);
            }

        } catch (SQLException e) {
            System.out.println("Error en listarTodos (médicos): " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(MedicoDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return medicos;
    }

    
    
    
    public Map<Integer,String> obtenerEspecialidades() {
        
       Map<Integer,String> especialidades = new HashMap<Integer,String>();
        
         try {
             Connection con = conexion.getConexion();
             PreparedStatement pst;
             ResultSet rs;            
             pst = con.prepareStatement("SELECT id_especialidad, nombre_especialidad FROM especialidades ORDER BY nombre_especialidad");
             rs = pst.executeQuery();
      
             while(rs.next()){
                 int id = rs.getInt("id_especialidad");
                 String nombre = rs.getString("nombre_especialidad");
                 especialidades.put(id, nombre);
             }
                     
         } catch (Exception ex) {
             Logger.getLogger(PacienteDAO.class.getName()).log(Level.SEVERE, null, ex);
         }
        
         return especialidades;
       
    }
    
    
    
    
}
