/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import interfaces.IConexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.MedicamentoSelect;


public class UtilDAO {
    
      private final IConexion conexion;

    public UtilDAO(IConexion conexion) {
        this.conexion = conexion;
    }
    
     public String obtenerNombrePacientePorId(int idPaciente) {
        return obtenerNombrePorId(
            "SELECT CONCAT(nombre_paciente, ' ', apellido_paciente) AS nombre_completo FROM pacientes WHERE id_paciente = ?",
            idPaciente
        );
    }

    public String obtenerNombreMedicoPorId(int idMedico) {
        return obtenerNombrePorId(
            "SELECT CONCAT(nombre_medico, ' ', apellido_medico) AS nombre_completo FROM medicos WHERE id_medico = ?",
            idMedico
        );
    }

    
     public List<MedicamentoSelect> obtenerMedicamentosParaSelect() {
            List<MedicamentoSelect> lista = new ArrayList<>();

            String sql = "SELECT id_medicamento, nombre_medicamento FROM medicamentos ORDER BY nombre_medicamento";

            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                con = conexion.getConexion();
                pst = con.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    MedicamentoSelect med = new MedicamentoSelect();
                    med.setId(rs.getInt("id_medicamento"));
                    med.setNombreMedicamento(rs.getString("nombre_medicamento"));

                    lista.add(med);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } catch (Exception ex) {
                Logger.getLogger(ConsultaDAO.class.getName()).log(Level.SEVERE, null, ex);
            }

            return lista;
        }
    
    
    
    
    
    
    
    
    private String obtenerNombrePorId(String sql, int id) {
        String nombreCompleto = "No encontrado";

        try (Connection con = conexion.getConexion();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                nombreCompleto = rs.getString("nombre_completo");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener nombre: " + e.getMessage());
        } catch (Exception ex) {
            Logger.getLogger(UtilDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return nombreCompleto;
    }
    
    
}
