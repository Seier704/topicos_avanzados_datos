CREATE OR REPLACE FUNCTION calcular_total_con_descuento(PedidoiD IN NUMBER)
RETURN NUMBER AS
	TotalD NUMBER;

BEGIN 
	SELECT p.Total * 0.9 INTO TotalD 
	FROM Pedidos p
	WHERE PedidoID =;
	RETURN TotalD;

END;
/


CREATE OR REPLACE PROCEDURE aplicar_descuento_pedido(p_pedido_id IN NUMBER) AS
	v_nuevo_total NUMBER;
BEGIN
	v_nuevo_total := calcular_total_con_descuento(p_pedido_id);
	IF v_nuevo_total = 0 THEN
 	RAISE_APPLICATION_ERROR(-20001, 'No se encontraron detalles para el pedido ' || p_pedido_id);
	END IF;
	UPDATE Pedidos
	SET Total = v_nuevo_total
	WHERE PedidoID = p_pedido_id;
	DBMS_OUTPUT.PUT_LINE('Total del pedido ' || p_pedido_id || ' actualizado a: ' || v_nuevo_total);
	COMMIT;

END;
/

DECLARE 
	aux NUMBER;
BEGIN 
	aux := calcular_total_con_descuento(101);
END;
/