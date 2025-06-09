SHOW PARAMETER audit_trail;

ALTER SYSTEM SET audit_trail = DB SCOPE=SPFILE;

SHUTDOWN IMMEDIATE;
STARTUP;

AUDIT SELECT ON curso_topicos.Clientes BY user_analista BY ACCESS;

AUDIT INSERT ON curso_topicos.Pedidos BY user_analista BY ACCESS;

-- Acción SELECT auditada
SELECT * FROM curso_topicos.Clientes WHERE ROWNUM = 1;

-- Acción INSERT auditada
INSERT INTO curso_topicos.Pedidos (PedidoID, ClienteID, FechaPedido)
VALUES (9999, 1, SYSDATE);

-- Consultar auditoría
SELECT
   username,
   obj_name,
   action_name,
   timestamp
FROM
   dba_audit_trail
WHERE
   username = 'USER_ANALISTA'
ORDER BY timestamp DESC;
