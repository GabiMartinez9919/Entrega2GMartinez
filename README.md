# 🗃️ Entrega 2 – SQL Coderhouse

**Alumno:** Gabriel A. Martínez  
**Curso:** SQL Coderhouse (2025)  
**Comisión:** 81840  

---

## 📘 Descripción

Proyecto relacional desarrollado como **Entrega 2** para el curso de SQL en Coderhouse.  
La base de datos **`idea_martinez`** gestiona clientes, productos, pedidos, facturas y pagos,  
integrando funciones, procedimientos almacenados, vistas y triggers que garantizan  
la consistencia e integridad de los datos.

> 🔹 Se incluye también la **Entrega 1**, según lo solicitado en la clase del **martes 28 de marzo**,  
> que contiene la creación del esquema, estructura de tablas y relaciones base.

---

## 📂 Archivos incluidos

| Archivo | Contenido |
|----------|------------|
| `01_schema_idea_martinez.sql` | Creación del esquema, tablas e integridad referencial. |
| `02_objects_idea_martinez.sql` | Funciones, vistas, procedimientos almacenados y triggers. |
| `03_seed_idea_martinez.sql` | Inserciones de datos, consultas de validación y ejecución de SP. |
| `IdeaMartinez_SQL_Entrega2_Correcto.pdf` | Documentación completa de la entrega. |
| `README.md` | Descripción general del proyecto (este archivo). |

---


## 🧩 Estructura de la base de datos

- **Tablas principales:** `clientes`, `productos`, `pedidos`, `pedido_items`, `facturas`, `pagos`.  
- **Vistas:** `vw_pedidos_detalle`, `vw_facturacion_por_cliente`, `vw_productos_mas_vendidos`.  
- **Funciones:** `fn_total_pedido`, `fn_cliente_fullname`.  
- **Procedimientos:** `sp_pedidos_por_estado`, `sp_top_productos_vendidos`.  
- **Triggers:** `trg_pi_bi_set_subtotal`, `trg_pi_aiu_recalc_total`, `trg_pi_ad_recalc_total`.  

---

## ✍️ Autor

**Gabriel Alejandro Martínez**  
