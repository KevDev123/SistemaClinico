
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/bootstrap.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-3">
            <div class="container-fluid">
                <div class="d-flex align-items-center">
                    <img src="img/Logo.png" style="height: 60px; width: auto;" class="me-3">
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav">
                            <li class="nav-item">
                                <a class="nav-link" href="inicio.jsp">Inicio</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="pacientes.jsp">Pacientes</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="medicos.jsp">Medicos</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="recetas.jsp">Recetas</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="medicamentos.jsp">Medicamentos</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="especialidades.jsp">Especialidades</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>
    </body>
</html>
