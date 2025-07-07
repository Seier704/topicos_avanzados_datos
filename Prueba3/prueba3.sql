--1. Explica qué es una transacción en una base de datos y describe
--a través de un ejemplo cómo usarías savepoints para manejar
--errores parciales en un procedimiento que registra horas
--trabajadas en RegistrosTiempo.
--R: Una transacción en una base de datos es un conjunto de operaciones tipo INSERT,UPDATE,DELETE que tiene
--Propiedades ACID(Atomicidad,Consistencia,Aislamiento,Durabilidad).


CREATE TABLE RegistrosTiempo (
    id INT PRIMARY KEY,
    empleado_id INT,
    fecha DATE,
    horas_trabajadas DECIMAL(5,2)
);

--Con ese ejemplo simple supongamos que tenemos un procedimiento que registra horas trabajadas por muchos empleados
--Solo con ocurrir un errar al insertar dicho registro se debe revertir esa inserción pero mantener los demás
--registros validos.
--Ejemplo se inserta el registro del empleado 25, el registro del empleado 26 da error por ende se revierte esa
--parte, el siguiente 27 se guarda si no hay problema y la transacción general no se aborta.



--2. ¿Qué es un Data Warehouse y cómo se diferencia de una base de
--datos transaccional? Describe cómo diseñarías una tabla de
--hechos para analizar las horas trabajadas por proyecto en la
--base de datos de la prueba.



--R: Sistema de almacenamiento de datos donde la importancia de esta es la toma de decisiones y análisis,
--reuniendo información desde multiples fuentes para que se pueda facilitar las consultas complejas y 
--reportes, La gran diferencia de una base de datos transaccional es que esta está diseñada para operaciones
--diarias y rápidas,en cuanto a datawarehouse es para grandes volúmenes.

--Tenemos una tabla de hechos_horas_trabajadas
--tenemos nuestras primary keys que son EmpleadoId,ProyectoID,horas_trabajadas,Fechaid donde tenemos nuestro tipo 
--de dato para cada uno con su dimensión(dim_empleado,dim_proyecto,dim_fecha,...) nos permitirá hacer un 
--análisis de horas trabajadas por empleado y mes, horas por proyecto en un año,mes,etc, comparar cargas laborales
--entre otros.

CREATE TABLE Fact_HorasTrabajadasTeoria (
	FactID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	ProyectoID NUMBER,
	EmpleadoID NUMBER,
	Fecha DATE,
	HorasTrabajadas NUMBER(5,2)
);

CREATE TABLE Dim_ProyectoTeoria(
	ProyectoID NUMBER PRIMARY KEY,
	NombreProyecto VARCHAR2(100),
	Presupuesto NUMBER(15,2),
	FechaInicio DATE,
	FechaFin DATE
);


--3. Explica cómo se implementa la herencia en Oracle usando tipos
--de objetos. Da un ejemplo de una jerarquía de tipos para
--modelar empleados (Empleado → Desarrollador) en la base de
--datos de la prueba.

--R: La herencia en Oracle se implementa creando los objetos con su clausula UNDER. Nos permitirá crear
-- un tipo que hereda atributos,metodos de su padre.
--Tenemos nuestro padre con ciertos atributos, creando después un subtipo o hijo que hereda todo lo del padre
--pero a este hijo se le pueden agregar nuevos atributos o métodos, dando asi modelar jerarquías y reutilizar 
--estructuras.

-- Crear tabla para empleados (base para herencia)
CREATE TABLE Empleados (
    EmpleadoID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nombre VARCHAR2(100),
    TipoEmpleado VARCHAR2(50), -- Para simular herencia (Desarrollador, etc.)
    Salario NUMBER(10,2)
)NOT FINAL; -- Este es importante dado que nos permite que otros tipos hereden de Empleados.

--Creamos un subtipo
--Donde desarrollador hereda de empleado y le agregaremos que tipo de lenguaje de programación ocupa
créate or replace type Desarrolador UNDER Empleado (
	LenguajeProgramacion varchar2(50)
);

--4. Describe las ventajas y desventajas de usar índices y
--particiones en una base de datos. ¿Cómo usarías un índice y
--una partición para mejorar el rendimiento de consultas en la
--tabla RegistrosTiempo?


--R: Las ventajas para usar índices es que aceleran las consultas tanto de joins como filtros, mejorando su
--rendimiento, reduciendo su costo de ejecución, PERO, su desventaja es que tiene un mayor costo para
--actualizaciones, uso adicional de espacio y en caso de que se implemente mal, perjudicara el rendimiento.
--Para las particiones sus ventajas son dividir la tabla en fragmentos pequeños(rango fecha,dias,mes,etc) 
--acelerando consultas a subconjuntos. Mejora rendimiento en bases de datos masivos y su mantenimiento es 
--eficiente, La complejidad que tiene es que es mas difícil de entender su diseño, y no siempre pueden ser
--necesarias.

