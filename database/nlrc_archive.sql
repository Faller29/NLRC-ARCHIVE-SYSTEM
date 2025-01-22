-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 23, 2025 at 07:52 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nlrc_archive`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_approval`
--

CREATE TABLE `tbl_approval` (
  `approval_id` int(11) NOT NULL,
  `acc_id` int(11) NOT NULL,
  `sack_id` int(11) NOT NULL,
  `status` varchar(50) DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_arbi_user`
--

CREATE TABLE `tbl_arbi_user` (
  `arbi_id` int(11) NOT NULL,
  `arbi_name` varchar(255) NOT NULL,
  `room` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_arbi_user`
--

INSERT INTO `tbl_arbi_user` (`arbi_id`, `arbi_name`, `room`) VALUES
(14, 'LA Sapallo', '1'),
(19, 'LA Renzy', '1');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_document`
--

CREATE TABLE `tbl_document` (
  `doc_id` int(11) NOT NULL,
  `sack_id` int(11) NOT NULL,
  `doc_number` varchar(40) NOT NULL,
  `doc_title` varchar(255) NOT NULL,
  `verdict` varchar(50) DEFAULT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_document`
--

INSERT INTO `tbl_document` (`doc_id`, `sack_id`, `doc_number`, `doc_title`, `verdict`, `status`) VALUES
(26, 43, '234', '12', '', 'Stored'),
(27, 45, 'qwe', 'qwe', '', 'Stored'),
(28, 46, 'RAB-02012024-001', 'SAPALLO VS CCC', '', 'Stored');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_request`
--

CREATE TABLE `tbl_request` (
  `req_id` int(11) NOT NULL,
  `acc_id` int(11) NOT NULL,
  `doc_id` int(11) NOT NULL,
  `status` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sack`
--

CREATE TABLE `tbl_sack` (
  `sack_id` int(11) NOT NULL,
  `sack_name` varchar(255) NOT NULL,
  `arbiter_number` varchar(244) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `status` varchar(100) NOT NULL,
  `admin_message` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_sack`
--

INSERT INTO `tbl_sack` (`sack_id`, `sack_name`, `arbiter_number`, `location`, `status`, `admin_message`) VALUES
(43, 'LA SAPALLO - 2025124', 'LA Sapallo', NULL, 'Stored', NULL),
(44, '1234', 'LA Renzy', NULL, 'Stored', 'qwe'),
(45, '123', 'LA Sapallo', NULL, 'Stored', 'qwe'),
(46, 'LA-SAPALLO-2024', 'LA Sapallo', NULL, 'Stored', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_account`
--

CREATE TABLE `tbl_user_account` (
  `acc_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `arbi_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_user_account`
--

INSERT INTO `tbl_user_account` (`acc_id`, `username`, `password`, `arbi_id`) VALUES
(2, '123', '123', NULL),
(12, '111', '111', 19);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_approval`
--
ALTER TABLE `tbl_approval`
  ADD PRIMARY KEY (`approval_id`),
  ADD KEY `acc_id` (`acc_id`),
  ADD KEY `sack_id` (`sack_id`);

--
-- Indexes for table `tbl_arbi_user`
--
ALTER TABLE `tbl_arbi_user`
  ADD PRIMARY KEY (`arbi_id`);

--
-- Indexes for table `tbl_document`
--
ALTER TABLE `tbl_document`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `fk_sack_id` (`sack_id`);

--
-- Indexes for table `tbl_request`
--
ALTER TABLE `tbl_request`
  ADD PRIMARY KEY (`req_id`),
  ADD KEY `acc_id` (`acc_id`),
  ADD KEY `doc_id` (`doc_id`);

--
-- Indexes for table `tbl_sack`
--
ALTER TABLE `tbl_sack`
  ADD PRIMARY KEY (`sack_id`);

--
-- Indexes for table `tbl_user_account`
--
ALTER TABLE `tbl_user_account`
  ADD PRIMARY KEY (`acc_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `arbi_id_3` (`arbi_id`),
  ADD KEY `arbi_id` (`arbi_id`),
  ADD KEY `arbi_id_2` (`arbi_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_approval`
--
ALTER TABLE `tbl_approval`
  MODIFY `approval_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_arbi_user`
--
ALTER TABLE `tbl_arbi_user`
  MODIFY `arbi_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `tbl_document`
--
ALTER TABLE `tbl_document`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `tbl_request`
--
ALTER TABLE `tbl_request`
  MODIFY `req_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_sack`
--
ALTER TABLE `tbl_sack`
  MODIFY `sack_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `tbl_user_account`
--
ALTER TABLE `tbl_user_account`
  MODIFY `acc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_approval`
--
ALTER TABLE `tbl_approval`
  ADD CONSTRAINT `tbl_approval_ibfk_1` FOREIGN KEY (`acc_id`) REFERENCES `tbl_user_account` (`acc_id`),
  ADD CONSTRAINT `tbl_approval_ibfk_2` FOREIGN KEY (`sack_id`) REFERENCES `tbl_sack` (`sack_id`);

--
-- Constraints for table `tbl_document`
--
ALTER TABLE `tbl_document`
  ADD CONSTRAINT `fk_sack_id` FOREIGN KEY (`sack_id`) REFERENCES `tbl_sack` (`sack_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_document_ibfk_1` FOREIGN KEY (`sack_id`) REFERENCES `tbl_sack` (`sack_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_request`
--
ALTER TABLE `tbl_request`
  ADD CONSTRAINT `tbl_request_ibfk_1` FOREIGN KEY (`acc_id`) REFERENCES `tbl_user_account` (`acc_id`),
  ADD CONSTRAINT `tbl_request_ibfk_2` FOREIGN KEY (`doc_id`) REFERENCES `tbl_document` (`doc_id`);

--
-- Constraints for table `tbl_user_account`
--
ALTER TABLE `tbl_user_account`
  ADD CONSTRAINT `tbl_user_account_ibfk_1` FOREIGN KEY (`arbi_id`) REFERENCES `tbl_arbi_user` (`arbi_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
