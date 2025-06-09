CREATE OR REPLACE TRIGGER validar_cantidad_detalle
BEFORE INSERT OR UPDATE ON DetallesPedidos
FOR EACH ROW
BEGIN
  IF :NEW.Cantidad <= 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error: La cantidad debe ser mayor a 0.');
  END IF;
END;
/