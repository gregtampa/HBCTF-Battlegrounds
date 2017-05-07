-- MySQL dump 10.13  Distrib 5.7.17, for Linux (i686)
--
-- Host: localhost    Database: csecvm
-- ------------------------------------------------------
-- Server version	5.7.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `basket`
--

DROP TABLE IF EXISTS `basket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `basket` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `product_id` int(11) NOT NULL DEFAULT '0',
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `basket_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `basket_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `basket`
--

LOCK TABLES `basket` WRITE;
/*!40000 ALTER TABLE `basket` DISABLE KEYS */;
/*!40000 ALTER TABLE `basket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cc` varchar(16) DEFAULT NULL,
  `cvv` varchar(3) DEFAULT NULL,
  `expire` date DEFAULT NULL,
  `outfordelivery` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_items`
--

DROP TABLE IF EXISTS `orders_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orders_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `orders_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_items`
--

LOCK TABLES `orders_items` WRITE;
/*!40000 ALTER TABLE `orders_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `image` varchar(128) DEFAULT NULL,
  `description` text,
  `price` text,
  `danger` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'A Table','/img/uploads/2015-01-02_Xgxtm2.jpg','A very big table, useful for ... putting things on and possibly eating at.','110.00',0),(2,'A Lamp','/img/uploads/2015-01-02_lzfzpK.jpg','For lighting things up in a dark room.','60.00',0),(3,'A Drinks Globe and Chair','/img/uploads/2015-01-02_rN4jBX.jpg','A Drinks Globe, something that should be in everyone\'s home!','90.00',0),(4,'Rocks of Cocaine','/img/uploads/2015-01-05_48A2N6.jpg','Lots and lots of coke!','5000.00',1),(5,'Weed','/img/uploads/2015-01-05_JYIUmP.jpg','Plenty of weed. Top quality stuff.','40.00',1),(6,'Heroin','/img/uploads/2015-01-05_MUSlKg.jpg','More Class As for you!','6000.00',1),(7,'ZeuS Source Code','/img/uploads/2015-01-05_2F6zjh.jpg','Get the source code to deploy your own botnet.','500.00',1),(8,'BlackHole Crimeware','/img/uploads/2015-01-05_lPh78V.jpg','Start a bot, maintain and control it. Your own crimewave.','800.00',1),(9,'DDOS your enemies','/img/uploads/2015-01-05_qHt6s3.jpg','We use ZeuS to DDOS a target server of your choice.','100.00',1),(10,'Web hacking','/img/uploads/2015-01-05_btQvWF.jpg','Give us a URL and you have an hour of our work to bring down a site of your choice.','50.00',1),(11,'My Little Pony','/img/uploads/2015-01-05_f7rk0d.jpg','022f844f138df4cd87af0d89189d8f57','999999.00',1);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `token` (
  `token` varchar(256) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
INSERT INTO `token` VALUES ('f46659047894a919ab5f43c3338811e6');
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `full` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `is_dealer` tinyint(1) DEFAULT '0',
  `email` varchar(128) DEFAULT NULL,
  `killed_on` timestamp NULL DEFAULT NULL,
  `killed_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_killed` (`killed_by`),
  CONSTRAINT `fk_killed` FOREIGN KEY (`killed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'jts','John Saxon','*DC917E8329C06E9E7735775F8E8F5CF2F2AE1505',0,'j.t.saxon@cs.bham.ac.uk',NULL,NULL),(2,'tpc','Tom Chothia','*D13C4744CA50C108313F76D56E7C1C23F8844026',1,'t.chothia@cs.bham.ac.uk',NULL,NULL),(3,'csn','Chris Novakovic','*9C5B7560B497DFA8B05F1ED9E0D163FF1809DF7A',0,'c.novakovic@cs.bham.ac.uk','2015-01-02 16:39:01',2),(4,'igb','Ian Batten','*4A0F50F04E783107E072358BEB80DFD2CE206ABC',0,'i.batten@cs.bham.ac.uk','2015-01-02 16:39:01',2),(5,'air','Andreea Radu','*D03F2141E072304885CF0BB96B8E93B2F2F079E5',0,'a.i.radu@cs.bham.ac.uk',NULL,NULL),(6,'tom','tom','tom',0,'tom@bham.ac.uk',NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-03-30 15:50:25
