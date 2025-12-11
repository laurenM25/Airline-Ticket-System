-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 11, 2025 at 11:47 AM
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
('jane_sj', 'scrypt:32768:8:1$aCM2E3d78RFP1Pwu$1eab600cd1ef289c0694f1eeaa1bb5931a8cbd843182a96820ddce4257d740cff9fd0ddcda1529d11d15d15c38beafeebc75f48572e4925df2f4c77f5be2034f', 'Jane', 'Doe', '1990-03-14', 'United'),
('kate_american', 'scrypt:32768:8:1$fq4bbIN8cJadMQZW$9a0f32b744bb7322c0ec41aeded22b36d87a6ff7d318d18e53a6860dc426ad9433ea13bea7fc533e3d19988fd287ae8f34c4b35e749ee797a4d5b1c379a32a3d', 'Kate', 'Johnson', '1982-02-20', 'American'),
('kevin_sv', 'scrypt:32768:8:1$n6gRVnWXnMe9NTI6$79d33a6ac772bff5096aaf072160ef44c3534cbe95e54b27d74b981c7f5187732210b3fef6ee940d01f76a9b2febced8444314e838b1b324e91be7b22a6e8be3', NULL, NULL, NULL, 'Delta'),
('mickey_sd', 'scrypt:32768:8:1$vgZwTUb0dLVAUfP1$1d066d560a6b5b1d8f5c1edb6ddd0f902cc322e029f5e1ea7b9316cdaf48c90f86bb70243fa2d57e56f821197707bb34057b39cca5f7070d1c6cdb7bf2442c9f', NULL, NULL, NULL, 'United'),
('oliver_ba', 'scrypt:32768:8:1$hL0lMefKZVCJ0D2v$c45e95fe583dd898b35ac36fea9932caf9d3db204dca090ca94af6af1e80a81dc73d2fc925580a927591a08a24712144034ba3582f723a6ac642922559165861', 'Oliver', 'Miller', '1987-03-28', 'British Airways'),
('random_staff', 'scrypt:32768:8:1$IJeZuFX2BkBSENIv$825d55329be9226689b17d15564da68e64e67a23bb21a88f7cfc6cf49567e672c394d644d526657fd45debc4737b769a539ebbcc5b70683c4cab061e8419c46c', 'Random', 'Person', '2004-02-02', 'Delta'),
('sam_delta', 'scrypt:32768:8:1$VcdpJS9JsAFhztRO$514a113ea79385b1f07b6e7a82a89839053cd46d14102827ac80e89075c13a2479e5b9db9c20b4c978d982770c19851d5e0982eb2899c77846f88e07039f44f5', 'Sam', 'Turner', '1985-07-11', 'Delta'),
('yuji_ana', 'scrypt:32768:8:1$eRzvVVzgUlk191mp$2cf3ef3fe0c87f09bd3a614a814515112f6a51858fc7aa2b63d5f2b61a27afd68a2ddd7df081a303cd9299da7771de7ce64704ab7ede3a3e3a294f9041a55326', 'Yuji', 'Sato', '1991-09-09', 'ANA');

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
('United', 2, 220),
('United', 4, 300),
('United', 999, 1);

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
('HZE', 'Hangzhou'),
('LHR', 'London'),
('LAX', 'Los Angeles'),
('JFK', 'New York'),
('LGA', 'New York'),
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
('agent3@gmail.com', 'British Airways'),
('agentperry@gmail.com', 'United'),
('random_agent@gmail.com', 'United');

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
('agent1@gmail.com', 'scrypt:32768:8:1$FcVGRL22PAQb3haI$3387f80fcaf71806b5c73ba5de24ab15e37868544cd71dad368a79508564c16b6ee03c95d648f39e592b01196839e344a6b10be729ced9e3aee633bf292effba'),
('agent2@gmail.com', 'scrypt:32768:8:1$O3LCzf0M00w0YTct$18ceb8aada590d724eed24c881f2b99e56552f3757d0eac28e117a9e720cf72d67f2c318c8758064819f9e68bc514eccba367d58801b46fccb173ab838d9a8b2'),
('agent3@gmail.com', 'scrypt:32768:8:1$kYrbvVkANybYElY4$69210eb4ed6b22613621d4596e7b693440b2c9afe7e29623f0c234d3f04d4ff7be46a3b05bd2d0fdfdd9db3aa7fe406aab89c49c5f9b1d712bf1fefb82a33d01'),
('agentperry@gmail.com', 'scrypt:32768:8:1$M0nJvAtASlc5CmjC$b6bee5fe3d6096b60797e1b7afe329ea289ed771f0e26f813ae19243874da06eabdd4946c81368b6508cdb2a57db3f3cf15759a0fdbf43d95f1448a62c150de9'),
('random_agent@gmail.com', 'scrypt:32768:8:1$HGgjCVgnRZwn9TfW$9c92962114692950f535a8d93887e8a95edfa70039aaa2157495576fa933d3c17cb3d3a0c1c0f19a02fa0b973bf3ef87e7f0df29d735cacea6e199e9ae8925fa');

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
,`departure_time` datetime
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` datetime
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
('Hangzhou'),
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
('drake@gmail.com', 'Drake', 'scrypt:32768:8:1$jwmTpkxI2eEtAq8P$fa318b348dc02c9afe5695a25d6cf20b947a9f33a4a0f584cf20e8472656b2807e404db99d741f2271e9b64e6794df25821b525e6bab115973c39045cd3faa05', NULL, NULL, NULL, NULL, '416-555-1515', 'P99903', '2031-01-01', 'Canada', '1986-10-24'),
('emmawatson@gmail.com', 'Emma Watson', 'scrypt:32768:8:1$G9XVPynl1mNqablI$f0da87c444cd21d8f4a1ee5e514c63a10c26e4dfc2bc71af22f7f62522b83822c5a267db6aee58e72baa61d31d423246a0308c4ff29c8ce25d992dd1b94666ca', NULL, NULL, NULL, NULL, '020-555-2020', 'P99904', '2033-03-03', 'UK', '1990-04-15'),
('md29458@gmail.com', 'megan donnelly', 'scrypt:32768:8:1$Gl8D0tWprRqcvwRb$2fb66e83e9e7d897d482096d1be112d8561f63380fe744bff749502656a1e169ee1f7f21dde190f672655a248d44f7916c10bb6c1de8c02816275437ead5896b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('rihanna@gmail.com', 'Rihanna', 'scrypt:32768:8:1$CdhU8TdFg4BxChtA$36fe3e501e50fac62b8b267e9000bc831b5ad2f6f521648dba53b89d5277d32784cd9df59b6ae0326c4893353f431cad791bff690a003293455b16b087ec0975', NULL, NULL, NULL, NULL, '310-555-1212', 'P99902', '2032-08-14', 'Barbados', '1988-02-20'),
('sabrinacarpenter@gmail.com', 'Sabrina Carpenter', 'scrypt:32768:8:1$AyP8ImWeVI7QwdQq$d72c8f794882430c36b5041a76258dd94395d8546d5d93398cc95076944f9922645313c783370be1f63846e14e1d5d4d31027db2c42107b6b0a48169593fd2d8', NULL, NULL, NULL, NULL, '646-555-3333', 'P54321', '2032-04-01', 'USA', '1999-05-11'),
('selenagomez@gmail.com', 'Selena Gomez', 'scrypt:32768:8:1$b2VyVnDD6cSvzEiX$1764ab1ed07dd8cdfad2b2309563088c03f0d7a78867388a5cfec21110a0f6b7f76545478bcaf05fb066d52fa12fc9f9e94a981501f8dace43249d31cf139419', NULL, NULL, NULL, NULL, '917-555-2222', 'P67890', '2031-01-15', 'USA', '1992-07-22'),
('taylorswift@gmail.com', 'Taylor Swift', 'scrypt:32768:8:1$7FJoOq7tWBlc2dZp$0f80ed7edd2b78e4b804d5f4e85871a68dd098b56588914fb713c8e47eeeeb7674afbbef8b8e565c2032ff44ef8084f3c0b7ed35ad1d26a8babd3be9541195dd', NULL, NULL, NULL, NULL, '123-456-7891', 'P12345', '2030-05-10', 'USA', '1989-12-13'),
('zendaya@gmail.com', 'Zendaya', 'scrypt:32768:8:1$xTnDsgDSGN6p2NR1$3216e233adf3e1aa1095324465166bab3390e3542a2a15600b4517ecf329e4422253460f3d4abd610271982c90585a3d88d7722c88ed6046b1ced78b32b9e7d6', NULL, NULL, NULL, NULL, '212-555-1111', 'P99901', '2030-06-10', 'USA', '1996-09-01');

-- --------------------------------------------------------

--
-- Stand-in structure for view `customers_list_for_flight`
-- (See below for the actual view)
--
CREATE TABLE `customers_list_for_flight` (
`airline_name` varchar(100)
,`flight_num` varchar(100)
,`departure_time` datetime
,`arrival_time` datetime
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
  `departure_time` datetime DEFAULT NULL,
  `arrival_time` datetime DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `airplane_id` int(11) NOT NULL,
  `departure_airport` varchar(100) NOT NULL,
  `arrival_airport` varchar(100) NOT NULL,
  `status` varchar(20) NOT NULL
) ;

--
-- Dumping data for table `flight`
--

INSERT INTO `flight` (`flight_num`, `airline_name`, `departure_time`, `arrival_time`, `price`, `airplane_id`, `departure_airport`, `arrival_airport`, `status`) VALUES
('AA300', 'American', '2025-10-10 09:00:00', '2025-10-10 17:00:00', 500.00, 1, 'LAX', 'LHR', 'delayed'),
('AA301', 'American', '2025-10-18 22:00:00', '2025-10-19 01:30:00', 250.00, 2, 'LHR', 'LAX', 'completed'),
('AA400', 'American', '2026-05-11 10:00:00', '2026-05-11 17:45:00', 520.00, 1, 'LAX', 'LHR', 'upcoming'),
('AA401', 'American', '2026-06-21 21:00:00', '2026-06-22 01:25:00', 260.00, 2, 'LHR', 'LAX', 'upcoming'),
('BA400', 'British Airways', '2025-08-30 07:30:00', '2025-08-30 11:30:00', 420.00, 1, 'LHR', 'JFK', 'completed'),
('BA401', 'British Airways', '2025-08-17 13:00:00', '2025-08-17 17:00:00', 440.00, 2, 'JFK', 'LHR', 'delayed'),
('BA500', 'British Airways', '2026-07-05 07:00:00', '2026-07-05 11:10:00', 430.00, 1, 'LHR', 'JFK', 'upcoming'),
('BA501', 'British Airways', '2026-07-19 13:00:00', '2026-07-19 17:05:00', 450.00, 2, 'JFK', 'LHR', 'upcoming'),
('DL200', 'Delta', '2025-11-05 07:00:00', '2025-11-05 15:30:00', 650.00, 1, 'LAX', 'JFK', 'completed'),
('DL201', 'Delta', '2025-11-08 12:15:00', '2025-11-09 06:45:00', 900.00, 2, 'JFK', 'NRT', 'completed'),
('DL300', 'Delta', '2026-01-18 06:00:00', '2026-01-18 14:30:00', 700.00, 1, 'LAX', 'JFK', 'upcoming'),
('DL301', 'Delta', '2026-02-05 13:15:00', '2026-02-06 09:20:00', 980.00, 2, 'JFK', 'NRT', 'upcoming'),
('NH100', 'ANA', '2025-09-22 14:00:00', '2025-09-22 22:00:00', 850.00, 1, 'NRT', 'PVG', 'in-progress'),
('NH101', 'ANA', '2025-09-23 08:00:00', '2025-09-23 16:20:00', 880.00, 2, 'PVG', 'NRT', 'completed'),
('NH200', 'ANA', '2026-03-03 09:00:00', '2026-03-03 17:00:00', 870.00, 1, 'NRT', 'PVG', 'upcoming'),
('NH201', 'ANA', '2026-03-04 08:00:00', '2026-03-04 16:00:00', 900.00, 2, 'PVG', 'NRT', 'upcoming'),
('UA100', 'United', '2025-10-12 08:00:00', '2025-10-12 20:00:00', 850.00, 1, 'JFK', 'PVG', 'completed'),
('UA101', 'United', '2025-10-09 06:30:00', '2025-10-09 10:45:00', 180.00, 2, 'PVG', 'JFK', 'in-progress'),
('UA102', 'United', '2025-10-08 09:00:00', '2025-10-08 13:30:00', 190.00, 1, 'JFK', 'PVG', 'delayed'),
('UA200', 'United', '2026-03-10 07:30:00', '2026-03-10 15:00:00', 820.00, 1, 'JFK', 'PVG', 'upcoming'),
('UA201', 'United', '2026-04-02 12:00:00', '2026-04-02 18:10:00', 210.00, 2, 'PVG', 'JFK', 'upcoming'),
('UA202', 'United', '2025-12-22 13:03:00', '2025-12-22 19:23:00', 450.00, 2, 'LGA', 'LAX', 'upcoming'),
('UA998', 'United', '2025-12-26 12:27:00', '2025-12-28 13:50:00', 850.00, 999, 'LGA', 'HZE', 'upcoming');

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
,`departure_time` datetime
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` datetime
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
,`departure_time` datetime
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` datetime
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
,`departure_time` datetime
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` datetime
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
('operator', 'kevin_sv'),
('admin', 'mickey_sd'),
('admin', 'oliver_ba'),
('admin', 'random_staff'),
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
,`departure_time` datetime
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` datetime
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
(740, 'taylorswift@gmail.com', 'agent1@gmail.com', '2025-12-11'),
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
(2219, 'md29458@gmail.com', NULL, '2025-12-11'),
(2743, 'drake@gmail.com', NULL, '2025-12-08'),
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
(3157, 'md29458@gmail.com', NULL, '2025-12-11'),
(3516, 'rihanna@gmail.com', NULL, '2025-12-04'),
(3740, 'rihanna@gmail.com', NULL, '2025-12-04'),
(4108, 'rihanna@gmail.com', NULL, '2025-12-04'),
(4304, 'drake@gmail.com', NULL, '2025-12-04'),
(4929, 'drake@gmail.com', NULL, '2025-12-08'),
(5057, 'emmawatson@gmail.com', 'agent1@gmail.com', '2025-12-08'),
(5116, 'rihanna@gmail.com', NULL, '2025-12-04'),
(5136, 'md29458@gmail.com', NULL, '2025-12-11'),
(5165, 'rihanna@gmail.com', NULL, '2025-12-04'),
(5581, 'taylorswift@gmail.com', 'agent1@gmail.com', '2025-12-11'),
(5600, 'drake@gmail.com', NULL, '2025-12-04'),
(5700, 'taylorswift@gmail.com', 'agent1@gmail.com', '2025-12-11'),
(6153, 'md29458@gmail.com', 'agentperry@gmail.com', '2025-12-11'),
(6310, 'rihanna@gmail.com', NULL, '2025-12-04'),
(6885, 'rihanna@gmail.com', NULL, '2025-12-04'),
(6900, 'rihanna@gmail.com', NULL, '2025-12-04'),
(6970, 'md29458@gmail.com', 'agentperry@gmail.com', '2025-12-11'),
(7153, 'drake@gmail.com', NULL, '2025-12-04'),
(7187, 'md29458@gmail.com', 'agentperry@gmail.com', '2025-12-11'),
(8101, 'rihanna@gmail.com', NULL, '2025-12-04'),
(9042, 'rihanna@gmail.com', NULL, '2025-12-04'),
(9072, 'rihanna@gmail.com', NULL, '2025-12-04'),
(9204, 'md29458@gmail.com', 'agentperry@gmail.com', '2025-12-11'),
(9692, 'emmawatson@gmail.com', 'agent1@gmail.com', '2025-12-08');

-- --------------------------------------------------------

--
-- Table structure for table `register_requests`
--

CREATE TABLE `register_requests` (
  `request_id` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` text NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `airline_name` varchar(100) DEFAULT NULL,
  `permission_type` varchar(100) DEFAULT NULL CHECK (`permission_type` in ('admin','operator'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
,`departure_time` datetime
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` datetime
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
-- Table structure for table `system_admin`
--

CREATE TABLE `system_admin` (
  `username` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_admin`
--

INSERT INTO `system_admin` (`username`, `password`, `created_at`) VALUES
('lauren', 'scrypt:32768:8:1$sRh6uRNOUOvGPzSh$65c000563f7a768010b0109462042a8701064161491fc6e381fec65742aeb542cf8d88c6d201b60af591b8620f0474f8e53f0b2fbb9a54edcc9a323bc89f47ea', '2025-12-11 09:18:17');

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
(740, 'UA200', 'United'),
(2219, 'UA200', 'United'),
(3001, 'UA200', 'United'),
(3157, 'UA200', 'United'),
(5136, 'UA200', 'United'),
(5581, 'UA200', 'United'),
(5700, 'UA200', 'United'),
(2743, 'UA201', 'United'),
(3002, 'UA201', 'United'),
(4929, 'UA201', 'United'),
(5057, 'UA201', 'United'),
(6153, 'UA201', 'United'),
(6970, 'UA201', 'United'),
(9204, 'UA201', 'United'),
(9692, 'UA201', 'United'),
(7187, 'UA998', 'United');

-- --------------------------------------------------------

--
-- Stand-in structure for view `top_destinations`
-- (See below for the actual view)
--
CREATE TABLE `top_destinations` (
`Month` int(2)
,`Year` int(4)
,`airline_name` varchar(100)
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
,`departure_time` datetime
,`arrival_airport` varchar(100)
,`arrival_city` varchar(100)
,`arrival_time` datetime
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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `browse_flights`  AS SELECT `uf`.`airline_name` AS `airline_name`, `uf`.`flight_num` AS `flight_num`, `uf`.`departure_airport` AS `departure_airport`, `uf`.`departure_city` AS `departure_city`, `uf`.`departure_time` AS `departure_time`, `uf`.`arrival_airport` AS `arrival_airport`, `uf`.`arrival_city` AS `arrival_city`, `uf`.`arrival_time` AS `arrival_time`, `uf`.`price` AS `price`, `uf`.`status` AS `status`, `uf`.`airplane_id` AS `airplane_id`, `a`.`seat_capacity`- count(`t`.`ticket_id`) AS `available_seats` FROM ((`upcoming_flights` `uf` join `airplane` `a` on(`uf`.`airplane_id` = `a`.`id` and `uf`.`airline_name` = `a`.`airline_name`)) left join `ticket` `t` on(`uf`.`flight_num` = `t`.`flight_num`)) GROUP BY `uf`.`flight_num` HAVING `available_seats` > 0 ;

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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `top_destinations`  AS SELECT month(`p`.`purchase_date`) AS `Month`, year(`p`.`purchase_date`) AS `Year`, `t`.`airline_name` AS `airline_name`, `f`.`arrival_airport` AS `destination_airport`, `a_arr`.`city` AS `destination_city`, count(0) AS `tickets_sold` FROM (((`purchases` `p` join `ticket` `t` on(`p`.`ticket_id` = `t`.`ticket_id`)) join `flight` `f` on(`t`.`airline_name` = `f`.`airline_name` and `t`.`flight_num` = `f`.`flight_num`)) join `airport` `a_arr` on(`f`.`arrival_airport` = `a_arr`.`name`)) GROUP BY month(`p`.`purchase_date`), year(`p`.`purchase_date`), `t`.`airline_name`, `f`.`arrival_airport`, `a_arr`.`city` ;

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
-- Indexes for table `register_requests`
--
ALTER TABLE `register_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `airline_name` (`airline_name`);

--
-- Indexes for table `system_admin`
--
ALTER TABLE `system_admin`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `flight_num` (`flight_num`,`airline_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `register_requests`
--
ALTER TABLE `register_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
-- Constraints for table `register_requests`
--
ALTER TABLE `register_requests`
  ADD CONSTRAINT `register_requests_ibfk_1` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`flight_num`,`airline_name`) REFERENCES `flight` (`flight_num`, `airline_name`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
