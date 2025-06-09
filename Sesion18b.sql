CREATE OR REPLACE PACKAGE gestion_clientes AS

  -- Excepciones personalizadas
  e_fecha_invalida EXCEPTION;
  e_edad_invalida EXCEPTION;

  -- Variable global
  contador_clientes NUMBER := 0;

  -- Procedimiento
  PROCEDURE registrar_cliente(
    cliente_id IN NUMBER,
    nombre     IN VARCHAR2,
    ciudad     IN VARCHAR2,
    fecha_nac  IN DATE
  );

  -- Función
  FUNCTION obtener_edad(
    cliente_id IN NUMBER
  ) RETURN NUMBER;

END gestion_clientes;
/

CREATE OR REPLACE PACKAGE BODY gestion_clientes AS

  -- Procedimiento para registrar cliente
  PROCEDURE registrar_cliente(
    cliente_id IN NUMBER,
    nombre     IN VARCHAR2,
    ciudad     IN VARCHAR2,
    fecha_nac  IN DATE
  ) IS
    edad NUMBER;
  BEGIN
    -- Validar que la fecha de nacimiento es válida
    IF fecha_nac >= SYSDATE THEN
      RAISE e_fecha_invalida;
    END IF;

    -- Calcular edad
    edad := TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nac) / 12);

    -- Validar que la edad sea al menos 18 años
    IF edad < 18 THEN
      RAISE e_edad_invalida;
    END IF;

    -- Insertar cliente
    INSERT INTO Clientes(ClienteID, Nombre, Ciudad, FechaNacimiento)
    VALUES (cliente_id, nombre, ciudad, fecha_nac);

    contador_clientes := contador_clientes + 1;

  EXCEPTION
    WHEN e_fecha_invalida THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: La fecha de nacimiento no puede ser futura.');
    WHEN e_edad_invalida THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: El cliente debe tener al menos 18 años.');
  END;

  -- Función para calcular edad
  FUNCTION obtener_edad(
    cliente_id IN NUMBER
  ) RETURN NUMBER IS
    fecha_nac DATE;
  BEGIN
    SELECT FechaNacimiento INTO fecha_nac
    FROM Clientes
    WHERE ClienteID = cliente_id;

    RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nac) / 12);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Cliente no encontrado.');
      RETURN NULL;
  END;

END gestion_clientes;
/

-- Cliente con 15 años
BEGIN
  gestion_clientes.registrar_cliente(
    cliente_id => 2,
    nombre     => 'Ana Joven',
    ciudad     => 'Valparaíso',
    fecha_nac  => TO_DATE('2010-05-10', 'YYYY-MM-DD')
  );
END;
/


BEGIN
  gestion_clientes.registrar_cliente(
    cliente_id => 3,
    nombre     => 'Carlos Adulto',
    ciudad     => 'Santiago',
    fecha_nac  => TO_DATE('1990-08-20', 'YYYY-MM-DD')
  );
END;
/
