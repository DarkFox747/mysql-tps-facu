--Consultas SQL

-- 1. Detalle de clientes que realizaron pedidos entre fechas
SELECT c.Apellido, c.Nombres, c.mail
FROM Clientes c
JOIN Pedidos p ON c.idcliente = p.idcliente
WHERE p.fecha BETWEEN '2024-01-01' AND '2024-12-31';

-- 2. Detalle de vendedores con la cantidad de pedidos realizados
SELECT v.Apellido, v.Nombres, v.email, COUNT(p.NumeroPedido) AS CantidadPedidos
FROM Vendedor v
LEFT JOIN Pedidos p ON v.idvendedor = p.idvendedor
GROUP BY v.idvendedor;

-- 3. Detalle de pedidos con un total mayor a un determinado valor umbral
SELECT p.NumeroPedido, p.fecha, SUM(d.PrecioUnitario * d.cantidad) AS TotalPedido
FROM Pedidos p
JOIN DetallePedidos d ON p.NumeroPedido = d.NumeroPedido
GROUP BY p.NumeroPedido, p.fecha
HAVING TotalPedido > 500; -- Puedes cambiar el valor umbral segun sea necesario

-- 4. Lista de productos vendidos entre fechas
SELECT pr.Descripcion, SUM(d.cantidad) AS CantidadTotal
FROM Productos pr
JOIN DetallePedidos d ON pr.idproducto = d.idproducto
JOIN Pedidos p ON d.NumeroPedido = p.NumeroPedido
WHERE p.fecha BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY pr.idproducto, pr.Descripcion;

-- 5. Proveedor que realizo mas ventas
SELECT pr.idproveedor, pr.NombreProveedor, COUNT(d.NumeroPedido) AS CantidadPedidos
FROM Proveedores pr
JOIN Productos p ON pr.idproveedor = p.idproveedor
JOIN DetallePedidos d ON p.idproducto = d.idproducto
GROUP BY pr.idproveedor
ORDER BY CantidadPedidos DESC
LIMIT 1;

-- 6. Detalle de clientes registrados que nunca realizaron un pedido
SELECT c.Apellido, c.Nombres, c.mail
FROM Clientes c
LEFT JOIN Pedidos p ON c.idcliente = p.idcliente
WHERE p.idcliente IS NULL;

-- 7. Detalle de clientes que realizaron menos de dos pedidos
SELECT c.Apellido, c.Nombres, c.mail
FROM Clientes c
JOIN Pedidos p ON c.idcliente = p.idcliente
GROUP BY c.idcliente
HAVING COUNT(p.NumeroPedido) < 2;

-- 8. Cantidad total vendida por origen de producto
SELECT p.origen, SUM(d.cantidad) AS CantidadTotal
FROM Productos p
JOIN DetallePedidos d ON p.idproducto = d.idproducto
GROUP BY p.origen;
