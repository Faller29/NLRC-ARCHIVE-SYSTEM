-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 30, 2025 at 04:31 PM
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
(19, 'LA Renzy', '1'),
(20, 'LA Sapallo', '2');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_archived`
--

CREATE TABLE `tbl_archived` (
  `req_id` int(11) NOT NULL,
  `acc_id` int(11) NOT NULL,
  `doc_id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_document`
--

CREATE TABLE `tbl_document` (
  `doc_id` int(11) NOT NULL,
  `sack_id` int(11) NOT NULL,
  `doc_number` varchar(40) NOT NULL,
  `doc_complainant` varchar(255) NOT NULL,
  `doc_respondent` varchar(255) NOT NULL,
  `verdict` varchar(50) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `volume` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_document`
--

INSERT INTO `tbl_document` (`doc_id`, `sack_id`, `doc_number`, `doc_complainant`, `doc_respondent`, `verdict`, `status`, `version`, `volume`) VALUES
(550, 86, 'RAB-IV-04-00551-16-L', 'DIOGENES STO. DOMINGO, JR.', 'ENGR. LILIBETH PEREZ', NULL, 'Stored', 'old', ''),
(551, 86, 'RAB-IV-7-00976-15-Q', 'MELCHOR D. MANALILI', 'COMPUTER SYSTEMS TECHNOLOGICAL COLLEGE INC. (CSTC)', NULL, 'Stored', 'old', ''),
(552, 86, 'RAB-IV-03-00435-17-C', 'JOHN REY ESPANUEVA, ET. AL.', 'VISMAN SECURITY AGENCY CORP., ET. AL', NULL, 'Stored', 'old', ''),
(553, 86, 'RAB-IV-03-00457-16-C', 'CHRISTOPHER D. ALVARE', 'EVER GOLD TRUCKING ET. AL', NULL, 'Stored', 'old', ''),
(554, 86, 'RAB-IV-08-01126-16-B', 'ARNEL MANSUMAGAN', '168 DOUBLE DRAGON AGENCY, ET. AL', NULL, 'Stored', 'old', ''),
(555, 86, 'RAB-IV-04-00541-16-B', 'PIO A. ARCANSALIN', 'PER\'Z PROTECTIVE & DETECTIVE SERVICES', NULL, 'Stored', 'old', ''),
(556, 86, 'RAB-IV-03-00510-16-L', 'MIGUEL D. LLUBIT', 'ST. CLAIR SECURIT & INVESTIGATION AGENCT, ET. AL', NULL, 'Stored', 'old', ''),
(557, 86, 'RAB-IV-04-00545-16-L', 'JESPER MARK B. LABITA', 'STARION ENTERPRISES 7-ELEVEN FRANCHISEE', NULL, 'Stored', 'old', ''),
(558, 86, 'RAB-IV-12-01830-16-L', 'NIÑO R. MENDOZA', 'SARAH HAZEL RICO AND GROCERIES', NULL, 'Stored', 'old', ''),
(559, 86, 'RAB-IV-09-01298-16-L', 'DAN ERIC S. GUEVARRA', 'FERUSCHE STAINLESS INC. / SANYO SEIKI STAINLESS STEEL CORP., ET. AL', NULL, 'Stored', 'old', ''),
(560, 86, 'RAB-IV-03-00481-17-C', 'GUILLERMA A. ANGUE, ET. AL.', 'YEONHO ELECTRONICS PHIL. INC., ET. AL', NULL, 'Stored', 'old', ''),
(561, 86, 'RAB-IV-12-01893-16-C', 'RAMON EDROSO, ET. AL.', 'SAINT ANTHONY OF PADUA TRANS, ET. AL', NULL, 'Stored', 'old', ''),
(562, 86, 'RAB-IV-09-05174-16-B', 'ERNAN S. MAURO', 'CONCEPT PLACEMENT RESOURCES INC., ET. AL', NULL, 'Stored', 'old', ''),
(563, 86, 'RAB-IV-07-01050-16-C', 'MELVIN P. MEJILLA', 'C & F MANUFACTURING PHILS., CORP., ET. AL', NULL, 'Stored', 'old', ''),
(564, 86, 'RAB-IV-10-01473-16-L', 'MAE D. ARINGO', 'ROCA SECURITY SERVICES INC., ET. AL', NULL, 'Stored', 'old', ''),
(565, 86, 'RAB-IV-10-01626-17-RI', 'LEOPOLDO PAAT, JR.', 'JOLY FOOD CORP.', NULL, 'Stored', 'old', ''),
(566, 86, 'RAB-IV-05-00863-17-C', 'ALVIA V. FRIAL', 'SEOGWANG CHRISTIAN SCHOOL', NULL, 'Stored', 'old', ''),
(567, 86, 'RAB-IV-11-01765-16-RI', 'VICTOR LEGAZPI', 'CHYNNA CONSUMER SERVICES INC., NUTRI ASIA PHILS., ET. AL', NULL, 'Stored', 'old', ''),
(568, 86, 'RAB-IV-07-01058-16-C', 'NOEL GAMOSO, ET. AL', 'CORINTHIANG INTEGRATED SECURITY AGENCY, INC., ET. AL', NULL, 'Stored', 'old', ''),
(569, 86, 'RAB-IV-12-01854-17-RI', 'RENANTE BAUTISTA', 'SIDEKICK FORCE SECURITY INVESTIGATION ET. AL', NULL, 'Stored', 'old', ''),
(570, 86, 'RAB-IV-09-01281-16-L', 'RAMON VERGARA', 'MIGHTY CORP., ET. AL', NULL, 'Stored', 'old', ''),
(571, 86, 'RAB-IV-10-01582-16-L', 'RICKY C. CANTUBA', 'GROLIER INTERNATIONAL FINANCE INC., ET. AL', NULL, 'Stored', 'old', ''),
(572, 86, 'RAB-IV-08-01209-13-L', 'NELSON NARVAEZ', 'FAST SERVICES CORP. / NESTLE PHILS. INC.', NULL, 'Stored', 'old', ''),
(573, 86, 'RAB-IV-05-00722-13-C', 'DOMILITO C. ORTIZ', 'GOLDEN EGG CO.', NULL, 'Stored', 'old', ''),
(574, 86, 'RAB-IV-04-00613-16-C', 'JACQUELINE G. ROSAIRO', 'IQOR PHILS. INC.', NULL, 'Stored', 'old', ''),
(575, 86, 'RAB-IV-07-01073-16-C', 'CHRISTOPHER PHILIP C. DIONIDO, JR.', 'C & F MANUFACTURING PHILS., CORP., ET. AL', NULL, 'Stored', 'old', ''),
(576, 86, 'RAB-IV-06-00851-16-RI', 'ROSALIO P. BARNIDO, JR.', 'UNLIMITED BUILDERS & CONSTRUCTION SUPPLY / A.B.C., ET. AL', NULL, 'Stored', 'old', ''),
(577, 86, 'RAB-IV-05-00711-17-L', 'SIDNEY L. TOEL', 'BRENT INT\'L. SCHOOL MANILA, ET. AL', NULL, 'Stored', 'old', ''),
(578, 86, 'RAB-IV-03-00527-19-C', 'ERIC HARDER GATON', 'NEWLIFE HARDWARE, ET. AL.', NULL, 'Stored', 'old', ''),
(579, 86, 'RAB-IV-06-00939-17-L', 'MICHAEL M. FLORES', 'SAGARA METRO PLASTICS INDUSTRIAL CORP., ET. AL', NULL, 'Stored', 'old', ''),
(580, 87, 'RAB-IV-8-16088-02-L', 'EDWIN B. EDRINA ET. AL.', 'MIDDLE PHILS. CORP.', NULL, 'Stored', 'old', 'VOL. 1'),
(581, 87, 'RAB-IV-12-16648-02-C', 'GHINGH GEMMA P. SUELLO, ET. AL.', 'QUEEN OF HEARTS ACADEMY', NULL, 'Stored', 'old', ''),
(582, 87, 'RAB-IV-8-16058-02-RI', 'NERISSA TALAVERA', 'ICCT COLLEGE', NULL, 'Stored', 'old', ''),
(583, 87, 'RAB-IV-9-16097-02-RI', 'CIRILO E. COLINARES', 'F.R. CEMENT CORPORATION', NULL, 'Stored', 'old', ''),
(584, 87, 'RAB-IV-12-21745-05-C', 'ECLOY FRANCISCO', 'ARB. CABATO', NULL, 'Stored', 'old', ''),
(585, 87, 'RAB-IV-08-16022-02-L', 'REYNALDO DIMAYUGA, ET. AL.', 'NESTLE PHILS., INC.', NULL, 'Stored', 'old', 'VOL. 4 & 5'),
(586, 87, 'RAB-IV-8-16047-02-L', 'LEONARDO SANTOS', 'HONDA CARS PHILS.', NULL, 'Stored', 'old', ''),
(587, 87, 'RAB-IV-8-16028-02-C', 'GIGI TOYADO, ET. ALL.', 'CID INTERNATIONAL', NULL, 'Stored', 'old', ''),
(588, 87, 'RAB-IV-8-16066-02-C', 'ROMMEL LOTERIA, ET. AL.', 'SONIC STEEL INDUSTRIES INC.,', NULL, 'Stored', 'old', ''),
(589, 87, 'RAB-IV-8-16038-02-RI', 'ROBERTO R. SOLTES JR.', 'SHACKLES TRADING', NULL, 'Stored', 'old', ''),
(590, 87, 'RAB-IV-8-16068-02-B', 'RUBEN B. RAMOS', 'EMERITUS SCTY & MAINTENANCE SYSTEM, INC.', NULL, 'Stored', 'old', ''),
(591, 87, 'RAB-IV-8-16055-02-L', 'EVANGELINA EXPRESCION AND MELECIO P. MELANIS', 'ARCYA GLASS CORPORATION', NULL, 'Stored', 'old', ''),
(592, 87, 'RAB-IV-8-16015-02-RI', 'MA. LUISA FLORES AND LOURDES ENRIQUEZ', 'ENCHIS TAILORING', NULL, 'Stored', 'old', ''),
(593, 87, 'RAB-IV-8-16086-02-L', 'NELSON R. VELASCO / SUSANO ARCIAGO', 'A.M. GEN. SVCS.', NULL, 'Stored', 'old', ''),
(594, 87, 'RAB-IV-1-16689-03-L', 'ALBERTO C. BELO, ET. AL.', 'MORALES SUPERMARKET', NULL, 'Stored', 'old', ''),
(595, 87, 'RAB-IV-1-16697-03-C', 'ORLY B. TIBAYAN', 'STENIEL CAVITE PCKG. CORP. ', NULL, 'Stored', 'old', ''),
(596, 87, 'RAB-IV-01-16686-03-B', 'MA. BRENDA M. AGAID', 'DAYS HOTEL', NULL, 'Stored', 'old', ''),
(597, 87, 'RAB-IV-11-16419-02-RI', 'FW LABOR UNION / MARIVIC ENOVAL, ET. AL.', 'FW GARMENT CORP.', NULL, 'Stored', 'old', ''),
(598, 87, 'RAB-IV-01-16726-03-C', 'SAMAHANG MANGGAWA NG EUROTILES - ANGLO - KMU / HENRY UMANDAL ET. AL.', 'EUROTILES INDUSTRIAL CORP.', NULL, 'Stored', 'old', 'VOL. 1, 2 & 3'),
(599, 87, 'RAB-IV-11-16470-02-C', 'EDUARDO R. NAVARRO JR.', 'PACIFIC ACTIVATED CARBON CO.', NULL, 'Stored', 'old', ''),
(600, 87, 'RAB-IV-11-16483-02-L', 'CARLO CANUA (UNION PRESIDENT) /OLALIA KMU', 'PLUS ONE MFG. INC.', NULL, 'Stored', 'old', ''),
(601, 87, 'RAB-IV-11-16482-02-L', 'JAIME F. MENDOZA', 'ON Q TECHNOLOGY, INC. (A SUBSIDIARY OF DEVICE DYNAMICS)', NULL, 'Stored', 'old', ''),
(602, 87, 'RAB-IV-10-16403-02-C', 'NILO ROMERO JR., ET. AL', 'COSMOS BOTTLING CORP.', NULL, 'Stored', 'old', ''),
(603, 87, 'RAB-IV-10-16409-02-RI', 'ANACLETO M. TRANGIA', 'SELECTIVE SECURITY AGENCY / GLOBE PAPER MILLS, ET. AL.', NULL, 'Stored', 'old', ''),
(604, 87, 'RAB-IV-10-16416-02-C', 'GIOVANNI P. SAPNIT', 'MC GEORGE FOOD INDUSTRIES (MC DONALDS)', NULL, 'Stored', 'old', ''),
(605, 87, 'RAB-IV-11-16478-02-L', 'JOSE A. GALLARDO JR.', 'DRAGON CHEF FOOD CO.', NULL, 'Stored', 'old', ''),
(606, 87, 'RAB-IV-10-16412-02-C', 'ALEXANDER PARAON', 'PLUS BUILDERS', NULL, 'Stored', 'old', ''),
(607, 87, 'RAB-IV-11-16452-02-C', 'VENERANDA J. PREMERO', 'TRIPLE EIGHT (8) GARMENTS MFG. CORP.', NULL, 'Stored', 'old', ''),
(608, 87, 'RAB-IV-10-16414-02-RI', 'ROMEO D. AMBROCIO', 'ENZIO FERRERA COLLECTION', NULL, 'Stored', 'old', ''),
(609, 87, 'RAB-IV-10-16407-02-RI', 'EDGAR HUIT', 'COCA-COLA BOTTLERS PHILS., INC.', NULL, 'Stored', 'old', ''),
(610, 87, 'RAB-IV-10-16352-02-RI', 'RODERICK TALAVERA', 'NORTHWEST ADVERTISING SERVICES', NULL, 'Stored', 'old', ''),
(611, 87, 'RAB-IV-10-16303-02-RI', 'ARACELI PERLAS, ET. AL.', 'WESTAR TECHNOLOGY, INC.', NULL, 'Stored', 'old', ''),
(612, 87, 'RAB-IV-10-16397-02-RI', 'NINFA A. ROSALES', 'LE DERMA CARE', NULL, 'Stored', 'old', ''),
(613, 87, 'RAB-IV-10-16328-02-C', 'SUSTINES GOÑA JR.', 'VISMAN SECURITY AGENCY & ALLIED SVCS.', NULL, 'Stored', 'old', ''),
(614, 87, 'RAB-IV-10-16380-02-L', 'ALDRIN EDIA', 'SOUTHERN ESTATE GENERAL SERVICES', NULL, 'Stored', 'old', ''),
(615, 87, 'RAB-IV-10-16366-02-L', 'LOURDES LOYSAGA', 'EL TIGRE SECURITY', NULL, 'Stored', 'old', ''),
(616, 87, 'RAB-IV-10-16374-02-C', 'BABY MERCY MARAVE', 'THE HEROES LEARNING SCHOOL', NULL, 'Stored', 'old', ''),
(617, 87, 'RAB-IV-10-16311-02-RI', 'GENER GOMEZ', 'ENZIO FERRERA COLLECTION', NULL, 'Stored', 'old', ''),
(618, 87, 'RAB-IV-10-16339-02-RI', 'MALOU DE MARQUEZ', 'ICCT COLLEGES', NULL, 'Stored', 'old', ''),
(619, 87, 'RAB-IV-16304-02-RI', 'RODOLFO P. GUBALA', 'COLOR CREST CORP.', NULL, 'Stored', 'old', ''),
(620, 87, 'RAB-IV-10-16383-02-RI', 'FLORENTINO GALVE', 'ATHLETIC DESIGN INTL. CORP.', NULL, 'Stored', 'old', ''),
(621, 87, 'RAB-IV-10-16318-02-C', 'JOSEPH A. REGIO', '202 LUMBER & CONSTRUCTION SUPPLY', NULL, 'Stored', 'old', ''),
(622, 87, 'RAB-IV-10-16308-02-L', 'CEZAR P. ZAGUIRRE', 'RSM RESTAUNRANT AND RESORT', NULL, 'Stored', 'old', ''),
(623, 87, 'RAB-IV-10-16386-02-R', 'JESSICA SAYUD', 'WOO YOUNG PHILS., INC.', NULL, 'Stored', 'old', ''),
(624, 87, 'RAB-IV-10-16336-02-RI', 'ALFREDO COLICO', 'HANJIN HEAVY INDUSTRIES', NULL, 'Stored', 'old', ''),
(625, 87, 'RAB-IV-10-16391-02-LUCENA', 'JAIME RODRIGAZO JR.', 'KING\'S 2000 SECURITY & GENERAL SERVICES CORPORATION', NULL, 'Stored', 'old', ''),
(626, 87, 'RAB-IV-10-16354-02-B', 'CALTEX REFINERY EMPLOYEES ASSOCIATION (CREA)', 'CALTEX PHILS., INC.', NULL, 'Stored', 'old', ''),
(627, 87, 'RAB-IV-10-16371-02-L', 'DIOSDADO RIVERA & ADENCIO BUO', 'JERA MARKETING', NULL, 'Stored', 'old', ''),
(628, 87, 'RAB-IV-11-16470-02-RI', 'ANNABEL B. CONCEPCION', 'ANTIPOLO GARMENTS, INC.', NULL, 'Stored', 'old', ''),
(629, 87, 'RAB-IV-02-24340-07-C', 'JOCELYN P. CERVANIA, ET. AL.', 'YOUNGHWE PHILS. INC.', NULL, 'Stored', 'old', ''),
(630, 87, 'RAB-IV-02-24382-01-L', 'MA. LUIZA A. IBANEZ, ET. AL.', 'VALERY APPAREL, INC.', NULL, 'Stored', 'old', ''),
(631, 87, 'RAB-IV-02-24244-07-L', 'MARIO S. BALBERONA', 'MERIT CORPORATION INVESTIGATION AGENCY, INC.', NULL, 'Stored', 'old', ''),
(632, 87, 'RAB-IV-01-24047-07-L', 'JAY ACEDO GONNAD', 'HAUSKON, INC.', NULL, 'Stored', 'old', ''),
(633, 87, 'RAB-IV-05-24696-07-L', 'RENATO R. CALUMBA, ET. AL.', 'SOUTH STAR GLASS & ALUMINUM SUPPLY', NULL, 'Stored', 'old', ''),
(634, 87, 'RAB-IV-02-24348-07-B', 'ROLLY MAYOR', 'HO WOONG INC. AND S.G. MANPOWER SERVICES', NULL, 'Stored', 'old', ''),
(636, 85, 'RAB-IV-03-00510-16-L', 'MIGUEL D. LLUBIT', 'ST. CLAIR SECURIT & INVESTIGATION AGENCT, ET. AL', '', 'Stored', 'old', '1');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sack`
--

CREATE TABLE `tbl_sack` (
  `sack_id` int(11) NOT NULL,
  `sack_name` varchar(255) NOT NULL,
  `arbiter_number` varchar(244) NOT NULL,
  `status` varchar(100) NOT NULL,
  `admin_message` varchar(255) DEFAULT NULL,
  `acc_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_sack`
--

INSERT INTO `tbl_sack` (`sack_id`, `sack_name`, `arbiter_number`, `status`, `admin_message`, `acc_id`) VALUES
(85, '1', 'LA Renzy', 'Creating', NULL, 2),
(86, 'Sack 16', 'LA Renzy', 'Stored', NULL, 2),
(87, 'Sack 17', 'LA Renzy', 'Stored', NULL, 2),
(88, 'Sack 18', 'LA Renzy', 'Stored', NULL, 2),
(89, 'Sack 19', 'LA Renzy', 'Stored', NULL, 2),
(90, 'Sack 20', 'LA Renzy', 'Stored', NULL, 2);

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
(12, '111', '111', 19),
(13, '222', '222', 20);

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
-- Indexes for table `tbl_archived`
--
ALTER TABLE `tbl_archived`
  ADD PRIMARY KEY (`req_id`),
  ADD KEY `acc_id` (`acc_id`),
  ADD KEY `doc_id` (`doc_id`);

--
-- Indexes for table `tbl_document`
--
ALTER TABLE `tbl_document`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `fk_sack_id` (`sack_id`);

--
-- Indexes for table `tbl_sack`
--
ALTER TABLE `tbl_sack`
  ADD PRIMARY KEY (`sack_id`),
  ADD KEY `fk_acc_id_creator` (`acc_id`);

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
  MODIFY `arbi_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tbl_archived`
--
ALTER TABLE `tbl_archived`
  MODIFY `req_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `tbl_document`
