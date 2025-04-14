SELECT * FROM Clientes
WHERE REGEXP_LIKE(Nombre, '^M');

SELECT * FROM Clientes
WHERE REGEXP_LIKE(Ciudad, 'o$');