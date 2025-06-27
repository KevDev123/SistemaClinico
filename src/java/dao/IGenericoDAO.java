/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import java.util.List;

/**
 *
 * @author Hello
 */
public interface IGenericoDAO<T>{
    void guardar(T entidad);
    void actualizar(T entidad);
    void eliminar(int id);
    List<T> listarTodos(String nombre);
}
