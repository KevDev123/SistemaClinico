/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import dao.MedicamentoDAO;
import interfaces.IConexion;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ConexionBD;
import model.Medicamento;

/**
 *
 * @author Hello
 */
@WebServlet("/MedicamentoServlet")
public class MedicamentoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException{
        
         //Obtiene el id enviado por el formulario "pacientes.jsp"
        String idStr = request.getParameter("id");
        
        //variable booleano que guarda si se recibio un id true o no false
        boolean esEditar = idStr != null && !idStr.isEmpty();
        
        Medicamento medicamento = new Medicamento();
        
        medicamento.setNombre(request.getParameter("nombre"));
        medicamento.setViaTransmision(request.getParameter("viaTransmision"));
        medicamento.setFecha(request.getParameter("fechaVencimiento"));
        medicamento.setCantidad(Integer.parseInt(request.getParameter("cantidadDisponible")));
        
        
        try{
            IConexion c = new ConexionBD();
            MedicamentoDAO me = new MedicamentoDAO(c);
            
            if(esEditar){
                medicamento.setId(Integer.parseInt(idStr));
                me.actualizar(medicamento);
            }else{
                me.guardar(medicamento);
            }
            
            
             //mensaje a ser enviado a la pagina para verifacion de ejecucion sql realizada correctamente
            String mensaje = esEditar ? "Medicamento actualizado correctamente" : "Medicamento guardado correctamente";
            response.sendRedirect("medicamentos.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));

            
        }catch(Exception e){
             request.setAttribute("error", e.getMessage());
             request.getRequestDispatcher("error.jsp").forward(request, response);
        }
        
    }
    
    
    
    
    
}
