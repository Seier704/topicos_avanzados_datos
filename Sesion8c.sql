DECLARE
	CURSOR lista_cursor IS
	SELECT a.ClienteID,a.Nombre,SUM(b.Total) AS SumaTotal
	FROM Clientes a
	JOIN Pedidos b ON b.ClienteID = a.ClienteID
	GROUP BY a.ClienteID,a.Nombre
	HAVING SUM(b.Total) > 800;
	
	idCliente NUMBER;
	nombreCliente VARCHAR(50);
	totalPedido NUMBER;

BEGIN
	OPEN lista_cursor;
	LOOP
	FETCH lista_cursor INTO idCliente,nombreCliente,totalPedido;
	EXIT WHEN lista_cursor%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE('Nombre:' || nombreCliente || ', Total del Pedido:' || totalPedido);
	END LOOP;
	CLOSE lista_cursor;
EXCEPTION
	WHEN OTHERS THEN
 	DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/