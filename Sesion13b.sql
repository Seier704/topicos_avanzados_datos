CREATE TABLE Dim_Ciudad (
    CiudadID NUMBER PRIMARY KEY,
    NombreCiudad VARCHAR2(100),
    Region VARCHAR2(100),        -- Ejemplo adicional para info regional
    Pais VARCHAR2(50)
);

CREATE TABLE Fact_Pedidos (
    PedidoID NUMBER PRIMARY KEY,
    CiudadID NUMBER,
    FechaPedido DATE,
    TotalVenta NUMBER(12,2),
    CantidadTotal NUMBER,
    CONSTRAINT fk_ciudad FOREIGN KEY (CiudadID) REFERENCES Dim_Ciudad(CiudadID)
);

SELECT 
    dc.NombreCiudad,
    EXTRACT(YEAR FROM fp.FechaPedido) AS Anio,
    SUM(fp.TotalVenta) AS TotalVentas
FROM 
    Fact_Pedidos fp
JOIN 
    Dim_Ciudad dc ON fp.CiudadID = dc.CiudadID
GROUP BY 
    dc.NombreCiudad,
    EXTRACT(YEAR FROM fp.FechaPedido)
ORDER BY 
    dc.NombreCiudad,
    Anio;
