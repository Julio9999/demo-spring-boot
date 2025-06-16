package com.julio.apirest.apirest.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.julio.apirest.apirest.Entities.Producto;

public interface ProductoRepository extends JpaRepository<Producto, Long> {


}
