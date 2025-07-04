
<%@page import="model.Especialidad"%>
<%@page import="dao.EspecialidadDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    // Cargar datos si es modificación
    String nombreMod = "";


    
    // Variables para modo edición
    boolean isEdit = false;
    int idEspecialidad = 0;
    IConexion con = new ConexionBD();
    EspecialidadDAO dao = new EspecialidadDAO(con);
       
    
    
    if (request.getParameter("id") != null) {
        isEdit = true;
        idEspecialidad = Integer.parseInt(request.getParameter("id"));
         Especialidad es = dao.enviarDatosID(idEspecialidad);
         
            //Cargar datos si es modificacion 
        nombreMod = es.getNombre();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= isEdit ? "Editar" : "Agregar"%> Especialidad</title>
    </head>
    <body class="bg-secondary">
        <%@include file="header.jsp" %>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0"><%= isEdit ? "Editar Especialidad Médica" : "Nueva Especialidad Médica"%></h4>
                        </div>
                        <div class="card-body">
                            <form method="post" action="EspecialidadServlet">
                                <% if (isEdit) {%>
                                <input type="hidden" name="id" value="<%= idEspecialidad%>">
                                <% }%>

                                <div class="mb-3">
                                    <label for="nombreEspecialidad" class="form-label">Nombre de la Especialidad</label>
                                    <input type="text" class="form-control" id="nombreEspecialidad" name="nombreEspecialidad" 
                                           value="<%= nombreMod%>" required
                                           placeholder="Ej: Cardiología, Pediatría, etc.">
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="especialidades.jsp" class="btn btn-danger">Cancelar</a>
                                    <button type="submit" name="submit" class="btn btn-success">
                                        <%= isEdit ? "Actualizar" : "Agregar"%>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>