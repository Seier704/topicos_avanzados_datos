DECLARE
v_total NUMBER;
v_cliente_id NUMBER := 999; -- Cliente inexistente
BEGIN
SELECT SUM(Total) INTO v_total
FROM Pedidos
WHERE ClienteID = v_cliente_id;

DBMS_OUTPUT.PUT_LINE('Total gastado: ' || v_total);
EXCEPTION
WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('No se encontraron pedidos para el cliente '
|| v_cliente_id);
WHEN VALUE_ERROR THEN
 DBMS_OUTPUT.PUT_LINE('Error de valor en los datos.');
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/