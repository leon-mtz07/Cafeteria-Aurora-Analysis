-- Análisis Exploratorio

-- Ventas totales por día de la semana
SELECT
    DAYOFWEEK(fecha) AS day,
    SUM(cantidad) AS ventas_totales
FROM
    ventas
GROUP BY
    day
ORDER BY
    day;

/*
 Se encontró que en las ventas totales de la semana, todos varian entre 650 y 750, pero el domingo, es el único día
 que tiene 592 ventas, no es un cambio grande, pero se hace notar que hay menos ventas.
 */

-- Top 5 productos más vendidos por cantidad y por ingresos
-- Por cantidad
SELECT
    nombre_producto,
    SUM(cantidad) AS cantidad
FROM
    productos
INNER JOIN ventas ON productos.producto_id = ventas.producto_id
GROUP BY
    nombre_producto
ORDER BY
    cantidad DESC
LIMIT 5;

/*
 Los principales productos que se venden son el jugo natural, el té verde, el café latte, el capucchino, y el pastel
 de zanahoria, y van desde 660 unidades vendidas hasta 610, por lo tanto, da a entender que aunque si se venden mucho,
 no hay mucha diferencia entre el top 5.
 */

-- Por Ingresos
SELECT
    nombre_producto,
    SUM(total_venta) AS ingresos
FROM
    productos
INNER JOIN ventas ON productos.producto_id = ventas.producto_id
GROUP BY
    nombre_producto
ORDER BY
    ingresos DESC
LIMIT 5;

/*
 Luego vemos esta tabla y logramos relacionarlo con la anterior, porque vemos productos que ya estaban, en esta tabla
 está el swandwich integral, el jugo natural, el pastel de zanahoria, el capuchino, y el café latte, logramos relacionar
 con los precios debido a que pueden ser de los más altos y a la vez de los más vendidos, logrando alcanzar muchas
 ganancias
 */

-- Ventas por categoría (café, postres, tés, etc.) según la hora
SELECT
    HOUR(hora) AS hora,
    SUM(cantidad) AS cantidad
FROM
    productos
INNER JOIN coffee_aurora.ventas v on productos.producto_id = v.producto_id
WHERE
    categoria = 'Café'
GROUP BY
    HOUR(hora)
ORDER BY
    hora;

/*
 Aquí se logra ver algo interesante, debido a que hasta las 14:00 horas hay alrededor de 150 ventas, pero luego de esa
 hora, incrementan las ventas unas 30 unidades alcanzando ventas de 225 a las 18:00 horas, indicando que su horario
 fuerte es desde las 15:00 hasta las 18:00, to-do esto en la categoría del café
 */

-- Ventas por hora del té
SELECT
    HOUR(hora) AS hora,
    SUM(cantidad) AS cantidad
FROM
    productos
INNER JOIN coffee_aurora.ventas v on productos.producto_id = v.producto_id
WHERE
    categoria = 'Té'
GROUP BY
    HOUR(hora)
ORDER BY
    hora;

/*
 Con el té vemos algo diferente e interesante, desde las 8:00 que abren hasta las 11:00 vemos ventas de alrededor de
 60 unidades por hora, pero desde las 12:00 hasta las 13:00 se relajan las ventas disminuyendo hasta 42 unidades,
 luego desde las 14:00 aumenta con fuerza, aumenta hasta 72 unidades, indicando un patrón que en la tarde, en las
 últimas horas que está abierto, todos los productos se venden más, esto se puede deber a que es la hora, en la que
 la mayoría de las personas están disponibles en el día, por lo tanto, los empleados y los baristas deberían estar
 más atentos a esas horas
 */

SELECT
    HOUR(hora) AS hora,
    SUM(cantidad) AS cantidad
FROM
    productos
INNER JOIN coffee_aurora.ventas v on productos.producto_id = v.producto_id
WHERE
    categoria = 'Postres'
GROUP BY
    HOUR(hora)
ORDER BY
    hora;

/*
 Con los postres vemos algo diferente, pero de igual manera sigue hasta cierto punto el mismo patrón, debido a que
 los postres son muy pedidos en to-do el día a todas horas, por lo tanto, se debería de tener suficiente stock de
 postres en to-do el día, y tener cuidado de que no se acabe, ya que parece, que es una de nuestras mejores categorías
 */

