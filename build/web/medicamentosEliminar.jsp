
<%@page import="dao.MedicamentoDAO"%>
<%@page import="model.ConexionBD"%>
<%@page import="interfaces.IConexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");

    IConexion con = new ConexionBD();
    MedicamentoDAO medicamento = new MedicamentoDAO(con);
    medicamento.eliminar(Integer.parseInt(id));
%>
<script>
    alert("Medicamento eliminado");
    window.location.href = "medicamentos.jsp";
</script>    
<!DOCTYPE html>
<html>
    <head>
        <title>Eliminar Medicamento</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
    </body>
</html>
