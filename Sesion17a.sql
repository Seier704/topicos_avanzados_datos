CREATE USER user_analista IDENTIFIED BY analista123;

-- Asignar permisos básicos para que pueda iniciar sesión
GRANT CREATE SESSION TO user_analista;

CREATE ROLE rol_analista;

-- Dar permiso SELECT sobre todas las tablas del esquema curso_topicos
BEGIN
   FOR t IN (
      SELECT table_name 
      FROM all_tables 
      WHERE owner = 'CURSO_TOPICOS'
   ) LOOP
      EXECUTE IMMEDIATE 'GRANT SELECT ON curso_topicos.' || t.table_name || ' TO rol_analista';
   END LOOP;
END;
/

-- Permitir INSERT solo en la tabla Pedidos
GRANT INSERT ON curso_topicos.Pedidos TO rol_analista;


GRANT rol_analista TO user_analista;

-- Conectarse como user_analista (según la herramienta que uses: SQL*Plus, SQL Developer, etc.)

-- Prueba de SELECT (debería funcionar)
SELECT * FROM curso_topicos.Productos;

-- Prueba de INSERT (debería funcionar)
INSERT INTO curso_topicos.Pedidos (PedidoID, ClienteID, FechaPedido)
VALUES (1001, 1, SYSDATE);

-- Prueba de UPDATE (debería fallar, no se concedió UPDATE)
UPDATE curso_topicos.Pedidos SET FechaPedido = SYSDATE WHERE PedidoID = 1001;
