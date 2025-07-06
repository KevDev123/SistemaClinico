
<%@page import="dao.ConsultaDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    String idPaciente = request.getParameter("id_Paciente");

   IConexion con = new ConexionBD();
   ConsultaDAO dao = new ConsultaDAO(con);
   
   dao.eliminar(Integer.parseInt(id));
%>
<script>
    alert("Consulta eliminada");
    window.location.href = "consultas.jsp?id_paciente=<%= idPaciente %>";
</script>    
<!DOCTYPE html>
<html>
    <head>
        <title>Eliminar Consulta</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
    </body>
</html>
