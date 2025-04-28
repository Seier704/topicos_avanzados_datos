--Escribe un bloque PL/SQL con un cursor explícito que reduzca
--un 5% el presupuesto de los proyectos que tienen un
--presupuesto mayor a 1500000. Usa FOR UPDATE y maneja
--excepciones.

DECLARE
	CURSOR reduccion_proyecto IS
	SELECT ProyectoID,Nombre,Presupuesto
	FROM Proyectos
	WHERE Presupuesto > 1500000
	FOR UPDATE;
	proyectoID NUMBER;
	nombreP VARCHAR(50);
	presupuestoP NUMBER;

BEGIN 
	OPEN reduccion_proyecto;
	LOOP
	FETCH reduccion_proyecto INTO proyectoID,nombreP,presupuestoP;
	EXIT WHEN reduccion_proyecto%NOTFOUND;
	UPDATE Proyectos
	SET Presupuesto = presupuestoP * 0.95
	WHERE CURRENT OF reduccion_proyecto;
	DBMS_OUTPUT.PUT_LINE('Proyecto ID:' || proyectoID || ', Nombre:' || nombreP || ', Actualizado a:' || (presupuestoP*0.95));
	END LOOP;
	CLOSE reduccion_proyecto;

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

COMMIT;