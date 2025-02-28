-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bicycle
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `bicycles`
--

DROP TABLE IF EXISTS `bicycles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bicycles` (
  `id_bicycle` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(45) NOT NULL,
  `model` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `rental_point_id_rental_point` int NOT NULL,
  PRIMARY KEY (`id_bicycle`,`rental_point_id_rental_point`),
  KEY `fk_bicycles_rental_point1_idx` (`rental_point_id_rental_point`),
  CONSTRAINT `fk_bicycles_rental_point1` FOREIGN KEY (`rental_point_id_rental_point`) REFERENCES `rental_point` (`id_rental_point`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bicycles`
--

LOCK TABLES `bicycles` WRITE;
/*!40000 ALTER TABLE `bicycles` DISABLE KEYS */;
INSERT INTO `bicycles` VALUES (1,'Giant','Talon 2','available',1),(2,'Trek','Marlin 5','available',1),(3,'Merida','Big Nine','rented',2),(4,'Specialized','Rockhopper','available',3),(5,'Scott','Aspect 950','available',3);
/*!40000 ALTER TABLE `bicycles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `id_client` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `number` bigint NOT NULL,
  `registration_date` datetime NOT NULL,
  PRIMARY KEY (`id_client`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (1,'Иван Петров',79261234567,'2024-02-25 10:30:00'),(2,'Мария Смирнова',79161239876,'2024-02-20 15:45:00'),(3,'Кирил Поздний',79121329867,'2024-02-20 15:45:00'),(4,'Ирина Складчикова',79116000243,'2024-02-20 15:45:00'),(5,'Алексей Иванов',79051233456,'2024-01-10 09:15:00');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rent`
--

DROP TABLE IF EXISTS `rent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rent` (
  `id_rent` int NOT NULL AUTO_INCREMENT,
  `clients_id_client` int NOT NULL,
  `bicycles_id_bicycle` int NOT NULL,
  `start_rent_point` int NOT NULL,
  `end_rental_point` int DEFAULT NULL,
  `rental_start` datetime NOT NULL,
  `rental_end` datetime DEFAULT NULL,
  PRIMARY KEY (`id_rent`,`clients_id_client`,`bicycles_id_bicycle`,`start_rent_point`),
  KEY `fk_rent_clients1_idx` (`clients_id_client`),
  KEY `fk_rent_bicycles1_idx` (`bicycles_id_bicycle`,`start_rent_point`),
  KEY `fk_rent_rental_point1_idx` (`end_rental_point`),
  CONSTRAINT `fk_rent_bicycles1` FOREIGN KEY (`bicycles_id_bicycle`, `start_rent_point`) REFERENCES `bicycles` (`id_bicycle`, `rental_point_id_rental_point`),
  CONSTRAINT `fk_rent_clients1` FOREIGN KEY (`clients_id_client`) REFERENCES `clients` (`id_client`),
  CONSTRAINT `fk_rent_rental_point1` FOREIGN KEY (`end_rental_point`) REFERENCES `rental_point` (`id_rental_point`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rent`
--

LOCK TABLES `rent` WRITE;
/*!40000 ALTER TABLE `rent` DISABLE KEYS */;
INSERT INTO `rent` VALUES (1,1,1,1,NULL,'2024-02-26 09:00:00',NULL),(2,2,2,1,1,'2024-02-25 14:30:00','2024-02-25 18:00:00'),(3,2,2,1,NULL,'2024-02-26 15:00:00',NULL),(4,4,5,3,3,'2024-02-25 12:30:00','2024-02-25 14:00:00'),(5,5,5,3,3,'2024-02-25 14:30:00','2024-02-25 18:00:00');
/*!40000 ALTER TABLE `rent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rental_point`
--

DROP TABLE IF EXISTS `rental_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rental_point` (
  `id_rental_point` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `address` varchar(50) NOT NULL,
  PRIMARY KEY (`id_rental_point`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rental_point`
--

LOCK TABLES `rental_point` WRITE;
/*!40000 ALTER TABLE `rental_point` DISABLE KEYS */;
INSERT INTO `rental_point` VALUES (1,'Центральная станция','ул. Ленина, 10'),(2,'Северный прокат','пр. Победы, 45'),(3,'Южная точка','ул. Гагарина, 5');
/*!40000 ALTER TABLE `rental_point` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'bicycle'
--

--
-- Dumping routines for database 'bicycle'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-01  0:13:12
