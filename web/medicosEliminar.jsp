
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");

    Connection con;
    PreparedStatement pst;
    ResultSet rs;

    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost/clinica?useSSL=false", "root", "");

    pst = con.prepareStatement("delete from medicos where id_medico =?");
    pst.setString(1, id);
    pst.executeUpdate();
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
