# Optimización de Ventas y Gestión de Inventario en Café Aurora

## Contexto del Negocio

**Café Aurora** es una cafetería local ubicada en una zona residencial. Opera todos los días de la semana, con un menú
de cafés, tés, postres, desayunos ligeros y productos de temporada. Al ser un negocio pequeño, no cuenta con un sistema
de Business Intelligence formal, pero guarda los datos de ventas, productos y clientes en una base de datos relacional
local (por ejemplo, MySQL).

La dueña quiere entender mejor:
- ¿Qué productos se venden más según el día/hora?
- ¿Cómo afectan las promociones a las ventas?
- ¿Qué productos podrían ser retirados o potenciados?
- ¿Cuál es la relación entre el clima y tipos de productos vendidos (opcional)?
- ¿Cómo prever necesidades de inventario básicas según patrones de consumo?

## Objetivos del Proyecto
1. Analizar patrones de venta por día, hora y categoría de producto.
2. Identificar productos con bajo rendimiento.
3. Detectar horas pico y días de mayor afluencia.
4. Estimar una predicción básica de demanda semanal por tipo de producto.
5. Proporcionar recomendaciones simples para optimizar el menú e inventario,

## Parte 1: Análisis Exploratorio en SQL

Todo el análisis inicial se hace directamente con SQL.
1. Ventas totales por día de la semana.
2. Top 5 productos más vendidos por cantidad y por ingresos.
3. Ventas por categoría (café, postres, tés, etc.) según la hora.
4. Stock medio semanal vs. ventas (para detectar sobrestock o subastecimiento).
5. Detección de productos que no se venden en ciertos días.