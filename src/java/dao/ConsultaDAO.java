/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import interfaces.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Consulta;
import model.Medicamento;
import model.MedicoSelect;

/**
 *
 * @author Hello
 */
public class ConsultaDAO implements IActualizableDAO<Consulta>,IEliminableDAO<Consulta>,IGuardableDAO<Consulta>,IBuscablePorIdDAO<Consulta>,IListableIdDAO<Consulta>{

    private final IConexion conexion;

    public ConsultaDAO(IConexion conexion) {
        this.conexion = conexion;
    }
    
    
    
    
    
    @Override
    public void guardar(Consulta co) {
      
        try{
            
            Connection con = conexion.getConexion();
            PreparedStatement pst = null;
            
            pst = con.prepareStatement("INSERT INTO consultas(id_paciente,id_medico,fecha_consulta,observaciones) VALUES (?,?,?,?)");
            pst.setInt(1, co.getIdPaciente());
            pst.setInt(2, co.getIdMedico());
            pst.setString(3,co.getFecha());
            pst.setString(4,co.getObservaciones());
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }

    @Override
    public void actualizar(Consulta co) {
        
        try{
            
            Connection con = conexion.getConexion();
            PreparedStatement pst = null;
            
            pst = con.prepareStatement("update consultas set id_paciente=?,id_medico=?,fecha_consulta=?,observaciones=? where id_consulta=?");
            pst.setInt(1, co.getIdPaciente());
            pst.setInt(2, co.getIdMedico());
            pst.setString(3, co.getFecha());
            pst.setString(4, co.getObservaciones());
            pst.setInt(5, co.getId());
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }

    @Override
    public void eliminar(int id) {
      
        try{
            
            Connection con = conexion.getConexion();
            PreparedStatement pst = null;
            
            pst = con.prepareStatement("delete from consultas where id_consulta=?");
            pst.setString(1,String.valueOf(id));
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        
    }

        @Override
        public Consulta enviarDatosID(int id) {
            Consulta consulta = new Consulta();

            String sql = "SELECT c.id_consulta, c.id_paciente, "
                       + "CONCAT(p.nombre_paciente, ' ', p.apellido_paciente) AS paciente, "
                       + "c.id_medico, c.fecha_consulta, c.observaciones "
                       + "FROM consultas c "
                       + "INNER JOIN pacientes p ON c.id_paciente = p.id_paciente "
                       + "WHERE c.id_consulta = ?";

            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                con = conexion.getConexion();
                pst = con.prepareStatement(sql);
                pst.setInt(1, id);
                rs = pst.executeQuery();

                if (rs.next()) {
                    consulta = new Consulta();
                    consulta.setId(rs.getInt("id_consulta"));
                    consulta.setIdPaciente(rs.getInt("id_paciente"));
                    consulta.setNombrePaciente(rs.getString("paciente"));
                    consulta.setIdMedico(rs.getInt("id_medico"));
                    consulta.setFecha(rs.getString("fecha_consulta"));
                    consulta.setObservaciones(rs.getString("observaciones"));
                }

            } catch (SQLException e) {
                System.out.println("Error al obtener datos de la consulta por ID.");
                e.printStackTrace();
            } catch (Exception ex) {
                Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
            } 

            return consulta;
        }


    @Override
    public List<Consulta> listarporID(int id) {
        
        List<Consulta> consulta = new ArrayList<>();
        
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
       
         String sql = "SELECT c.id_consulta, "
                                            + "CONCAT(p.nombre_paciente, ' ', p.apellido_paciente) AS paciente, "
                                            + "CONCAT(m.nombre_medico, ' ', m.apellido_medico) AS medico, "
                                            + "c.fecha_consulta, c.observaciones "
                                            + "FROM consultas c "
                                            + "INNER JOIN pacientes p ON c.id_paciente = p.id_paciente "
                                            + "INNER JOIN medicos m ON c.id_medico = m.id_medico "
                                            + "WHERE c.id_paciente = ?";
        
        try{
            
             con = conexion.getConexion();
             pst = con.prepareStatement(sql);      
             pst.setInt(1, id);
            rs = pst.executeQuery();
            
            while(rs.next()){
                   
                Consulta co = new Consulta();
                 
                co.setId(rs.getInt("id_consulta"));
                co.setNombrePaciente(rs.getString("paciente"));
                co.setNombreMedico(rs.getString("medico"));
                co.setFecha(rs.getString("fecha_consulta"));
                co.setObservaciones(rs.getString("observaciones"));
                
                consulta.add(co);
                
            }
                                
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
         return consulta;
        
    }
        
    
    
    public List<MedicoSelect> obtenerMedicosParaSelect()  {
    List<MedicoSelect> lista = new ArrayList<>();
    
    String sql = "SELECT id_medico, CONCAT(nombre_medico, ' ', apellido_medico) AS nombre_completo FROM medicos ORDER BY nombre_medico";
    
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

    try{
         con = conexion.getConexion();
          pst = con.prepareStatement(sql);
          rs = pst.executeQuery();

        while (rs.next()) {
            MedicoSelect me = new MedicoSelect();
            me.setId(rs.getInt("id_medico"));
           me.setNombreCompleto(rs.getString("nombre_completo"));
           
           lista.add(me);
           
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }catch (Exception ex) {
            Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    return lista;
}
    
    
    public String obtenerNombrePacientePorId(int idPaciente) {
    String nombreCompleto = "Paciente no encontrado";

    String sql = "SELECT CONCAT(nombre_paciente, ' ', apellido_paciente) AS nombre_completo " +
                 "FROM pacientes WHERE id_paciente = ?";

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        con = conexion.getConexion();
        pst = con.prepareStatement(sql);
        pst.setInt(1, idPaciente);
        rs = pst.executeQuery();

        if (rs.next()) {
            nombreCompleto = rs.getString("nombre_completo");
        }
    } catch (SQLException e) {
        System.out.println("Error al obtener el nombre del paciente.");
        e.printStackTrace();
    } catch (Exception ex) {
        Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (pst != null) pst.close(); } catch (SQLException e) {}
        try { if (con != null) con.close(); } catch (SQLException e) {}
    }

    return nombreCompleto;
}

    
    
}
