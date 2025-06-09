--Crea un índice compuesto en la tabla
--DetallesPedidos para las columnas PedidoID y
--ProductoID. Luego, escribe una consulta que use
--este índice y analiza su plan de ejecución.

CREATE INDEX idx_pedidos_pedidoid_productoid ON
DetallesPedidos(PedidoID,ProductoID);

SELECT * 
FROM DetallesPedidos
WHERE PedidoID = 101 AND ProductoID = 1;

EXPLAIN PLAN FOR
SELECT * 
FROM DetallesPedidos
WHERE PedidoID = 101 AND ProductoID = 1;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
