--Crea un trigger auditar_movimientos que se dispare después
--de insertar o eliminar un movimiento en la tabla Movimientos
--y registre el MovimientoID, ProductoID, TipoMovimiento,
--Cantidad, la acción ('INSERT' o 'DELETE') y la fecha en una
--tabla de auditoría AuditoriaMovimientos.

CREATE TABLE AuditoriaMovimientos (
AuditoriaID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
MovimientoID NUMBER,
ProductoID NUMBER,
TipoMovimiento VARCHAR2,
Cantidad NUMBER,
FechaMovimiento DATE
);
-- Crear trigger
CREATE OR REPLACE TRIGGER auditar_movimientos
AFTER DELETE OR INSERT ON Movimientos
FOR EACH ROW
BEGIN
INSERT INTO AuditoriaMovimientos (MovimientoID, ProductoID, TipoMovimiento,Cantidad, FechaMovimiento)
VALUES (:OLD.MovimientoID, :OLD.ProductoID, :OLD.TipoMovimiento,:OLD.Cantidad, SYSDATE);
END;
/
-- Prueba
DELETE FROM Movimientos WHERE ProductoID = 102;
SELECT * FROM AuditoriaMovimientos;