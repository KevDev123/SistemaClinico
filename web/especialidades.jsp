
<%@page import="model.Especialidad"%>
<%@page import="java.util.List"%>
<%@page import="dao.EspecialidadDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Especialidades</title>
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
                <h5>Listado de Especialidades</h5>
                <div>
                    <a href="especialidadesCRUD.jsp?accion=nuevo" class="btn btn-success me-2">
                        <i class="bi bi-plus-circle"></i> Nueva Especialidad
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
                                <th>Nombre de Especialidad</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                        String buscarTerm = request.getParameter("buscar");
                                        IConexion c = new ConexionBD();
                                        EspecialidadDAO especialidadDAO = new EspecialidadDAO(c);
                                       List<Especialidad> lista = especialidadDAO.listarTodos(buscarTerm);
                                    if (lista.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="3" class="text-center text-muted py-4">
                                    No se encontraron especialidades que coincidan con "<%= buscarTerm%>"
                                    <br>
                                    <a href="especialidades.jsp" class="btn btn-sm btn-outline-primary mt-2">Mostrar todos</a>
                                </td>
                            </tr>
                            <%
                            }else{
                               for(Especialidad es : lista){
                            %>
                            <tr>
                                <td><%= es.getId() %></td>
                                <td><%= es.getNombre() %></td>
                                <td class="action-buttons">
                                    <a href="especialidadesCRUD.jsp?accion=editar&id=<%= es.getId() %>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar Especialidad">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="especialidadesEliminar.jsp?accion=eliminar&id=<%= es.getId() %>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Especialidad" 
                                       onclick="return confirm('¿Está seguro de eliminar esta especialidad?')">
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