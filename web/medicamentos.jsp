
<%@page import="model.Medicamento"%>
<%@page import="java.util.List"%>
<%@page import="dao.MedicamentoDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestión de Medicamentos</title>
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
                <h5>Listado de Medicamentos</h5>
                <div>
                    <a href="medicamentosCRUD.jsp?accion=nuevo" class="btn btn-success me-2">
                        <i class="bi bi-plus-circle"></i> Nuevo Medicamento
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
                                <th>Vía de Transmisión</th>
                                <th>Fecha Vencimiento</th>
                                <th>Cantidad Disponible</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                      
                                 String buscarTerm = request.getParameter("buscar");
                                IConexion c = new ConexionBD();
                                MedicamentoDAO dao = new MedicamentoDAO(c);
                                List<Medicamento> lista = dao.listarTodos(buscarTerm);
                                

                                    if (lista.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    No se encontraron medicamentos que coincidan con "<%= buscarTerm%>"
                                    <br>
                                    <a href="medicamentos.jsp" class="btn btn-sm btn-outline-primary mt-2">Mostrar todos</a>
                                </td>
                            </tr>
                            <%
                            } else {
                                for(Medicamento me : lista){
                            %>
                            <tr>
                                <td><%= me.getId()%></td>
                                <td><%= me.getNombre()%></td>
                                <td><%= me.getViaTransmision()%></td>
                                <td><%= me.getFecha()%></td>
                                <td><%= me.getCantidad()%></td>
                                <td class="action-buttons">
                                    <a href="medicamentosCRUD.jsp?accion=editar&id=<%= me.getId()%>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar Medicamento">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="medicamentosEliminar.jsp?accion=eliminar&id=<%= me.getId()%>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Medicamento" 
                                       onclick="return confirm('¿Está seguro de eliminar este medicamento?')">
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