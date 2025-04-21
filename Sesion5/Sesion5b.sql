DECLARE
CURSOR pedido_cursor IS
 SELECT PedidoID, Total
 FROM Pedidos
 WHERE Total < 500
 FOR UPDATE;
v_pedido_id NUMBER;
v_total NUMBER;
BEGIN
OPEN pedido_cursor;
LOOP
 FETCH pedido_cursor INTO v_pedido_id, v_total;
 EXIT WHEN pedido_cursor%NOTFOUND;
 UPDATE Pedidos
 SET Total = v_total * 1.5
 WHERE CURRENT OF pedido_cursor;
 DBMS_OUTPUT.PUT_LINE('Pedido ' || v_pedido_id || ' actualizado a: ' || (v_total *
1.5));
END LOOP;
CLOSE pedido_cursor;
END;
/
