/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;


import dao.ConsultaDAO;
import interfaces.IConexion;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ConexionBD;
import model.Consulta;
/**
 *
 * @author Hello
 */

@WebServlet("/ConsultaServlet")
public class ConsultaServlet extends HttpServlet {
    
     protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException{
         
          //Obtiene el id enviado por el formulario "pacientes.jsp"
        String idStr = request.getParameter("id");
        
        //variable booleano que guarda si se recibio un id true o no false
        boolean esEditar = idStr != null && !idStr.isEmpty();
         
         
        Consulta consulta = new Consulta();
         
         consulta.setIdMedico(Integer.parseInt(request.getParameter("idMedico")));
         consulta.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
         consulta.setFecha(request.getParameter("fechaConsulta"));
         consulta.setObservaciones(request.getParameter("observaciones"));
         
         try{
            IConexion c = new ConexionBD();
            ConsultaDAO dao = new ConsultaDAO(c);
        
          if(esEditar){
            consulta.setId(Integer.parseInt(idStr));
            dao.actualizar(consulta);
        }else{
              dao.guardar(consulta);
          }
          
           //mensaje a ser enviado a la pagina para verifacion de ejecucion sql realizada correctamente
            String mensaje = esEditar ? "Consulta actualizada correctamente" : "Consulta guardada correctamente";
            response.sendRedirect("consultas.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8") +"&id_paciente=" + consulta.getIdPaciente());
        
        }catch(Exception e){
             request.setAttribute("error", e.getMessage());
             request.getRequestDispatcher("error.jsp").forward(request, response);
        }
     }
    
    
    
    
    
    
}
