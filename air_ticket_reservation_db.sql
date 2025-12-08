-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 07, 2025 at 06:23 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `air_ticket_reservation_db`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `agent_analytics`
-- (See below for the actual view)
--
CREATE TABLE `agent_analytics` (
`booking_agent_email` varchar(100)
,`ticket_id` int(11)
,`customer_email` varchar(100)
,`purchase_date` date
,`airline_name` varchar(100)
,`flight_num` varchar(100)
,`sold_price` decimal(10,2)
,`commission` decimal(13,4)
);

-- --------------------------------------------------------

--
-- Table structure for table `airline`
--

CREATE TABLE `airline` (
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airline`
--

INSERT INTO `airline` (`name`) VALUES
('American'),
('ANA'),
('British Airways'),
('Delta'),
('United');

-- --------------------------------------------------------

--
-- Table structure for table `airline_staff`
--

CREATE TABLE `airline_staff` (
  `username` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `airline_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airline_staff`
--

INSERT INTO `airline_staff` (`username`, `password`, `first_name`, `last_name`, `date_of_birth`, `airline_name`) VALUES
('jane_sj', 'staffpassword', 'Jane', 'Doe', '1990-03-14', 'United'),
('kate_american', 'pwdk', 'Kate', 'Johnson', '1982-02-20', 'American'),
('oliver_ba', 'pwdo', 'Oliver', 'Miller', '1987-03-28', 'British Airways'),
('sam_delta', 'pwds', 'Sam', 'Turner', '1985-07-11', 'Delta'),
('yuji_ana', 'pwdy', 'Yuji', 'Sato', '1991-09-09', 'ANA');

-- --------------------------------------------------------

--
-- Table structure for table `airplane`
--

CREATE TABLE `airplane` (
  `airline_name` varchar(100) NOT NULL,
  `id` int(11) NOT NULL,
  `seat_capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airplane`
--

INSERT INTO `airplane` (`airline_name`, `id`, `seat_capacity`) VALUES
('American', 1, 200),
('American', 2, 260),
('ANA', 1, 180),
('ANA', 2, 300),
('British Airways', 1, 220),
('British Airways', 2, 300),
('Delta', 1, 190),
('Delta', 2, 250),
('United', 1, 180),
('United', 2, 220);

-- --------------------------------------------------------

--
-- Table structure for table `airport`
--

CREATE TABLE `airport` (
  `name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airport`
--

INSERT INTO `airport` (`name`, `city`) VALUES
('LHR', 'London'),
('LAX', 'Los Angeles'),
('JFK', 'New York'),
('PVG', 'Shanghai'),
('NRT', 'Tokyo');

-- --------------------------------------------------------

--
-- Table structure for table `authorized_by`
--

CREATE TABLE `authorized_by` (
  `agent_email` varchar(100) NOT NULL,
  `airline_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `authorized_by`
--

INSERT INTO `authorized_by` (`agent_email`, `airline_name`) VALUES
('agent1@gmail.com', 'United'),
('agent2@gmail.com', 'Delta'),
('agent3@gmail.com', 'ANA'),
('agent3@gmail.com', 'British Airways');

-- --------------------------------------------------------

--
-- Table structure for table `booking_agent`
--

CREATE TABLE `booking_agent` (
  `email` varchar(100) NOT NULL,
  `password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking_agent`
--

INSERT INTO `booking_agent` (`email`, `password`) VALUES
('agent1@gmail.com', 'agentpassword'),
('agent2@gmail.com', 'pass2'),
('agent3@gmail.com', 'pass3');

-- --------------------------------------------------------

--
-- Stand-in structure for view `browse_flights`
-- (See below for the actual view)
--
CREATE TABLE `browse_flights` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_airport` varchar(100)
,`departure_city` varchar(100)
,`departure_time` varchar(100)
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` varchar(100)
,`price` decimal(10,2)
,`status` varchar(20)
,`airplane_id` int(11)
,`available_seats` bigint(22)
);

-- --------------------------------------------------------

--
-- Table structure for table `city`
--

CREATE TABLE `city` (
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `city`
--

INSERT INTO `city` (`name`) VALUES
('London'),
('Los Angeles'),
('New York'),
('Shanghai'),
('Tokyo');

-- --------------------------------------------------------

--
-- Table structure for table `city_alias`
--

CREATE TABLE `city_alias` (
  `alias_name` varchar(100) NOT NULL,
  `city_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `city_alias`
--

INSERT INTO `city_alias` (`alias_name`, `city_name`) VALUES
('Hu City', 'Shanghai'),
('LA', 'Los Angeles'),
('Nippon Capital', 'Tokyo'),
('NYC', 'New York'),
('The Big Apple', 'New York'),
('The Big Smoke', 'London'),
('The City of Angels', 'Los Angeles'),
('The Pearl of the Orient', 'Shanghai');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `email` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `building` varchar(100) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `phone_number` varchar(100) DEFAULT NULL,
  `passport_number` varchar(100) DEFAULT NULL,
  `passport_expiration_date` date DEFAULT NULL,
  `passport_country` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`email`, `name`, `password`, `building`, `street`, `city`, `state`, `phone_number`, `passport_number`, `passport_expiration_date`, `passport_country`, `date_of_birth`) VALUES
('drake@gmail.com', 'Drake', 'pwdd', NULL, NULL, NULL, NULL, '416-555-1515', 'P99903', '2031-01-01', 'Canada', '1986-10-24'),
('emmawatson@gmail.com', 'Emma Watson', 'pwde', NULL, NULL, NULL, NULL, '020-555-2020', 'P99904', '2033-03-03', 'UK', '1990-04-15'),
('rihanna@gmail.com', 'Rihanna', 'pwdr', NULL, NULL, NULL, NULL, '310-555-1212', 'P99902', '2032-08-14', 'Barbados', '1988-02-20'),
('sabrinacarpenter@gmail.com', 'Sabrina Carpenter', 'password3', NULL, NULL, NULL, NULL, '646-555-3333', 'P54321', '2032-04-01', 'USA', '1999-05-11'),
('selenagomez@gmail.com', 'Selena Gomez', 'password2', NULL, NULL, NULL, NULL, '917-555-2222', 'P67890', '2031-01-15', 'USA', '1992-07-22'),
('taylorswift@gmail.com', 'Taylor Swift', 'password1', NULL, NULL, NULL, NULL, '123-456-7891', 'P12345', '2030-05-10', 'USA', '1989-12-13'),
('zendaya@gmail.com', 'Zendaya', 'pwdz', NULL, NULL, NULL, NULL, '212-555-1111', 'P99901', '2030-06-10', 'USA', '1996-09-01');

-- --------------------------------------------------------

--
-- Stand-in structure for view `customers_list_for_flight`
-- (See below for the actual view)
--
CREATE TABLE `customers_list_for_flight` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_time` varchar(100)
,`arrival_time` varchar(100)
,`ticket_id` int(11)
,`purchase_date` date
,`booking_agent_email` varchar(100)
,`customer_email` varchar(100)
,`customer_name` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `customer_analytics`
-- (See below for the actual view)
--
CREATE TABLE `customer_analytics` (
`airline_name` varchar(100)
,`customer_email` varchar(100)
,`customer_name` varchar(100)
,`tickets_purchased` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `flight`
--

CREATE TABLE `flight` (
  `flight_num` varchar(100) NOT NULL,
  `airline_name` varchar(100) NOT NULL,
  `departure_time` varchar(100) NOT NULL,
  `arrival_time` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL CHECK (`status` in ('upcoming','in-progress','delayed')),
  `airplane_id` int(11) NOT NULL,
  `departure_airport` varchar(100) NOT NULL,
  `arrival_airport` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `flight`
--

INSERT INTO `flight` (`flight_num`, `airline_name`, `departure_time`, `arrival_time`, `price`, `status`, `airplane_id`, `departure_airport`, `arrival_airport`) VALUES
('AA300', 'American', '2025-10-10 09:00', '2025-10-10 17:00', 500.00, 'delayed', 1, 'LAX', 'LHR'),
('AA301', 'American', '2025-10-18 22:00', '2025-10-19 01:30', 250.00, 'upcoming', 2, 'LHR', 'LAX'),
('AA400', 'American', '2026-05-11 10:00', '2026-05-11 17:45', 520.00, 'upcoming', 1, 'LAX', 'LHR'),
('AA401', 'American', '2026-06-21 21:00', '2026-06-22 01:25', 260.00, 'upcoming', 2, 'LHR', 'LAX'),
('BA400', 'British Airways', '2025-08-30 07:30', '2025-08-30 11:30', 420.00, 'upcoming', 1, 'LHR', 'JFK'),
('BA401', 'British Airways', '2025-08-17 13:00', '2025-08-17 17:00', 440.00, 'delayed', 2, 'JFK', 'LHR'),
('BA500', 'British Airways', '2026-07-05 07:00', '2026-07-05 11:10', 430.00, 'upcoming', 1, 'LHR', 'JFK'),
('BA501', 'British Airways', '2026-07-19 13:00', '2026-07-19 17:05', 450.00, 'upcoming', 2, 'JFK', 'LHR'),
('DL200', 'Delta', '2025-11-05 07:00', '2025-11-05 15:30', 650.00, 'upcoming', 1, 'LAX', 'JFK'),
('DL201', 'Delta', '2025-11-08 12:15', '2025-11-09 06:45', 900.00, 'in-progress', 2, 'JFK', 'NRT'),
('DL300', 'Delta', '2026-01-18 06:00', '2026-01-18 14:30', 700.00, 'upcoming', 1, 'LAX', 'JFK'),
('DL301', 'Delta', '2026-02-05 13:15', '2026-02-06 09:20', 980.00, 'upcoming', 2, 'JFK', 'NRT'),
('NH100', 'ANA', '2025-09-22 14:00', '2025-09-22 22:00', 850.00, 'in-progress', 1, 'NRT', 'PVG'),
('NH101', 'ANA', '2025-09-23 08:00', '2025-09-23 16:20', 880.00, 'upcoming', 2, 'PVG', 'NRT'),
('NH200', 'ANA', '2026-03-03 09:00', '2026-03-03 17:00', 870.00, 'upcoming', 1, 'NRT', 'PVG'),
('NH201', 'ANA', '2026-03-04 08:00', '2026-03-04 16:00', 900.00, 'upcoming', 2, 'PVG', 'NRT'),
('UA100', 'United', '2025-10-12 08:00', '2025-10-12 20:00', 850.00, 'upcoming', 1, 'JFK', 'PVG'),
('UA101', 'United', '2025-10-09 06:30', '2025-10-09 10:45', 180.00, 'in-progress', 2, 'PVG', 'JFK'),
('UA102', 'United', '2025-10-08 09:00', '2025-10-08 13:30', 190.00, 'delayed', 1, 'JFK', 'PVG'),
('UA200', 'United', '2026-03-10 07:30', '2026-03-10 15:00', 820.00, 'upcoming', 1, 'JFK', 'PVG'),
('UA201', 'United', '2026-04-02 12:00', '2026-04-02 18:10', 210.00, 'upcoming', 2, 'PVG', 'JFK');

-- --------------------------------------------------------

--
-- Stand-in structure for view `in_progress_flights`
-- (See below for the actual view)
--
CREATE TABLE `in_progress_flights` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_airport` varchar(100)
,`departure_city` varchar(100)
,`departure_time` varchar(100)
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` varchar(100)
,`price` decimal(10,2)
,`status` varchar(20)
,`airplane_id` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `next_30_days_flights`
-- (See below for the actual view)
--
CREATE TABLE `next_30_days_flights` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_airport` varchar(100)
,`departure_city` varchar(100)
,`departure_time` varchar(100)
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` varchar(100)
,`price` decimal(10,2)
,`status` varchar(20)
,`airplane_id` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `past_flights`
-- (See below for the actual view)
--
CREATE TABLE `past_flights` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_airport` varchar(100)
,`departure_city` varchar(100)
,`departure_time` varchar(100)
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` varchar(100)
,`price` decimal(10,2)
,`status` varchar(20)
,`airplane_id` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `permission`
--

CREATE TABLE `permission` (
  `permission_type` varchar(100) NOT NULL CHECK (`permission_type` in ('admin','operator')),
  `airline_staff_username` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `permission`
--

INSERT INTO `permission` (`permission_type`, `airline_staff_username`) VALUES
('admin', 'jane_sj'),
('operator', 'jane_sj'),
('admin', 'kate_american'),
('operator', 'kate_american'),
('admin', 'oliver_ba'),
('admin', 'sam_delta'),
('operator', 'sam_delta'),
('operator', 'yuji_ana');

-- --------------------------------------------------------

--
-- Stand-in structure for view `purchased_flights`
-- (See below for the actual view)
--
CREATE TABLE `purchased_flights` (
`ticket_id` int(11)
,`customer_email` varchar(100)
,`customer_name` varchar(100)
,`booking_agent_email` varchar(100)
,`purchase_date` date
,`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_airport` varchar(100)
,`departure_city` varchar(100)
,`departure_time` varchar(100)
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` varchar(100)
,`price` decimal(10,2)
,`status` varchar(20)
,`airplane_id` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `ticket_id` int(11) NOT NULL,
  `customer_email` varchar(100) NOT NULL,
  `booking_agent_email` varchar(100) DEFAULT NULL,
  `purchase_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`ticket_id`, `customer_email`, `booking_agent_email`, `purchase_date`) VALUES
(220, 'rihanna@gmail.com', NULL, '2025-12-04'),
(854, 'drake@gmail.com', NULL, '2025-12-04'),
(1001, 'taylorswift@gmail.com', 'agent1@gmail.com', '2025-10-01'),
(1002, 'selenagomez@gmail.com', NULL, '2025-10-02'),
(1003, 'sabrinacarpenter@gmail.com', NULL, '2025-10-03'),
(2001, 'zendaya@gmail.com', 'agent2@gmail.com', '2025-10-05'),
(2002, 'zendaya@gmail.com', NULL, '2025-10-06'),
(2003, 'rihanna@gmail.com', 'agent2@gmail.com', '2025-10-04'),
(2004, 'drake@gmail.com', NULL, '2025-09-29'),
(2005, 'emmawatson@gmail.com', 'agent3@gmail.com', '2025-09-15'),
(2006, 'zendaya@gmail.com', 'agent3@gmail.com', '2025-09-16'),
(2007, 'drake@gmail.com', NULL, '2025-08-20'),
(2008, 'rihanna@gmail.com', 'agent3@gmail.com', '2025-08-21'),
(2199, 'drake@gmail.com', NULL, '2025-12-04'),
(3001, 'taylorswift@gmail.com', 'agent1@gmail.com', '2026-02-25'),
(3002, 'selenagomez@gmail.com', NULL, '2026-03-15'),
(3003, 'zendaya@gmail.com', 'agent2@gmail.com', '2026-01-05'),
(3004, 'rihanna@gmail.com', 'agent2@gmail.com', '2026-01-14'),
(3005, 'drake@gmail.com', NULL, '2026-04-22'),
(3006, 'emmawatson@gmail.com', 'agent2@gmail.com', '2026-05-01'),
(3007, 'rihanna@gmail.com', 'agent3@gmail.com', '2026-02-12'),
(3008, 'zendaya@gmail.com', NULL, '2026-02-14'),
(3009, 'drake@gmail.com', 'agent3@gmail.com', '2026-06-30'),
(3010, 'emmawatson@gmail.com', NULL, '2026-07-01'),
(3516, 'rihanna@gmail.com', NULL, '2025-12-04'),
(3740, 'rihanna@gmail.com', NULL, '2025-12-04'),
(4108, 'rihanna@gmail.com', NULL, '2025-12-04'),
(4304, 'drake@gmail.com', NULL, '2025-12-04'),
(5116, 'rihanna@gmail.com', NULL, '2025-12-04'),
(5165, 'rihanna@gmail.com', NULL, '2025-12-04'),
(5600, 'drake@gmail.com', NULL, '2025-12-04'),
(6310, 'rihanna@gmail.com', NULL, '2025-12-04'),
(6885, 'rihanna@gmail.com', NULL, '2025-12-04'),
(6900, 'rihanna@gmail.com', NULL, '2025-12-04'),
(7153, 'drake@gmail.com', NULL, '2025-12-04'),
(8101, 'rihanna@gmail.com', NULL, '2025-12-04'),
(9042, 'rihanna@gmail.com', NULL, '2025-12-04'),
(9072, 'rihanna@gmail.com', NULL, '2025-12-04');

-- --------------------------------------------------------

--
-- Stand-in structure for view `sold_tickets_w_airline`
-- (See below for the actual view)
--
CREATE TABLE `sold_tickets_w_airline` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`ticket_id` int(11)
,`customer_email` varchar(100)
,`booking_agent_email` varchar(100)
,`purchase_date` date
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `spending`
-- (See below for the actual view)
--
CREATE TABLE `spending` (
`customer_email` varchar(100)
,`customer_name` varchar(100)
,`purchase_date` date
,`airline_name` varchar(100)
,`flight_num` varchar(100)
,`ticket_price` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `staff_analytics`
-- (See below for the actual view)
--
CREATE TABLE `staff_analytics` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_airport` varchar(100)
,`departure_city` varchar(100)
,`departure_time` varchar(100)
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` varchar(100)
,`price` decimal(10,2)
,`status` varchar(20)
,`airplane_id` int(11)
,`ticket_id` int(11)
,`purchase_date` date
,`customer_email` varchar(100)
,`customer_name` varchar(100)
,`booking_agent_email` varchar(100)
,`agent_email` varchar(100)
,`sold_price` decimal(10,2)
,`commission` decimal(13,4)
,`tickets_purchased` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `ticket_id` int(11) NOT NULL,
  `flight_num` varchar(100) NOT NULL,
  `airline_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ticket`
--

INSERT INTO `ticket` (`ticket_id`, `flight_num`, `airline_name`) VALUES
(2003, 'AA300', 'American'),
(2004, 'AA301', 'American'),
(4304, 'AA301', 'American'),
(854, 'AA400', 'American'),
(3005, 'AA400', 'American'),
(7153, 'AA400', 'American'),
(3006, 'AA401', 'American'),
(2007, 'BA400', 'British Airways'),
(2008, 'BA401', 'British Airways'),
(3009, 'BA500', 'British Airways'),
(3010, 'BA501', 'British Airways'),
(2001, 'DL200', 'Delta'),
(2199, 'DL200', 'Delta'),
(5600, 'DL200', 'Delta'),
(6885, 'DL200', 'Delta'),
(6900, 'DL200', 'Delta'),
(8101, 'DL200', 'Delta'),
(9042, 'DL200', 'Delta'),
(2002, 'DL201', 'Delta'),
(3003, 'DL300', 'Delta'),
(3004, 'DL301', 'Delta'),
(3516, 'DL301', 'Delta'),
(4108, 'DL301', 'Delta'),
(6310, 'DL301', 'Delta'),
(2005, 'NH100', 'ANA'),
(2006, 'NH101', 'ANA'),
(3007, 'NH200', 'ANA'),
(9072, 'NH200', 'ANA'),
(220, 'NH201', 'ANA'),
(3008, 'NH201', 'ANA'),
(3740, 'NH201', 'ANA'),
(5116, 'NH201', 'ANA'),
(5165, 'NH201', 'ANA'),
(1001, 'UA100', 'United'),
(1002, 'UA101', 'United'),
(1003, 'UA102', 'United'),
(3001, 'UA200', 'United'),
(3002, 'UA201', 'United');

-- --------------------------------------------------------

--
-- Stand-in structure for view `top_destinations`
-- (See below for the actual view)
--
CREATE TABLE `top_destinations` (
`airline_name` varchar(100)
,`destination_airport` varchar(100)
,`destination_city` varchar(100)
,`tickets_sold` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `upcoming_flights`
-- (See below for the actual view)
--
CREATE TABLE `upcoming_flights` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_airport` varchar(100)
,`departure_city` varchar(100)
,`departure_time` varchar(100)
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` varchar(100)
,`price` decimal(10,2)
,`status` varchar(20)
,`airplane_id` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `agent_analytics`
--
DROP TABLE IF EXISTS `agent_analytics`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `agent_analytics`  AS SELECT `p`.`booking_agent_email` AS `booking_agent_email`, `p`.`ticket_id` AS `ticket_id`, `p`.`customer_email` AS `customer_email`, `p`.`purchase_date` AS `purchase_date`, `t`.`airline_name` AS `airline_name`, `t`.`flight_num` AS `flight_num`, `f`.`price` AS `sold_price`, `f`.`price`* 0.10 AS `commission` FROM ((`purchases` `p` join `ticket` `t` on(`p`.`ticket_id` = `t`.`ticket_id`)) join `flight` `f` on(`t`.`airline_name` = `f`.`airline_name` and `t`.`flight_num` = `f`.`flight_num`)) WHERE `p`.`booking_agent_email` is not null ;

-- --------------------------------------------------------

--
-- Structure for view `browse_flights`
--
DROP TABLE IF EXISTS `browse_flights`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `browse_flights`  AS SELECT `uf`.`airline_name` AS `airline_name`, `uf`.`flight_num` AS `flight_num`, `uf`.`departure_airport` AS `departure_airport`, `uf`.`departure_city` AS `departure_city`, `uf`.`departure_time` AS `departure_time`, `uf`.`arrival_airport` AS `arrival_airport`, `uf`.`arrival_city` AS `arrival_city`, `uf`.`arrival_time` AS `arrival_time`, `uf`.`price` AS `price`, `uf`.`status` AS `status`, `uf`.`airplane_id` AS `airplane_id`, `a`.`seat_capacity`- count(`t`.`ticket_id`) AS `available_seats` FROM ((`upcoming_flights` `uf` join `airplane` `a` on(`uf`.`airplane_id` = `a`.`id` and `uf`.`airline_name` = `a`.`airline_name`)) join (`ticket` `t` join `purchases` `p` on(`t`.`ticket_id` = `p`.`ticket_id`)) on(`uf`.`flight_num` = `t`.`flight_num`)) GROUP BY `uf`.`flight_num` ;

-- --------------------------------------------------------

--
-- Structure for view `customers_list_for_flight`
--
DROP TABLE IF EXISTS `customers_list_for_flight`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `customers_list_for_flight`  AS SELECT `t`.`airline_name` AS `airline_name`, `t`.`flight_num` AS `flight_num`, `f`.`departure_time` AS `departure_time`, `f`.`arrival_time` AS `arrival_time`, `p`.`ticket_id` AS `ticket_id`, `p`.`purchase_date` AS `purchase_date`, `p`.`booking_agent_email` AS `booking_agent_email`, `p`.`customer_email` AS `customer_email`, `c`.`name` AS `customer_name` FROM (((`ticket` `t` join `flight` `f` on(`t`.`airline_name` = `f`.`airline_name` and `t`.`flight_num` = `f`.`flight_num`)) join `purchases` `p` on(`p`.`ticket_id` = `t`.`ticket_id`)) join `customer` `c` on(`p`.`customer_email` = `c`.`email`)) ;

-- --------------------------------------------------------

--
-- Structure for view `customer_analytics`
--
DROP TABLE IF EXISTS `customer_analytics`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `customer_analytics`  AS SELECT `t`.`airline_name` AS `airline_name`, `p`.`customer_email` AS `customer_email`, `c`.`name` AS `customer_name`, count(0) AS `tickets_purchased` FROM ((`purchases` `p` join `ticket` `t` on(`p`.`ticket_id` = `t`.`ticket_id`)) join `customer` `c` on(`p`.`customer_email` = `c`.`email`)) GROUP BY `t`.`airline_name`, `p`.`customer_email`, `c`.`name` ;

-- --------------------------------------------------------

--
-- Structure for view `in_progress_flights`
--
DROP TABLE IF EXISTS `in_progress_flights`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `in_progress_flights`  AS SELECT `f`.`airline_name` AS `airline_name`, `f`.`flight_num` AS `flight_num`, `f`.`departure_airport` AS `departure_airport`, `a_dep`.`city` AS `departure_city`, `f`.`departure_time` AS `departure_time`, `f`.`arrival_airport` AS `arrival_airport`, `a_arr`.`city` AS `arrival_city`, `f`.`arrival_time` AS `arrival_time`, `f`.`price` AS `price`, `f`.`status` AS `status`, `f`.`airplane_id` AS `airplane_id` FROM ((`flight` `f` join `airport` `a_dep` on(`f`.`departure_airport` = `a_dep`.`name`)) join `airport` `a_arr` on(`f`.`arrival_airport` = `a_arr`.`name`)) WHERE `f`.`status` = 'in-progress' ;

-- --------------------------------------------------------

--
-- Structure for view `next_30_days_flights`
--
DROP TABLE IF EXISTS `next_30_days_flights`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `next_30_days_flights`  AS SELECT `f`.`airline_name` AS `airline_name`, `f`.`flight_num` AS `flight_num`, `f`.`departure_airport` AS `departure_airport`, `a_dep`.`city` AS `departure_city`, `f`.`departure_time` AS `departure_time`, `f`.`arrival_airport` AS `arrival_airport`, `a_arr`.`city` AS `arrival_city`, `f`.`arrival_time` AS `arrival_time`, `f`.`price` AS `price`, `f`.`status` AS `status`, `f`.`airplane_id` AS `airplane_id` FROM ((`flight` `f` join `airport` `a_dep` on(`f`.`departure_airport` = `a_dep`.`name`)) join `airport` `a_arr` on(`f`.`arrival_airport` = `a_arr`.`name`)) WHERE `f`.`status` in ('upcoming','in-progress') AND `f`.`departure_time` between current_timestamp() and current_timestamp() + interval 30 day ;

-- --------------------------------------------------------

--
-- Structure for view `past_flights`
--
DROP TABLE IF EXISTS `past_flights`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `past_flights`  AS SELECT `f`.`airline_name` AS `airline_name`, `f`.`flight_num` AS `flight_num`, `f`.`departure_airport` AS `departure_airport`, `a_dep`.`city` AS `departure_city`, `f`.`departure_time` AS `departure_time`, `f`.`arrival_airport` AS `arrival_airport`, `a_arr`.`city` AS `arrival_city`, `f`.`arrival_time` AS `arrival_time`, `f`.`price` AS `price`, `f`.`status` AS `status`, `f`.`airplane_id` AS `airplane_id` FROM ((`flight` `f` join `airport` `a_dep` on(`f`.`departure_airport` = `a_dep`.`name`)) join `airport` `a_arr` on(`f`.`arrival_airport` = `a_arr`.`name`)) WHERE `f`.`arrival_time` < current_timestamp() ;

-- --------------------------------------------------------

--
-- Structure for view `purchased_flights`
--
DROP TABLE IF EXISTS `purchased_flights`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `purchased_flights`  AS SELECT `p`.`ticket_id` AS `ticket_id`, `p`.`customer_email` AS `customer_email`, `c`.`name` AS `customer_name`, `p`.`booking_agent_email` AS `booking_agent_email`, `p`.`purchase_date` AS `purchase_date`, `t`.`airline_name` AS `airline_name`, `t`.`flight_num` AS `flight_num`, `f`.`departure_airport` AS `departure_airport`, `a_dep`.`city` AS `departure_city`, `f`.`departure_time` AS `departure_time`, `f`.`arrival_airport` AS `arrival_airport`, `a_arr`.`city` AS `arrival_city`, `f`.`arrival_time` AS `arrival_time`, `f`.`price` AS `price`, `f`.`status` AS `status`, `f`.`airplane_id` AS `airplane_id` FROM (((((`purchases` `p` join `ticket` `t` on(`p`.`ticket_id` = `t`.`ticket_id`)) join `flight` `f` on(`t`.`airline_name` = `f`.`airline_name` and `t`.`flight_num` = `f`.`flight_num`)) join `customer` `c` on(`p`.`customer_email` = `c`.`email`)) join `airport` `a_dep` on(`f`.`departure_airport` = `a_dep`.`name`)) join `airport` `a_arr` on(`f`.`arrival_airport` = `a_arr`.`name`)) ;

-- --------------------------------------------------------

--
-- Structure for view `sold_tickets_w_airline`
--
DROP TABLE IF EXISTS `sold_tickets_w_airline`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sold_tickets_w_airline`  AS SELECT `al`.`name` AS `airline_name`, `f`.`flight_num` AS `flight_num`, `t`.`ticket_id` AS `ticket_id`, `p`.`customer_email` AS `customer_email`, `p`.`booking_agent_email` AS `booking_agent_email`, `p`.`purchase_date` AS `purchase_date` FROM (((`airline` `al` join `flight` `f` on(`al`.`name` = `f`.`airline_name`)) join `ticket` `t` on(`f`.`airline_name` = `t`.`airline_name` and `f`.`flight_num` = `t`.`flight_num`)) join `purchases` `p` on(`t`.`ticket_id` = `p`.`ticket_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `spending`
--
DROP TABLE IF EXISTS `spending`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `spending`  AS SELECT `p`.`customer_email` AS `customer_email`, `c`.`name` AS `customer_name`, `p`.`purchase_date` AS `purchase_date`, `t`.`airline_name` AS `airline_name`, `t`.`flight_num` AS `flight_num`, `f`.`price` AS `ticket_price` FROM (((`purchases` `p` join `customer` `c` on(`p`.`customer_email` = `c`.`email`)) join `ticket` `t` on(`p`.`ticket_id` = `t`.`ticket_id`)) join `flight` `f` on(`t`.`airline_name` = `f`.`airline_name` and `t`.`flight_num` = `f`.`flight_num`)) ;

-- --------------------------------------------------------

--
-- Structure for view `staff_analytics`
--
DROP TABLE IF EXISTS `staff_analytics`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `staff_analytics`  AS SELECT `pf`.`airline_name` AS `airline_name`, `pf`.`flight_num` AS `flight_num`, `pf`.`departure_airport` AS `departure_airport`, `pf`.`departure_city` AS `departure_city`, `pf`.`departure_time` AS `departure_time`, `pf`.`arrival_airport` AS `arrival_airport`, `pf`.`arrival_city` AS `arrival_city`, `pf`.`arrival_time` AS `arrival_time`, `pf`.`price` AS `price`, `pf`.`status` AS `status`, `pf`.`airplane_id` AS `airplane_id`, `stwa`.`ticket_id` AS `ticket_id`, `stwa`.`purchase_date` AS `purchase_date`, `stwa`.`customer_email` AS `customer_email`, `c`.`name` AS `customer_name`, `stwa`.`booking_agent_email` AS `booking_agent_email`, `ba`.`email` AS `agent_email`, `aa`.`sold_price` AS `sold_price`, `aa`.`commission` AS `commission`, `ca`.`tickets_purchased` AS `tickets_purchased` FROM (((((`sold_tickets_w_airline` `stwa` join `past_flights` `pf` on(`stwa`.`airline_name` = `pf`.`airline_name` and `stwa`.`flight_num` = `pf`.`flight_num`)) left join `customer` `c` on(`stwa`.`customer_email` = `c`.`email`)) left join `booking_agent` `ba` on(`stwa`.`booking_agent_email` = `ba`.`email`)) left join `agent_analytics` `aa` on(`stwa`.`booking_agent_email` = `aa`.`booking_agent_email` and `stwa`.`ticket_id` = `aa`.`ticket_id`)) left join `customer_analytics` `ca` on(`stwa`.`customer_email` = `ca`.`customer_email` and `stwa`.`airline_name` = `ca`.`airline_name`)) ;

-- --------------------------------------------------------

--
-- Structure for view `top_destinations`
--
DROP TABLE IF EXISTS `top_destinations`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `top_destinations`  AS SELECT `t`.`airline_name` AS `airline_name`, `f`.`arrival_airport` AS `destination_airport`, `a_arr`.`city` AS `destination_city`, count(0) AS `tickets_sold` FROM (((`purchases` `p` join `ticket` `t` on(`p`.`ticket_id` = `t`.`ticket_id`)) join `flight` `f` on(`t`.`airline_name` = `f`.`airline_name` and `t`.`flight_num` = `f`.`flight_num`)) join `airport` `a_arr` on(`f`.`arrival_airport` = `a_arr`.`name`)) GROUP BY `t`.`airline_name`, `f`.`arrival_airport`, `a_arr`.`city` ;

-- --------------------------------------------------------

--
-- Structure for view `upcoming_flights`
--
DROP TABLE IF EXISTS `upcoming_flights`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `upcoming_flights`  AS SELECT `f`.`airline_name` AS `airline_name`, `f`.`flight_num` AS `flight_num`, `f`.`departure_airport` AS `departure_airport`, `a_dep`.`city` AS `departure_city`, `f`.`departure_time` AS `departure_time`, `f`.`arrival_airport` AS `arrival_airport`, `a_arr`.`city` AS `arrival_city`, `f`.`arrival_time` AS `arrival_time`, `f`.`price` AS `price`, `f`.`status` AS `status`, `f`.`airplane_id` AS `airplane_id` FROM ((`flight` `f` join `airport` `a_dep` on(`f`.`departure_airport` = `a_dep`.`name`)) join `airport` `a_arr` on(`f`.`arrival_airport` = `a_arr`.`name`)) WHERE `f`.`status` = 'upcoming' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `airline`
--
ALTER TABLE `airline`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `airline_staff`
--
ALTER TABLE `airline_staff`
  ADD PRIMARY KEY (`username`),
  ADD KEY `airline_name` (`airline_name`);

--
-- Indexes for table `airplane`
--
ALTER TABLE `airplane`
  ADD PRIMARY KEY (`airline_name`,`id`);

--
-- Indexes for table `airport`
--
ALTER TABLE `airport`
  ADD PRIMARY KEY (`name`),
  ADD KEY `city_name` (`city`);

--
-- Indexes for table `authorized_by`
--
ALTER TABLE `authorized_by`
  ADD PRIMARY KEY (`agent_email`,`airline_name`),
  ADD KEY `airline_name` (`airline_name`);

--
-- Indexes for table `booking_agent`
--
ALTER TABLE `booking_agent`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `city_alias`
--
ALTER TABLE `city_alias`
  ADD PRIMARY KEY (`alias_name`,`city_name`),
  ADD KEY `city_name` (`city_name`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`email`),
  ADD UNIQUE KEY `passport_number` (`passport_number`);

--
-- Indexes for table `flight`
--
ALTER TABLE `flight`
  ADD PRIMARY KEY (`flight_num`,`airline_name`),
  ADD KEY `airline_name` (`airline_name`,`airplane_id`),
  ADD KEY `depart_airport` (`departure_airport`),
  ADD KEY `arrive_airport` (`arrival_airport`);

--
-- Indexes for table `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`airline_staff_username`,`permission_type`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`ticket_id`,`customer_email`),
  ADD KEY `customer_email` (`customer_email`),
  ADD KEY `booking_agent_email` (`booking_agent_email`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `flight_num` (`flight_num`,`airline_name`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `airline_staff`
--
ALTER TABLE `airline_staff`
  ADD CONSTRAINT `airline_staff_ibfk_1` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `airplane`
--
ALTER TABLE `airplane`
  ADD CONSTRAINT `airplane_ibfk_1` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `airport`
--
ALTER TABLE `airport`
  ADD CONSTRAINT `airport_ibfk_1` FOREIGN KEY (`city`) REFERENCES `city` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `authorized_by`
--
ALTER TABLE `authorized_by`
  ADD CONSTRAINT `authorized_by_ibfk_1` FOREIGN KEY (`agent_email`) REFERENCES `booking_agent` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `authorized_by_ibfk_2` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `city_alias`
--
ALTER TABLE `city_alias`
  ADD CONSTRAINT `city_alias_ibfk_1` FOREIGN KEY (`city_name`) REFERENCES `city` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `flight`
--
ALTER TABLE `flight`
  ADD CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `flight_ibfk_2` FOREIGN KEY (`airline_name`,`airplane_id`) REFERENCES `airplane` (`airline_name`, `id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `flight_ibfk_3` FOREIGN KEY (`departure_airport`) REFERENCES `airport` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `flight_ibfk_4` FOREIGN KEY (`arrival_airport`) REFERENCES `airport` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `permission`
--
ALTER TABLE `permission`
  ADD CONSTRAINT `permission_ibfk_1` FOREIGN KEY (`airline_staff_username`) REFERENCES `airline_staff` (`username`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`customer_email`) REFERENCES `customer` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `purchases_ibfk_3` FOREIGN KEY (`booking_agent_email`) REFERENCES `booking_agent` (`email`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`flight_num`,`airline_name`) REFERENCES `flight` (`flight_num`, `airline_name`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
