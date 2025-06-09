--Crea un paquete gestion_clientes con:
--○ Un procedimiento registrar_cliente que reciba
--ClienteID, Nombre, Ciudad y FechaNacimiento, y
--valide que la fecha de nacimiento sea anterior a
--la fecha actual.
--○ Una función obtener_edad que reciba un ClienteID
--y devuelva la edad del cliente.
--○ Usa una variable global para contar los clientes
--registrados

CREATE OR REPLACE PACKAGE gestion_clientes AS

  -- Excepción personalizada
  e_fecha_invalida EXCEPTION;

  -- Variable global para contar clientes registrados
  contador_clientes NUMBER := 0;

  -- Procedimiento para registrar clientes
  PROCEDURE registrar_cliente(
    cliente_id     IN NUMBER,
    nombre         IN VARCHAR2,
    ciudad         IN VARCHAR2,
    fecha_nac      IN DATE
  );

  -- Función para obtener la edad de un cliente por su ID
  FUNCTION obtener_edad(
    cliente_id IN NUMBER
  ) RETURN NUMBER;

END gestion_clientes;
/


CREATE OR REPLACE PACKAGE BODY gestion_clientes AS

  -- Procedimiento para registrar un cliente
  PROCEDURE registrar_cliente(
    cliente_id     IN NUMBER,
    nombre         IN VARCHAR2,
    ciudad         IN VARCHAR2,
    fecha_nac      IN DATE
  ) IS
  BEGIN
    -- Validar que la fecha de nacimiento es anterior a la actual
    IF fecha_nac >= SYSDATE THEN
      RAISE e_fecha_invalida;
    END IF;

    -- Insertar en la tabla Clientes
    INSERT INTO Clientes(ClienteID, Nombre, Ciudad, FechaNacimiento)
    VALUES (cliente_id, nombre, ciudad, fecha_nac);

    -- Incrementar contador global
    contador_clientes := contador_clientes + 1;
  EXCEPTION
    WHEN e_fecha_invalida THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: La fecha de nacimiento debe ser anterior a la actual.');
  END;

  -- Función que obtiene la edad del cliente
  FUNCTION obtener_edad(
    cliente_id IN NUMBER
  ) RETURN NUMBER IS
    fecha_nac DATE;
    edad NUMBER;
  BEGIN
    -- Obtener fecha de nacimiento del cliente
    SELECT FechaNacimiento INTO fecha_nac
    FROM Clientes
    WHERE ClienteID = cliente_id;

    -- Calcular la edad en años
    edad := TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nac) / 12);

    RETURN edad;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Cliente no encontrado.');
      RETURN NULL;
  END;

END gestion_clientes;
/


-- Registrar cliente válido
BEGIN
  gestion_clientes.registrar_cliente(1, 'Juan Pérez', 'Santiago', TO_DATE('1995-01-15', 'YYYY-MM-DD'));
END;
/

-- Obtener edad del cliente
SELECT gestion_clientes.obtener_edad(1) AS Edad FROM dual;

-- Ver el contador de clientes registrados
-- Esto solo se puede ver dentro de una sesión PL/SQL o paquete
BEGIN
  DBMS_OUTPUT.PUT_LINE('Clientes registrados: ' || gestion_clientes.contador_clientes);
END;
/

	