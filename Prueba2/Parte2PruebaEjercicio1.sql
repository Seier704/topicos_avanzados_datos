--Escribe un procedimiento registrar_movimiento que reciba un
--ProductoID, TipoMovimiento ('Entrada' o 'Salida'), y
--Cantidad (parámetros IN). El procedimiento debe:
--Insertar un nuevo movimiento en la tabla Movimientos (usa
--el próximo MovimientoID disponible).
--Actualizar la cantidad en Inventario según el tipo de
--movimiento.
--Actualizar la FechaActualizacion en Inventario a la fecha
--actual.
--Manejar excepciones si el producto no existe o si la
--cantidad en inventario se vuelve negativa.

CREATE OR REPLACE PROCEDURE registrar_movimiento (
    Movimiento IN NUMBER,
    ProductoID IN NUMBER,
    TipoMovimientos IN VARCHAR2,
    CantidadT IN NUMBER
) AS
    v_cantidad_actual NUMBER;
BEGIN
    SELECT Cantidad INTO v_cantidad_actual
    FROM Inventario
    WHERE ProductoID = ProductoID;

    IF TipoMovimientos = 'Entrada' THEN

        UPDATE Inventario
        SET Cantidad = v_cantidad_actual + CantidadT,
            FechaActualizacion = SYSDATE
        WHERE ProductoID = ProductoID;

        INSERT INTO Movimientos (MovimientoID,ProductoID, TipoMovimiento, Cantidad, FechaMovimiento)
        VALUES (Movimiento,ProductoID, TipoMovimientos, CantidadT, SYSDATE);

    ELSIF TipoMovimientos = 'Salida' THEN
        IF v_cantidad_actual >= CantidadT THEN
            UPDATE Inventario
            SET Cantidad = v_cantidad_actual - CantidadT,
                FechaActualizacion = SYSDATE
            WHERE ProductoID = ProductoID;

            INSERT INTO Movimientos (MovimientoID,ProductoID, TipoMovimiento, Cantidad, FechaMovimiento)
            VALUES (Movimiento,ProductoID, TipoMovimientos, CantidadT, SYSDATE);
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Cantidad insuficiente en inventario para salida.');
        END IF;

    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Tipo de movimiento inválido. Debe ser Entrada o Salida.');
    END IF;
END;
/
	
	
	