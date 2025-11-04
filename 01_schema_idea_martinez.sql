-- ===========================================
-- 01_schema_idea_martinez.sql
-- Creación de la base de datos y estructura de tablas
-- ===========================================

DROP DATABASE IF EXISTS idea_martinez;
CREATE DATABASE idea_martinez CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE idea_martinez;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE clientes (
  id_cliente   INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  apellido     VARCHAR(100),
  email        VARCHAR(150),
  activo       BOOLEAN DEFAULT TRUE,
  fecha_alta   DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_clientes_email UNIQUE (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE productos (
  id_producto  INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(150) NOT NULL,
  precio_venta DECIMAL(12,2) DEFAULT 0,
  activo       BOOLEAN DEFAULT TRUE,
  fecha_alta   DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pedidos (
  id_pedido     INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente    INT NOT NULL,
  fecha_pedido  DATETIME DEFAULT CURRENT_TIMESTAMP,
  estado        VARCHAR(30) DEFAULT 'nuevo',
  total         DECIMAL(14,2) DEFAULT 0,
  CONSTRAINT fk_pedidos_cliente
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pedido_items (
  id_item         INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido       INT NOT NULL,
  id_producto     INT NOT NULL,
  cantidad        DECIMAL(12,3) NOT NULL,
  precio_unitario DECIMAL(12,2) NOT NULL,
  subtotal        DECIMAL(14,2) NOT NULL,
  CONSTRAINT fk_pi_pedido
    FOREIGN KEY (id_pedido)   REFERENCES pedidos(id_pedido)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pi_producto
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_pedido_items_pedido   ON pedido_items(id_pedido);
CREATE INDEX idx_pedido_items_producto ON pedido_items(id_producto);

CREATE TABLE facturas (
  id_factura      INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido       INT NOT NULL,
  fecha_emision   DATETIME DEFAULT CURRENT_TIMESTAMP,
  tipo_comprobante VARCHAR(30),
  total           DECIMAL(14,2) DEFAULT 0,
  CONSTRAINT fk_facturas_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pagos (
  id_pago      INT AUTO_INCREMENT PRIMARY KEY,
  id_factura   INT NOT NULL,
  fecha_pago   DATETIME DEFAULT CURRENT_TIMESTAMP,
  metodo_pago  VARCHAR(50),
  monto        DECIMAL(14,2) NOT NULL,
  CONSTRAINT fk_pagos_factura
    FOREIGN KEY (id_factura) REFERENCES facturas(id_factura)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
