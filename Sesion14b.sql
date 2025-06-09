CREATE OR REPLACE TYPE Camion UNDER Vehiculo (
    CapacidadCarga NUMBER,
    OVERRIDING MEMBER FUNCTION obtener_antiguedad RETURN NUMBER,
    MEMBER FUNCTION descripcion_vehiculo RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY Camion AS
    OVERRIDING MEMBER FUNCTION obtener_antiguedad RETURN NUMBER IS
    BEGIN
        RETURN (2025 - SELF.Año + 2); -- 2 años más
    END;

    MEMBER FUNCTION descripcion_vehiculo RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Camión de Marca ' || Marca || ' con capacidad de ' || CapacidadCarga || ' toneladas.';
    END;
END;
/


INSERT INTO Vehiculos
VALUES (Camion('Volvo', 2010, 10));

SELECT 
    v.Marca,
    v.obtener_antiguedad() AS Antiguedad,
    TREAT(VALUE(v) AS Camion).descripcion_vehiculo() AS Descripcion,
    v.Año
FROM Vehiculos v
WHERE VALUE(v) IS OF (Camion);
