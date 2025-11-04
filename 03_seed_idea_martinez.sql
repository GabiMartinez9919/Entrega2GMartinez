-- ===========================================
-- 03_seed_idea_martinez.sql
-- Inserts, validaciones y consultas finales
-- ===========================================

USE idea_martinez;

-- ======================
-- Inserciones iniciales
-- ======================
INSERT INTO clientes (nombre, apellido, email) VALUES
('Ana','Pérez','ana@example.com'),
('Bruno','Gómez','bruno@example.com');

INSERT INTO productos (nombre, precio_venta) VALUES
('Teclado', 35000.00),
('Mouse',   25000.00);

INSERT INTO pedidos (id_cliente, estado, total) VALUES
(1, 'procesando', 60000.00);

INSERT INTO pedido_items (id_pedido, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 1, 35000.00, 35000.00),
(1, 2, 1, 25000.00, 25000.00);

INSERT INTO facturas (id_pedido, tipo_comprobante, total) VALUES
(1, 'B', 60000.00);

INSERT INTO pagos (id_factura, metodo_pago, monto) VALUES
(1, 'Tarjeta', 60000.00);

-- ======================
-- Consultas de validación
-- ======================
SELECT * FROM vw_facturacion_por_cliente ORDER BY total_facturado DESC LIMIT 10;
SELECT * FROM vw_productos_mas_vendidos LIMIT 10;
CALL sp_pedidos_por_estado('procesando');
CALL sp_top_productos_vendidos(5);

-- ======================
-- Verificación de objetos
-- ======================
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW FUNCTION STATUS WHERE Db='idea_martinez';
SHOW PROCEDURE STATUS WHERE Db='idea_martinez';
SHOW TRIGGERS;
