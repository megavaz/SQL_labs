-- MySQL dump 10.13  Distrib 8.0.18, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: lw
-- ------------------------------------------------------
-- Server version	8.0.18

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authors` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `surname` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `patronymic` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (1,'Толстой','Лев','Николаевич'),(2,'Достоевский','Федор','Михайлович'),(3,'Пушкин','Александр','Сергеевич'),(4,'Чехов','Антон','Павлович'),(5,'Макмахон','Дженнифер',NULL),(6,'Дилан','Боб',NULL),(7,'Гейман','Нил',NULL),(8,'Ильф','Илья',NULL),(9,'Петров','Евгений',NULL);
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_catalog`
--

DROP TABLE IF EXISTS `book_catalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_catalog` (
  `edition_code` varchar(10) NOT NULL,
  `name` varchar(80) NOT NULL,
  `publisher` varchar(25) NOT NULL,
  `publishment_year` decimal(4,0) NOT NULL,
  `pages` decimal(4,0) DEFAULT NULL,
  `comment` varchar(40) DEFAULT 'Сборник',
  PRIMARY KEY (`edition_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_catalog`
--

LOCK TABLES `book_catalog` WRITE;
/*!40000 ALTER TABLE `book_catalog` DISABLE KEYS */;
INSERT INTO `book_catalog` VALUES ('edition001','War and Peace','Росмен',1999,2438,'Сборник'),('edition002','Преступление и наказание','Росмен',2003,812,'Сборник'),('edition003','Идиот','Росмен',2005,786,'Сборник'),('edition004','Рассказы для детей','Детские книги',2012,132,'Сборник'),('edition005','Вам меня не испугать','Эксмо',2017,390,'Сборник'),('edition006','Хроники','Эксмо',2017,340,'Сборник'),('edition007','Скандинавские боги','АСТ',2018,190,'Сборник'),('edition008','Вишневый сад','Русбук',2005,64,'Сборник'),('edition009','Три сестры','Русская пьеса',2013,92,'Сборник'),('edition010','Дядя Ваня','Русская пьеса',2011,38,'Сборник'),('edition011','Сказки Пушкина','Детство',2016,93,'Сборник'),('edition012','Двенадцать стульев','Время',1998,448,'Сборник'),('edition013','Остров мира','Pub',1972,69,'Сборник');
/*!40000 ALTER TABLE `book_catalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content`
--

DROP TABLE IF EXISTS `content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `product` mediumint(9) NOT NULL,
  `book` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content`
--

LOCK TABLES `content` WRITE;
/*!40000 ALTER TABLE `content` DISABLE KEYS */;
INSERT INTO `content` VALUES (1,1,'edition001'),(2,2,'edition002'),(3,3,'edition003'),(4,4,'edition004'),(5,5,'edition004'),(6,6,'edition004'),(7,7,'edition005'),(8,8,'edition007'),(9,9,'edition006'),(10,10,'edition011'),(11,11,'edition011'),(12,11,'edition004'),(13,13,'edition009'),(14,14,'edition010'),(15,15,'edition008'),(16,12,'edition011'),(18,16,'edition012'),(19,17,'edition013');
/*!40000 ALTER TABLE `content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_authors`
--

DROP TABLE IF EXISTS `product_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_authors` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `product` mediumint(9) NOT NULL,
  `author` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_authors`
--

LOCK TABLES `product_authors` WRITE;
/*!40000 ALTER TABLE `product_authors` DISABLE KEYS */;
INSERT INTO `product_authors` VALUES (1,1,1),(2,2,2),(3,3,2),(7,7,5),(8,8,7),(9,9,6),(10,10,3),(11,11,3),(12,12,3),(13,13,4),(14,14,4),(15,15,4),(19,16,8),(20,16,9),(21,17,9);
/*!40000 ALTER TABLE `product_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Война и мир','Роман'),(2,'Преступление и наказание','Роман'),(3,'Идиот','Роман'),(4,'Колобок','Сказка'),(5,'Курочка Ряба','Сказка'),(6,'Репка','Сказка'),(7,'Вам меня не испугать','Роман'),(8,'Скандинавские боги','Роман'),(9,'Хроники','Биография'),(10,'Сказка о царе Салтане','Сказка'),(11,'У лукоморья дуб зелёный','Сказка'),(12,'Сказка о рыбаке и рыбке','Сказка'),(13,'Три сестры','Пьеса'),(14,'Дядя Ваня','Пьеса'),(15,'Вишневый сад','Пьеса'),(16,'Двенадцать стульев','Роман'),(17,'Остров мира','Пьесса');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products2`
--

DROP TABLE IF EXISTS `products2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products2` (
  `id` mediumint(9) NOT NULL,
  `title` varchar(30) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products2`
--

LOCK TABLES `products2` WRITE;
/*!40000 ALTER TABLE `products2` DISABLE KEYS */;
INSERT INTO `products2` VALUES (6,'Репка','Сказка'),(7,'Вам меня не испугать','Роман'),(8,'Скандинавские боги','Роман'),(9,'Хроники','Биография'),(10,'Сказка о царе Салтане','Сказка'),(11,'У лукоморья дуб зелёный','Сказка'),(16,'Двенадцать стульев','Роман'),(17,'Остров мира','Пьесса'),(18,'Анна Каренина','Роман'),(19,'Стив Джобс','Биография'),(20,'Американские боги','Роман'),(21,'Конёк-Горбунок','Сказка'),(22,'Ворона и Лисица','Басня'),(23,'Краткая история времени','Энциклопедия'),(25,'Война и мир','Роман');
/*!40000 ALTER TABLE `products2` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-22 16:45:15
