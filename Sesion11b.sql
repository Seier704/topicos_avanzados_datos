CREATE OR REPLACE FUNCTION calcular_promedio 
RETURN NUMBER IS
    promedioT NUMBER;
BEGIN

    SELECT AVG(Precio)
    INTO promedioT
    FROM Productos;    
    RETURN promedioT;


EXCEPTION
    WHEN OTHERS THEN
        -- Lanzar una excepción si el Producto no existe
       RAISE_APPLICATION_ERROR(-20002, 'Error al calcular el promedio: ' || SQLERRM);
END;
/
-- Consulta

    SELECT Nombre,Precio FROM Productos
    WHERE Precio > calcular_promedio();
/
