--Crea un tipo de objeto empleado_obj con atributos
--empleado_id, nombre, y un método get_info. Luego, crea una
--tabla basada en ese tipo y transfiere los datos de Empleados
--a esa tabla. Finalmente, escribe un cursor explícito que
--liste la información de los empleados usando el método
--get_info.

CREATE OR REPLACE TYPE empleado_obj AS OBJ(empleado_id NUMBER,nombre VARCHAR(50),MEMBER FUNCTION get_info RETURN VARCHAR2);
/

CREATE OR REPLACE TYPE BODY empleado_obj AS
MEMBER FUNCTION get_info RETURN VARCHAR2 IS
BEGIN
 	RETURN 'ID: ' || empleado_id || ', Nombre: ' ||
	nombre;
END;
/

CREATE TABLE empleado_obj OF SELECT(c.EmpleadoID,c.Nombre) FROM Empleados c(
empleado_id PRIMARY KEY
);
/

DECLARE 
	
	CURSOR listar_empleado IS
 	SELECT VALUE(c) FROM empleado_obj c;
	l_empleado empleado_obj;

BEGIN 

	OPEN listar_empleado;
	LOOP
	EXIT WHEN listar_empleado%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE(l_empleado.get_info);
	END LOOP;
	CLOSE listar_empleado;

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

COMMIT;

