-- Insertar un nuevo cliente
INSERT INTO Clientes (ClienteID, Nombre, Ciudad, FechaNacimiento) 
VALUES (4, 'Carlos Ruiz', 'Concepción', TO_DATE('1992-07-18', 'YYYY-MM-DD'));

-- Insertar un nuevo pedido para el cliente recién agregado
INSERT INTO Pedidos (PedidoID, ClienteID, Total, FechaPedido) 
VALUES (104, 4, 450, TO_DATE('2025-04-10', 'YYYY-MM-DD'));

-- Confirmar los cambios
COMMIT;