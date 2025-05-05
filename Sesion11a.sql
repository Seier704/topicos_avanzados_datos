CREATE OR REPLACE FUNCTION calcular_edad(ClienteID IN NUMBER) 
RETURN NUMBER AS
    FechaNacimiento DATE;
    Edad NUMBER;
BEGIN
    -- Obtener la fecha de nacimiento del cliente usando un alias para evitar conflictos
    SELECT FechaNacimiento 
    INTO FechaNacimiento
    FROM Clientes
    WHERE ClienteID = calcular_edad.ClienteID;
    
    -- Calcular la edad
    Edad := FLOOR(MONTHS_BETWEEN(SYSDATE, FechaNacimiento) / 12);
    
    -- Devolver la edad calculada
    RETURN Edad;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Lanzar una excepción si el ClienteID no existe
        RAISE_APPLICATION_ERROR(-20001, 'Detalle con ID ' || ClienteID || ' no encontrado.');
END;
/
-- Bloque anónimo para probar la función
DECLARE 
    edad NUMBER;
BEGIN
    -- Llamar a la función con un ClienteID de ejemplo
    edad := calcular_edad(1);
    -- Imprimir la edad del cliente con DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Edad cliente id 1: ' || edad);
END;
/
