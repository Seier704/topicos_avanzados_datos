--1. Escribe un procedimiento registrar_movimiento que reciba un
--ProductoID, TipoMovimiento ('Entrada' o 'Salida'), y
--Cantidad (parámetros IN). El procedimiento debe:
--○ Insertar un nuevo movimiento en la tabla Movimientos (usa
--el próximo MovimientoID disponible).
--○ Actualizar la cantidad en Inventario según el tipo de
--movimiento.
--○ Actualizar la FechaActualizacion en Inventario a la fecha
--actual.
--○ Manejar excepciones si el producto no existe o si la
--cantidad en inventario se vuelve negativa.

CREATE PROCEDURE registrar_movimiento (
    @ProductoID INT,
    @TipoMovimiento VARCHAR(10),
    @Cantidad INT
)
AS
BEGIN
    -- Desactiva el conteo de filas afectadas para no interferir con el resultado
    SET NOCOUNT ON;

    DECLARE @CantidadActual INT;

    -- Inicia una transacción para asegurar la integridad de los datos
    BEGIN TRANSACTION;

    -- Verifica si el producto existe en el inventario
    IF NOT EXISTS (SELECT 1 FROM Inventario WHERE ProductoID = @ProductoID)
    BEGIN
        -- Si no existe, cancela la transacción y lanza un error
        ROLLBACK TRANSACTION;
        THROW 50001, 'Error: El producto especificado no existe.', 1;
        RETURN;
    END

    -- Obtiene la cantidad actual del producto en inventario
    SELECT @CantidadActual = Cantidad FROM Inventario WHERE ProductoID = @ProductoID;

    -- Procesa el tipo de movimiento
    IF @TipoMovimiento = 'Entrada'
    BEGIN
        -- Actualiza la cantidad en el inventario sumando la nueva cantidad
        UPDATE Inventario
        SET
            Cantidad = Cantidad + @Cantidad,
            FechaActualizacion = GETDATE()
        WHERE ProductoID = @ProductoID;
    END
    ELSE IF @TipoMovimiento = 'Salida'
    BEGIN
        -- Verifica si hay suficiente stock para la salida
        IF @CantidadActual < @Cantidad
        BEGIN
            -- Si no hay suficiente stock, cancela la transacción y lanza un error
            ROLLBACK TRANSACTION;
            THROW 50002, 'Error: La cantidad en inventario no puede ser negativa.', 1;
            RETURN;
        END

        -- Actualiza la cantidad en el inventario restando la cantidad
        UPDATE Inventario
        SET
            Cantidad = Cantidad - @Cantidad,
            FechaActualizacion = GETDATE()
        WHERE ProductoID = @ProductoID;
    END
    ELSE
    BEGIN
        -- Si el tipo de movimiento no es válido, cancela la transacción y lanza un error
        ROLLBACK TRANSACTION;
        THROW 50003, 'Error: El tipo de movimiento especificado no es válido. Use ''Entrada'' o ''Salida''.', 1;
        RETURN;
    END

    -- Inserta el nuevo movimiento en la tabla de Movimientos
    INSERT INTO Movimientos (ProductoID, TipoMovimiento, Cantidad, FechaMovimiento)
    VALUES (@ProductoID, @TipoMovimiento, @Cantidad, GETDATE());

    -- Confirma la transacción si todas las operaciones fueron exitosas
    COMMIT TRANSACTION;

    -- Reactiva el conteo de filas afectadas
    SET NOCOUNT OFF;
END;


--2. Escribe una función calcular_valor_inventario_proveedor que
--reciba un ProveedorID (parámetro IN) y devuelva el valor
--total del inventario de los productos de ese proveedor (suma
--de Precio * Cantidad). Luego, usa la función en un
--procedimiento mostrar_valor_proveedor que muestre el valor
--total del inventario por proveedor para todos los
--proveedores.

CREATE FUNCTION calcular_valor_inventario_proveedor (
    @ProveedorID INT
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @ValorTotal DECIMAL(18, 2);

    SELECT @ValorTotal = SUM(P.Precio * I.Cantidad)
    FROM Productos AS P
    INNER JOIN Inventario AS I ON P.ProductoID = I.ProductoID
    WHERE P.ProveedorID = @ProveedorID;

    -- Si el proveedor no tiene productos, retorna 0
    IF @ValorTotal IS NULL
        SET @ValorTotal = 0;

    RETURN @ValorTotal;
END;

--3. Crea un trigger auditar_movimientos que se dispare después
--de insertar o eliminar un movimiento en la tabla Movimientos
--y registre el MovimientoID, ProductoID, TipoMovimiento,
--Cantidad, la acción ('INSERT' o 'DELETE') y la fecha en una
--tabla de auditoría AuditoriaMovimientos.

CREATE TABLE AuditoriaMovimientos (
    AuditoriaID INT PRIMARY KEY IDENTITY(1,1),
    MovimientoID INT,
    ProductoID INT,
    TipoMovimiento VARCHAR(10),
    Cantidad INT,
    Accion VARCHAR(10),
    FechaAuditoria DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER auditar_movimientos
ON Movimientos
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Captura de inserciones
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AuditoriaMovimientos (MovimientoID, ProductoID, TipoMovimiento, Cantidad, Accion)
        SELECT
            i.MovimientoID,
            i.ProductoID,
            i.TipoMovimiento,
            i.Cantidad,
            'INSERT'
        FROM
            inserted i;
    END

    -- Captura de eliminaciones
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO AuditoriaMovimientos (MovimientoID, ProductoID, TipoMovimiento, Cantidad, Accion)
        SELECT
            d.MovimientoID,
            d.ProductoID,
            d.TipoMovimiento,
            d.Cantidad,
            'DELETE'
        FROM
            deleted d;
    END
END;


