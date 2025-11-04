-- ===========================================
-- 01_objects_idea_martinez.sql
-- Vistas, Funciones, Stored Procedures y Triggers
-- ===========================================

USE idea_martinez;

-- ===========================================
-- FUNCIONES
-- ===========================================

DROP FUNCTION IF EXISTS fn_total_pedido;
DELIMITER //
CREATE FUNCTION fn_total_pedido(p_id_pedido INT)
RETURNS DECIMAL(14,2)
DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(14,2);
  SELECT SUM(subtotal) INTO v_total
  FROM pedido_items
  WHERE id_pedido = p_id_pedido;
  RETURN IFNULL(v_total, 0);
END //
DELIMITER ;

DROP FUNCTION IF EXISTS fn_cliente_fullname;
DELIMITER //
CREATE FUNCTION fn_cliente_fullname(p_id_cliente INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
  DECLARE v_nombre VARCHAR(100);
  DECLARE v_apellido VARCHAR(100);
  SELECT nombre, apellido INTO v_nombre, v_apellido
  FROM clientes
  WHERE id_cliente = p_id_cliente;
  RETURN CONCAT(v_nombre, ' ', v_apellido);
END //
DELIMITER ;

-- ===========================================
-- VISTAS
-- ===========================================

DROP VIEW IF EXISTS vw_pedidos_detalle;
CREATE VIEW vw_pedidos_detalle AS
SELECT 
  p.id_pedido,
  fn_cliente_fullname(p.id_cliente) AS cliente,
  p.fecha_pedido,
  p.estado,
  pr.nombre AS producto,
  i.cantidad,
  i.precio_unitario,
  i.subtotal
FROM pedidos p
INNER JOIN pedido_items i ON p.id_pedido = i.id_pedido
INNER JOIN productos pr ON i.id_producto = pr.id_producto;

DROP VIEW IF EXISTS vw_facturacion_por_cliente;
CREATE VIEW vw_facturacion_por_cliente AS
SELECT 
  c.id_cliente,
  fn_cliente_fullname(c.id_cliente) AS cliente,
  SUM(f.total) AS total_facturado
FROM facturas f
INNER JOIN pedidos p ON f.id_pedido = p.id_pedido
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente;

DROP VIEW IF EXISTS vw_productos_mas_vendidos;
CREATE VIEW vw_productos_mas_vendidos AS
SELECT 
  pr.id_producto,
  pr.nombre AS producto,
  SUM(i.cantidad) AS cantidad_vendida,
  SUM(i.subtotal) AS monto_vendido
FROM pedido_items i
INNER JOIN productos pr ON i.id_producto = pr.id_producto
GROUP BY pr.id_producto
ORDER BY cantidad_vendida DESC;

-- ===========================================
-- STORED PROCEDURES
-- ===========================================

DROP PROCEDURE IF EXISTS sp_pedidos_por_estado;
DELIMITER //
CREATE PROCEDURE sp_pedidos_por_estado(IN p_estado VARCHAR(30))
BEGIN
  SELECT 
    p.id_pedido,
    fn_cliente_fullname(p.id_cliente) AS cliente,
    p.fecha_pedido,
    p.estado,
    p.total
  FROM pedidos p
  WHERE p.estado COLLATE utf8mb4_general_ci = p_estado COLLATE utf8mb4_general_ci
  ORDER BY p.fecha_pedido DESC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_top_productos_vendidos;
DELIMITER //
CREATE PROCEDURE sp_top_productos_vendidos(IN limite INT)
BEGIN
  SELECT 
    pr.id_producto,
    pr.nombre AS producto,
    SUM(i.cantidad) AS cantidad_vendida,
    SUM(i.subtotal) AS monto_vendido
  FROM pedido_items i
  INNER JOIN productos pr ON i.id_producto = pr.id_producto
  GROUP BY pr.id_producto
  ORDER BY cantidad_vendida DESC
  LIMIT limite;
END //
DELIMITER ;

-- ===========================================
-- TRIGGERS
-- ===========================================

DROP TRIGGER IF EXISTS trg_pi_bi_set_subtotal;
DELIMITER //
CREATE TRIGGER trg_pi_bi_set_subtotal
BEFORE INSERT ON pedido_items
FOR EACH ROW
BEGIN
  SET NEW.subtotal = ROUND(NEW.cantidad * NEW.precio_unitario, 2);
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_pi_aiu_recalc_total;
DELIMITER //
CREATE TRIGGER trg_pi_aiu_recalc_total
AFTER INSERT ON pedido_items
FOR EACH ROW
BEGIN
  UPDATE pedidos 
  SET total = fn_total_pedido(NEW.id_pedido)
  WHERE id_pedido = NEW.id_pedido;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_pi_ad_recalc_total;
DELIMITER //
CREATE TRIGGER trg_pi_ad_recalc_total
AFTER DELETE ON pedido_items
FOR EACH ROW
BEGIN
  UPDATE pedidos 
  SET total = fn_total_pedido(OLD.id_pedido)
  WHERE id_pedido = OLD.id_pedido;
END //
DELIMITER ;

-- ===========================================
-- FIN DEL SCRIPT
-- ===========================================
