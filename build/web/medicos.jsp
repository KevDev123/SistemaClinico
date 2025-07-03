
<%@page import="model.Medico"%>
<%@page import="java.util.List"%>
<%@page import="interfaces.IConexion"%>
<%@page import="dao.MedicoDAO"%>
<%@page import="model.ConexionBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Medicos</title>
    </head>
    <body>
          <%
            String msg = request.getParameter("msg");
            if (msg != null) {
        %>
            <script>
                alert("<%= msg %>");
            </script>
            <%
                }
            %>

        <%@include file="header.jsp" %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Listado de Médicos</h5>
                <div>
                    <a href="medicosCRUD.jsp?accion=nuevo" class="btn btn-success me-2">
                        <i class="bi bi-plus-circle"></i> Nuevo Médico
                    </a>
                    <a href="inicio.jsp" class="btn">
                        <i class="bi bi-arrow-left"></i> Regresar
                    </a>
                </div>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-end">
                    <form method="GET" action="" class="input-group" style="width: 33%;">
                        <input type="text" class="form-control" id="buscar" name="buscar" 
                               placeholder="Buscar..." value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
                        <button type="submit" class="btn btn-dark">
                            <i class="bi bi-search"></i>
                        </button>
                    </form>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>Especialidad</th>
                                <th>Teléfono</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                        String buscarTerm = request.getParameter("buscar");
                                        IConexion c = new ConexionBD();
                                       MedicoDAO medicoDAO = new MedicoDAO(c);
                                       List<Medico> lista = medicoDAO.listarTodos(buscarTerm);
                                    if (lista.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">
                                    No se encontraron médicos que coincidan con "<%= buscarTerm%>"
                                    <br>
                                    <a href="medicos.jsp" class="btn btn-sm btn-outline-primary mt-2">Mostrar todos</a>
                                </td>
                            </tr>
                            <%
                            } else {
                                for(Medico m : lista){
                            %>
                            <tr>
                                <td><%= m.getId()%></td>
                                <td><%= m.getNombre()%></td>
                                <td><%= m.getApellido()%></td>
                                <td><%= m.getNombreEspecialidad()%></td>
                                <td><%= m.getTelefono() != null ? m.getTelefono() : "-"%></td>
                                <td class="action-buttons">
                                    <a href="medicosCRUD.jsp?accion=editar&id=<%= m.getId() %>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar Médico">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="medicosEliminar.jsp?accion=eliminar&id=<%= m.getId() %>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Médico" 
                                       onclick="return confirm('¿Está seguro de eliminar este médico?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                              
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </body>
</html>