--Para registro de tiempo mejoraría su rendimiento particionando mediante su mes 

PARTITION BY RANGE (Fecha) (
    PARTITION p2025_01 VALUES LESS THAN (TO_DATE('2025-02-01', 'YYYY-MM-DD')),
    PARTITION p2025_02 VALUES LESS THAN (TO_DATE('2025-03-01', 'YYYY-MM-DD')),
    PARTITION p2025_03 VALUES LESS THAN (TO_DATE('2025-04-01', 'YYYY-MM-DD')),
    PARTITION p_max VALUES LESS THAN (MAXVALUE)
);

-- y crearía un índice por la asignación y su fecha
create index idx_regtiempo_asignacion_fecha
on RegistrosTiempo(AsignacionID, Fecha);

--Parte 2 Prueba


--1. Escribe un procedimiento registrar_tiempo que reciba un
--AsignacionID, Fecha y HorasTrabajadas (parámetros IN). El
--procedimiento debe
--○ Insertar un nuevo registro en RegistrosTiempo (usa el
--próximo RegistroID disponible).
--○ Validar que las horas no excedan 8 por día para esa
--asignación.
--○ Usar savepoints para manejar errores (por ejemplo, si las
--horas exceden el límite).
--○ Manejar excepciones y transacciones adecuadamente.

CREATE OR REPLACE PROCEDURE registrar_tiempo (
	asignacion_id IN NUMBER,
	fecha IN DATE,
	horas IN NUMBER
) IS
	total_horas NUMBER(5,2);
BEGIN
	SAVEPOINT antes_de_insertar;
	
	SELECT NVL(SUM(HorasTrabajadas), 0)
	INTO total_horas
	FROM RegistrosTiempo
	WHERE AsignacionID = asignacion_id AND Fecha = fecha;
	
	IF total_horas + horas > 8 THEN
		RAISE_APPLICATION_ERROR(-20001, 'Horas exceden limite diario.');
	END IF;

	INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas)
	VALUES (asignacion_id, fecha, horas);
	
	COMMIT;

EXCEPTION 
	WHEN OTHERS THEN
		ROLLBACK TO antes_de_insertar;
		DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--2. Diseña una tabla de hechos Fact_HorasTrabajadas y una
--dimensión Dim_Proyecto para un Data Warehouse basado en la
--base de datos de la prueba. Escribe una consulta analítica
--que muestre las horas totales trabajadas por proyecto y mes.


CREATE TABLE Fact_HorasTrabajadas (
	FactID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	ProyectoID NUMBER,
	EmpleadoID NUMBER,
	Fecha DATE,
	HorasTrabajadas NUMBER(5,2)
);

CREATE TABLE Dim_Proyecto(
	ProyectoID NUMBER PRIMARY KEY,
	NombreProyecto VARCHAR2(100),
	Presupuesto NUMBER(15,2),
	FechaInicio DATE,
	FechaFin DATE
);

INSERT INTO Fact_HorasTrabajadas (ProyectoID, EmpleadoID, Fecha, HorasTrabajadas)
SELECT
    a.ProyectoID,
    a.EmpleadoID,
    rt.Fecha,
    rt.HorasTrabajadas
FROM
    RegistrosTiempo rt
JOIN
    Asignaciones a ON rt.AsignacionID = a.AsignacionID;

--Crea un índice compuesto en RegistrosTiempo para las
columnas AsignacionID y Fecha. Luego, particiona la tabla
RegistrosTiempo por rango de fechas (mensual, para 2025).
Escribe una consulta que muestre las horas trabajadas por
asignación en marzo de 2025 y analiza su plan de ejecución.

create index idx_regtiempo_asignacion_fecha
on RegistrosTiempo(AsignacionID, Fecha);

CREATE TABLE RegistrosTiempo (
    id INT PRIMARY KEY,
    empleado_id INT,
    fecha DATE,
    horas_trabajadas DECIMAL(5,2)
)

PARTITION BY RANGE (fecha) (
    PARTITION p2025_01 VALUES LESS THAN (TO_DATE('2025-02-01', 'YYYY-MM-DD')),
    PARTITION p2025_02 VALUES LESS THAN (TO_DATE('2025-03-01', 'YYYY-MM-DD')),
    PARTITION p2025_03 VALUES LESS THAN (TO_DATE('2025-04-01', 'YYYY-MM-DD')),
    PARTITION p_max VALUES LESS THAN (MAXVALUE)
);


