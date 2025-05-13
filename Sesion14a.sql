--Crea un supertipo Vehiculo con atributos Marca y
--Año, y un método obtener_antiguedad. Luego, crea
--un subtipo Automovil que herede de Vehiculo, con
--un atributo adicional NumeroPuertas y un método
--descripcion que devuelva una cadena con los
--detalles del automóvil.

CREATE OR REPLACE TYPE Vehiculo AS OBJECT (
	Marca VARCHAR(50),
	Año NUMBER,
	MEMBER FUNCTION obtener_antiguedad RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY Vehiculo AS
	MEMBER FUNCTION obtener_antiguedad RETURN NUMBER IS
	BEGIN
		RETURN (2025- SELF.Año);
	END;
END;
/

CREATE OR REPLACE TYPE Automovil UNDER Vehiculo(

	NumeroPuertas NUMBER,
	MEMBER FUNCTION descripcion_vehiculo RETURN VARCHAR2

);
/

CREATE OR REPLACE TYPE BODY Automovil AS 
	MEMBER FUNCTION descripcion_vehiculo RETURN VARCHAR2 IS
	BEGIN 
		RETURN 'Automóvil de Marca ' || Marca || ' Con un total de ' || NumeroPuertas || ' Puertas y con ';
	END;
END;
/			
	

CREATE TABLE Vehiculos OF Vehiculo;

INSERT INTO Vehiculos
VALUES (Vehiculo('Hyundai', 2000));

INSERT INTO Vehiculos
VALUES (Automovil('Hyundai', 2000, 4));


SELECT v.Marca, v.obtener_antiguedad() AS Antiguedad, TREAT(VALUE(v) AS Automovil).descripcion_vehiculo() AS descripcion, v.Año
    FROM Vehiculos v
    WHERE VALUE(v) IS OF (Automovil); 

