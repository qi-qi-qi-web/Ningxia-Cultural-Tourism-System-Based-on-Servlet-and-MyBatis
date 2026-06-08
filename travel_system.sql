-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: travel_system
-- ------------------------------------------------------
-- Server version	9.6.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '65c12ca1-21ec-11f1-a59e-fc5cee66ca0c:1-367';

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `target_id` int DEFAULT NULL,
  `content` text,
  `star` int DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `scenic_id` int DEFAULT NULL,
  `hotel_id` int DEFAULT NULL,
  `route_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_com_user` (`user_id`),
  KEY `fk_com_scenic` (`scenic_id`),
  KEY `fk_com_hotel` (`hotel_id`),
  KEY `fk_com_route` (`route_id`),
  CONSTRAINT `fk_com_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_com_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_com_scenic` FOREIGN KEY (`scenic_id`) REFERENCES `scenic_spots` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_com_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,1,'scenic',1,'沙湖太美了，值得一去！',5,'2026-06-02 15:49:59',NULL,NULL,NULL),(2,1,'scenic',2,'大话西游取景地，情怀满满！',5,'2026-06-02 15:49:59',NULL,NULL,NULL),(3,1,'hotel',1,'酒店环境很好，住着舒服',5,'2026-06-02 15:49:59',NULL,NULL,NULL);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `cover_img` varchar(255) DEFAULT NULL,
  `images` text,
  `content` text,
  `star` varchar(20) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `tel` varchar(20) DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `mer_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_hotel_mer` (`mer_id`),
  CONSTRAINT `fk_hotel_mer` FOREIGN KEY (`mer_id`) REFERENCES `merchants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotels`
--

