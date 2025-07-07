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
import model.MedicamentoSelect;
import model.Receta;

/**
 *
 * @author Hello
 */
public class RecetaDAO implements IGenericoDAO<Receta>{
    
    private final IConexion conexion; 

    public RecetaDAO(IConexion conexion) {
        this.conexion = conexion;
    }
   
    
    @Override
    public void guardar(Receta re) {
        
        Connection con = null;
        PreparedStatement pst = null;
        
        
       try{
            
             con = conexion.getConexion();      
            
            pst = con.prepareStatement("INSERT INTO recetas(id_consulta,id_medicamento,cantidad) VALUES (?,?,?)");
            pst.setInt(1, re.getIdConsulta());
            pst.setInt(2, re.getIdMedicamento());
            pst.setInt(3, re.getCantidad());
           
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {     
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
         }  
       
       
    }

    @Override
    public void actualizar(Receta re) {
        
        
            Connection con = null;
            PreparedStatement pst = null;
            
        try{
            
            con = conexion.getConexion();       
            
            pst = con.prepareStatement("update recetas set id_consulta=?,id_medicamento=?,cantidad=? where id_receta=?");
            pst.setInt(1, re.getIdConsulta());
            pst.setInt(2, re.getIdMedicamento());
            pst.setInt(3, re.getCantidad());
            pst.setInt(4, re.getId());
           
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
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
            
            pst = con.prepareStatement("delete from recetas where id_receta=?");
            pst.setInt(1,id);
           
            pst.executeUpdate();
                       
        }catch(SQLException e){
            System.out.println("Error al conectar a la base de datos.");
            e.printStackTrace();
        } catch (Exception ex) {
            Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
        }finally {     
            try { if (pst != null) pst.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
         }  
      
      
    }

    @Override
    public Receta enviarDatosID(int id) {
       
        
         Receta r = new Receta();
          Connection con = null;
          PreparedStatement pst = null;
          ResultSet rs = null;
        
         try{
            
             con = conexion.getConexion();
            
            pst = con.prepareStatement("select * from recetas where id_receta=?");
            pst.setString(1,String.valueOf(id));
            rs = pst.executeQuery();
            
            if(rs.next()){
                r.setId(rs.getInt("id_receta"));
                r.setIdConsulta(rs.getInt("id_consulta"));
                r.setIdMedicamento(rs.getInt("id_medicamento"));
                r.setCantidad(rs.getInt("cantidad"));
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
         
        
     return r;
        
        
    }

        @Override
      public List<Receta> listarTodos(String nombre) {
               List<Receta> lista = new ArrayList<>();
              Connection con = null;
              PreparedStatement pst = null;
              ResultSet rs = null;

          String sql = "SELECT r.id_receta, r.id_consulta, "
                     + "CONCAT(p.nombre_paciente, ' ', p.apellido_paciente) AS nombre_completo_paciente, "
                     + "CONCAT(m.nombre_medico, ' ', m.apellido_medico) AS nombre_completo_medico, "
                     + "med.nombre_medicamento, r.cantidad "
                     + "FROM recetas r "
                     + "INNER JOIN consultas c ON r.id_consulta = c.id_consulta "
                     + "INNER JOIN pacientes p ON c.id_paciente = p.id_paciente "
                     + "INNER JOIN medicos m ON c.id_medico = m.id_medico "
                     + "INNER JOIN medicamentos med ON r.id_medicamento = med.id_medicamento ";

          if (nombre != null && !nombre.trim().isEmpty()) {
              sql += "WHERE p.nombre_paciente LIKE ? "
                   + "OR p.apellido_paciente LIKE ? "
                   + "OR m.nombre_medico LIKE ? "
                   + "OR m.apellido_medico LIKE ? "
                   + "OR med.nombre_medicamento LIKE ? ";
          }


          try {
                  con = conexion.getConexion();
                  pst = con.prepareStatement(sql);

                  if (nombre != null && !nombre.trim().isEmpty()) {
                       String filtro = "%" + nombre + "%";
                       for (int i = 1; i <= 5; i++) {
                           pst.setString(i, filtro);
                       }
                   }

                  rs = pst.executeQuery();
                  while (rs.next()) {
                      Receta r = new Receta();
                      r.setId(rs.getInt("id_receta"));
                      r.setIdConsulta(rs.getInt("id_consulta"));
                      r.setNombrePaciente(rs.getString("nombre_completo_paciente"));
                      r.setNombreMedico(rs.getString("nombre_completo_medico"));
                      r.setNombreMedicamento(rs.getString("nombre_medicamento"));
                      r.setCantidad(rs.getInt("cantidad"));
                      lista.add(r);
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


          return lista;
      }

           
            
            
         

}
