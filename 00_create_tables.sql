# airline
CREATE TABLE `airline` (
  `airline_id` smallint NOT NULL,
  `iata` char(2) DEFAULT NULL,
  `airlinename` varchar(30) DEFAULT NULL,
  `base_airport` smallint DEFAULT NULL,
  PRIMARY KEY (`airline_id`),
  KEY `airline_id` (`airline_id`),
  KEY `base_airport` (`base_airport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# airplane
CREATE TABLE `airplane` (
  `airplane_id` int NOT NULL,
  `capacity` mediumint NOT NULL,
  `type_id` int NOT NULL,
  `airline_id` smallint NOT NULL,
  PRIMARY KEY (`airplane_id`),
  KEY `airplane_id` (`airplane_id`),
  KEY `type_id` (`type_id`),
  KEY `airline_id` (`airline_id`),
  CONSTRAINT `airplane_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `airplane_type` (`type_id`),
  CONSTRAINT `airplane_ibfk_2` FOREIGN KEY (`airline_id`) REFERENCES `airline` (`airline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# airplane_type
CREATE TABLE `airplane_type` (
  `type_id` int NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`type_id`),
  KEY `type_id` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# airport
CREATE TABLE `airport` (
  `airport_id` smallint NOT NULL,
  `iata` char(3) DEFAULT NULL,
  `icao` char(4) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`airport_id`),
  KEY `airport_id` (`airport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# airport_geo
CREATE TABLE `airport_geo` (
  `airport_id` smallint NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `latitude` decimal(11,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `geolocation` point DEFAULT NULL,
  PRIMARY KEY (`airport_id`),
  CONSTRAINT `airport_geo_ibfk_1` FOREIGN KEY (`airport_id`) REFERENCES `airport` (`airport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# airport_reachable
CREATE TABLE `airport_reachable` (
  `airport_id` smallint DEFAULT NULL,
  `hops` int DEFAULT NULL,
  KEY `airport_id` (`airport_id`),
  CONSTRAINT `airport_reachable_ibfk_1` FOREIGN KEY (`airport_id`) REFERENCES `airport` (`airport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# booking
CREATE TABLE `booking` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `flight_id` int NOT NULL,
  `seat` char(4) NOT NULL,
  `passenger_id` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `flight_id_2` (`flight_id`,`seat`),
  KEY `flight_id` (`flight_id`),
  KEY `passenger_id` (`passenger_id`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`passenger_id`) REFERENCES `passenger` (`passenger_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55093895 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# employee
CREATE TABLE `employee` (
  `employee_id` int NOT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `zip` smallint DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `emailaddress` varchar(120) DEFAULT NULL,
  `telephone` varchar(30) DEFAULT NULL,
  `salary` decimal(8,2) DEFAULT NULL,
  `department` varchar(120) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `password` char(32) DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# flight
CREATE TABLE `flight` (
  `flight_id` int NOT NULL,
  `flightno` char(8) DEFAULT NULL,
  `from` smallint DEFAULT NULL,
  `to` smallint DEFAULT NULL,
  `departure` datetime DEFAULT NULL,
  `arrival` datetime DEFAULT NULL,
  `airline_id` smallint DEFAULT NULL,
  `airplane_id` int DEFAULT NULL,
  PRIMARY KEY (`flight_id`),
  KEY `flight_id` (`flight_id`),
  KEY `from` (`from`),
  KEY `to` (`to`),
  KEY `airline_id` (`airline_id`),
  KEY `airplane_id` (`airplane_id`),
  CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`from`) REFERENCES `airport` (`airport_id`),
  CONSTRAINT `flight_ibfk_2` FOREIGN KEY (`to`) REFERENCES `airport` (`airport_id`),
  CONSTRAINT `flight_ibfk_3` FOREIGN KEY (`airline_id`) REFERENCES `airline` (`airline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# flightschedule
CREATE TABLE `flightschedule` (
  `flightno` char(8) DEFAULT NULL,
  `from` smallint DEFAULT NULL,
  `to` smallint DEFAULT NULL,
  `departure` time DEFAULT NULL,
  `arrival` time DEFAULT NULL,
  `airline_id` smallint DEFAULT NULL,
  `monday` tinyint(1) DEFAULT NULL,
  `tuesday` tinyint(1) DEFAULT NULL,
  `wednesday` tinyint(1) DEFAULT NULL,
  `thursday` tinyint(1) DEFAULT NULL,
  `friday` tinyint(1) DEFAULT NULL,
  `saturday` tinyint(1) DEFAULT NULL,
  `sunday` tinyint(1) DEFAULT NULL,
  KEY `flightno` (`flightno`),
  KEY `from` (`from`),
  KEY `to` (`to`),
  KEY `airline_id` (`airline_id`),
  CONSTRAINT `flightschedule_ibfk_1` FOREIGN KEY (`from`) REFERENCES `airport` (`airport_id`),
  CONSTRAINT `flightschedule_ibfk_2` FOREIGN KEY (`to`) REFERENCES `airport` (`airport_id`),
  CONSTRAINT `flightschedule_ibfk_3` FOREIGN KEY (`airline_id`) REFERENCES `airline` (`airline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# flight_log
CREATE TABLE `flight_log` (
  `flight_log_id` int NOT NULL,
  `log_date` datetime DEFAULT NULL,
  `user` varchar(100) DEFAULT NULL,
  `flight_id` int DEFAULT NULL,
  `flightno_old` char(8) DEFAULT NULL,
  `flightno_new` char(8) DEFAULT NULL,
  `from_old` smallint DEFAULT NULL,
  `to_old` smallint DEFAULT NULL,
  `from_new` smallint DEFAULT NULL,
  `to_new` smallint DEFAULT NULL,
  `departure_old` datetime DEFAULT NULL,
  `arrival_old` datetime DEFAULT NULL,
  `departure_new` datetime DEFAULT NULL,
  `arrival_new` datetime DEFAULT NULL,
  `airplane_id_old` int DEFAULT NULL,
  `airplane_id_new` int DEFAULT NULL,
  `airline_id_old` smallint DEFAULT NULL,
  `airline_id_new` smallint DEFAULT NULL,
  `comment` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`flight_log_id`),
  KEY `flight_id` (`flight_id`),
  CONSTRAINT `flight_log_ibfk_1` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# passenger
CREATE TABLE `passenger` (
  `passenger_id` int NOT NULL,
  `passport_no` char(9) DEFAULT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`passenger_id`),
  KEY `passenger_id` (`passenger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# passengerdetails
CREATE TABLE `passengerdetails` (
  `passenger_id` int NOT NULL,
  `birthdate` date DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `zip` smallint DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `emailaddress` varchar(120) DEFAULT NULL,
  `telephone` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`passenger_id`),
  CONSTRAINT `passengerdetails_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `passenger` (`passenger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# weatherdata
CREATE TABLE `weatherdata` (
  `log_date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `station` int DEFAULT NULL,
  `temp` decimal(3,1) DEFAULT NULL,
  `humidity` decimal(4,1) DEFAULT NULL,
  `airpressure` decimal(10,2) DEFAULT NULL,
  `wind` decimal(5,2) DEFAULT NULL,
  `weather` varchar(100) DEFAULT NULL,
  `winddirection` smallint DEFAULT NULL,
  KEY `log_date` (`log_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci