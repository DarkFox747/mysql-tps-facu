#punto A: 
Create schema if not exists RH;
Use RH;
# Punto b 
CREATE TABLE IF NOT EXISTS `RH`.`cargo` (
  `idcargo` INT NOT NULL,
  `cargo` VARCHAR(45) NOT NULL,
  `id_salario` INT NOT NULL,
  PRIMARY KEY (`idcargo`),
  INDEX `id_salario_idx` (`id_salario` ASC) VISIBLE,
  CONSTRAINT `id_salario`
    FOREIGN KEY (`id_salario`)
    REFERENCES `RH`.`salario` (`idsalario`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`correo_electronico` (
  `id_correo_electronico` INT NOT NULL,
  `correo_electronico` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_correo_electronico`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`empleados` (
  `Id_empleado` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `fecha_contratacion` DATE NOT NULL,
  `dni` INT NOT NULL,
  `id_cargo` INT NULL DEFAULT NULL,
  `id_telefono` INT NOT NULL,
  `id_correo` INT NOT NULL,
  `id_historial` INT NULL DEFAULT NULL,
  `idsucursal` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Id_empleado`),
  INDEX `id_cargo_idx` (`id_cargo` ASC) VISIBLE,
  INDEX `id_telefono_idx` (`id_telefono` ASC) VISIBLE,
  INDEX `id_correo_electronico_idx` (`id_correo` ASC) VISIBLE,
  INDEX `id_historial_idx` (`id_historial` ASC) VISIBLE,
  INDEX `idsucursal_idx` (`idsucursal` ASC) VISIBLE,
  CONSTRAINT `id_cargo`
    FOREIGN KEY (`id_cargo`)
    REFERENCES `RH`.`cargo` (`idcargo`),
  CONSTRAINT `id_correo_electronico`
    FOREIGN KEY (`id_correo`)
    REFERENCES `RH`.`correo_electronico` (`id_correo_electronico`),
  CONSTRAINT `id_historial`
    FOREIGN KEY (`id_historial`)
    REFERENCES `RH`.`historial` (`id_historial`),
  CONSTRAINT `id_telefono`
    FOREIGN KEY (`id_telefono`)
    REFERENCES `RH`.`telefono` (`id_telefono`),
  CONSTRAINT `idsucursal`
    FOREIGN KEY (`idsucursal`)
    REFERENCES `RH`.`sucursal` (`idsucursal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`historial` (
  `id_historial` INT NOT NULL,
  `id_historial_cargos` INT NOT NULL,
  `id_historial_sucursal` INT NOT NULL,
  PRIMARY KEY (`id_historial`),
  INDEX `id_historial_cargos_idx` (`id_historial_cargos` ASC) VISIBLE,
  INDEX `id_historial_sucursal_idx` (`id_historial_sucursal` ASC) VISIBLE,
  CONSTRAINT `id_historial_cargos`
    FOREIGN KEY (`id_historial_cargos`)
    REFERENCES `RH`.`historial_cargos` (`id_historial_cargos`),
  CONSTRAINT `id_historial_sucursal`
    FOREIGN KEY (`id_historial_sucursal`)
    REFERENCES `RH`.`historial_sucursal` (`idhistorial_sucursal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`historial_cargos` (
  `id_historial_cargos` INT NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NULL DEFAULT NULL,
  `id_cargo` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_historial_cargos`),
  INDEX `id_cargo_idx` (`id_cargo` ASC) VISIBLE,
  CONSTRAINT `idcargo`
    FOREIGN KEY (`id_cargo`)
    REFERENCES `RH`.`cargo` (`idcargo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`historial_sucursal` (
  `idhistorial_sucursal` INT NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NULL DEFAULT NULL,
  `id_sucursal` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idhistorial_sucursal`),
  INDEX `id_sucursal_idx` (`id_sucursal` ASC) VISIBLE,
  CONSTRAINT `id_sucursal`
    FOREIGN KEY (`id_sucursal`)
    REFERENCES `RH`.`sucursal` (`idsucursal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`localidad` (
  `idlocalidad` INT NOT NULL,
  `localidad` VARCHAR(45) NOT NULL,
  `id_provincia` INT NOT NULL,
  PRIMARY KEY (`idlocalidad`),
  INDEX `id_provincia_idx` (`id_provincia` ASC) VISIBLE,
  CONSTRAINT `id_provincia`
    FOREIGN KEY (`id_provincia`)
    REFERENCES `RH`.`provincia` (`idprovincia`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`provincia` (
  `idprovincia` INT NOT NULL,
  `provincia` VARCHAR(45) NOT NULL,
  `id_region` INT NOT NULL,
  PRIMARY KEY (`idprovincia`),
  INDEX `id_region_idx` (`id_region` ASC) VISIBLE,
  CONSTRAINT `id_region`
    FOREIGN KEY (`id_region`)
    REFERENCES `RH`.`region` (`idregion`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`region` (
  `idregion` INT NOT NULL,
  `region` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idregion`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`salario` (
  `idsalario` INT NOT NULL,
  `salario_minimo` VARCHAR(45) NOT NULL,
  `salario_maximo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idsalario`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`sucursal` (
  `idsucursal` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `id_localidad` INT NOT NULL,
  PRIMARY KEY (`idsucursal`),
  INDEX `id_localidad_idx` (`id_localidad` ASC) VISIBLE,
  CONSTRAINT `id_localidad`
    FOREIGN KEY (`id_localidad`)
    REFERENCES `RH`.`localidad` (`idlocalidad`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS `RH`.`telefono` (
  `id_telefono` INT NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_telefono`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

#Punto C 
insert into region values (01,"litoral"), (02,"patagonia"), (03,"cuyo");
insert into provincia values (01,"Santa Fe",01), (02,"Entre Rios",01), (03,"Neuquén",02),(04,"Río Negro",02),(05,"Mendoza",03),(06,"San Juan",03);
insert into localidad values (01,"Santa Fe",01), (02,"Rosario",01), (03,"Parana",02),(04,"Concordia",02),(05,"Neuquén",03),(06,"San Martín de los Andes",03),(07,"Bariloche",04),(08,"Viedma",04),(09,"Mendoza",05),(10,"San Rafael",05),(11,"San Juan",06),(12,"Rivadavia",06);
insert into sucursal values (01,"Sucursal Santa Fe",01), (02,"Sucursal Rosario",02), (03,"Sucursal Parana",03),(04,"Sucursal Concordia",04),(05,"Sucursal Neuquén",05),(06,"Sucursal San Martín de los Andes",06),(07,"Sucursal Bariloche",07),(08,"Sucursal Viedma",08),(09,"Sucursal Mendoza",09),(10,"Sucursal San Rafael",10),(11,"Sucursal San Juan",11),(12,"Sucursal Rivadavia",12);
insert into salario values (01,"500.000","1.000.000"),(02,"100.000","499.999"),(03,"20.000","99.999");
insert into cargo values (01,"Gerente","01"),(02,"Empleado de comercio","02"),(03,"Limpieza","03");
insert into telefono values (01,1122334455),(02,2233445566),(03,4455667788),(04,3344556677),(05,5566778899),(06,6677889900);
insert into correo_electronico values (01,"santiago.garcia@example.com"),(02,"valentina.rodriguez@example.com"),(03,"matias.lopez@example.com"),(04,"sofia.martinez@example.com"),(05,"sebastian.gonzalez@example.com"),(06,"lucia.fernandez@example.com");
insert into historial_sucursal values (01,'2017-05-27',null,01),(02,'20-03-15',null,02),(03,'19-11-07',null,03),(04,'21-06-22',null,02),(05,'22-09-03',null,null), (06,'2018-09-03',null,null);
insert into historial values (01,01,01),(02,02,02),(03,03,03),(04,04,04),(05,05,05),(06,06,06);
insert into empleados values (01,"Santiago","García",'2017-05-27',25609875,01,01,01,01);
insert into empleados values (02,"Valentina","Rodríguez",'2020-03-15',44870653,02,02,02,02);
insert into empleados values (03,"Matías","López",'2019-11-07',33501289,03,03,03,03);
insert into empleados values (04,"Sofía","Martínez",'2021-06-22',51237986,02,04,04,04);
insert into empleados values (05,"Sebastián","González",'2022-09-03',63985124,null,05,05,05);
insert into empleados values (06,"Lucía","Fernández",'2018-09-03',38789234,null,06,06,06);
update empleados set idsucursal = 01 Where Id_empleado = 01;
update empleados set idsucursal = 02 Where Id_empleado = 02;
update empleados set idsucursal = 03 Where Id_empleado = 03;
update empleados set idsucursal = 02 Where Id_empleado = 04;

#punto D 
#Detalle de empleados (apellido, nombres, DNI, correo electrónico).

SELECT apellido, nombre, DNI, correo_electronico FROM empleados inner join correo_electronico ON empleados.Id_empleado = correo_electronico.id_correo_electronico;

#Detalle de empleados sin destino y cargo asignado (apellido, nombres, DNI, correo electrónico).

SELECT apellido, nombre, DNI, correo_electronico FROM empleados inner join correo_electronico ON empleados.Id_empleado = correo_electronico.id_correo_electronico WHERE id_cargo is NULL and idsucursal is NULL;

#Cantidad de empleados por sucursal (nombre sucursal, cantidad empleados).
select sucursal.nombre, count(*) from sucursal inner join empleados on empleados.idsucursal = sucursal.idsucursal group by sucursal.nombre;

#Cantidad de empleados por región (nombre sucursal, cantidad empleados).
select region, count(*) from region inner join provincia on provincia.id_region= region.idregion inner join localidad on localidad.id_provincia = provincia.idprovincia inner join sucursal on sucursal.id_localidad = localidad.idlocalidad inner join empleados on empleados.idsucursal = sucursal.idsucursal group by region.idregion;

#Detalle de empleados ingresados en un período determinado (entre fechas).

SELECT apellido, nombre, DNI, correo_electronico,fecha_contratacion FROM empleados inner join correo_electronico ON empleados.Id_empleado = correo_electronico.id_correo_electronico where  fecha_contratacion > '2017-01-01' and fecha_contratacion < '2020-01-01';

#Punto E
#Crea una vista que permita consultar el siguiente detalle de datos: Apellido, nombres, correo electrónico, nombre, cargo, nombre sucursal, provincia.
SELECT apellido, empleados.nombre, correo_electronico,cargo,sucursal.nombre,provincia FROM empleados inner join correo_electronico ON empleados.Id_empleado = correo_electronico.id_correo_electronico inner join cargo on empleados.id_cargo = idcargo inner join sucursal on empleados.idsucursal = sucursal.idsucursal inner join localidad on sucursal.idsucursal = localidad.idlocalidad inner join provincia on localidad.idlocalidad = provincia.idprovincia;

#punto F
#Obtén el listado de cargos disponibles en la organización, indicando el salario mínimo y máximo definido para cada uno.
select cargo,salario_minimo,salario_maximo from cargo inner join salario on cargo.id_salario = salario.idsalario;


