--1. Diseña un modelo NoSQL para el esquema
--curso_topicos. Documenta en comentarios cómo
--estructurarías los datos en MongoDB (por ejemplo,
--qué datos embebes y por qué). Proporciona un
--ejemplo de un documento.

-- Modelo NoSQL para curso_topicos
-- Colección: clientes
-- - Embeber los Pedidos y DetallesPedidos en el documento del cliente
-- - Embeber los datos de Productos en Detalles para evitar consultas adicionales
-- - Motivo: Reducir la necesidad de JOINs y mejorar el rendimiento en consultas frecuentes
-- - Nota: Si los productos cambian frecuentemente, podría ser mejor mantenerlos en una colección
separada
-- Ejemplo de documento en la colección clientes
{
 "ClienteID": 1,
 "Nombre": "Juan Pérez",
 "Ciudad": "Santiago",
 "FechaNacimiento": "1990-05-15",
 "Pedidos": [
{
 "PedidoID": 101,
 "Total": 2272.5,
 "FechaPedido": "2025-03-01",
 "Detalles": [
 { "ProductoID": 1, "Nombre": "Laptop", "Precio": 1200, "Cantidad": 2 },
 { "ProductoID": 2, "Nombre": "Mouse", "Precio": 25, "Cantidad": 5 }
 ]
}
 ]
}
--2. Escribe dos consultas en MongoDB:
--a. Una para obtener los clientes de una ciudad
--específica (por ejemplo, Santiago).
--b. Otra para calcular el número total de
--productos vendidos por producto.

{
  "_id": ObjectId("..."),
  "nombre": "Juan Pérez",
  "email": "juan.perez@example.com",
  "ciudad": "Santiago",
  "pais": "Chile"
}

{
  "_id": ObjectId("..."),
  "cliente_id": ObjectId("..."), // Referencia al cliente que hizo la orden
  "fecha_orden": ISODate("..."),
  "productos": [
    {
      "producto_id": ObjectId("..."), // Referencia al producto
      "nombre_producto": "Laptop XYZ",
      "cantidad": 1,
      "precio_unitario": 1200
    },
    {
      "producto_id": ObjectId("..."),
      "nombre_producto": "Mouse Inalámbrico",
      "cantidad": 2,
      "precio_unitario": 25
    }
  ],
  "total": 1250
}

db.clientes.find({ "ciudad": "Santiago" });

db.ordenes.aggregate([
  {
    $unwind: "$productos" // Descompone el array 'productos' en documentos separados
  },
  {
    $group: {
      _id: "$productos.nombre_producto", // Agrupa por el nombre del producto
      total_vendido: { $sum: "$productos.cantidad" } // Suma la cantidad de cada producto
    }
  },
  {
    $sort: { total_vendido: -1 } // Opcional: Ordena los resultados de mayor a menor cantidad vendida
  }
]);
