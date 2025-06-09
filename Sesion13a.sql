--Creo INventario
BEGIN
  EXECUTE IMMEDIATE '
    CREATE TABLE Inventario (
      ProductoID NUMBER PRIMARY KEY,
      CantidadDisponible NUMBER NOT NULL
    )
  ';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -955 THEN -- ORA-00955: tabla ya existe
      NULL; -- tabla ya existe, no hacemos nada
    ELSE
      RAISE;
    END IF;
END;
/

--Codigo Pedido

CREATE OR REPLACE PROCEDURE actualizar_inventario_pedido(p_PedidoID IN NUMBER) IS
  CURSOR cur_detalles IS
    SELECT ProductoID, Cantidad
    FROM DetallesPedidos
    WHERE PedidoID = p_PedidoID;

  v_producto_id DetallesPedidos.ProductoID%TYPE;
  v_cantidad_detalle DetallesPedidos.Cantidad%TYPE;
  v_cantidad_inventario Inventario.CantidadDisponible%TYPE;

  -- Savepoint para manejo de errores
  savepoint_before_update VARCHAR2(30);

BEGIN
  -- Crear savepoint
  SAVEPOINT sp_before_update;

  FOR rec IN cur_detalles LOOP
    v_producto_id := rec.ProductoID;
    v_cantidad_detalle := rec.Cantidad;

    -- Obtener cantidad disponible en inventario
    SELECT CantidadDisponible INTO v_cantidad_inventario
    FROM Inventario
    WHERE ProductoID = v_producto_id
    FOR UPDATE;

    -- Verificar si hay suficiente inventario
    IF v_cantidad_inventario < v_cantidad_detalle THEN
      -- No hay suficiente stock, revertir cambios
      ROLLBACK TO SAVEPOINT sp_before_update;
      RAISE_APPLICATION_ERROR(-20010, 
        'No hay suficiente inventario para el ProductoID ' || v_producto_id);
    ELSE
      -- Actualizar inventario restando cantidad pedida
      UPDATE Inventario
      SET CantidadDisponible = CantidadDisponible - v_cantidad_detalle
      WHERE ProductoID = v_producto_id;
    END IF;
  END LOOP;

  -- Confirmar cambios (commit)
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    ROLLBACK TO SAVEPOINT sp_before_update;
    RAISE_APPLICATION_ERROR(-20011, 'Producto no encontrado en Inventario.');
  WHEN OTHERS THEN
    ROLLBACK TO SAVEPOINT sp_before_update;
    RAISE;
END actualizar_inventario_pedido;
/