LOCK TABLES `hotels` WRITE;
/*!40000 ALTER TABLE `hotels` DISABLE KEYS */;
INSERT INTO `hotels` VALUES (1,'银川国际饭店','宁夏银川市兴庆区',NULL,NULL,'银川市中心高端酒店，交通便利，设施完善，服务优质。','五星级',380.00,'0951-88888888',1,'2026-06-02 15:49:59',NULL);
/*!40000 ALTER TABLE `hotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_log_user` (`user_id`),
  CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchants`
--

DROP TABLE IF EXISTS `merchants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchants`
--

LOCK TABLES `merchants` WRITE;
/*!40000 ALTER TABLE `merchants` DISABLE KEYS */;
/*!40000 ALTER TABLE `merchants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notices`
--

DROP TABLE IF EXISTS `notices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `content` text,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notices`
--

LOCK TABLES `notices` WRITE;
/*!40000 ALTER TABLE `notices` DISABLE KEYS */;
INSERT INTO `notices` VALUES (1,'宁夏文旅温馨提示','欢迎来到宁夏，请注意防晒、补水，祝您旅途愉快！','2026-06-02 15:49:59'),(2,'景区开放通知','沙湖、镇北堡、沙坡头全年正常开放！','2026-06-02 15:49:59');
/*!40000 ALTER TABLE `notices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_form`
--

DROP TABLE IF EXISTS `order_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_form` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_no` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `type` varchar(20) DEFAULT NULL COMMENT 'scenic/hotel/route',
  `scenic_id` int DEFAULT NULL,
  `hotel_id` int DEFAULT NULL,
  `ticket_id` int DEFAULT NULL,
  `num` int DEFAULT '1',
  `total_price` decimal(10,2) DEFAULT NULL,
  `pay_time` datetime DEFAULT NULL,
  `status` tinyint DEFAULT '0' COMMENT '0=未支付, 1=已支付, 2=已取消, 3=已退款',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `route_id` int DEFAULT NULL,
  `contact_name` varchar(30) DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系人电话',
  PRIMARY KEY (`id`),
  KEY `idx_order_user_id` (`user_id`),
  KEY `idx_order_order_no` (`order_no`),
  KEY `idx_order_scenic_id` (`scenic_id`),
  KEY `idx_order_hotel_id` (`hotel_id`),
  KEY `idx_order_ticket_id` (`ticket_id`),
  KEY `idx_order_route_id` (`route_id`),
  CONSTRAINT `fk_ord_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ord_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ord_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ord_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_form`
--

LOCK TABLES `order_form` WRITE;
/*!40000 ALTER TABLE `order_form` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route_scenic`
--

DROP TABLE IF EXISTS `route_scenic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route_scenic` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '中间表主键',
  `route_id` int NOT NULL COMMENT '线路ID，关联routes.id',
  `scenic_id` int NOT NULL COMMENT '景点ID，关联scenic_spots.id',
  `sort` int DEFAULT '0' COMMENT '景点在线路中的游玩顺序',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_scenic` (`route_id`,`scenic_id`) COMMENT '防止重复关联',
  KEY `scenic_id` (`scenic_id`),
  CONSTRAINT `route_scenic_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `route_scenic_ibfk_2` FOREIGN KEY (`scenic_id`) REFERENCES `scenic_spots` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='旅游线路关联景点中间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route_scenic`
--

LOCK TABLES `route_scenic` WRITE;
/*!40000 ALTER TABLE `route_scenic` DISABLE KEYS */;
/*!40000 ALTER TABLE `route_scenic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `routes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `cover_img` varchar(255) DEFAULT NULL,
  `days` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `content` text,
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
INSERT INTO `routes` VALUES (1,'宁夏经典3日游',NULL,3,580.00,'第一天：沙湖；第二天：镇北堡西部影城；第三天：沙坡头。纯玩无购物！',1,'2026-06-02 15:49:59');
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scenic_spots`
--

DROP TABLE IF EXISTS `scenic_spots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scenic_spots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `cover_img` varchar(255) DEFAULT NULL,
  `images` text,
  `content` text,
  `price` decimal(10,2) DEFAULT NULL,
  `open_time` varchar(100) DEFAULT NULL,
  `tel` varchar(20) DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `sort` int DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `mer_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_scenic_mer` (`mer_id`),
  CONSTRAINT `fk_scenic_mer` FOREIGN KEY (`mer_id`) REFERENCES `merchants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scenic_spots`
--

LOCK TABLES `scenic_spots` WRITE;
/*!40000 ALTER TABLE `scenic_spots` DISABLE KEYS */;
INSERT INTO `scenic_spots` VALUES (1,'沙湖生态旅游区','宁夏石嘴山市平罗县',NULL,NULL,'沙湖是国家5A级景区，以沙、水、苇、鸟、山五大景源有机结合，被誉为“世间少有”的文化旅游胜地。',60.00,'08:00-18:00','0952-12345678',1,0,'2026-06-02 15:49:59',NULL),(2,'镇北堡西部影城','宁夏银川市西夏区',NULL,NULL,'《大话西游》《红高粱》拍摄地，中国十大影视基地，国家5A级景区。',80.00,'08:00-18:00','0951-12345678',1,0,'2026-06-02 15:49:59',NULL),(3,'沙坡头旅游区','宁夏中卫市沙坡头区',NULL,NULL,'黄河与沙漠交汇，国家5A级景区，拥有滑沙、黄河漂流、沙漠骆驼等特色体验。',100.00,'08:00-19:00','0955-12345678',1,0,'2026-06-02 15:49:59',NULL);
/*!40000 ALTER TABLE `scenic_spots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `scenic_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int DEFAULT '0',
  `type` varchar(20) DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_tik_scenic` (`scenic_id`),
  CONSTRAINT `fk_tik_scenic` FOREIGN KEY (`scenic_id`) REFERENCES `scenic_spots` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
INSERT INTO `tickets` VALUES (1,1,'沙湖门票',60.00,1000,NULL,1,'2026-06-02 15:49:59'),(2,2,'镇北堡西部影城门票',80.00,1000,NULL,1,'2026-06-02 15:49:59'),(3,3,'沙坡头门票',100.00,1000,NULL,1,'2026-06-02 15:49:59');
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `nickname` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `role` varchar(20) DEFAULT 'user',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','123456','系统管理员','13800000000',NULL,1,'admin','2026-06-02 15:49:59');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'travel_system'
--
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-08 16:45:16
