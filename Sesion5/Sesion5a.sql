DECLARE
CURSOR pedido_cursor(p_cliente_id NUMBER) IS
 SELECT PedidoID, Total
 FROM Pedidos
 WHERE ClienteID = p_cliente_id;
v_pedido_id NUMBER;
v_total NUMBER;
BEGIN
OPEN pedido_cursor(1);
LOOP
 FETCH pedido_cursor INTO v_pedido_id, v_total;
 EXIT WHEN pedido_cursor%NOTFOUND;
 DBMS_OUTPUT.PUT_LINE('Pedido ID: ' || v_pedido_id || ', Total: ' || v_total);
END LOOP;
CLOSE pedido_cursor;
EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
 IF pedido_cursor%ISOPEN THEN
 CLOSE pedido_cursor;
 END IF;
END;
/