SELECT
    HOUR(hora) AS hora,
    SUM(cantidad) AS cantidad
FROM
    productos
INNER JOIN coffee_aurora.ventas v on productos.producto_id = v.producto_id
WHERE
    categoria = 'Desayunos'
GROUP BY
    HOUR(hora)
ORDER BY
    hora;

/*
 Con los postres es otra historia, debido a que es muy poco pedido, es una de las categorías que menos piden,
 por lo tanto, se deberían de emplear estrategias para tratar de vender más de estos productos
 */

SELECT
    HOUR(hora) AS hora,
    SUM(cantidad) AS cantidad
FROM
    productos
INNER JOIN coffee_aurora.ventas v on productos.producto_id = v.producto_id
WHERE
    categoria = 'Bebidas'
GROUP BY
    HOUR(hora)
ORDER BY
    hora;

-- Con las bebidas sucede lo mismo, debido a que es una de las categorías menos pedidas

-- Categorías ordenadas por ingresos y pedidos
-- Ingresos
SELECT
    categoria,
    SUM(total_venta) AS ingresos
FROM
    productos
INNER JOIN ventas ON productos.producto_id = ventas.producto_id
GROUP BY
    categoria
ORDER BY
    ingresos DESC
LIMIT 5;

/*
 Aquí vemos que en orden de ingresos de mayor a menos está primero el café, luego los postres, luego los desayunos,
 luego las bebidas, y luego los tés
 */

-- Cantidad
SELECT
    categoria,
    SUM(cantidad) AS cantidad,
    ROUND(SUM(cantidad) / 4904 * 100, 2) AS percentage
FROM
    productos
INNER JOIN ventas ON productos.producto_id = ventas.producto_id
GROUP BY
    categoria
ORDER BY
    cantidad DESC
LIMIT 5;

/*
 Aquí cambia muy poco la tabla, el orden es el café, luego le sigue los postres, luego las bebidas, luego el té, y luego
 los desayunos, se ve un patrón curioso, ya que se ve que la gente suele acompañar los cafés con un buen postre, debido
 a que lo dulce que bien con un café. Esto reflejando los principales productos y el fuerte de la cafetería.
 */

-- Stock medio semanal vs. ventas (para detectar sobrestock o subastecimiento)
WITH stock_media AS (
    SELECT
        WEEKOFYEAR(fecha_actualizacion) AS week,
        ROUND(AVG(stock_actual)) AS media_stock,
        SUM(cantidad) AS cantidad
    FROM
        inventario
    INNER JOIN ventas ON inventario.producto_id = ventas.producto_id AND
                         DATE(inventario.fecha_actualizacion) = DATE(ventas.fecha)
    GROUP BY
        week
    ORDER BY
        week
)

SELECT
    week,
    media_stock,
    cantidad,
    ROUND(cantidad / media_stock, 2) AS rotation
FROM
    stock_media;

/*
 Aquí se logra ver que está en general bien la rotación, debido a que supera la medida de 1.5, solo en casos muy
 puntuales está por debajo de 1.
 */

-- Detección de productos que no se venden en ciertos días
WITH dias AS (
    SELECT 0 AS dia UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
    SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
),

producto_dias AS (
    SELECT
        p.producto_id,
        p.nombre_producto,
        d.dia
    FROM productos p
    CROSS JOIN dias d
),

ventas_por_dia AS (
    SELECT DISTINCT
        producto_id,
        DAYOFWEEK(fecha) - 1 AS dia
    FROM ventas
)

SELECT
    pd.nombre_producto,
    pd.dia
FROM producto_dias pd
LEFT JOIN ventas_por_dia vd
    ON pd.producto_id = vd.producto_id AND pd.dia = vd.dia
WHERE vd.producto_id IS NULL
ORDER BY pd.nombre_producto, pd.dia;

/*
 Aquí no se detecta que algún producto no se haga vendido en algún día, por lo que eso es muy bueno, ya que dice que
 todos nuestros productos se venden todos los días.
 */