-- IdeaMartinez.sql
-- Sistema de Gestión de Ventas y Stock
-- Autor: Gabriel Martínez
-- Fecha: 2025-10-07
-- MySQL Workbench compatible (InnoDB + utf8mb4)

-- Crear base de datos
DROP DATABASE IF EXISTS idea_martinez;
CREATE DATABASE idea_martinez CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE idea_martinez;

-- ===========================
-- Tabla: clientes
-- ===========================
CREATE TABLE clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100),
  email VARCHAR(150),
  telefono VARCHAR(50),
  direccion VARCHAR(200),
  ciudad VARCHAR(100),
  provincia VARCHAR(100),
  pais VARCHAR(100),
  fecha_alta DATETIME DEFAULT CURRENT_TIMESTAMP,
  activo BOOLEAN DEFAULT TRUE,
  UNIQUE (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: categorias
-- ===========================
CREATE TABLE categorias (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  padre_id INT,
  FOREIGN KEY (padre_id) REFERENCES categorias(id_categoria) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: proveedores
-- ===========================
CREATE TABLE proveedores (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre_razon VARCHAR(150) NOT NULL,
  contacto VARCHAR(100),
  email VARCHAR(150),
  telefono VARCHAR(50),
  direccion VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: productos
-- ===========================
CREATE TABLE productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  id_categoria INT,
  precio_venta DECIMAL(12,2),
  precio_costo DECIMAL(12,2),
  peso DECIMAL(10,3),
  fecha_alta DATETIME DEFAULT CURRENT_TIMESTAMP,
  activo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: producto_proveedor
-- ===========================
CREATE TABLE producto_proveedor (
  id_prodprov INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT,
  id_proveedor INT,
  precio_ult_compra DECIMAL(12,2),
  tiempo_entrega_dias INT,
  UNIQUE (id_producto, id_proveedor),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,
  FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: inventarios
-- ===========================
CREATE TABLE inventarios (
  id_inventario INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT,
  cantidad DECIMAL(12,3) DEFAULT 0,
  stock_minimo DECIMAL(12,3) DEFAULT 0,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: movimientos_inventario
-- ===========================
CREATE TABLE movimientos_inventario (
  id_mov INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT,
  tipo_mov VARCHAR(20),
  referencia_tipo VARCHAR(50),
  referencia_id INT,
  cantidad DECIMAL(12,3),
  fecha_mov DATETIME DEFAULT CURRENT_TIMESTAMP,
  usuario VARCHAR(100),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: pedidos
-- ===========================
CREATE TABLE pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
  estado VARCHAR(30),
  total DECIMAL(14,2),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: pedido_items
-- ===========================
CREATE TABLE pedido_items (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT,
  id_producto INT,
  cantidad DECIMAL(12,3),
  precio_unitario DECIMAL(12,2),
  descuento DECIMAL(12,2),
  subtotal DECIMAL(14,2),
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: compras
-- ===========================
CREATE TABLE compras (
  id_compra INT AUTO_INCREMENT PRIMARY KEY,
  id_proveedor INT,
  fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
  estado VARCHAR(30),
  total DECIMAL(14,2),
  FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: compra_items
-- ===========================
CREATE TABLE compra_items (
  id_comp_item INT AUTO_INCREMENT PRIMARY KEY,
  id_compra INT,
  id_producto INT,
  cantidad DECIMAL(12,3),
  precio_unitario DECIMAL(12,2),
  subtotal DECIMAL(14,2),
  FOREIGN KEY (id_compra) REFERENCES compras(id_compra) ON DELETE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: facturas
-- ===========================
CREATE TABLE facturas (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT,
  fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
  tipo_comprobante VARCHAR(30),
  total DECIMAL(14,2),
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================
-- Tabla: pagos
-- ===========================
CREATE TABLE pagos (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT,
  fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
  metodo_pago VARCHAR(50),
  monto DECIMAL(14,2),
  referencia_pago VARCHAR(150),
  FOREIGN KEY (id_factura) REFERENCES facturas(id_factura)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
