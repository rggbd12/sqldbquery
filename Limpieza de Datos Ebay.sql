use clean;
Select * INTO  copia from productos;
select * from copia;
---------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA BRAND*/
SELECT DISTINCT BRAND, TRIM(replace(BRAND,'Dell Inc.','Dell'))
FROM productos 
WHERE Brand LIKE 'Dell%';

/*ACTUALIZAR MARCA DELL*/
UPDATE productos SET BRAND = 'Dell'
WHERE Brand LIKE 'Dell%';
-------------------------------------------------------------------------------------------------------------------

/*TRABAJAR EN LA COLUMNA PRICE*/
SELECT * FROM productos;
-- CREAMOS COLUMNA PRECIO
ALTER TABLE productos add Precio decimal (5,2);
-- EXTRAER SOLO EL PRECIO SE UTILIZA LEADING PARA EXTRAER EL VALOR ASIGNADO DE LADO DERECHO Y CAST PARA TIPO DE DATO
SELECT TRY_CAST( TRIM(TRIM(LEADING ',' FROM Right(Price,6))) AS decimal(5,2)) FROM productos;
-- SE ACTUALIZA LOS DATOS EN LA NUEVA COLUMNA CREADA CON SU TIPO DE DATO DECIMAL
UPDATE productos SET Precio = TRY_CAST( TRIM(TRIM(LEADING ',' FROM Right(Price,6))) AS decimal(5,2))
WHERE Precio is null;

---------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA CONDITION*/
-- CREAMOS LA TABLA CONDICION
ALTER TABLE productos add Condicion Varchar(100);

-- CON UN DISTINCT VISUALIZAMOS LOS DATOS DE LA COLUMNA CONDITION NECESITAMOS LOS VALORES NEW, Good - Refurbished
-- Excellent - Refurbished, Open Box etc.
SELECT distinct Condition FROM productos WHERE Condition LIKE 'NEW%';

-- ACTUALIZAMOS LAS COLUMNA DE LA COLUMNA CONDICION E INSERTAMOS LOS VALORES MENCIONADOS EN EL PASO ANTERIOR
UPDATE productos SET Condicion = 'New'
WHERE Condicion is null and Condition LIKE 'NEW%';

-- VISUALIZAMOS EN LOS OTROS CAMPOS QUE EXISTAN LA INFORMACION QUE QUEREMOS PARA SU INSERCION
SELECT distinct Price FROM productos WHERE Price LIKE '%New%';
SELECT distinct Price FROM productos WHERE Price LIKE '%Good - Refurbished%';
SELECT distinct Price FROM productos WHERE Price LIKE '%Excellent - Refurbished%';

-- ACTUALIZAMOS LOS DATOS EN LA COLUMNA CONDICION
-- EN BASE A LAS OTRAS COLUMNAS EXISTENTES.
UPDATE productos SET Condicion = 'Good - Refurbished'
WHERE Condicion is null and Price LIKE '%Good - Refurbished%';

-- VISUALIZAMOS QUE NO EXISTAN NULL EN CASO QUE EXISTAN NULOS VERIFICAR DE NUEVO CON UN DISTINCT EN CADA COLUMNA Y
-- VER SI HAY DATOS SOBRANTES PARA ACTUALIZAR A LA COLUMNA CREADA
SELECT * FROM productos WHERE Condicion IS NOT NULL;

/*-----------Asi mismo se realiza el mismo proceso para nuevas columnas y nuevos valores------------------------*/
---------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA RESOLUTION*/
ALTER TABLE productos add Resolucion Varchar(100);
SELECT * FROM productos WHERE Resolucion IS NULL;
BEGIN TRANSACTION;
SELECT distinct Screen_Size FROM productos WHERE Resolucion IS NULL;
SELECT distinct RAM FROM productos WHERE Resolucion IS NULL;
SELECT distinct Processor FROM productos WHERE Resolucion IS NULL;
SELECT distinct GPU FROM productos WHERE Resolucion IS NULL;
SELECT distinct GPU_Type FROM productos WHERE Resolucion IS NULL;
SELECT distinct Resolution FROM productos WHERE Resolucion IS NULL;
SELECT distinct Condition FROM productos WHERE Resolucion IS NULL;
SELECT distinct Price FROM productos WHERE Resolucion IS NULL and Price like '%2560*1600%';
UPDATE productos SET Resolucion = '1080 x 1920'
WHERE Resolucion is null and Condition LIKE '%1080p%';
SELECT * FROM productos WHERE Resolucion IS NULL;
ROLLBACK;
COMMIT;
---------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA GPU*/
ALTER TABLE productos add Tipo_Gpu Varchar(100);
SELECT distinct GPU_Type FROM productos WHERE GPU_Type LIKE '%Integrated Graphics%' AND Tipo_Gpu IS NULL;

