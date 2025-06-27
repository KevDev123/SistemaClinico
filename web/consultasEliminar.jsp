
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    String idPaciente = request.getParameter("id_Paciente");

    Connection con;
    PreparedStatement pst;
    ResultSet rs;

    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

    pst = con.prepareStatement("delete from consultas where id_consulta=?");
    pst.setString(1, id);
    pst.executeUpdate();
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
