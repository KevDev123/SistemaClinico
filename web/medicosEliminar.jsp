
<%@page import="dao.MedicoDAO"%>
<%@page import="interfaces.IConexion"%>
<%@page import="model.ConexionBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");

    IConexion con = new ConexionBD();
    MedicoDAO medico = new MedicoDAO(con);
    medico.eliminar(Integer.parseInt(id));
    
    
%>
<script>
    alert("Medico eliminado");
    window.location.href = "medicos.jsp";
</script>    
<!DOCTYPE html>
<html>
    <head>
        <title>Eliminar Medico</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
    </body>
</html>