UPDATE productos SET Tipo_Gpu = 'Integrated Graphics'
WHERE Tipo_Gpu is null and GPU_Type LIKE '%Integrated Graphics%';

SELECT * FROM productos WHERE  Tipo_Gpu IS NULL;
SELECT distinct Price FROM productos WHERE Price LIKE '%Integrated Graphics%' AND Tipo_Gpu IS NULL;
SELECT distinct Price FROM productos WHERE Price LIKE '%Integrated/On-Board Graphics%' AND Tipo_Gpu IS NULL;
SELECT distinct Price FROM productos WHERE Price LIKE '%Dedicated Graphics%' AND Tipo_Gpu IS NULL;

UPDATE productos SET Tipo_Gpu = 'Integrated Graphics'
WHERE Tipo_Gpu is null and GPU_Type LIKE '%Integrated%';
----------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA PROCESSOR*/
ALTER TABLE productos add Procesador Varchar(100);
SELECT distinct Processor FROM productos WHERE Procesador IS NULL AND Processor LIKE '%AMD%';
SELECT distinct Procesador FROM productos WHERE Processor LIKE '%AMD%';

begin transaction;

UPDATE productos SET Procesador = 'Intel Core i3 N305'
WHERE Procesador is null and Processor LIKE '%Intel i3-N305%';


SELECT distinct Product_Description FROM productos WHERE Procesador IS NULL AND Product_Description LIKE '%AMD R3 PRO 4450U%';
UPDATE productos SET Procesador = 'Intel Core i5 11'
WHERE Procesador is null and Product_Description LIKE '%c%'

commit;
rollback;
SELECT * FROM productos WHERE Procesador is not  null;
-- AÑADIMOS UNA NUEVA COLUMNA PARA SEPARAR GENERACION SERIES DE PROCESADOR AMD E INTEL
ALTER TABLE productos add Generación_Series Varchar(100);
SELECT distinct procesador FROM productos where Generación_Series is null ;

-- SE SUSTITUYE LA PALABRA SERIES PARA AMD EN VACIO
SELECT distinct   REPLACE(procesador, 'Series',''), procesador FROM productos 
WHERE  Generación_Series is null  and procesador LIKE '%AMD%';

-- SE ACTUALIZA LA COLUMNA QUE CONTIENE LAS SERIES
update productos set procesador = trim(REPLACE(procesador, 'Series',''))
WHERE  procesador LIKE '%AMD%';

-- SE EXTRAE CON RIGHT LOS ULTIMOS CARACTERES DE GENERACION INTEL Y SERIE EN AMD
SELECT distinct   TRIM(RIGHT(procesador,2)), procesador FROM productos 
WHERE  Generación_Series is null  and procesador LIKE '%Intel P%';

-- SE ACTUALIZA LA COLUMNA CON LOS NUEVOS VALORES EXTRAIDOS
update productos set Generación_Series = TRIM(RIGHT(procesador,2))
WHERE  Generación_Series is null  and procesador LIKE '%Intel Quad Core i3 10%';

SELECT distinct   substring(procesador,0,16), procesador,Generación_Series  FROM productos
WHERE procesador  LIKE 'AMD Ryzen 3 Pro%'
or procesador  LIKE 'AMD Ryzen 5 Pro%'
or procesador  LIKE 'AMD Ryzen 7 Pro%';

UPDATE productos SET procesador = TRIM(substring(procesador,0,16)) 
WHERE procesador  LIKE 'AMD Ryzen 3 Pro%'
or procesador  LIKE 'AMD Ryzen 5 Pro%'
or procesador  LIKE 'AMD Ryzen 7 Pro%'
----------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA GPU*/
ALTER TABLE productos add Grafica Varchar(100);
SELECT * FROM productos WHERE Grafica IS NULL;

SELECT DISTINCT Screen_Size FROM productos WHERE Grafica IS NULL AND Screen_Size LIKE '%Intel UHD Graphics%';

UPDATE productos SET Grafica =  'INTEL UHD'
WHERE Grafica IS NULL AND  Screen_Size LIKE '%Intel UHD Graphics%';

