DECLARE
	CURSOR total_cursor IS
	SELECT a.PedidoID,a.ClienteID,a.Total,b.Nombre
	FROM Pedidos a
	JOIN Clientes b 
	ON b.ClienteID = a.ClienteID
	WHERE a.Total > 500;
	
	pedidoID NUMBER;
	clienteID NUMBER;
	totalPedido NUMBER;
	nombreCliente VARCHAR(50);

BEGIN 
	OPEN total_cursor;
	LOOP
	FETCH total_cursor INTO pedidoID,clienteID,totalPedido,nombreCliente;
	EXIT WHEN total_cursor%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE('Pedido ID :' || pedidoID || ', Cliente ID:' || clienteID || ', Total :' || totalPedido || ', Nombre :' || nombreCliente);
	END LOOP;
	CLOSE total_cursor;
END;
/
		