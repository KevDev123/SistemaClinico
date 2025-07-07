package dao;

import interfaces.IConexion;
import interfaces.IGenericoDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Medicamento;

/**
 *
 * @author Hello
 */
public class MedicamentoDAO implements IGenericoDAO<Medicamento>{

 
    
    protected final IConexion conexion;
       
    
    public MedicamentoDAO(IConexion conexion) {
        this.conexion = conexion;
    }
     

    @Override
    public void guardar(Medicamento me) {
        
        
            Connection con = null;
            PreparedStatement pst = null;
      
        try{
            
             con = conexion.getConexion();
            
            pst = con.prepareStatement("INSERT INTO medicamentos(nombre_medicamento,via_transmision,fecha_vencimiento,cantidad_disponible) VALUES (?,?,?,?)");
            pst.setString(1, me.getNombre());
            pst.setString(2, me.getViaTransmision());
            pst.setString(3, me.getFecha());
            pst.setInt(4, me.getCantidad());
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(MedicamentoDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {     
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
         }
        
        
        
    }

    @Override
    public void actualizar(Medicamento me) {
        
        
            Connection con = null;
            PreparedStatement pst = null;
       
         try{
            
            con = conexion.getConexion();
            
            pst = con.prepareStatement("update medicamentos set nombre_medicamento=?,via_transmision=?,fecha_vencimiento=?,cantidad_disponible=? where id_medicamento=?");
            pst.setString(1, me.getNombre());
            pst.setString(2, me.getViaTransmision());
            pst.setString(3, me.getFecha());
            pst.setInt(4, me.getCantidad());
            pst.setInt(5,me.getId());
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(MedicamentoDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {     
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
         
        
    }

    @Override
    public void eliminar(int id) {
        
        
            Connection con = null;
            PreparedStatement pst = null;
        
       try{
            
             con = conexion.getConexion();
            
            pst = con.prepareStatement("delete from medicamentos where id_medicamento=?");
            pst.setString(1,String.valueOf(id));
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(MedicamentoDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {     
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
         }
       
       
    }

    @Override
    public Medicamento enviarDatosID(int id) {
        
        Medicamento medicamento = new Medicamento();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        
         try{
            
             con = conexion.getConexion();

            
            pst = con.prepareStatement("select * from medicamentos where id_medicamento=?");
            pst.setString(1,String.valueOf(id));
            rs = pst.executeQuery();
            
            if(rs.next()){
                medicamento.setId(rs.getInt("id_medicamento"));
                medicamento.setNombre(rs.getString("nombre_medicamento"));
                medicamento.setViaTransmision(rs.getString("via_transmision"));
                medicamento.setFecha(rs.getString("fecha_vencimiento"));
                medicamento.setCantidad(rs.getInt("cantidad_disponible"));
            }
                                
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(MedicamentoDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        } 
         
        
         return medicamento;
         
        
    }

    @Override
    public List<Medicamento> listarTodos(String nombre) {
        
        List<Medicamento> medicamento = new ArrayList<>();
        
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        // Consulta base
        String sql = "SELECT * FROM medicamentos";

        // Agregar filtros si se proporciona texto de búsqueda
        if (nombre != null && !nombre.trim().isEmpty()) {
            sql += " WHERE nombre_medicamento LIKE ?"
                + " OR via_transmision LIKE ?";
        }

         try{
            
             con = conexion.getConexion();
             pst = con.prepareStatement(sql); 
             
            // Si hay filtro, establecer los parámetros con %palabra%
             if (nombre != null && !nombre.trim().isEmpty()) {
                 String filtro = "%" + nombre + "%";
                 for (int i = 1; i <= 2; i++) {
                     pst.setString(i, filtro);
                 }
             }
             
             
            rs = pst.executeQuery();
            
            while(rs.next()){
                Medicamento med = new Medicamento();
                
                med.setId(rs.getInt("id_medicamento"));
                med.setNombre(rs.getString("nombre_medicamento"));
                med.setViaTransmision(rs.getString("via_transmision"));
                med.setFecha(rs.getString("fecha_vencimiento"));
                med.setCantidad(rs.getInt("cantidad_disponible"));
                
                medicamento.add(med);
                
            }
                                
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(MedicamentoDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        } 
        
         return medicamento;
         
         
        
    }
 


    
    
    
    
}