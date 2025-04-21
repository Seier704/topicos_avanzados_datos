CREATE OR REPLACE PROCEDURE aumentar_precio_producto (p_producto_id IN NUMBER, p_porcentaje_aumento IN NUMBER) AS
BEGIN
	
		IF p_porcentaje_aumento < 0 THEN
 		RAISE_APPLICATION_ERROR(-20002, 'El porcentaje debe ser mayor o igual a 0.');
		END IF;
	
		UPDATE Productos
		SET Precio = (Precio * ((p_porcentaje_aumento/100)+1))
		WHERE ProductoID = p_producto_id;
	
		IF SQL%ROWCOUNT = 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'Producto con ID ' || p_producto_id || ' no encontrado.');
		END IF;	
		DBMS_OUTPUT.PUT_LINE('Precio del producto ' || p_producto_id || ' actualizado' );
		COMMIT;

EXCEPTION
		WHEN VALUE_ERROR THEN 
		DBMS_OUTPUT.PUT_LINE('ERROR: El porcentaje debe ser valido.');
		WHEN OTHERS THEN
 		DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/

EXEC aumentar_precio_producto(1,13);
