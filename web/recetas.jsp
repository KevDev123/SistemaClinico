
<%@page import="model.Receta"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page import="dao.RecetaDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Recetas</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Listado de Recetas</h5>
                <div>
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
                                <th>ID Receta</th>
                                <th>ID Consulta</th>
                                <th>Paciente</th>
                                <th>Médico</th>
                                <th>Medicamento</th>
                                <th>Cantidad</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                
                                String buscarTerm = request.getParameter("buscar");
                                IConexion con = new ConexionBD();
                                RecetaDAO receta = new RecetaDAO(con);
                                List<Receta> lista = receta.listarTodos(buscarTerm);

                               

                                    if (lista.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">
                                    No se encontraron recetas que coincidan con "<%= buscarTerm%>"
                                    <br>
                                    <a href="recetas.jsp" class="btn btn-sm btn-outline-primary mt-2">Mostrar todos</a>
                                </td>
                            </tr>
                            <%
                            } else {
                                for(Receta re : lista) {
                            %>
                            <tr>
                                <td><%= re.getId()%></td>
                                <td><%= re.getIdConsulta()%></td>
                                <td><%= re.getNombrePaciente()%></td>
                                <td><%= re.getNombreMedico()%></td>
                                <td><%= re.getNombreMedicamento()%></td>
                                <td><%= re.getCantidad()%></td>
                                <td class="action-buttons">
                                    <a href="recetasCRUD.jsp?accion=editar&id=<%= re.getId()%>&idConsulta=<%= re.getIdConsulta()%>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar Receta">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="recetasEliminar.jsp?accion=eliminar&id=<%= re.getId()%>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Receta" 
                                       onclick="return confirm('¿Está seguro de eliminar esta receta?')">
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