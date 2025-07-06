
<%@page import="dao.ConsultaDAO"%>
<%@page import="model.Consulta"%>
<%@page import="java.util.List"%>
<%@page import="interfaces.IListableIdDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Historial de Consultas</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5>Historial de Consultas del Paciente</h5>
                <div>
                    <%
                        String id_paciente = request.getParameter("id_paciente");
                    %>

                    <a href="consultasCRUD.jsp?accion=nuevo&id_paciente=<%= id_paciente%>" class="btn btn-success me-2">
                        <i class="bi bi-plus-circle"></i> Agregar consulta
                    </a>
                    <a href="pacientes.jsp" class="btn">
                        <i class="bi bi-arrow-left"></i> Regresar
                    </a>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID Consulta</th>
                                <th>Paciente</th>
                                <th>Médico</th>
                                <th>Fecha</th>
                                <th>Observaciones</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                           
                                String idPaciente = request.getParameter("id_paciente");
                                IConexion con = new ConexionBD();
                                IListableIdDAO consulta = new ConsultaDAO(con);
                                List<Consulta> lista = consulta.listarporID(Integer.parseInt(idPaciente));
                               
                                    if (lista.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">
                                    No se encontraron consultas para este paciente
                                </td>
                            </tr>
                            <%
                            } else {
                                for(Consulta co : lista){
                            %>
                            <tr>
                                <td><%= co.getId()%></td>
                                <td><%= co.getNombrePaciente()%></td>
                                <td><%= co.getNombreMedico()%></td>
                                <td><%= co.getFecha()%></td>
                                <td><%= co.getObservaciones() != null ? co.getObservaciones() : "-"%></td>
                                <td class="action-buttons">
                                    <a href="consultasCRUD.jsp?accion=editar&id=<%= co.getId()%>" 
                                       class="btn btn-sm"
                                       style="color: green;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Editar consulta">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="consultasEliminar.jsp?accion=eliminar&id=<%= co.getId()%>&id_Paciente=<%= id_paciente%>" 
                                       class="btn btn-sm"
                                       style="color: red;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Eliminar Médico" 
                                       onclick="return confirm('¿Está seguro de eliminar esta consulta?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                    <a href="recetasCRUD.jsp?accion=nuevo&idConsulta=<%= co.getId()%>" 
                                       class="btn btn-sm"
                                       style="color: #17a2b8;"
                                       data-bs-toggle="tooltip" 
                                       data-bs-placement="top" 
                                       title="Agregar Receta">
                                        <i class="bi bi-capsule-pill"></i>
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