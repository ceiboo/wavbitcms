DROP TABLE IF EXISTS `users`;


CREATE TABLE IF NOT EXISTS `users` (
  `UserID` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(50) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `AllowLogin` enum('0','1') DEFAULT '0',
  `IsAdmin` enum('0','1') DEFAULT '0',
  `LastLogin` timestamp NULL DEFAULT NULL,
  `UserPass` varchar(500) NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
