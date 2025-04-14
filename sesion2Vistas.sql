CREATE OR REPLACE VIEW Vista_ResumenPedidos AS
SELECT c.Nombre, p.PedidoID, p.Total, p.FechaPedido
FROM Clientes c
JOIN Pedidos p ON c.ClienteID = p.ClienteID;


CREATE OR REPLACE VIEW Vista_ProductosCaros AS
SELECT * FROM Productos
WHERE Precio > 100;