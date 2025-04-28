DECLARE 
	CURSOR lista_departamentos IS
	SELECT d.DepartamentoId,d.Nombre,AVG(c.Salario) AS Salario_Empleados
	FROM Departamentos d 
	JOIN Empleados c 
	ON d.DepartamentoID = c.DepartamentoID
	GROUP BY d.DepartamentoId,d.Nombre
	HAVING AVG(c.Salario) > 600000;

	idDepa NUMBER;
	Ndepa VARCHAR(50);
	Prom NUMBER;
	
BEGIN
	OPEN lista_departamentos;
	LOOP
	FETCH lista_departamentos INTO idDepa,Ndepa,Prom;
	EXIT WHEN lista_departamentos%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE('Nombre:' || Ndepa || ', Promedio salario:' || Prom);
	END LOOP;
	CLOSE lista_departamentos;
EXCEPTION
	WHEN OTHERS THEN
 	DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/