SELECT COUNT(*) clientes  FROM clientes;
SELECT COUNT(*) productos FROM productos;
SELECT COUNT(*) pedidos   FROM pedidos;
SELECT COUNT(*) items     FROM pedido_items;
SELECT COUNT(*) facturas  FROM facturas;
SELECT COUNT(*) pagos     FROM pagos;

SELECT * FROM vw_pedidos_detalle LIMIT 10;
SELECT * FROM vw_facturacion_por_cliente ORDER BY total_facturado DESC LIMIT 10;
SELECT * FROM vw_productos_mas_vendidos LIMIT 10;

CALL sp_top_productos_vendidos(5);
