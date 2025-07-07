/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import dao.RecetaDAO;
import interfaces.IConexion;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ConexionBD;
import model.Receta;

@WebServlet("/RecetaServlet")
public class RecetaServlet extends HttpServlet{
        protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException{
         
          //Obtiene el id enviado por el formulario "pacientes.jsp"
        String idStr = request.getParameter("id");
        
        //variable booleano que guarda si se recibio un id true o no false
        boolean esEditar = idStr != null && !idStr.isEmpty();
         
         
        Receta receta = new Receta();
         
        receta.setIdConsulta(Integer.parseInt(request.getParameter("idConsulta")));
        receta.setIdMedicamento(Integer.parseInt(request.getParameter("idMedicamento")));
        receta.setCantidad(Integer.parseInt(request.getParameter("cantidad")));
         
         
         try{
            IConexion c = new ConexionBD();
            RecetaDAO dao = new RecetaDAO(c);
        
          if(esEditar){
            receta.setId(Integer.parseInt(idStr));
            dao.actualizar(receta);
        }else{
              dao.guardar(receta);
          }
          
           //mensaje a ser enviado a la pagina para verifacion de ejecucion sql realizada correctamente
            String mensaje = esEditar ? "Receta actualizada correctamente" : "Receta guardada correctamente";
            response.sendRedirect("recetas.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));
        
        }catch(Exception e){
             request.setAttribute("error", e.getMessage());
             request.getRequestDispatcher("error.jsp").forward(request, response);
        }
     }

}
