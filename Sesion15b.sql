CREATE TABLE Ventas (

	id INT NOT NULL,
	ClienteID INT NOT NULL,
	detallePedido VARCHAR(30),
	ciudad	VARCHAR(30),
	Fecha DATE
)

PARTITION BY HASH(ClienteID)
PARTITIONS 4;

SELECT 
    PARTITION_NAME, 
    COUNT(*) AS Registros
FROM 
    USER_TAB_PARTITIONS p
JOIN 
    TABLE(
        SELECT /*+ dynamic_sampling(4) */ * FROM Ventas
    ) v 
    ON MOD(v.ClienteID, 4) = TO_NUMBER(SUBSTR(p.PARTITION_NAME, -1))
GROUP BY PARTITION_NAME;

SELECT 
    ClienteID,
    DUMP(ROWID) AS RawRowID
FROM Ventas;
