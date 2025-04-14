DECLARE
v_precio NUMBER;
precio_bajo EXCEPTION;
memory_overflow EXCEPTION;
PRAGMA EXCEPTION_INIT(memory_overflow, -8000); -- Código TT8000
BEGIN
SELECT Precio INTO v_precio
FROM Productos
WHERE ProductoID = 2;

IF v_precio < 50 THEN
 RAISE precio_bajo;
END IF;

-- Simulación de un error de memoria (por ejemplo, consulta masiva en TimesTen)
DBMS_OUTPUT.PUT_LINE('Procesando datos masivos...');

DBMS_OUTPUT.PUT_LINE('Precio válido: ' || v_precio);
EXCEPTION
WHEN precio_bajo THEN
 DBMS_OUTPUT.PUT_LINE('Error: El precio es demasiado bajo (' || v_precio || ').');
WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('Error: Producto no encontrado.');
WHEN memory_overflow THEN
 DBMS_OUTPUT.PUT_LINE('Error TimesTen: Memoria insuficiente (TT8000).');
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/