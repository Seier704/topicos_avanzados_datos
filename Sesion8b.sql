DECLARE
	CURSOR aumento_cursor IS
	SELECT ProductoID,Nombre,Precio
	FROM Productos
	WHERE Precio < 1000
	FOR UPDATE;
	productoID NUMBER;
	nombreP VARCHAR(50);
	precioU NUMBER;

BEGIN 
	OPEN aumento_cursor;
	LOOP
	FETCH aumento_cursor INTO productoID,nombreP,precioU;
	EXIT WHEN aumento_cursor%NOTFOUND;
	UPDATE Productos
	SET Precio = precioU * 1.15
	WHERE CURRENT OF aumento_cursor;
	DBMS_OUTPUT.PUT_LINE('Producto ID:' || productoID || ', Nombre:' || nombreP || ', Actualizado a:' || (precioU*1.15));
	END LOOP;
	CLOSE aumento_cursor;

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
		