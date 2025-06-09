--Escribe una función calcular_valor_inventario_proveedor que
--reciba un ProveedorID (parámetro IN) y devuelva el valor
--total del inventario de los productos de ese proveedor (suma
--de Precio * Cantidad). Luego, usa la función en un
--procedimiento mostrar_valor_proveedor que muestre el valor
--total del inventario por proveedor para todos los
--proveedores.

CREATE OR REPLACE FUNCTION calcular_valor_inventario_proveedor(proveedorId IN NUMBER) RETURN NUMBER AS
    VTotal NUMBER;
BEGIN 
    SELECT 
        NVL(SUM(i.Cantidad * p.Precio), 0)
    INTO VTotal
    FROM Inventario i
    JOIN Productos p ON i.ProductoID = p.ProductoID
    WHERE p.ProveedorID = proveedorId;

    RETURN VTotal;
END;
/


CREATE OR REPLACE PROCEDURE mostrar_valor_proveedor AS 
CURSOR proveedor_cursor IS
	SELECT ProveedorID,ProductoID
	FROM Productos;
BEGIN
	FOR proveedor in proveedor_cursor LOOP
	    calcular_valor_inventario_proveedor(proveedor.ProveedorID);
	END LOOP;
	COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
 		DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
 		ROLLBACK;
	END;
/
