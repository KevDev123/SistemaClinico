/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import dao.MedicoDAO;
import interfaces.IConexion;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ConexionBD;
import model.Medico;


public class MedicoServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException{
        
         //Obtiene el id enviado por el formulario "pacientes.jsp"
        String idStr = request.getParameter("id");
        
        //variable booleano que guarda si se recibio un id true o no false
        boolean esEditar = idStr != null && !idStr.isEmpty();
        
        Medico medico = new Medico();
        
         if (esEditar) {
            medico.setId(Integer.parseInt(idStr));
        }
        medico.setNombre(request.getParameter("nombre"));
        medico.setApellido(request.getParameter("apellido"));
        medico.setEspecialidad(Integer.parseInt(request.getParameter("id_especialidad")));
        medico.setTelefono(request.getParameter("telefono"));
        
        try{
            IConexion c = new ConexionBD();
            MedicoDAO m = new MedicoDAO(c);
            
            if(esEditar){
                m.actualizar(medico);
            }else{
                m.guardar(medico);
            }
            
            
             //mensaje a ser enviado a la pagina para verifacion de ejecucion sql realizada correctamente
            String mensaje = esEditar ? "Medico actualizado correctamente" : "Medico guardado correctamente";
            response.sendRedirect("medicos.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));

            
        }catch(Exception e){
             request.setAttribute("error", e.getMessage());
             request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    
    
    
    
}
