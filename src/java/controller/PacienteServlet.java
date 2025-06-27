/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import model.Paciente;
import dao.PacienteDAO;
import interfaces.IConexion;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ConexionBD;

@WebServlet("/PacienteServlet")
public class PacienteServlet extends HttpServlet {
    
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        boolean esEditar = idStr != null && !idStr.isEmpty();

        Paciente paciente = new Paciente();
        if (esEditar) {
            paciente.setId(Integer.parseInt(idStr));
        }
        paciente.setNombre(request.getParameter("nombre"));
        paciente.setApellido(request.getParameter("apellido"));
        paciente.setFechaNacimiento(request.getParameter("fechaNacimiento"));
        paciente.setGenero(request.getParameter("genero"));
        paciente.setDireccion(request.getParameter("direccion"));
        paciente.setTelefono(request.getParameter("telefono"));
        paciente.setDetalles(request.getParameter("detalles"));

        try {
            IConexion c = new ConexionBD();
            PacienteDAO dao = new PacienteDAO(c);
            if (esEditar) {
                dao.actualizar(paciente);
            } else {
                dao.guardar(paciente);
            }
           String mensaje = esEditar ? "Paciente actualizado correctamente" : "Paciente guardado correctamente";
            response.sendRedirect("pacientes.jsp?msg=" + URLEncoder.encode(mensaje, "UTF-8"));


        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
