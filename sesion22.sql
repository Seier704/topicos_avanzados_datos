--1. Diseña (sin script) una estrategia de alta
--disponibilidad para el esquema curso_topicos:
--○ Número de nodos y su ubicación geográfica.
--○ Tipo de replicación (síncrona o asíncrona).
--○ Uso de los nodos secundarios (por ejemplo, para
--reportes).
--○ Mecanismo de failover.

-- Estrategia de Alta Disponibilidad para curso_topicos
-- - Nodos:
-- * Nodo principal: Santiago, Chile
-- * Nodo standby: Valparaíso, Chile
-- - Replicación: Asíncrona con Oracle Data Guard
-- * Motivo: Menor latencia en el nodo principal, aceptable para este sistema
-- - Uso del nodo standby:
-- * Consultas de solo lectura (reportes de ventas) usando Active Data Guard
-- - Failover:
-- * Configurar Fast-Start Failover para cambio automático al nodo standby
-- * MTTR objetivo: 5 minutos
-- - Consideraciones:
-- * Respaldo completo semanal y archivelogs diarios (integrado con la estrategia
--de Sesión 22)
-- * Monitoreo: Usar Oracle Enterprise Manager para alertas de fallos

--2. Escribe una consulta de solo lectura que podría
--ejecutarse en el nodo standby para generar un
--reporte de ventas por cliente. Explica cómo
--aprovecharías Active Data Guard

-- Reporte de ventas totales agrupadas por cliente
SELECT
    c.NombreCliente,
    c.Email,
    COUNT(v.VentaID) AS NumeroDePedidos,
    SUM(dv.Cantidad * dv.PrecioUnitario) AS MontoTotalVendido
FROM
    Clientes c
JOIN
    Ventas v ON c.ClienteID = v.ClienteID
JOIN
    DetallesVenta dv ON v.VentaID = dv.VentaID
GROUP BY
    c.ClienteID, c.NombreCliente, c.Email
ORDER BY
    MontoTotalVendido DESC;

--Active Data Guard es una funcionalidad de Oracle Database que permite que una base de datos física de respaldo (standby) esté abierta en modo de solo lectura mientras recibe y aplica continuamente los cambios desde la base de datos principal (primaria).
