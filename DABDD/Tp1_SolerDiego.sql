CREATE DATABASE  IF NOT EXISTS `pedidos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pedidos`;
-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: pedidos
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `idcliente` int NOT NULL AUTO_INCREMENT,
  `Apellido` varchar(50) NOT NULL,
  `Nombres` varchar(50) NOT NULL,
  `Dirección` varchar(100) DEFAULT NULL,
  `mail` varchar(100) NOT NULL,
  PRIMARY KEY (`idcliente`),
  UNIQUE KEY `mail` (`mail`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Perez','Juan','Calle 123','juan.perez@example.com'),(2,'Gomez','Maria','Avenida 45','maria.gomez@example.com'),(3,'Lopez','Carlos','Boulevard 789','carlos.lopez@example.com'),(4,'Fernandez','Laura','Ruta 66','laura.fernandez@example.com'),(5,'Martinez','Ana','Pasaje 101','ana.martinez@example.com'),(6,'García','Laura','Calle Falsa 123','laura.garcia@example.com'),(7,'López','Carlos','Avenida Siempre Viva 456','carlos.lopez02@example.com'),(8,'Pérez','Ana','Boulevard de los Sueños 789','ana.perez@example.com'),(9,'Martínez','Juan','Plaza Mayor 101','juan.martinez@example.com');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PrevenirEliminacionClienteConPedidos` BEFORE DELETE ON `clientes` FOR EACH ROW BEGIN
    DECLARE totalPedidos INT;

    SELECT COUNT(*) INTO totalPedidos FROM Pedidos WHERE idcliente = OLD.idcliente;

    IF totalPedidos > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar un cliente que ha realizado pedidos.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `detallepedidos`
--

DROP TABLE IF EXISTS `detallepedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detallepedidos` (
  `NumeroPedido` int NOT NULL,
  `renglon` int NOT NULL,
  `idproducto` int DEFAULT NULL,
  `cantidad` int NOT NULL,
  `PrecioUnitario` decimal(10,2) NOT NULL,
  `Total` decimal(10,2) GENERATED ALWAYS AS ((`cantidad` * `PrecioUnitario`)) STORED,
  PRIMARY KEY (`NumeroPedido`,`renglon`),
  KEY `idproducto` (`idproducto`),
  CONSTRAINT `detallepedidos_ibfk_1` FOREIGN KEY (`NumeroPedido`) REFERENCES `pedidos` (`NumeroPedido`),
  CONSTRAINT `detallepedidos_ibfk_2` FOREIGN KEY (`idproducto`) REFERENCES `productos` (`idproducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detallepedidos`
--

LOCK TABLES `detallepedidos` WRITE;
/*!40000 ALTER TABLE `detallepedidos` DISABLE KEYS */;
INSERT INTO `detallepedidos` (`NumeroPedido`, `renglon`, `idproducto`, `cantidad`, `PrecioUnitario`) VALUES (1,1,1,2,100.00),(2,1,2,3,150.00),(2,2,3,1,200.00),(3,1,4,4,250.00),(4,1,5,2,300.00),(4,2,6,5,120.00),(4,3,7,1,180.00),(5,1,8,3,400.00),(5,2,9,2,220.00),(6,1,10,1,500.00),(7,1,3,2,200.00),(7,2,4,1,250.00),(7,3,1,3,100.00),(8,1,6,4,120.00),(9,1,5,3,300.00),(9,2,7,2,180.00),(10,1,8,1,400.00),(10,2,9,3,220.00),(10,3,10,2,500.00),(11,1,8,1,400.00);
/*!40000 ALTER TABLE `detallepedidos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `VerificarStockAntesDeInsertarDetalle` BEFORE INSERT ON `detallepedidos` FOR EACH ROW BEGIN
    DECLARE stockActual INT;

    SELECT Stock INTO stockActual FROM Productos WHERE idproducto = NEW.idproducto;

    IF stockActual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto especificado no existe.';
    ELSEIF NEW.cantidad > stockActual THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock para el producto solicitado.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ActualizarStockDespuesDeInsertarDetalle` AFTER INSERT ON `detallepedidos` FOR EACH ROW BEGIN
    UPDATE Productos
    SET Stock = Stock - NEW.cantidad
    WHERE idproducto = NEW.idproducto;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `logpedidosanulados`
--

DROP TABLE IF EXISTS `logpedidosanulados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logpedidosanulados` (
  `NumeroPedido` int NOT NULL,
  `FechaAnulacion` date NOT NULL,
  PRIMARY KEY (`NumeroPedido`),
  CONSTRAINT `logpedidosanulados_ibfk_1` FOREIGN KEY (`NumeroPedido`) REFERENCES `pedidos` (`NumeroPedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logpedidosanulados`
--

LOCK TABLES `logpedidosanulados` WRITE;
/*!40000 ALTER TABLE `logpedidosanulados` DISABLE KEYS */;
/*!40000 ALTER TABLE `logpedidosanulados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `NumeroPedido` int NOT NULL AUTO_INCREMENT,
  `idcliente` int DEFAULT NULL,
  `idvendedor` int DEFAULT NULL,
  `fecha` date NOT NULL,
  `Estado` enum('Confirmado','Anulado') NOT NULL,
  PRIMARY KEY (`NumeroPedido`),
  KEY `idcliente` (`idcliente`),
  KEY `idvendedor` (`idvendedor`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`idcliente`) REFERENCES `clientes` (`idcliente`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`idvendedor`) REFERENCES `vendedor` (`idvendedor`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,1,1,'2024-09-01','Confirmado'),(2,2,2,'2024-09-02','Confirmado'),(3,3,3,'2024-09-03','Confirmado'),(4,4,1,'2024-09-04','Confirmado'),(5,5,2,'2024-09-05','Confirmado'),(6,1,3,'2024-09-06','Confirmado'),(7,2,1,'2024-09-07','Confirmado'),(8,3,2,'2024-09-08','Confirmado'),(9,4,3,'2024-09-09','Confirmado'),(10,5,1,'2024-09-10','Confirmado'),(11,8,1,'2024-09-11','Confirmado');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RestaurarStockYRegistrarAnulacion` AFTER UPDATE ON `pedidos` FOR EACH ROW BEGIN
    IF OLD.Estado = 'Confirmado' AND NEW.Estado = 'Anulado' THEN
        -- Restaurar el stock
        UPDATE Productos p
        JOIN DetallePedidos dp ON p.idproducto = dp.idproducto
        SET p.Stock = p.Stock + dp.cantidad
        WHERE dp.NumeroPedido = NEW.NumeroPedido;

        -- Registrar en el log
        INSERT INTO LogPedidosAnulados (NumeroPedido, idcliente, idvendedor, fechaPedido)
        VALUES (NEW.NumeroPedido, NEW.idcliente, NEW.idvendedor, NEW.fecha);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `idproducto` int NOT NULL AUTO_INCREMENT,
  `Descripción` varchar(100) NOT NULL,
  `PrecioUnitario` decimal(10,2) NOT NULL,
  `Stock` int NOT NULL,
  `StockMax` int NOT NULL,
  `StockMin` int NOT NULL,
  `idproveedor` int DEFAULT NULL,
  `origen` enum('Nacional','Importado') NOT NULL,
  PRIMARY KEY (`idproducto`),
  KEY `idproveedor` (`idproveedor`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`idproveedor`) REFERENCES `proveedores` (`idproveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Producto 1',100.00,45,100,10,1,'Nacional'),(2,'Producto 2',200.00,27,70,5,1,'Importado'),(3,'Producto 3',150.00,17,60,10,2,'Nacional'),(4,'Producto 4',80.00,35,90,15,2,'Nacional'),(5,'Producto 5',50.00,55,120,20,3,'Importado'),(6,'Producto 6',120.00,26,80,10,3,'Nacional'),(7,'Producto 7',90.00,22,70,5,1,'Importado'),(8,'Producto 8',110.00,10,50,10,2,'Nacional'),(9,'Producto 9',130.00,50,110,20,3,'Nacional'),(10,'Producto 10',140.00,42,100,15,1,'Importado');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ValidarStockAlInsertarProducto` BEFORE INSERT ON `productos` FOR EACH ROW BEGIN
    IF NEW.Stock < NEW.StockMin THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El stock inicial no puede ser menor que el stock mínimo.';
    ELSEIF NEW.Stock > NEW.StockMax THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El stock inicial no puede ser mayor que el stock máximo.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `idproveedor` int NOT NULL AUTO_INCREMENT,
  `NombreProveedor` varchar(100) NOT NULL,
  `Dirección` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`idproveedor`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'Proveedor A','Calle Principal 1','proveedorA@example.com'),(2,'Proveedor B','Avenida Secundaria 2','proveedorB@example.com'),(3,'Proveedor C','Ruta 3','proveedorC@example.com');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendedor`
--

DROP TABLE IF EXISTS `vendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendedor` (
  `idvendedor` int NOT NULL AUTO_INCREMENT,
  `Apellido` varchar(50) NOT NULL,
  `Nombres` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `comisión` decimal(5,2) NOT NULL,
  PRIMARY KEY (`idvendedor`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendedor`
--

LOCK TABLES `vendedor` WRITE;
/*!40000 ALTER TABLE `vendedor` DISABLE KEYS */;
INSERT INTO `vendedor` VALUES (1,'Garcia','Luis','luis.garcia@example.com',0.05),(2,'Rodriguez','Ana','ana.rodriguez@example.com',0.04),(3,'Sanchez','Jorge','jorge.sanchez@example.com',0.06);
/*!40000 ALTER TABLE `vendedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'pedidos'
--

--
-- Dumping routines for database 'pedidos'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-01 20:55:37