SELECT DISTINCT REPLACE(Grafica, '(R)', '') FROM productos; 
SELECT DISTINCT CONCAT('AMD ', Grafica) FROM productos WHERE GRAFICA  LIKE 'Radeon pro%'; 
UPDATE productos SET Grafica = CONCAT('AMD', Grafica) FROM productos WHERE GRAFICA  LIKE 'Radeon pro%'; 
UPDATE productos SET Grafica = UPPER(TRIM(GRAFICA))
UPDATE productos SET Grafica = UPPER(REPLACE(Grafica, 'GEFORCE', '')) WHERE Grafica IS NOT NULL;
UPDATE productos SET Grafica = 'NVIDIA QUADRO M1200' WHERE Grafica IS NOT NULL AND GRAFICA LIKE 'Silver Quadro M1200"%'
UPDATE  productos SET GRAFICA = 'NVIDIA RTX 3050 TI' WHERE GRAFICA IS NOT NULL AND GRAFICA = 'NVIDIA  RTX 3050 TI';
----------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA RAM*/
ALTER TABLE productos add Memoria_Ram INT;
SELECT * FROM productos WHERE Memoria_Ram IS NULL ;

SELECT DISTINCT RAM
FROM productos 
WHERE Memoria_Ram IS NULL 
AND RAM LIKE '8GB%'

UPDATE productos SET Memoria_Ram = 8
WHERE Memoria_Ram IS NULL
AND RAM LIKE '8GB%'

----------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA SCREEN SIZE*/
ALTER TABLE productos add Pantalla decimal(3,1);
SELECT * FROM productos WHERE Pantalla IS NULL ;

SELECT DISTINCT RAM
FROM productos 
WHERE Pantalla IS NULL 
AND RAM LIKE '%14%'

UPDATE productos SET Pantalla =  13
WHERE Pantalla IS NULL 
AND RAM LIKE '%13%'

----------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA ALMACENAMIENTO*/
ALTER TABLE productos add Almacenamiento varchar(50);
SELECT * FROM productos WHERE Almacenamiento IS NULL ;

SELECT DISTINCT Product_Description
FROM productos 
WHERE Almacenamiento IS NULL 
AND Product_Description LIKE '%40GB%'

UPDATE productos SET Almacenamiento =  '512 GB'
WHERE Almacenamiento IS NULL 
AND GPU_Type LIKE '% 512GB SSD win 10"%'

----------------------------------------------------------------------------------------------------------------
/*TRABAJAR EN LA COLUMNA PRODUCT DESCRIPTION*/
ALTER TABLE productos add Descripcion_Producto varchar(50);

SELECT distinct brand FROM productos;
SELECT brand, replace(brand, 'VAIO','SONY') FROM productos;
UPDATE productos SET brand = replace(brand, 'VAIO','SONY')

SELECT * FROM productos WHERE Descripcion_Producto IS NULL AND Brand LIKE 'DELL%';

UPDATE productos SET Descripcion_Producto = 'Dell Global'
WHERE Descripcion_Producto IS NULL AND Brand LIKE 'DELL%'
AND Product_Description like '%Precision%';

UPDATE productos SET  Brand = 'LENOVO'
WHERE Brand = 'DELL' AND Product_Description LIKE '%"LENOVO THINKPAD T14 GEN 14"" FHD I5-10310U 512GB SSD 16GB W11P Warranty"%'

----------------------------------------------------------------------------------------------------------------------------------------
/*Eliminamos columnas que ya no utilizaremos en este caso es una copia de la tabla original*/
alter table copia drop column Resolution;
alter table copia drop column RAM;
alter table copia drop column Condition;
alter table copia drop column GPU;
alter table copia drop column Gpu_Type;
alter table copia drop column Price;
alter table copia drop column Product_Description;

/*Ponemos con mayusucula los registros en cada uno de las columnas texto*/
update copia set Tipo_Gpu = TRIM(UPPER(Tipo_Gpu));

/*Visualizamos todos los campos ya con los datos ya procesados*/
select 
Brand, 
Descripcion_Producto,
Tipo_Gpu, 
Memoria_Ram, 
Almacenamiento, 
Pantalla, 
Resolucion, 
Condicion, 
Procesador, 
Generación_Series,
Precio 
from copia;

/*Eliminar Datos Duplicados*/
with cte_duplicado as (
select *,
ROW_NUMBER() over(
partition by
Brand, 
Descripcion_Producto,
Tipo_Gpu, 
Memoria_Ram, 
Almacenamiento, 
Pantalla, 
Resolucion, 
Condicion, 
Procesador, 
Generación_Series,
Precio 
order by brand
) as datos
from copia
)
delete from cte_duplicado where datos > 1;