--
ALTER TABLE `tbl_document`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=637;

--
-- AUTO_INCREMENT for table `tbl_sack`
--
ALTER TABLE `tbl_sack`
  MODIFY `sack_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `tbl_user_account`
--
ALTER TABLE `tbl_user_account`
  MODIFY `acc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

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
-- Constraints for table `tbl_archived`
--
ALTER TABLE `tbl_archived`
  ADD CONSTRAINT `fk_acc_id` FOREIGN KEY (`acc_id`) REFERENCES `tbl_user_account` (`acc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doc_id` FOREIGN KEY (`doc_id`) REFERENCES `tbl_document` (`doc_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_document`
--
ALTER TABLE `tbl_document`
  ADD CONSTRAINT `fk_sack_id` FOREIGN KEY (`sack_id`) REFERENCES `tbl_sack` (`sack_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_document_ibfk_1` FOREIGN KEY (`sack_id`) REFERENCES `tbl_sack` (`sack_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_sack`
--
ALTER TABLE `tbl_sack`
  ADD CONSTRAINT `fk_acc_id_creator` FOREIGN KEY (`acc_id`) REFERENCES `tbl_user_account` (`acc_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_user_account`
--
ALTER TABLE `tbl_user_account`
  ADD CONSTRAINT `tbl_user_account_ibfk_1` FOREIGN KEY (`arbi_id`) REFERENCES `tbl_arbi_user` (`arbi_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
