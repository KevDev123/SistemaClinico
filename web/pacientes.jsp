
<%@page import="dao.IGenericoDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Paciente"%>
<%@page import="dao.PacienteDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Pacientes</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Listado de Pacientes</h5>
                <div>
                    <a href="pacientesCRUD.jsp?accion=nuevo" class="btn btn-success me-2">
                        <i class="bi bi-plus-circle"></i> Nuevo Paciente
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
                                <th>Apellido</th>
                                <th>Nombre</th>
                                <th>Fecha nacimiento</th>
                                <th>Genero</th>
                                <th>Dirección</th>
                                <th>Teléfono</th>
                                <th>Detalles</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                     String buscarTerm = request.getParameter("buscar");
                                    PacienteDAO pacienteDAO = new PacienteDAO();
                                    List<Paciente> lista = pacienteDAO.listarTodos(buscarTerm);
                                    if (lista.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">
                                    No se encontraron pacientes que coincidan con "<%= buscarTerm%>"
                                    <br>
                                    <a href="pacientes.jsp" class="btn btn-sm btn-outline-primary mt-2">Mostrar todos</a>
                                </td>
                            </tr>
                            <%
                            } else {
                                for(Paciente p : lista){
                            %>
                            <tr>
                                <td><%= p.getId()%></td>
                                <td><%= p.getApellido()%></td>
                                <td><%= p.getNombre()%></td>
                                <td><%= p.getFechaNacimiento()%></td>
                                <td><%= p.getGenero()%></td>
                                <td><%= p.getDireccion()%></td>
                                <td><%= p.getTelefono() != null ? p.getTelefono() : "-"%></td>
                                <td><%= p.getDetalles()%></td>
                                <td class="action-buttons">
                                    <a href="pacientesCRUD.jsp?accion=editar&id=<%= p.getId()%>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar Paciente">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="pacientesEliminar.jsp?accion=eliminar&id=<%= p.getId()%>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Paciente" 
                                       onclick="return confirm('¿Está seguro de eliminar este paciente?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                    <a href="consultas.jsp?id_paciente=<%= p.getId()%>" 
                                       class="btn btn-sm"
                                       style="color: #17a2b8;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Revisar Consultas">
                                        <i class="bi bi-calendar2-check"></i>
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
