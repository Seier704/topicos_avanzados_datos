DECLARE
	v_total NUMBER;
BEGIN

	SELECT Precio INTO v_total
	FROM Productos;


	IF v_total > 2999 THEN
 	DBMS_OUTPUT.PUT_LINE('Precio grande: ' || v_total);
	ELSIF v_total > 700 THEN
 	DBMS_OUTPUT.PUT_LINE('Precio mediano: ' || v_total);
	ELSE
	DBMS_OUTPUT.PUT_LINE('Precio pequeño: ' || v_total);
	END IF;


END;
/