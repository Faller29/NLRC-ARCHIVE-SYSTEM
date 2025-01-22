-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 22, 2025 at 10:06 AM
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
-- Database: `db_genhospital`
--
CREATE DATABASE IF NOT EXISTS `db_genhospital` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `db_genhospital`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_appointment`
--

CREATE TABLE `tbl_appointment` (
  `id` int(11) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `appointment_time_end` time DEFAULT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `remarks_dissapprove` varchar(255) DEFAULT NULL,
  `idate` datetime NOT NULL DEFAULT current_timestamp(),
  `status_id` int(11) NOT NULL DEFAULT 3,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_appointment`
--

INSERT INTO `tbl_appointment` (`id`, `appointment_date`, `appointment_time`, `appointment_time_end`, `patient_id`, `doctor_id`, `message`, `remarks_dissapprove`, `idate`, `status_id`, `active`) VALUES
(53, '2023-07-24', '09:51:00', NULL, 31, 29, 'ewq', NULL, '2023-07-24 09:51:09', 3, 1),
(54, '2023-07-25', '09:54:00', NULL, 31, 29, 'ewq', NULL, '2023-07-24 09:52:01', 3, 1),
(55, '2023-07-26', '16:00:00', NULL, 31, 32, 'ewq', NULL, '2023-07-25 15:02:46', 3, 1),
(56, '2023-07-27', '22:24:00', NULL, 31, 29, '321ewq', NULL, '2023-07-26 08:29:50', 3, 1),
(57, '2023-07-26', '21:00:00', NULL, 31, 29, 'ewqe', NULL, '2023-07-26 08:30:12', 3, 1),
(58, '2023-08-02', '21:00:00', '23:27:00', 31, 29, 'Sample', NULL, '2023-07-28 15:42:33', 4, 1),
(59, '2023-08-02', '08:00:00', '12:09:00', 31, 29, 'sa', NULL, '2023-07-30 12:32:32', 4, 1),
(60, '2023-08-02', '12:10:00', '13:00:00', 31, 29, 'ewqq', NULL, '2023-07-30 13:01:56', 4, 1),
(61, '2023-08-03', '13:00:00', '14:00:00', 31, 29, 'weqe', NULL, '2023-08-02 09:45:47', 4, 1),
(62, '2023-08-03', '08:00:00', '12:00:00', 31, 29, 'ewq', NULL, '2023-08-02 10:05:11', 4, 1),
(63, '2023-08-04', '09:55:00', NULL, 31, 29, 'ewqe', NULL, '2023-08-03 09:31:38', 6, 1),
(64, '2023-08-04', '12:02:00', '13:00:00', 31, 32, 'ewqe', NULL, '2023-08-03 10:23:00', 4, 1),
(65, '2023-08-04', '15:23:00', '16:00:00', 31, 32, 'ewqweq', NULL, '2023-08-03 10:23:17', 4, 1),
(66, '2023-08-11', '15:20:00', '16:53:00', 31, 32, 'ewq', NULL, '2023-08-03 10:25:09', 4, 1),
(67, '2023-08-09', '12:01:00', '15:00:00', 31, 32, 'weq', NULL, '2023-08-03 12:55:53', 4, 1),
(68, '2023-08-10', '12:01:00', '14:00:00', 31, 32, 'ewq', NULL, '2023-08-03 13:20:18', 4, 1),
(69, '2023-08-10', '12:30:00', NULL, 31, 32, 'ewq', NULL, '2023-08-03 13:21:55', 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_day_name`
--

CREATE TABLE `tbl_day_name` (
  `id` int(11) NOT NULL,
  `Id_Day` int(11) NOT NULL,
  `Description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_day_name`
--

INSERT INTO `tbl_day_name` (`id`, `Id_Day`, `Description`) VALUES
(2, 2, 'Monday'),
(3, 3, 'Tuesday'),
(4, 4, 'Wednesday'),
(7, 5, 'Thursday'),
(8, 6, 'Friday'),
(13, 7, 'Saturday'),
(14, 1, 'Sunday');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_doctor_details`
--

CREATE TABLE `tbl_doctor_details` (
  `id` int(255) NOT NULL,
  `contact_number` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `birthdate` date DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `specialize_id` int(255) NOT NULL DEFAULT 0,
  `login_id` int(255) NOT NULL DEFAULT 0,
  `profile_pic` longblob NOT NULL,
  `idate` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_doctor_details`
--

INSERT INTO `tbl_doctor_details` (`id`, `contact_number`, `email`, `birthdate`, `description`, `specialize_id`, `login_id`, `profile_pic`, `idate`, `active`) VALUES
(18, '9051231422', 'russel@gmail.com', '2023-07-23', 'sample', 3, 29, '', '2023-07-23 20:22:05.465946', 1),
(19, '9123224444', 'christan@gmail.com', '1998-02-02', 'Docotr', 3, 32, '', '2023-07-25 14:35:09.626642', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_doctor_sched`
--

CREATE TABLE `tbl_doctor_sched` (
  `ID` int(11) NOT NULL,
  `DayFrom` int(11) NOT NULL,
  `DayTo` int(11) NOT NULL,
  `TimeFrom` time NOT NULL,
  `TimeTo` time NOT NULL,
  `doctorsId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_doctor_sched`
--

INSERT INTO `tbl_doctor_sched` (`ID`, `DayFrom`, `DayTo`, `TimeFrom`, `TimeTo`, `doctorsId`) VALUES
(40, 2, 5, '08:00:00', '23:00:00', 29),
(41, 2, 6, '12:00:26', '15:24:26', 32);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_login_user`
--

CREATE TABLE `tbl_login_user` (
  `id` bigint(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `user_type_id` int(255) NOT NULL,
  `isadmin` tinyint(1) NOT NULL DEFAULT 0,
  `idate` datetime NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_login_user`
--

INSERT INTO `tbl_login_user` (`id`, `username`, `password`, `firstname`, `lastname`, `user_type_id`, `isadmin`, `idate`, `active`) VALUES
(29, 'rcg', '$2y$10$fEI16oQoaGKy0/yfg3Rzz.xmSuVj7bsWvGVsa9dUZ1f0OOP5obEkO', 'Russel', 'Gutierrez', 2, 0, '2023-07-20 11:59:23', 1),
(30, 'admin', '$2y$10$ScTR1eHt5FC1PbtNBl8Fo.t61.PI9XcRUWmugfrk8XH7elXUl5vyi', 'admin', 'admin', 1, 0, '2023-07-23 19:50:59', 1),
(31, 'ren', '$2y$10$iOvaXk.ukhO85ozPFrWs8O3ApBDbXN2vOsz1rQC802KpNbdLKW8tS', 'Renzy', 'Gutierrez', 3, 0, '2023-07-23 19:52:14', 1),
(32, 'stan', '$2y$10$4vn2LqIp/Ty2OQdl.T0JrucSPNJuBBoM2UNnpXBr9gdiscl/Pnbu2', 'Christan', 'Gutierrez', 2, 0, '2023-07-25 14:24:47', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_max_patients`
--

CREATE TABLE `tbl_max_patients` (
  `id` int(100) NOT NULL,
  `value_day` int(100) NOT NULL,
  `doctor_id` int(100) NOT NULL,
  `idate` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_max_patients`
--

INSERT INTO `tbl_max_patients` (`id`, `value_day`, `doctor_id`, `idate`) VALUES
(5, 5, 29, '2023-07-23 20:22:05'),
(6, 5, 32, '2023-07-25 14:35:09');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_patient_table`
--

CREATE TABLE `tbl_patient_table` (
  `id` int(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `contact_number` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `birthdate` date NOT NULL,
  `idate` datetime NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `login_id` int(255) NOT NULL,
  `profile_pic` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_patient_table`
--

INSERT INTO `tbl_patient_table` (`id`, `description`, `contact_number`, `email`, `birthdate`, `idate`, `active`, `login_id`, `profile_pic`) VALUES
(15, 'Sample', '2132100', 'russel@gmail.com', '2023-07-23', '2023-07-23 20:21:21', 1, 31, '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_specialize`
--

CREATE TABLE `tbl_specialize` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `idate` datetime NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_specialize`
--

INSERT INTO `tbl_specialize` (`id`, `name`, `description`, `idate`, `active`) VALUES
(2, 'Pediatrician', 'Pediatrician', '2023-06-16 09:42:09', 1),
(3, 'Psychiatrist', 'Psychiatrist', '2023-06-16 09:42:09', 1),
(4, 'Cardiologist', 'Cardiologist', '2023-06-16 09:44:08', 1),
(5, 'Dermatologist', 'Dermatologist', '2023-06-16 09:44:08', 1),
(6, 'Gastroenterologist', 'Gastroenterologist', '2023-06-16 09:44:31', 1),
(7, 'Obstetrician/Gynecologist', 'Obstetrician/Gynecologist', '2023-06-16 09:44:31', 1),
(8, 'Ophthalmologist', 'Ophthalmologist', '2023-06-16 09:44:47', 1),
(9, 'Orthopedic ', 'Orthopedic ', '2023-06-16 09:44:47', 1),
(10, 'Family Physician', 'Family Physician', '2023-06-16 09:45:16', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_status`
--

CREATE TABLE `tbl_status` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `descrption` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `idate` datetime NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_status`
--

INSERT INTO `tbl_status` (`id`, `name`, `descrption`, `class`, `idate`, `active`) VALUES
(3, 'Pending', 'Pending', 'bg-warning', '2023-06-17 08:14:38', 1),
(4, 'Approved', 'Approved', 'bg-success', '2023-06-17 08:14:38', 1),
(5, 'Disapproved', 'Disapproved', 'bg-danger', '2023-06-21 17:04:33', 1),
(6, 'Cancel', 'Cancel', 'bg-info', '2023-07-01 10:11:26', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_type`
--

CREATE TABLE `tbl_user_type` (
  `id` bigint(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `idate` datetime NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_user_type`
--

INSERT INTO `tbl_user_type` (`id`, `name`, `description`, `idate`, `active`) VALUES
(1, 'admin', 'Administrator', '2023-06-15 11:43:39', 1),
(2, 'DR', 'Doctor', '2023-06-15 11:43:56', 1),
(3, 'Patient', 'Patient', '2023-06-15 11:44:16', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_appointment`
--
ALTER TABLE `tbl_appointment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_day_name`
--
ALTER TABLE `tbl_day_name`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_doctor_details`
--
ALTER TABLE `tbl_doctor_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_doctor_sched`
--
ALTER TABLE `tbl_doctor_sched`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tbl_login_user`
--
ALTER TABLE `tbl_login_user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_max_patients`
--
ALTER TABLE `tbl_max_patients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_patient_table`
--
ALTER TABLE `tbl_patient_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_specialize`
--
ALTER TABLE `tbl_specialize`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_status`
--
ALTER TABLE `tbl_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user_type`
--
ALTER TABLE `tbl_user_type`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_appointment`
--
ALTER TABLE `tbl_appointment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `tbl_day_name`
--
ALTER TABLE `tbl_day_name`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `tbl_doctor_details`
--
ALTER TABLE `tbl_doctor_details`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `tbl_doctor_sched`
--
ALTER TABLE `tbl_doctor_sched`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `tbl_login_user`
--
ALTER TABLE `tbl_login_user`
  MODIFY `id` bigint(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `tbl_max_patients`
--
ALTER TABLE `tbl_max_patients`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_patient_table`
--
ALTER TABLE `tbl_patient_table`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tbl_specialize`
--
ALTER TABLE `tbl_specialize`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tbl_status`
--
ALTER TABLE `tbl_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_user_type`
--
ALTER TABLE `tbl_user_type`
  MODIFY `id` bigint(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Database: `nlrc_archive`
--
CREATE DATABASE IF NOT EXISTS `nlrc_archive` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `nlrc_archive`;

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
  `arbi_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_document`
--

CREATE TABLE `tbl_document` (
  `doc_id` int(11) NOT NULL,
  `sack_id` int(11) NOT NULL,
  `doc_number` int(40) NOT NULL,
  `doc_title` varchar(255) NOT NULL,
  `verdict` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_document`
--

INSERT INTO `tbl_document` (`doc_id`, `sack_id`, `doc_number`, `doc_title`, `verdict`) VALUES
(9, 31, 123, 'edd', NULL),
(10, 31, 12, '2dswe', NULL),
(11, 31, 123, 'edd', NULL),
(12, 31, 12, 'sas', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_request`
--

CREATE TABLE `tbl_request` (
  `req_id` int(11) NOT NULL,
  `acc_id` int(11) NOT NULL,
  `doc_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sack`
--

CREATE TABLE `tbl_sack` (
  `sack_id` int(11) NOT NULL,
  `sack_name` varchar(255) NOT NULL,
  `arbiter_number` varchar(244) NOT NULL,
  `arbi_id` int(11) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_sack`
--

INSERT INTO `tbl_sack` (`sack_id`, `sack_name`, `arbiter_number`, `arbi_id`, `location`) VALUES
(31, '123', 'Arbiter 2', NULL, NULL),
(33, '12', 'Arbiter 3', NULL, NULL),
(34, '43423', 'Arbiter 1', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_account`
--

CREATE TABLE `tbl_user_account` (
  `acc_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `arbi_id` int(11) DEFAULT NULL,
  `room` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_user_account`
--

INSERT INTO `tbl_user_account` (`acc_id`, `username`, `password`, `arbi_id`, `room`) VALUES
(2, '123', '123', NULL, 'Room 101');

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
  ADD PRIMARY KEY (`sack_id`),
  ADD KEY `arbi_id` (`arbi_id`);

--
-- Indexes for table `tbl_user_account`
--
ALTER TABLE `tbl_user_account`
  ADD PRIMARY KEY (`acc_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `arbi_id` (`arbi_id`);

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
  MODIFY `arbi_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_document`
--
ALTER TABLE `tbl_document`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_request`
--
ALTER TABLE `tbl_request`
  MODIFY `req_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_sack`
--
ALTER TABLE `tbl_sack`
  MODIFY `sack_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `tbl_user_account`
--
ALTER TABLE `tbl_user_account`
  MODIFY `acc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  ADD CONSTRAINT `fk_sack_id` FOREIGN KEY (`sack_id`) REFERENCES `tbl_sack` (`sack_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_document_ibfk_1` FOREIGN KEY (`sack_id`) REFERENCES `tbl_sack` (`sack_id`);

--
-- Constraints for table `tbl_request`
--
ALTER TABLE `tbl_request`
  ADD CONSTRAINT `tbl_request_ibfk_1` FOREIGN KEY (`acc_id`) REFERENCES `tbl_user_account` (`acc_id`),
  ADD CONSTRAINT `tbl_request_ibfk_2` FOREIGN KEY (`doc_id`) REFERENCES `tbl_document` (`doc_id`);

--
-- Constraints for table `tbl_sack`
--
ALTER TABLE `tbl_sack`
  ADD CONSTRAINT `tbl_sack_ibfk_1` FOREIGN KEY (`arbi_id`) REFERENCES `tbl_arbi_user` (`arbi_id`);

--
-- Constraints for table `tbl_user_account`
--
ALTER TABLE `tbl_user_account`
  ADD CONSTRAINT `tbl_user_account_ibfk_1` FOREIGN KEY (`arbi_id`) REFERENCES `tbl_arbi_user` (`arbi_id`);
--
-- Database: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Table structure for table `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Table structure for table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Table structure for table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Table structure for table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Table structure for table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Table structure for table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Dumping data for table `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"nlrc_archive\",\"table\":\"tbl_document\"},{\"db\":\"nlrc_archive\",\"table\":\"tbl_request\"},{\"db\":\"nlrc_archive\",\"table\":\"tbl_sack\"},{\"db\":\"nlrc_archive\",\"table\":\"tbl_user_account\"},{\"db\":\"tutordb\",\"table\":\"tblteacherinfo\"},{\"db\":\"db_genhospital\",\"table\":\"tbl_user_type\"},{\"db\":\"db_genhospital\",\"table\":\"tbl_status\"},{\"db\":\"db_genhospital\",\"table\":\"tbl_doctor_sched\"},{\"db\":\"db_genhospital\",\"table\":\"tbl_day_name\"},{\"db\":\"db_genhospital\",\"table\":\"tbl_doctor_details\"}]');

-- --------------------------------------------------------

--
-- Table structure for table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Table structure for table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

--
-- Dumping data for table `pma__table_uiprefs`
--

INSERT INTO `pma__table_uiprefs` (`username`, `db_name`, `table_name`, `prefs`, `last_update`) VALUES
('root', 'db_genhospital', 'tbl_appointment', '{\"CREATE_TIME\":\"2024-02-16 19:13:05\",\"col_order\":[0,1,2,3,4,5,6,7,8,9,10],\"col_visib\":[1,1,1,1,1,1,1,1,1,1,1]}', '2025-01-20 10:45:54'),
('root', 'tutordb', 'assesssubmit', '{\"sorted_col\":\"`assesssubmit`.`remarks` DESC\"}', '2024-02-18 13:06:57'),
('root', 'tutordb', 'tblteacherinfo', '{\"CREATE_TIME\":\"2024-02-16 20:54:25\"}', '2024-02-19 08:57:04');

-- --------------------------------------------------------

--
-- Table structure for table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data for table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2025-01-22 09:05:54', '{\"Console\\/Mode\":\"show\",\"NavigationWidth\":192}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Table structure for table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indexes for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indexes for table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indexes for table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indexes for table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indexes for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indexes for table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indexes for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indexes for table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indexes for table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indexes for table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indexes for table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indexes for table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indexes for table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `practice`
--
CREATE DATABASE IF NOT EXISTS `practice` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `practice`;

-- --------------------------------------------------------

--
-- Table structure for table `user_table`
--

CREATE TABLE `user_table` (
  `uid` int(11) NOT NULL,
  `uname` varchar(40) NOT NULL,
  `uemail` varchar(40) NOT NULL,
  `upassword` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_table`
--

INSERT INTO `user_table` (`uid`, `uname`, `uemail`, `upassword`) VALUES
(1, 'renzy', 'renzy@gmail.com', '123456'),
(2, 'renzy', 'renzy@gmail.com', '123456'),
(3, 'renzy', 'renzy@gmail.com', '123456');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `user_table`
--
ALTER TABLE `user_table`
  ADD PRIMARY KEY (`uid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `user_table`
--
ALTER TABLE `user_table`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Database: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
--
-- Database: `tutordb`
--
CREATE DATABASE IF NOT EXISTS `tutordb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `tutordb`;

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `subject` varchar(100) NOT NULL,
  `level` varchar(10) NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `teacher_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activities`
--

INSERT INTO `activities` (`id`, `title`, `description`, `subject`, `level`, `file_path`, `teacher_id`, `created_at`) VALUES
(7, 'Activity 1', 'Place Values Hundreds', 'Mathematics', 'Grade 2', '../files/FINAL_OUPUT (1).pdf', 0, '2023-07-31 10:17:36'),
(8, 'Activity 2', 'Place Values', 'Mathematics', 'Grade 2', '../../files/LMS-System Documentation.docx', 0, '2023-07-31 10:19:37'),
(9, 'Activity 3', 'Regrouping', 'Mathematics', 'Grade 2', '../../files/FINAL_OUPUT.pdf', 0, '2024-02-19 06:26:54'),
(10, 'Activity 4', 'Addition', 'Mathematics', 'Grade 2', '../../files/LMS-Chapter1-5.pdf', 0, '2024-02-19 09:09:56'),
(11, 'Activity 5', 'Subtraction', 'Mathematics', 'Grade 2', '../../files/LEARNING MANAGEMENT SYSTEM FOR TUTOR HOUSE INC. -SE2-CS3.pdf', 0, '2024-02-19 09:10:10');

-- --------------------------------------------------------

--
-- Table structure for table `actsubmit`
--

CREATE TABLE `actsubmit` (
  `id` int(11) NOT NULL,
  `activityid` int(15) NOT NULL,
  `name` varchar(50) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `level` varchar(50) NOT NULL,
  `studname` varchar(50) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `remarks` varchar(10) NOT NULL,
  `acaverage` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `actsubmit`
--

INSERT INTO `actsubmit` (`id`, `activityid`, `name`, `subject`, `level`, `studname`, `file_path`, `created_at`, `remarks`, `acaverage`) VALUES
(2, 5, '1', 'Filipino', 'Grade 2', '0', '../../submit/FORMAT (1).docx', '2024-02-17 10:08:22', 'C', ''),
(3, 6, '2', 'Filipino', 'Grade 2', 'Garino', '../../submit/LMS-System Documentation.docx', '2024-02-17 10:03:00', 'C', ''),
(4, 7, '3', 'Filipino', 'Grade 2', 'Garino', '../../submit/FORMAT (1).docx', '2024-02-19 09:07:54', 'C', ''),
(5, 8, '4', 'Mathematics', 'Grade 2', 'Garino', '../../submit/Presented-by-GROUP-3.pdf', '2024-02-19 09:13:55', 'B', ''),
(6, 9, '5', 'Mathematics', 'Grade 2', 'Garino', '../../submit/EMERGINGTECHNOLOGIES.pptx', '2024-02-19 09:14:00', 'D', ''),
(7, 10, '4', 'Mathematics', 'Grade 2', 'Garino', '../../submit/aaa.txt', '2024-02-19 09:18:50', 'A', ''),
(8, 11, '5', 'Mathematics', 'Grade 2', 'Garino', '../../submit/FINAL_OUPUT.pdf', '2024-02-19 09:18:55', 'C', ''),
(9, 11, '5', 'Mathematics', 'Grade 2', 'Garino', '../../submit/LMS-Chapter1-5.pdf', '2024-02-19 09:19:08', 'B', '');

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `content`, `created_at`, `updated_at`) VALUES
(6, 'Welcome!', 'Mabuhay! Thank you for choosing Tutor House Inc. for your little ones. Rest assured that we offer quality tutoring sessions, now even virtually. We offer you our very own Learning Management System.\r\n\r\nWe are beyond grateful for your decision to join us and embark to your child\'s journey towards academic progression!\r\n\r\nSee you!', '2023-07-31 09:15:49', '2023-07-31 09:15:49'),
(7, 'General Meeting for First Month', 'Greetings!\r\nWe would like to invite you to our very first virtual meeting, to discuss the institutions\' values, rules, and platforms this coming August 21, 2023. Attendance is a must, especially for our first timer tutees.\r\n\r\nSee you!', '2023-07-31 09:37:32', '2023-07-31 09:37:32');

-- --------------------------------------------------------

--
-- Table structure for table `assess`
--

CREATE TABLE `assess` (
  `id` int(10) NOT NULL,
  `studentid` int(10) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `initial` varchar(255) NOT NULL,
  `act` varchar(10) NOT NULL,
  `ass` varchar(10) NOT NULL,
  `ave` varchar(10) NOT NULL,
  `final` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assess`
--

INSERT INTO `assess` (`id`, `studentid`, `lastname`, `subject`, `initial`, `act`, `ass`, `ave`, `final`, `status`) VALUES
(1, 15, 'Garino', '', '', '', '', '', '', ''),
(52, 0, 'Garino', 'Mathematics', 'C', '3', '3', '3', 'C', 'Pass'),
(53, 0, 'Garino', 'English', 'Ungraded', '0', '0', '0', 'Ungraded', 'Pass');

-- --------------------------------------------------------

--
-- Table structure for table `assessments`
--

CREATE TABLE `assessments` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `subject` varchar(100) NOT NULL,
  `level` varchar(10) NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `teacher_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assessments`
--

INSERT INTO `assessments` (`id`, `title`, `description`, `subject`, `level`, `file_path`, `teacher_id`, `created_at`) VALUES
(2, 'Assessment 1', 'First Monthly Assessment', 'Mathematics', 'Grade 2', '../files/MOCKJOBINTERVIEWGUIDELINESANDRUBRIC.docx', 0, '2023-07-31 08:05:13'),
(4, 'Assessment 2', 'swswdwdw', 'Mathematics', 'Grade 2', '../files/LEARNING MANAGEMENT SYSTEM FOR TUTOR HOUSE INC. -SE2-CS3.pdf', 0, '2024-02-18 12:44:58'),
(5, 'Assessment 3', 'Answer Carefully', 'Mathematics', 'Grade 2', '../../files/LMS-Chapter1-5.pdf', 0, '2024-02-19 09:10:55'),
(6, 'Assessment 4', 'Read the question carefully.', 'Mathematics', 'Grade 2', '../../files/SE2-LMS-PPTX.pptx', 0, '2024-02-19 09:11:15'),
(7, 'Assessment 5', 'GO!', 'Mathematics', 'Grade 2', '../../files/FINAL_OUPUT.pdf', 0, '2024-02-19 09:16:11'),
(8, 'Assessment 7', 'Visual Programming', 'Mathematics', 'Grade 2', '../../files/LEARNING MANAGEMENT SYSTEM FOR TUTOR HOUSE INC. -SE2-CS3.pdf', 0, '2024-02-19 09:40:23');

-- --------------------------------------------------------

--
-- Table structure for table `assesssubmit`
--

CREATE TABLE `assesssubmit` (
  `id` int(11) NOT NULL,
  `assessid` int(15) NOT NULL,
  `name` varchar(50) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `level` varchar(50) NOT NULL,
  `studname` varchar(50) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `remarks` varchar(10) NOT NULL,
  `asaverage` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assesssubmit`
--

INSERT INTO `assesssubmit` (`id`, `assessid`, `name`, `subject`, `level`, `studname`, `file_path`, `created_at`, `remarks`, `asaverage`) VALUES
(1, 0, 'Assessment 2', 'Mathematics', 'Grade 2', 'Garino', '../../submit/MOCKJOBINTERVIEWGUIDELINESANDRUBRIC.pdf', '2023-08-01 12:21:25', 'A', 0),
(2, 2, 'Assessment 1', 'Mathematics', 'Grade 2', 'Garino', '../../submit/FORMAT (1).docx', '2023-08-01 12:53:47', 'A', 0),
(3, 4, 'Assessment 1', 'Mathematics', 'Grade 2', 'Garino', '../../submit/FINAL_OUPUT.pdf', '2024-02-18 12:52:26', 'C', 0),
(4, 5, 'Assessment 3', 'Mathematics', 'Grade 2', 'Garino', '../../submit/aaa.txt', '2024-02-19 09:11:42', 'B', 0),
(5, 6, 'Assessment 4', 'Mathematics', 'Grade 2', 'Garino', '../../submit/aaa.txt', '2024-02-19 09:12:15', 'F', 0),
(6, 7, 'Assessment 5', 'Mathematics', 'Grade 2', 'Garino', '../../submit/LMS-Chapter1-5.pdf', '2024-02-19 09:19:51', 'F', 0),
(7, 8, 'Assessment 7', 'Mathematics', 'Grade 2', 'Garino', '../../submit/LEARNING MANAGEMENT SYSTEM FOR TUTOR HOUSE INC. -SE2-CS3.pdf', '2024-02-19 09:41:50', 'E', 0),
(8, 4, 'Assessment 2', 'Mathematics', 'Grade 2', 'Garino', '../../submit/LEARNING MANAGEMENT SYSTEM FOR TUTOR HOUSE INC. -SE2-CS3.pdf', '2024-02-19 09:42:52', 'F', 0);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `description`, `name`, `subject`, `content`, `created_at`, `updated_at`) VALUES
(6, '', 'Garino', 'Mathematics', 'Bad', '2023-08-02 11:06:05', '2023-08-02 11:10:39'),
(7, '', 'Garino', 'Mathematics', 'Can count 1-20 now. Keep practicing at home.', '2023-08-02 11:11:04', '2023-08-02 11:11:04'),
(8, '', 'Garino', 'Reading', 'Diction is progressing, as well as the proper pronunciation. However, still needs more practice.', '2023-08-02 11:14:52', '2023-08-02 11:14:52');

-- --------------------------------------------------------

--
-- Table structure for table `lessons`
--

CREATE TABLE `lessons` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `subject` varchar(100) NOT NULL,
  `level` varchar(10) NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `teacher_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lessons`
--

INSERT INTO `lessons` (`id`, `title`, `description`, `subject`, `level`, `file_path`, `teacher_id`, `created_at`) VALUES
(3, 'Lesson 1', 'Ponema', 'Filipino', 'Grade 4', '../files/PRELIM_HANDOUT2.pdf', 0, '2023-07-31 08:08:46'),
(4, 'Lesson 3', 'Addition', 'Mathematics', 'Grade 2', '../../files/SE2-LMS-PPTX.pptx', 0, '2024-02-19 10:25:14');

-- --------------------------------------------------------

--
-- Table structure for table `tbladmin`
--

CREATE TABLE `tbladmin` (
  `id` int(5) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `level` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbladmin`
--

INSERT INTO `tbladmin` (`id`, `email`, `password`, `type`, `level`) VALUES
(1, 'den.poblador0@gmail.com', '$2y$10$.9lEyan2Gc/fX6yVtaZ3L.rhy6DQTj9dc7MNZCNGctgAMvBgkCtda', 'admin', ''),
(2, 'dmacapagal@gmail.com', '$2y$10$ZB0Cj2uafgtjhFE1qtL07.Dkb2mRUuYKoCp86SjwwNVNnTOB38gsW', 'teacher', ''),
(3, 'denwhiz@gmail.com', '$2y$10$AiXsmaBRZDMY92BxyKj4Q.9AvgUvMk5Zg3V5zvpjdT68WjhOZTOKK', 'student', ''),
(18, 'garinobrix@gmail.com', '$2y$10$1koRGCNTB90M0lU1ZjxuQOTnagY3fI8FWLPojeRi9MraKo7QbBR8i', 'student', 'Grade 2'),
(20, 'anton_chi@gmail.com', '$2y$10$vHYUsGN1pXHBt3dZLgSbXe8H6MSvZe1D1x2O/caGsXgq3VjqXSthG', 'teacher', '');

-- --------------------------------------------------------

--
-- Table structure for table `tblstudentinfo`
--

CREATE TABLE `tblstudentinfo` (
  `id` int(10) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `middlename` varchar(255) NOT NULL,
  `suffix` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `barangay` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `birthdate` varchar(255) NOT NULL,
  `age` int(10) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `school` varchar(255) NOT NULL,
  `level` varchar(255) NOT NULL,
  `parentname` varchar(255) NOT NULL,
  `parentaddress` varchar(255) NOT NULL,
  `parentnumber` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tblstudentinfo`
--

INSERT INTO `tblstudentinfo` (`id`, `lastname`, `firstname`, `middlename`, `suffix`, `address`, `barangay`, `city`, `email`, `phone`, `birthdate`, `age`, `gender`, `school`, `level`, `parentname`, `parentaddress`, `parentnumber`, `password`) VALUES
(15, 'Garino', 'Brix', 'Casintahan', 'Jr', 'Block 1 Lot 21 Villa Tagumpay', 'Halang', 'Calamba', 'garinobrix@gmail.com', '09265342612', '2017-02-07', 6, 'Male', 'LCBA', 'Grade 2', 'Larry Garino', 'Block 1 Lot 21 Villa Tagumpay, Halang, Calamba', '09265342612', '$2y$10$1koRGCNTB90M0lU1ZjxuQOTnagY3fI8FWLPojeRi9MraKo7QbBR8i');

-- --------------------------------------------------------

--
-- Table structure for table `tblteacherinfo`
--

CREATE TABLE `tblteacherinfo` (
  `id` int(10) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `middlename` varchar(50) NOT NULL,
  `suffix` varchar(10) NOT NULL,
  `address` int(75) NOT NULL,
  `barangay` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `email` varchar(30) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `birthdate` varchar(50) NOT NULL,
  `age` int(10) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tblteacherinfo`
--

INSERT INTO `tblteacherinfo` (`id`, `lastname`, `firstname`, `middlename`, `suffix`, `address`, `barangay`, `city`, `email`, `phone`, `birthdate`, `age`, `gender`, `password`) VALUES
(1, 'Chigurh', 'Anton', 'Smith', 'II', 21, 'Parian', 'Calamba', 'anton_chi@gmail.com', '09627837266', '1995-11-11', 27, 'Male', '$2y$10$vHYUsGN1pXHBt3dZLgSbXe8H6MSvZe1D1x2O/caGsXgq3VjqXSthG');

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `id` int(10) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `remarks` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ticket`
--

INSERT INTO `ticket` (`id`, `email`, `name`, `remarks`) VALUES
(1, 'garinobrix@gmail.com', 'Brix Garino', 'Resolved'),
(2, 'anton_chi@gmail.com', 'Anton Chigurh', 'Resolved'),
(3, 'garinobrix@gmail.com', 'Brix Garino', 'Resolved');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `actsubmit`
--
ALTER TABLE `actsubmit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `assess`
--
ALTER TABLE `assess`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `assessments`
--
ALTER TABLE `assessments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `assesssubmit`
--
ALTER TABLE `assesssubmit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbladmin`
--
ALTER TABLE `tbladmin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tblstudentinfo`
--
ALTER TABLE `tblstudentinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tblteacherinfo`
--
ALTER TABLE `tblteacherinfo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `actsubmit`
--
ALTER TABLE `actsubmit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `assess`
--
ALTER TABLE `assess`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `assessments`
--
ALTER TABLE `assessments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `assesssubmit`
--
ALTER TABLE `assesssubmit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `lessons`
--
ALTER TABLE `lessons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbladmin`
--
ALTER TABLE `tbladmin`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `tblstudentinfo`
--
ALTER TABLE `tblstudentinfo`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tblteacherinfo`
--
ALTER TABLE `tblteacherinfo`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
