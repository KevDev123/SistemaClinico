/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import model.Paciente;
import dao.PacienteDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
            PacienteDAO dao = new PacienteDAO();
            if (esEditar) {
                dao.actualizar(paciente);
            } else {
                dao.guardar(paciente);
            }
            response.sendRedirect("pacientes.jsp");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
