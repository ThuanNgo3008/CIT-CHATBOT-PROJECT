-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: chatbot_db
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `Department`
--

DROP TABLE IF EXISTS `Department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Department` (
  `department_id` int NOT NULL AUTO_INCREMENT,
  `department_code` varchar(10) NOT NULL,
  `department_name` varchar(100) NOT NULL,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_code` (`department_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Department`
--

LOCK TABLES `Department` WRITE;
/*!40000 ALTER TABLE `Department` DISABLE KEYS */;
INSERT INTO `Department` VALUES (1,'CIT','School of Computing and Information Technology'),(2,'SET','School of Engineering'),(3,'BBS','Becamex Business School'),(4,'SNS','School of Health Sciences');
/*!40000 ALTER TABLE `Department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Lecturer`
--

DROP TABLE IF EXISTS `Lecturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lecturer` (
  `lecturer_id` int NOT NULL AUTO_INCREMENT,
  `major_id` int NOT NULL,
  `lecturer_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`lecturer_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `lecturer_id` (`lecturer_id`,`major_id`),
  KEY `major_id` (`major_id`),
  CONSTRAINT `Lecturer_ibfk_1` FOREIGN KEY (`major_id`) REFERENCES `Major` (`major_id`),
  CONSTRAINT `Lecturer_chk_1` CHECK ((`email` like _utf8mb4'%@eiu.edu.vn'))
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Lecturer`
--

LOCK TABLES `Lecturer` WRITE;
/*!40000 ALTER TABLE `Lecturer` DISABLE KEYS */;
INSERT INTO `Lecturer` VALUES (1,2,'Huỳnh Tấn Phước','phuoc.huynh@eiu.edu.vn','0909383432'),(2,2,'Phan Văn Vinh','vinh.phan@eiu.edu.vn','0918491753'),(3,2,'Nguyễn Ngọc Thanh','thanh.nguyenngoc@eiu.edu.vn',''),(4,2,'Nguyễn Đức Tiến','tien.nguyenduc@eiu.edu.vn','0969343606'),(5,2,'Nguyễn Thị Ngọc Phim','phim.nguyen@eiu.edu.vn',''),(6,1,'Phạm Đại Xuân','xuan.phamdai@eiu.edu.vn','0909156924'),(7,1,'Hà Minh Ngọc','ngoc.ha@eiu.edu.vn','0908003888'),(8,1,'Đặng Phạm Hữu Thảo','thao.dang@eiu.edu.vn',''),(9,1,'Trần Văn Tài','tai.tran@eiu.edu.vn',''),(10,1,'Tất Quảng Phát','phat.tat@eiu.edu.vn',''),(11,1,'Nguyễn Thành Đại','dai.nguyen@eiu.edu.vn',''),(12,1,'Ung Văn Giàu','giau.ung@eiu.edu.vn',''),(13,1,'Nguyễn Hải Vĩnh Cường','cuong.nguyenhaivinh@eiu.edu.vn',''),(14,1,'Nguyễn Mạnh Phúc','phuc.nguyenmanh@eiu.edu.vn',''),(15,1,'Nguyễn Xuân Cường','cuong.nguyenxuan@eiu.edu.vn','0382453914'),(16,1,'Narayan Chandra Debnath','narayan.debnath@eiu.edu.vn',''),(17,1,'Trần Thị Như Quỳnh','quynh.tran@eiu.edu.vn','0967521271'),(18,1,'Nguyễn Tiến Tuấn Khiêm','khiem.nguyen@eiu.edu.vn','0333845452'),(19,1,'Cao Khắc Ngọc Lân','lan.cao@eiu.edu.vn','0828727594'),(20,1,'Đỗ Đặng Thanh Huy','huy.do@eiu.edu.vn','0896123044'),(21,1,'Anirban Mitra','anirban.mitra@eiu.edu.vn',''),(22,1,'Soumen Banerjee','soumen.banerjee@eiu.edu.vn',''),(23,1,'Đỗ Thị Thuỷ Phương','phuong.do@eiu.edu.vn','0886202289');
/*!40000 ALTER TABLE `Lecturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LecturerProject`
--

DROP TABLE IF EXISTS `LecturerProject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LecturerProject` (
  `lecturer_id` int NOT NULL,
  `project_id` int NOT NULL,
  `major_id` int NOT NULL,
  PRIMARY KEY (`lecturer_id`,`project_id`),
  KEY `lecturer_id` (`lecturer_id`,`major_id`),
  KEY `project_id` (`project_id`,`major_id`),
  CONSTRAINT `LecturerProject_ibfk_1` FOREIGN KEY (`lecturer_id`, `major_id`) REFERENCES `Lecturer` (`lecturer_id`, `major_id`),
  CONSTRAINT `LecturerProject_ibfk_2` FOREIGN KEY (`project_id`, `major_id`) REFERENCES `Project` (`project_id`, `major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LecturerProject`
--

LOCK TABLES `LecturerProject` WRITE;
/*!40000 ALTER TABLE `LecturerProject` DISABLE KEYS */;
INSERT INTO `LecturerProject` VALUES (1,1,2),(1,2,2),(1,3,2),(1,4,2),(1,5,2),(2,1,2),(2,2,2),(2,3,2),(2,4,2),(2,5,2),(3,1,2),(3,2,2),(3,3,2),(3,4,2),(3,5,2),(4,1,2),(4,2,2),(4,3,2),(4,4,2),(4,5,2),(5,1,2),(5,2,2),(5,3,2),(5,4,2),(5,5,2),(6,6,1),(6,7,1),(6,8,1),(6,9,1),(7,6,1),(7,7,1),(7,8,1),(7,9,1),(8,6,1),(8,7,1),(8,8,1),(8,9,1),(9,6,1),(9,7,1),(9,8,1),(9,9,1),(10,6,1),(10,7,1),(10,8,1),(10,9,1),(11,6,1),(11,7,1),(11,8,1),(11,9,1),(12,6,1),(12,7,1),(12,8,1),(12,9,1),(13,6,1),(13,7,1),(13,8,1),(13,9,1),(14,6,1),(14,7,1),(14,8,1),(14,9,1),(15,6,1),(15,7,1),(15,8,1),(15,9,1),(16,6,1),(16,7,1),(16,8,1),(16,9,1),(17,6,1),(17,7,1),(17,8,1),(17,9,1),(18,6,1),(18,7,1),(18,8,1),(18,9,1),(19,6,1),(19,7,1),(19,8,1),(19,9,1),(20,6,1),(20,7,1),(20,8,1),(20,9,1),(21,6,1),(21,7,1),(21,8,1),(21,9,1),(22,6,1),(22,7,1),(22,8,1),(22,9,1),(23,6,1),(23,7,1),(23,8,1),(23,9,1);
/*!40000 ALTER TABLE `LecturerProject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LecturerResearch`
--

DROP TABLE IF EXISTS `LecturerResearch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LecturerResearch` (
  `lecturer_id` int NOT NULL,
  `research_id` int NOT NULL,
  PRIMARY KEY (`lecturer_id`,`research_id`),
  KEY `research_id` (`research_id`),
  CONSTRAINT `LecturerResearch_ibfk_1` FOREIGN KEY (`lecturer_id`) REFERENCES `Lecturer` (`lecturer_id`),
  CONSTRAINT `LecturerResearch_ibfk_2` FOREIGN KEY (`research_id`) REFERENCES `ResearchArea` (`research_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LecturerResearch`
--

LOCK TABLES `LecturerResearch` WRITE;
/*!40000 ALTER TABLE `LecturerResearch` DISABLE KEYS */;
INSERT INTO `LecturerResearch` VALUES (1,1),(3,1),(5,1),(1,2),(2,3),(4,3),(5,3),(2,4),(4,4),(3,5),(3,6),(6,7),(13,7),(18,7),(6,8),(22,8),(6,9),(8,9),(18,9),(22,9),(6,10),(2,11),(13,11),(16,11),(18,11),(19,11),(22,11),(13,12),(18,13),(19,13),(22,13),(23,14),(16,15),(4,16),(8,16),(9,16),(10,16),(12,16),(14,16),(17,16),(20,16),(6,17),(11,18),(11,19),(13,19),(15,19),(19,19),(4,20),(7,20),(14,20),(15,20),(7,21),(14,21),(15,21),(19,21),(13,22),(13,23),(7,24),(16,24),(15,25),(17,25),(15,26),(17,26),(19,26),(19,27),(16,28),(18,29),(18,30),(18,31),(19,32),(19,33),(21,34),(21,35),(21,36),(21,37);
/*!40000 ALTER TABLE `LecturerResearch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Major`
--

DROP TABLE IF EXISTS `Major`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Major` (
  `major_id` int NOT NULL AUTO_INCREMENT,
  `major_name` varchar(100) NOT NULL,
  `department_id` int NOT NULL,
  PRIMARY KEY (`major_id`),
  UNIQUE KEY `department_id` (`department_id`,`major_name`),
  CONSTRAINT `Major_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `Department` (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Major`
--

LOCK TABLES `Major` WRITE;
/*!40000 ALTER TABLE `Major` DISABLE KEYS */;
INSERT INTO `Major` VALUES (2,'Data communications and Computer Networks',1),(1,'Software Engineering',1);
/*!40000 ALTER TABLE `Major` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project`
--

DROP TABLE IF EXISTS `Project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project` (
  `project_id` int NOT NULL AUTO_INCREMENT,
  `project_code` varchar(10) NOT NULL,
  `project_name` varchar(100) NOT NULL,
  `major_id` int NOT NULL,
  PRIMARY KEY (`project_id`),
  UNIQUE KEY `project_code` (`project_code`),
  UNIQUE KEY `project_code_2` (`project_code`,`major_id`),
  UNIQUE KEY `uq_project_major` (`project_id`,`major_id`),
  KEY `major_id` (`major_id`),
  CONSTRAINT `Project_ibfk_1` FOREIGN KEY (`major_id`) REFERENCES `Major` (`major_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project`
--

LOCK TABLES `Project` WRITE;
/*!40000 ALTER TABLE `Project` DISABLE KEYS */;
INSERT INTO `Project` VALUES (1,'CSN 340','CNDC Project',2),(2,'CSN 341','Internship',2),(3,'CSN 494','Capstone project 1',2),(4,'CSN 495','Capstone project 2',2),(5,'CSN 496','Capstone project 3',2),(6,'CSW 400','Internship',1),(7,'CSW 480','Capstone project 1',1),(8,'CSW 481','Capstone project 2',1),(9,'CSW 482','Capstone project 3',1);
/*!40000 ALTER TABLE `Project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ResearchArea`
--

DROP TABLE IF EXISTS `ResearchArea`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ResearchArea` (
  `research_id` int NOT NULL AUTO_INCREMENT,
  `research_name` varchar(100) NOT NULL,
  PRIMARY KEY (`research_id`),
  UNIQUE KEY `research_name` (`research_name`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ResearchArea`
--

LOCK TABLES `ResearchArea` WRITE;
/*!40000 ALTER TABLE `ResearchArea` DISABLE KEYS */;
INSERT INTO `ResearchArea` VALUES (16,'Application Development'),(11,'Artificial Intelligence'),(1,'Computer Networks'),(7,'Computer Vision'),(29,'Control Systems'),(6,'Cyber Security'),(25,'Data Analytics'),(28,'Data Management'),(27,'Data Science'),(26,'Data Visualisation'),(13,'Deep Learning'),(23,'Game Development'),(37,'Human Behavior Analysis'),(8,'Image Processing'),(3,'Internet of Things (IoT)'),(18,'Java Desktop Applications'),(17,'Java Software Development'),(35,'Knowledge Graph'),(36,'Knowledge Management'),(9,'Machine Learning'),(22,'Mobile Application Development'),(12,'Natural Language Processing'),(2,'Network Security'),(10,'Pattern Recognition'),(31,'Power Electronics'),(30,'Robotics'),(34,'Social Network Analysis'),(14,'Software Development'),(15,'Software Engineering'),(24,'Software Testing'),(33,'Speech-to-Text (STT)'),(5,'System Administration'),(32,'Text-to-Speech (TTS)'),(21,'Web Back-end'),(19,'Web Development'),(20,'Web Front-end'),(4,'Wireless Sensor Networks');
/*!40000 ALTER TABLE `ResearchArea` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-08  0:19:27
