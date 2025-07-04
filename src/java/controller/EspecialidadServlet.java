/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import dao.EspecialidadDAO;
import interfaces.IConexion;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ConexionBD;
import model.Especialidad;

/**
 *
 * @author Hello
 */

@WebServlet("/EspecialidadServlet")
public class EspecialidadServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException{
        
        //Obtiene el id enviado por el formulario "pacientes.jsp"
        String idStr = request.getParameter("id");
        
        //variable booleano que guarda si se recibio un id true o no false
        boolean esEditar = idStr != null && !idStr.isEmpty();
        
        
        Especialidad especialidad = new Especialidad();
        
      
        especialidad.setNombre(request.getParameter("nombreEspecialidad"));
        
        try{
        IConexion c = new ConexionBD();
        EspecialidadDAO dao = new EspecialidadDAO(c);
        
          if(esEditar){
            especialidad.setId(Integer.parseInt(idStr));
            dao.actualizar(especialidad);
        }else{
              dao.guardar(especialidad);
          }
          
           //mensaje a ser enviado a la pagina para verifacion de ejecucion sql realizada correctamente
            String mensaje = esEditar ? "Especialidad actualizada correctamente" : "Especialidad guardada correctamente";
            response.sendRedirect("especialidades.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
        
        }catch(Exception e){
             request.setAttribute("error", e.getMessage());
             request.getRequestDispatcher("error.jsp").forward(request, response);
        }
        
    }
    
}
