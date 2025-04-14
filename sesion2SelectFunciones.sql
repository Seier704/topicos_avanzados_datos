SELECT ClienteID, SUM(Total) AS TotalGastado
FROM Pedidos
GROUP BY ClienteID;


SELECT AVG(Precio) AS PromedioPrecio FROM Productos;