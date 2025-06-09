--Reestructuracion
SELECT c.Nombre, COUNT(p.PedidoID) AS TotalPedidos
FROM Clientes c
JOIN Pedidos p ON c.ClienteID = p.ClienteID
WHERE c.Ciudad = 'Santiago'
  AND p.FechaPedido >= TO_DATE('2025-03-01', 'YYYY-MM-DD')
GROUP BY c.Nombre;

-- Índice compuesto en Clientes
CREATE INDEX idx_clientes_ciudad_id ON Clientes(Ciudad, ClienteID);

-- Índice compuesto en Pedidos
CREATE INDEX idx_pedidos_cliente_fecha ON Pedidos(ClienteID, FechaPedido);
