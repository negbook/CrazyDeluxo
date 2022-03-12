
CREATE DATABASE IF NOT EXISTS `crazydeluxo` 
USE `crazydeluxo`;

CREATE TABLE IF NOT EXISTS `ranking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scores` double DEFAULT NULL,
  `mode` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `playername` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `updatetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

