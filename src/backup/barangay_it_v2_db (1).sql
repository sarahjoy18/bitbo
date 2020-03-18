-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 12, 2019 at 08:50 AM
-- Server version: 10.4.6-MariaDB
-- PHP Version: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barangay_it_v2_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_resident` (IN `search_val` VARCHAR(255))  BEGIN
	SELECT RESIDENT_ID
	, CONCAT(FIRSTNAME,' ', LASTNAME) AS FULLNAME
	, CONCAT(MONTHNAME(DATE_OF_BIRTH),' ',DAY(DATE_OF_BIRTH),', ',YEAR(DATE_OF_BIRTH)) AS DATE_OF_BIRTH
	, PLACE_OF_BIRTH
	, CONCAT(ADDRESS_HOUSE_NO,' ',ADDRESS_STREET_NO, ' ',ADDRESS_STREET) AS FULL_ADDRESS
	, PROFILE_PICTURE
	FROM t_resident_basic_info
	WHERE RESIDENT_ID NOT IN (SELECT RESIDENT_ID FROM t_barangay_official) 
	AND CONCAT(FIRSTNAME,' ', LASTNAME) LIKE CONCAT('%',search_val, '%')
	AND FIRSTNAME LIKE CONCAT('%',search_val, '%') OR LASTNAME  LIKE CONCAT('%',search_val, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_permissions` ()  BEGIN
	SELECT
	
	DISTINCT(concat( `rbi`.`FIRSTNAME`, ' ', `rbi`.`MIDDLENAME`, ' ', `rbi`.`LASTNAME` )) AS `FULLNAME`
	,p.POSITION_NAME
	,`u`.`PERMIS_RESIDENT_BASIC_INFO` AS `PERMIS_RESIDENT_BASIC_INFO`
	,`u`.`PERMIS_FAMILY_PROFILE` AS `PERMIS_FAMILY_PROFILE`
	,`u`.`PERMIS_COMMUNITY_PROFILE` AS `PERMIS_COMMUNITY_PROFILE`
	,`u`.`PERMIS_BLOTTER` AS `PERMIS_BLOTTER`
	,`u`.`PERMIS_PATAWAG` AS `PERMIS_PATAWAG`
	,`u`.`PERMIS_BARANGAY_OFFICIAL` AS `PERMIS_BARANGAY_OFFICIAL`
	,`u`.`PERMIS_BUSINESSES` AS `PERMIS_BUSINESSES`
	,`u`.`PERMIS_ISSUANCE_OF_FORMS` AS `PERMIS_ISSUANCE_OF_FORMS`
	,`u`.`PERMIS_ORDINANCES` AS `PERMIS_ORDINANCES`
	,`u`.`PERMIS_SYSTEM_REPORT` AS `PERMIS_SYSTEM_REPORT`
	,`u`.`PERMIS_HEALTH_SERVICES` AS `PERMIS_HEALTH_SERVICES`
	,`u`.`PERMIS_DATA_MIGRATION` AS `PERMIS_DATA_MIGRATION`
	,`u`.`PERMIS_USER_ACCOUNTS` AS `PERMIS_USER_ACCOUNTS`
	,`u`.`PERMIS_BARANGAY_CONFIG` AS `PERMIS_BARANGAY_CONFIG`
	,`u`.`PERMIS_BUSINESS_APPROVAL` AS `PERMIS_BUSINESS_APPROVAL`
	
FROM
	(
	(
	(
	(
	( `t_users` `u` JOIN `t_barangay_official` `bo` ON ( ( `bo`.`BARANGAY_OFFICIAL_ID` = `u`.`BARANGAY_OFFICIAL_ID` ) ) )
	JOIN `r_barangay_information` `bs` ON ( ( `bs`.`BARANGAY_ID` = `bo`.`BARANGAY_ID` ) ) 
	)
	JOIN `t_resident_basic_info` `rbi` ON ( ( `bo`.`RESIDENT_ID` = `rbi`.`RESIDENT_ID` ) ) 
	)
	JOIN `r_position` `p` ON ( ( `p`.`POSITION_ID` = `u`.`POSITION_ID` ) ) 
	)
	JOIN `r_municipal_information` `mi` ON ( ( `mi`.`MUNICIPAL_ID` = `bs`.`MUNICIPAL_ID` ) ) 
	);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_positions` ()  BEGIN
	SELECT POSITION_ID, POSITION_NAME FROM r_position;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_residents_not_official` ()  BEGIN
	SELECT RESIDENT_ID, CONCAT(FIRSTNAME,' ',LASTNAME) AS FULLNAME FROM t_resident_basic_info
	WHERE RESIDENT_ID NOT IN (SELECT RESIDENT_ID FROM t_barangay_official);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `r_barangay_information`
--

CREATE TABLE `r_barangay_information` (
  `BARANGAY_ID` int(11) NOT NULL,
  `BARANGAY_NAME` varchar(255) DEFAULT NULL,
  `BARANGAY_SEAL` varchar(150) DEFAULT NULL,
  `LAND_AREA` double(255,0) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT current_timestamp(),
  `UPDATED_AT` datetime DEFAULT current_timestamp(),
  `ACTIVE_FLAG` int(11) DEFAULT 1,
  `USER_ID` int(11) DEFAULT NULL,
  `MUNICIPAL_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_barangay_information`
--

INSERT INTO `r_barangay_information` (`BARANGAY_ID`, `BARANGAY_NAME`, `BARANGAY_SEAL`, `LAND_AREA`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `USER_ID`, `MUNICIPAL_ID`) VALUES
(1, 'Cayabu', 'barangay_cuyambay.jpg', 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, 32, 1),
(2, 'Cuyambay', 'barangay_cuyambay.jpg', 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(3, 'Daraitan', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(4, 'Katipunan-Bayani', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(5, 'Kay Buto', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(6, 'Laiban', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(7, 'Mag-Ampon ', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(8, 'Mamuyao', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(9, 'Pinagkamaligan', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(10, 'Plaza Aldea', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1),
(11, 'Sampaloc', NULL, 177, '2019-07-29 19:58:45', '2019-07-29 19:58:45', 1, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `r_barangay_zone`
--

CREATE TABLE `r_barangay_zone` (
  `BARANGAY_ZONE_ID` int(11) NOT NULL,
  `BARANGAY_ZONE_NAME` varchar(250) DEFAULT NULL,
  `BARANGAY_ZONE_DESC` varchar(250) DEFAULT NULL,
  `BARANGAY_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT current_timestamp(),
  `UPDATED_AT` datetime DEFAULT current_timestamp(),
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_barangay_zone`
--

INSERT INTO `r_barangay_zone` (`BARANGAY_ZONE_ID`, `BARANGAY_ZONE_NAME`, `BARANGAY_ZONE_DESC`, `BARANGAY_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(6, 'ASPEN', NULL, NULL, '2019-10-04 00:23:32', '2019-10-04 00:23:32', 1);

-- --------------------------------------------------------

--
-- Table structure for table `r_bf_facilities_equipment`
--

CREATE TABLE `r_bf_facilities_equipment` (
  `FACILITY_EQUIPMENT_ID` int(11) NOT NULL,
  `FACILITY_EQUIPMENT_NAME` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `r_bf_line_of_business`
--

CREATE TABLE `r_bf_line_of_business` (
  `LINE_OF_BUSINESS_ID` int(11) NOT NULL,
  `LINE_OF_BUSINESS_NAME` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_bf_line_of_business`
--

INSERT INTO `r_bf_line_of_business` (`LINE_OF_BUSINESS_ID`, `LINE_OF_BUSINESS_NAME`) VALUES
(1, 'Agriculture'),
(2, 'Forestry'),
(3, 'Fishery'),
(4, 'Mining'),
(5, 'Food Processing Industry'),
(6, 'Textile and Clothing Industry'),
(7, 'Leather Industry'),
(8, 'Wood Processing Industry'),
(9, 'Paper Industry'),
(10, 'Printing Industry'),
(11, 'Chemical Industry'),
(12, 'Glass and Ceramic'),
(13, 'Machine and Metal-Working Industry'),
(14, 'Production of Electricity and Gas'),
(15, 'Building Industry'),
(16, 'Retail Sale and Wholesale'),
(17, 'Storage and Complementary Services'),
(18, 'Accommodation and Catering Services'),
(19, 'Information, Communication and Publishing'),
(20, 'Financial Activities'),
(21, 'Education'),
(22, 'Health Care and Social Services'),
(23, 'Cultural, Entertainment, Recreational, Sport Activ'),
(24, 'Real Estate and Renting'),
(25, 'Scientific and Technic Testing and  Analyses');

-- --------------------------------------------------------

--
-- Table structure for table `r_blotter_subjects`
--

CREATE TABLE `r_blotter_subjects` (
  `BLOTTER_SUBJECT_ID` int(11) NOT NULL,
  `BLOTTER_NAME` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_blotter_subjects`
--

INSERT INTO `r_blotter_subjects` (`BLOTTER_SUBJECT_ID`, `BLOTTER_NAME`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(17, 'Missing person', '2019-10-04 01:25:07', NULL, 1),
(18, 'Missing person', '2019-10-04 01:25:38', NULL, 1),
(19, 'Sample', '2019-10-08 12:29:31', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `r_business_nature`
--

CREATE TABLE `r_business_nature` (
  `BUSINESS_NATURE_ID` int(11) NOT NULL,
  `BUSINESS_NATURE_NAME` varchar(100) DEFAULT NULL,
  `BUSINESS_NATURE_DESCRIPTION` varchar(250) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT current_timestamp(),
  `UPDATED_AT` datetime DEFAULT current_timestamp(),
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_business_nature`
--

INSERT INTO `r_business_nature` (`BUSINESS_NATURE_ID`, `BUSINESS_NATURE_NAME`, `BUSINESS_NATURE_DESCRIPTION`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(9, 'MERCHANDISING', NULL, '2019-10-04 00:23:32', '2019-10-04 00:23:32', 1);

-- --------------------------------------------------------

--
-- Table structure for table `r_issuance_category`
--

CREATE TABLE `r_issuance_category` (
  `ISSUANCE_CATEGORY_ID` int(11) NOT NULL,
  `ISSUANCE_NAME` varchar(50) DEFAULT NULL,
  `ISSUANCE_DESCRIPTION` varchar(250) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT current_timestamp(),
  `UPDATED_AT` datetime DEFAULT current_timestamp(),
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_issuance_category`
--

INSERT INTO `r_issuance_category` (`ISSUANCE_CATEGORY_ID`, `ISSUANCE_NAME`, `ISSUANCE_DESCRIPTION`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(1, 'Application Barangay Business Permit Form', NULL, '2019-07-29 00:00:00', '2019-07-29 00:00:00', 1),
(2, 'Application Barangay Clearance Form', NULL, '2019-07-29 00:00:00', '2019-07-29 00:00:00', 1),
(3, 'Request Barangay Certification Form', NULL, '2019-07-29 00:00:00', '2019-07-29 00:00:00', 1),
(4, 'Request Certified Records', NULL, '2019-07-29 00:00:00', '2019-07-23 00:00:00', 1),
(5, 'Application Use Of Barangay Property Facilities', NULL, '2019-07-22 00:00:00', '2019-07-30 00:00:00', 1),
(6, 'Transient Registration Form', NULL, '2019-07-30 00:00:00', '2019-07-30 00:00:00', 1),
(7, 'Barangay Business Permit', NULL, '2019-07-30 00:00:00', '2019-07-17 00:00:00', 1),
(8, 'Barangay Clearance Building', NULL, '2019-07-16 00:00:00', '2019-07-11 00:00:00', 1),
(9, 'Barangay Clearance Business', NULL, '2019-07-18 00:00:00', '2019-07-10 00:00:00', 1),
(10, 'Barangay Clearance Zonal', NULL, '2019-07-12 00:00:00', '2019-07-03 00:00:00', 1),
(11, 'Barangay Clearance Tricycle', NULL, '2019-07-23 00:00:00', '2019-07-09 00:00:00', 1),
(12, 'Barangay Clearance General Purposes', NULL, '2019-08-05 18:40:21', '2019-08-05 18:40:21', 1),
(13, 'Barangay Certificate Residency', NULL, '2019-08-04 11:50:09', '2019-08-04 11:50:09', 1),
(14, 'Barangay Certificate Calamity Loan SSS-GSIS', NULL, '2019-08-04 11:50:31', '2019-08-04 11:50:31', 1),
(15, 'Barangay Certificate Calamity Loan OFW', NULL, '2019-08-04 11:50:56', '2019-08-04 11:50:56', 1),
(16, 'Barangay Certificate SPES', NULL, '2019-08-04 11:51:18', '2019-08-04 11:51:18', 1),
(17, 'Barangay Certificate Solo Parent', NULL, '2019-08-04 11:51:36', '2019-08-04 11:51:36', 1),
(18, 'Barangay Certificate Indigency', NULL, '2019-08-04 11:51:45', '2019-08-04 11:51:45', 1),
(20, 'Sample', 'Personal Sample', '2019-10-03 16:03:43', '2019-10-04 00:03:43', 1);

-- --------------------------------------------------------

--
-- Table structure for table `r_municipal_information`
--

CREATE TABLE `r_municipal_information` (
  `MUNICIPAL_ID` int(11) NOT NULL,
  `MUNICIPAL_NAME` varchar(50) NOT NULL,
  `PROVINCE_NAME` varchar(50) NOT NULL,
  `MUNICIPAL_SEAL` varchar(50) NOT NULL,
  `CREATED_AT` datetime NOT NULL DEFAULT current_timestamp(),
  `UPDATED_AT` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `r_municipal_information`
--

INSERT INTO `r_municipal_information` (`MUNICIPAL_ID`, `MUNICIPAL_NAME`, `PROVINCE_NAME`, `MUNICIPAL_SEAL`, `CREATED_AT`, `UPDATED_AT`) VALUES
(1, 'Tanay', 'Rizal', 'tanay_logo.jpg', '2019-09-26 23:08:22', '2019-09-29 06:07:05');

-- --------------------------------------------------------

--
-- Table structure for table `r_ordinance_category`
--

CREATE TABLE `r_ordinance_category` (
  `ORDINANCE_CATEGORY_ID` int(11) NOT NULL,
  `ORDINANCE_CATEGORY_NAME` varchar(100) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_ordinance_category`
--

INSERT INTO `r_ordinance_category` (`ORDINANCE_CATEGORY_ID`, `ORDINANCE_CATEGORY_NAME`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(5, 'Peace and order', '2019-10-03 16:03:08', NULL, 1),
(6, 'FARES', NULL, NULL, NULL),
(7, 'Sample', '2019-10-08 12:29:48', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `r_position`
--

CREATE TABLE `r_position` (
  `POSITION_ID` int(11) NOT NULL,
  `POSITION_NAME` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_position`
--

INSERT INTO `r_position` (`POSITION_ID`, `POSITION_NAME`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(6, 'Admin', '2019-07-30 12:15:06', NULL, 1),
(35, 'Secretary', '2019-10-03 23:45:06', NULL, 1),
(36, 'Census Officer', '2019-10-03 23:45:06', NULL, 1),
(37, 'Barangay Chairman', '2019-10-03 23:45:07', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `r_resident_type`
--

CREATE TABLE `r_resident_type` (
  `TYPE_ID` int(11) NOT NULL,
  `TYPE_NAME` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `r_resident_type`
--

INSERT INTO `r_resident_type` (`TYPE_ID`, `TYPE_NAME`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(1, 'Native Residents', '2019-08-05 04:48:04', NULL, 1),
(2, 'Migrants', '2019-08-05 04:49:10', NULL, 1),
(3, 'Transients', '2019-08-05 04:49:27', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_barangay_official`
--

CREATE TABLE `t_barangay_official` (
  `BARANGAY_OFFICIAL_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `BARANGAY_ID` int(11) DEFAULT NULL,
  `START_TERM` date DEFAULT NULL,
  `END_TERM` date DEFAULT NULL,
  `EMPLOYEE_NUMBER` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_barangay_official`
--

INSERT INTO `t_barangay_official` (`BARANGAY_OFFICIAL_ID`, `RESIDENT_ID`, `BARANGAY_ID`, `START_TERM`, `END_TERM`, `EMPLOYEE_NUMBER`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(37, 3788, 1, '2019-10-16', '2022-10-16', '27-002312', '2019-10-11 17:24:45', NULL, 1),
(39, 3786, 1, '2019-10-10', '2022-10-10', '26-2312345', '2019-10-11 19:59:17', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_barangay_certification`
--

CREATE TABLE `t_bf_barangay_certification` (
  `BARANGAY_CERTIFICATION_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `BF_MAIN_LGU_ID` int(11) DEFAULT NULL,
  `PAYMENT_DETAILS_ID` int(11) DEFAULT NULL,
  `ID_PRESENTED` varchar(50) DEFAULT NULL,
  `DATE_ISSUE` date DEFAULT NULL,
  `VALIDITY` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_barangay_clearance`
--

CREATE TABLE `t_bf_barangay_clearance` (
  `BARANGAY_CLEARANCE_ID` int(11) NOT NULL,
  `BUSINESS_ID` int(11) DEFAULT NULL,
  `BF_MAIN_LGU_ID` int(11) DEFAULT NULL,
  `PAYMENT_DETAILS_ID` int(11) DEFAULT NULL,
  `REGISTERED_NAME` varchar(150) DEFAULT NULL,
  `KIND_OF_BUSINESS` varchar(50) DEFAULT NULL,
  `CONSTRUCTION_ADDRESS` varchar(100) DEFAULT NULL,
  `SCOPE_OF_WORK_ID` int(11) DEFAULT NULL,
  `OCCUPANCY_TYPE` varchar(50) DEFAULT NULL,
  `KIND_OF_SIGNAGE` varchar(50) DEFAULT NULL,
  `SIGNAGE_WORDINGS` varchar(50) DEFAULT NULL,
  `NO_STOREYS_BUILDING` varchar(50) DEFAULT NULL,
  `START_DATE_INSTALLATION` date DEFAULT NULL,
  `END_COMPLETION` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_business_activity`
--

CREATE TABLE `t_bf_business_activity` (
  `BUSINESS_ACTIVITY_ID` int(11) NOT NULL,
  `LINE_OF_BUSINESS_ID` int(11) NOT NULL,
  `NO_OF_UNITS` varchar(50) DEFAULT NULL,
  `CAPITALIZATION` varchar(50) DEFAULT NULL,
  `GROSS_RECEIPTS_ESSENTIAL` varchar(50) DEFAULT NULL,
  `GROSS_RECEIPTS_NON_ESSENTIAL` varchar(50) DEFAULT NULL,
  `BUSINESS_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_business_permit`
--

CREATE TABLE `t_bf_business_permit` (
  `BUSINESS_PERMIT_ID` int(11) NOT NULL,
  `BUSINESS_ID` int(11) DEFAULT NULL,
  `BF_MAIN_LGU_ID` int(11) DEFAULT NULL,
  `PAYMENT_DETAILS_ID` int(11) DEFAULT NULL,
  `AMENDMENT_FROM` varchar(50) DEFAULT NULL,
  `AMENDMENT_TO` varchar(50) DEFAULT NULL,
  `IS_ENJOYING_TAZ_INCENTIVE` tinyint(4) DEFAULT NULL,
  `SPECIFY_REASON` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_certified_record`
--

CREATE TABLE `t_bf_certified_record` (
  `CERTIFIED_RECORD_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `BF_MAIN_LGU_ID` int(11) DEFAULT NULL,
  `PAYMENT_DETAILS_ID` int(11) DEFAULT NULL,
  `RECORD_TYPE_REQUEST` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_main_lgu`
--

CREATE TABLE `t_bf_main_lgu` (
  `BF_MAIN_LGU_ID` int(11) NOT NULL,
  `ORIGINAL_TRANSFER_CERTIFICATE_AGENCY` varchar(50) DEFAULT NULL,
  `ORIGINAL_TRANSFER_CERTIFICATE_FLAG` varchar(50) DEFAULT NULL,
  `TAX_DECLARATION_AGENCY` varchar(50) DEFAULT NULL,
  `TAX_DECLARATION_FLAG` varchar(50) DEFAULT NULL,
  `CONTRACT_OF_LEASE_AGENCY` varchar(50) DEFAULT NULL,
  `CONTRACT_OF_LEASE_FLAG` varchar(50) DEFAULT NULL,
  `GROSS_RECEIPT_AGENCY` varchar(50) DEFAULT NULL,
  `GROSS_RECEIPT_FLAG` varchar(50) DEFAULT NULL,
  `SET_OF_MAP_AGENCY` varchar(50) DEFAULT NULL,
  `SET_OF_MAP_FLAG` varchar(50) DEFAULT NULL,
  `BILLS_OF_MATERIALS_AGENCY` varchar(50) DEFAULT NULL,
  `BILLS_OF_MATERIALS_FLAG` varchar(50) DEFAULT NULL,
  `OCCUPANCY_PERMIT_AGENCY` varchar(50) DEFAULT NULL,
  `OCCUPANCY_PERMIT_FLAG` varchar(50) DEFAULT NULL,
  `OR_OF_TRICYCLE_AGENCY` varchar(50) DEFAULT NULL,
  `OR_OF_TRICYCLE_FLAG` varchar(50) DEFAULT NULL,
  `PAYMENT_TODA_MEMBERSHIP_AGENCY` varchar(50) DEFAULT NULL,
  `PAYMENT_TODA_MEMBERSHIP_FLAG` varchar(50) DEFAULT NULL,
  `CTC_AGENCY` varchar(50) DEFAULT NULL,
  `CTC_FLAG` varchar(50) DEFAULT NULL,
  `BP_BUSINESS_REGISTRATION_AGENCY` varchar(50) DEFAULT NULL,
  `BP_BUSINESS_REGISTRATION_FLAG` varchar(50) DEFAULT NULL,
  `BP_BUSINESS_CAPITALIZATION_AGENCY` varchar(50) DEFAULT NULL,
  `BP_BUSINESS_CAPITALIZATION_FLAG` varchar(50) DEFAULT NULL,
  `GROSS_SALES_TAX_AMOUNT` varchar(50) DEFAULT NULL,
  `GROSS_SALES_TAX_SURCHARGE` varchar(50) DEFAULT NULL,
  `TAX_OR_SIGNBOARD_AMOUNT` varchar(50) DEFAULT NULL,
  `TAX_OR_SIGNBOARD_SURCHARGE` varchar(50) DEFAULT NULL,
  `PERMIT_FEE_AMOUNT` varchar(50) DEFAULT NULL,
  `PERMIT_FEE_SURCHARGE` varchar(50) DEFAULT NULL,
  `GARBAGE_CHARGE_AMOUNT` varchar(50) DEFAULT NULL,
  `GARBAGE_CHARGE_SURCHARGE` varchar(50) DEFAULT NULL,
  `SIGNBOARD_RENEWAL_FEE_AMOUNT` varchar(50) DEFAULT NULL,
  `SIGNBOARD_RENEWAL_FEE_SURCHARGE` varchar(50) DEFAULT NULL,
  `CTC_AMOUNT` varchar(50) DEFAULT NULL,
  `CTC_SURCHARGE` varchar(50) DEFAULT NULL,
  `OTHERS_AMOUNT` varchar(50) DEFAULT NULL,
  `OTHERS_SURCHARGE` varchar(50) DEFAULT NULL,
  `BC_DOCUMENTARY_STAMPS_AMOUNT` varchar(50) DEFAULT NULL,
  `BC_DOCUMENTARY_STAMPS_SURCHARGE` varchar(50) DEFAULT NULL,
  `BUSINESS_CLUB_AMOUNT` varchar(50) DEFAULT NULL,
  `BUSINESS_CLUB_SURCHARGE` varchar(50) DEFAULT NULL,
  `CLEARANCE_FEE_AMOUNT` varchar(50) DEFAULT NULL,
  `CLEARANCE_FEE_SURCHARGE` varchar(50) DEFAULT NULL,
  `VERIFIED_BY` varchar(150) DEFAULT NULL,
  `ASSESSED_BY` varchar(150) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(255) NOT NULL,
  `TAX_CLEARANCE_AGENCY` varchar(50) DEFAULT NULL,
  `TAX_CLEARANCE_FLAG` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_payment_details`
--

CREATE TABLE `t_bf_payment_details` (
  `PAYMENT_DETAILS_ID` int(11) NOT NULL,
  `RELEASED_DATE` date DEFAULT NULL,
  `OR_NUMBER` varchar(50) DEFAULT NULL,
  `AMOUNT` varchar(50) DEFAULT NULL,
  `OR_DATE` date DEFAULT NULL,
  `PAYMENT_RECEIVED_BY` varchar(150) DEFAULT NULL,
  `PAYMENT_DATE_RECEIVED` date DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_scope_of_work`
--

CREATE TABLE `t_bf_scope_of_work` (
  `SCOPE_OF_WORK_ID` int(11) NOT NULL,
  `SCOPE_OF_WORK_NAME` varchar(50) NOT NULL,
  `SCOPE_OF_WORK_SPECIFY` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_uof_facility_equipment`
--

CREATE TABLE `t_bf_uof_facility_equipment` (
  `UOF_FACILITY_ID` int(11) NOT NULL,
  `FACILITY_ID` int(11) NOT NULL,
  `NO_OF_FACILITY` int(50) NOT NULL,
  `REMARKS` varchar(255) NOT NULL,
  `USE_OF_FACILITY_EQUIPMENT_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_use_of_facility_equipment`
--

CREATE TABLE `t_bf_use_of_facility_equipment` (
  `USE_OF_FACILITY_EQUIPMENT_ID` int(11) NOT NULL,
  `ORGANIZATION_NAME` varchar(50) DEFAULT NULL,
  `AUTHORIZED_REPRESENTATIVE` varchar(150) DEFAULT NULL,
  `REPRESENTATIVE_ADDRESS` varchar(150) DEFAULT NULL,
  `REPRESENTATIVE_CONTACT_NO` varchar(150) DEFAULT NULL,
  `REPRESENTATIVE_EMAIL` varchar(150) DEFAULT NULL,
  `PERSON_PRESENT_AT_EVENT` varchar(150) DEFAULT NULL,
  `PERSON_ADDRESS` varchar(150) DEFAULT NULL,
  `PERSON_CONTACT_NO` varchar(150) DEFAULT NULL,
  `PERSON_EMAIL` varchar(150) DEFAULT NULL,
  `ACTIVITY` varchar(150) DEFAULT NULL,
  `PURPOSE` varchar(150) DEFAULT NULL,
  `DATE_NEEDED` date DEFAULT NULL,
  `TIME_NEEDED` time DEFAULT NULL,
  `PARTICIPANTS` varchar(150) DEFAULT NULL,
  `HOURS_OF_USE` varchar(150) DEFAULT NULL,
  `HAVE_ADMISSION_FEE` tinyint(4) DEFAULT NULL,
  `VENUE` varchar(150) DEFAULT NULL,
  `IS_SECURITY_REQUIRED` tinyint(4) DEFAULT NULL,
  `NO_OF_SECURITY` int(11) DEFAULT NULL,
  `DATE_SECURITY` date DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT NULL,
  `ISSUANCE_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_blotter`
--

CREATE TABLE `t_blotter` (
  `BLOTTER_ID` int(10) UNSIGNED NOT NULL,
  `BLOTTER_SUBJECT_ID` int(11) DEFAULT NULL,
  `USER_ID` int(11) DEFAULT NULL,
  `BARANGAY_ID` int(11) DEFAULT NULL,
  `BLOTTER_CODE` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INCIDENT_DATE` date NOT NULL,
  `INCIDENT_AREA` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `COMPLAINT_NAME` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ACCUSED_RESIDENT` int(11) DEFAULT NULL,
  `COMPLAINT_STATEMENT` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RESOLUTION` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMPLAINT_DATE` date NOT NULL,
  `CLOSED_DATE` date DEFAULT NULL,
  `STATUS` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `RESPONDENT` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BLOTTER_SUBJECT` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVE_FLAG` int(11) NOT NULL DEFAULT 1,
  `CREATED_AT` timestamp NULL DEFAULT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_blotter`
--

INSERT INTO `t_blotter` (`BLOTTER_ID`, `BLOTTER_SUBJECT_ID`, `USER_ID`, `BARANGAY_ID`, `BLOTTER_CODE`, `INCIDENT_DATE`, `INCIDENT_AREA`, `COMPLAINT_NAME`, `ACCUSED_RESIDENT`, `COMPLAINT_STATEMENT`, `RESOLUTION`, `COMPLAINT_DATE`, `CLOSED_DATE`, `STATUS`, `RESPONDENT`, `BLOTTER_SUBJECT`, `ACTIVE_FLAG`, `CREATED_AT`, `UPDATED_AT`) VALUES
(12, NULL, NULL, NULL, 'BLOT-12', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'Walang solusyon', '2019-09-23', '2019-09-23', 'Pending', 'Glen', 'Missing person', 1, NULL, NULL),
(13, NULL, NULL, NULL, 'BLOT-13', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'Walang solusyon', '2019-09-23', '2019-09-23', 'Pending', 'Glen', 'Missing person', 1, NULL, NULL),
(14, NULL, NULL, NULL, 'BLOT-14', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'Walang solusyon', '2019-09-23', '2019-09-23', 'Pending', 'Glen', 'Missing person', 1, NULL, NULL),
(15, NULL, NULL, NULL, 'BLOT-15', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'Walang solusyon', '2019-09-23', '2019-09-23', 'Pending', 'Glen', 'Missing person', 1, NULL, NULL),
(16, NULL, NULL, NULL, 'BLOT-16', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'Walang solusyon', '2019-09-23', '2019-09-23', 'Pending', 'Glen', 'Missing person', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `t_business_approval`
--

CREATE TABLE `t_business_approval` (
  `APPROVAL_ID` int(11) NOT NULL,
  `BUSINESS_ID` int(11) DEFAULT NULL,
  `STATUS` varchar(50) DEFAULT NULL,
  `APPROVED_BY` varchar(255) DEFAULT NULL,
  `DATE_APPROVED` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_business_approval`
--

INSERT INTO `t_business_approval` (`APPROVAL_ID`, `BUSINESS_ID`, `STATUS`, `APPROVED_BY`, `DATE_APPROVED`) VALUES
(24, 21, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(25, 22, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(26, 23, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(27, 24, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(28, 25, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(29, 26, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(30, 27, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(31, 28, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(32, 29, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(33, 30, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(34, 31, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(35, 32, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(36, 33, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(37, 34, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(38, 35, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(39, 36, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(40, 37, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(41, 38, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(42, 39, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(43, 40, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(44, 41, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(45, 42, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(46, 43, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(47, 44, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(48, 45, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(49, 46, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(50, 47, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(51, 48, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(52, 49, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(53, 50, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(54, 51, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(55, 52, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(56, 53, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(57, 54, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(58, 55, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(59, 56, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(60, 57, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(61, 58, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00'),
(62, 59, 'EVALUATED', 'JOHN HENRY FERNANDEZ', '2019-06-03 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `t_business_information`
--

CREATE TABLE `t_business_information` (
  `BUSINESS_ID` int(11) NOT NULL,
  `BUSINESS_NAME` varchar(50) DEFAULT NULL,
  `TRADE_NAME` varchar(50) DEFAULT NULL,
  `BUSINESS_NATURE_ID` int(11) DEFAULT NULL,
  `BUSINESS_OWNER_FIRSTNAME` varchar(150) DEFAULT NULL,
  `BUSINESS_OWNER_MIDDLENAME` varchar(50) DEFAULT NULL,
  `BUSINESS_OWNER_LASTNAME` varchar(50) DEFAULT NULL,
  `BUSINESS_ADDRESS` varchar(255) DEFAULT NULL,
  `BUSINESS_OR_NUMBER` varchar(50) DEFAULT NULL,
  `BUSINESS_OR_ACQUIRED_DATE` date DEFAULT NULL,
  `BARANGAY_ZONE_ID` int(11) DEFAULT NULL,
  `TIN_NO` varchar(50) DEFAULT NULL,
  `DTI_REGISTRATION_NO` varchar(50) DEFAULT NULL,
  `TYPE_OF_BUSINESS` varchar(50) DEFAULT NULL,
  `BUSINESS_POSTAL_CODE` varchar(50) DEFAULT NULL,
  `BUSINESS_EMAIL_ADD` varchar(100) DEFAULT NULL,
  `BUSINESS_TELEPHONE_NO` varchar(50) DEFAULT NULL,
  `BUSINESS_MOBILE_NO` varchar(50) DEFAULT NULL,
  `OWNER_ADDRESS` varchar(150) DEFAULT NULL,
  `OWNER_POSTAL_CODE` varchar(50) DEFAULT NULL,
  `OWNER_EMAIL_ADD` varchar(100) DEFAULT NULL,
  `OWNER_TELEPHONE_NO` varchar(50) DEFAULT NULL,
  `OWNER_MOBILE_NO` varchar(50) DEFAULT NULL,
  `EMERGENCY_CONTACT_PERSON` varchar(150) DEFAULT NULL,
  `EMERGENCY_PERSON_CONTACT_NO` varchar(50) DEFAULT NULL,
  `EMERGENCY_PERSON_EMAIL_ADD` varchar(50) DEFAULT NULL,
  `BUSINESS_AREA` varchar(50) DEFAULT NULL,
  `NO_EMPLOYEE_ESTABLISHMENT` int(11) DEFAULT NULL,
  `NO_EMPLOYEE_LGU` int(11) DEFAULT NULL,
  `LESSOR_NAME` varchar(150) DEFAULT NULL,
  `LESSOR_ADDRESS` varchar(150) DEFAULT NULL,
  `LESSOR_CONTACT_NO` varchar(50) DEFAULT NULL,
  `LESSOR_EMAIL_ADD` varchar(100) DEFAULT NULL,
  `MONTHLY_RENTAL` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL,
  `STATUS` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_business_information`
--

INSERT INTO `t_business_information` (`BUSINESS_ID`, `BUSINESS_NAME`, `TRADE_NAME`, `BUSINESS_NATURE_ID`, `BUSINESS_OWNER_FIRSTNAME`, `BUSINESS_OWNER_MIDDLENAME`, `BUSINESS_OWNER_LASTNAME`, `BUSINESS_ADDRESS`, `BUSINESS_OR_NUMBER`, `BUSINESS_OR_ACQUIRED_DATE`, `BARANGAY_ZONE_ID`, `TIN_NO`, `DTI_REGISTRATION_NO`, `TYPE_OF_BUSINESS`, `BUSINESS_POSTAL_CODE`, `BUSINESS_EMAIL_ADD`, `BUSINESS_TELEPHONE_NO`, `BUSINESS_MOBILE_NO`, `OWNER_ADDRESS`, `OWNER_POSTAL_CODE`, `OWNER_EMAIL_ADD`, `OWNER_TELEPHONE_NO`, `OWNER_MOBILE_NO`, `EMERGENCY_CONTACT_PERSON`, `EMERGENCY_PERSON_CONTACT_NO`, `EMERGENCY_PERSON_EMAIL_ADD`, `BUSINESS_AREA`, `NO_EMPLOYEE_ESTABLISHMENT`, `NO_EMPLOYEE_LGU`, `LESSOR_NAME`, `LESSOR_ADDRESS`, `LESSOR_CONTACT_NO`, `LESSOR_EMAIL_ADD`, `MONTHLY_RENTAL`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `STATUS`) VALUES
(21, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(22, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(23, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(24, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(25, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(26, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(27, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(28, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(29, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(30, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(31, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(32, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(33, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(34, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(35, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(36, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(37, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(38, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(39, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(40, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(41, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(42, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(43, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(44, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(45, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(46, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(47, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(48, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(49, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(50, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(51, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(52, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(53, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(54, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(55, 'LEA SARI SARI STORE', 'LECEL', 9, 'LEA', 'CERVANTES', 'ZENAROSA', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320142', '2019-04-04', 6, '235413', NULL, 'DTI 00849744', 'MERCHANDISING', '3023', 'LEA@GMAIL.COM', '8700', '9187791260', 'NORTH FAIRVIEW, QUEZON CITY', '3023', 'LEA@GMAIL.COM', '87000', '9187791260', 'EDCEL', 'EDCEL@GMAIL.COM', 'MRB AREA', 2, 2, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(56, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(57, 'Edcel Store', 'Ed Store', NULL, 'EDCEL', 'ZEN', 'RENDEV', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320143', '2019-04-04', 6, '231423242', NULL, 'DTI 00849745', 'SERVICE BUSINESS', '3023', 'EDCEL@GMAIL.COM', '8200', '9101344206', 'NORTH FAIRVIEW, QUEZON CITY', '3024', 'EDCEL@GMAIL.COM', '87200', '9101344206', 'RODEL', 'RODEL@GMAIL.COM', 'MRB AREA', 3, 5, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(58, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved'),
(59, 'Rodel Store', 'Rod Store', NULL, 'RODEL', 'VELGA', 'MUHAMAD', 'NORTH FAIRVIEW, QUEZON CITY', 'OR320144', '2019-04-04', 6, '2344352', NULL, 'DTI 00849746', 'SERVICE BUSINESS', '3023', 'RODEL@GMAIL.COM', '8300', '9386945894', 'NORTH FAIRVIEW, QUEZON CITY', '3025', 'RODEL@GMAIL.COM', '87002', '9386945894', 'SHIEL', 'SHIEL@GMAIL.COM', 'MRB AREA', 2, 3, 'RODEL DUTERTE', 'WEST FAIRVIEW, QUEZON CITY', '925182312', 'RODEL@GMAIL.COM', '2500', NULL, NULL, 1, 'Approved');

-- --------------------------------------------------------

--
-- Table structure for table `t_children_profile`
--

CREATE TABLE `t_children_profile` (
  `CHILDREN_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `BIRTH_ORDER` int(11) DEFAULT NULL,
  `IS_REGISTERED` int(11) DEFAULT NULL,
  `BORN_AT` varchar(50) DEFAULT NULL,
  `CHILDER_MOTHER_TONGUE` varchar(25) DEFAULT NULL,
  `CHILDREN_OTHER_DIALECT` varchar(50) DEFAULT NULL,
  `CHILDREN_HEIGHT` decimal(10,0) DEFAULT NULL,
  `CHILDREN_WEIGHT` decimal(10,0) DEFAULT NULL,
  `DOES_IT_HAVE_ECCD_CARD` varchar(11) DEFAULT NULL,
  `DOES_IT_HAVE_MOTHER_CHILD_BOOK` varchar(11) DEFAULT NULL,
  `DOES_IT_HAVE_OTHERS` varchar(50) DEFAULT NULL,
  `VACCINATION_BCG` varchar(10) DEFAULT NULL,
  `VACCINATION_DPT` varchar(11) DEFAULT NULL,
  `VACCINATION_ORAL_POLIO` varchar(11) DEFAULT NULL,
  `VACCINATION_HEPA_B` varchar(11) DEFAULT NULL,
  `VACCINATION_MEASLES` varchar(11) DEFAULT NULL,
  `VACCINATION_OTHERS` varchar(50) DEFAULT NULL,
  `DEFORMITY_HARE_LIP` int(11) DEFAULT NULL,
  `DEFORMITY_DISABLE_LEG` int(11) DEFAULT NULL,
  `DEFORMITY_CROSS_EYED` int(11) DEFAULT NULL,
  `DEFORMITY_DISABLE_ARM_LEG` int(11) DEFAULT NULL,
  `DEFORMITY_FINGER_TOES` int(11) DEFAULT NULL,
  `DEFORMITY_DEAF` int(11) DEFAULT NULL,
  `DEFORMITY_BLIND` int(11) DEFAULT NULL,
  `PROBLEMS_WITH_BEHAVIOR` int(11) DEFAULT NULL,
  `PROBLEMS_WITH_SPEAKING` int(11) DEFAULT NULL,
  `PROBLEMS_WITH_HEARING` int(11) DEFAULT NULL,
  `PROBLEMS_WITH_VISION` int(11) DEFAULT NULL,
  `IS_LEFT_HANDED` int(11) DEFAULT NULL,
  `CHILDHOOD_EXP_NURSERY` int(11) DEFAULT NULL,
  `CHILDHOOD_EXP_KINDERGARTEN` int(11) DEFAULT NULL,
  `CHILDHOOD_EXP_PREPARATORY` int(11) DEFAULT NULL,
  `LEARNS_AT_HOME_W_PARENTS` int(11) DEFAULT NULL,
  `LEARNS_AT_HOME_W_NOBODY` int(11) DEFAULT NULL,
  `LEARNS_AT_HOME_W_SIBLINGS` int(11) DEFAULT NULL,
  `LEARNS_AT_HOME_W_RELATIVES` int(11) DEFAULT NULL,
  `LEARNS_AT_HOME_W_MAID` int(11) DEFAULT NULL,
  `LEARNS_AT_HOME_TUTOR` int(11) DEFAULT NULL,
  `LEARNS_AT_HOME_W_OTHERS` varchar(50) DEFAULT NULL,
  `INTERACTS_W_OLDER_SIBLINGS` int(11) DEFAULT NULL,
  `INTERACTS_W_YOUNGER_SIBLINGS` int(11) DEFAULT NULL,
  `INTERACTS_W_SAME_AGE` int(11) DEFAULT NULL,
  `EATS_MEAL_BEFORE_SCHOOL` varchar(50) DEFAULT NULL,
  `HAS_BAON` varchar(50) DEFAULT NULL,
  `FOOD_NORMALLY_EATEN` varchar(50) DEFAULT NULL,
  `TRAVEL_TIME_TO_DCC` varchar(25) DEFAULT NULL,
  `MODE_TRANSPORTATION_TO_DCC` varchar(25) DEFAULT NULL,
  `TRAVEL_TIME_TO_NCDC` varchar(25) DEFAULT NULL,
  `MODE_TRANSPORTATION_TO_NCDC` varchar(25) DEFAULT NULL,
  `PUBLIC_TRANSPORTATION_ID` varchar(50) DEFAULT NULL,
  `TRANSPORTATION_FARE` varchar(50) DEFAULT NULL,
  `GOES_TO_SCHOOL_WITH` varchar(25) DEFAULT NULL,
  `CHILD_DEVELOPMENT_TEACHER` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_family_header`
--

CREATE TABLE `t_family_header` (
  `FAMILY_HEADER_ID` int(11) NOT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `t_family_information`
--

CREATE TABLE `t_family_information` (
  `FAMILY_INFORMATION_ID` int(11) NOT NULL,
  `FAMILY_HEADER_ID` int(11) DEFAULT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `t_fathers_profile`
--

CREATE TABLE `t_fathers_profile` (
  `FATHERS_ID` int(11) NOT NULL,
  `FATHER_MOTHER_TONGUE` varchar(25) DEFAULT NULL,
  `FATHER_OTHER_DIALECTS` varchar(50) DEFAULT NULL,
  `FATHER_EDUCATIONAL_ATTAINMENT` varchar(50) DEFAULT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_food_eaten`
--

CREATE TABLE `t_food_eaten` (
  `FOOD_EATEN_ID` int(11) NOT NULL,
  `CHILDREN_ID` int(11) DEFAULT NULL,
  `VEGETABLE` int(11) DEFAULT NULL,
  `RICE` int(11) DEFAULT NULL,
  `CEREAL` int(11) DEFAULT NULL,
  `PORK` int(11) DEFAULT NULL,
  `NOODLE` int(11) DEFAULT NULL,
  `FRUIT_JUICE` int(11) DEFAULT NULL,
  `CHICKEN` int(11) DEFAULT NULL,
  `SOUP` int(11) DEFAULT NULL,
  `MILK` int(11) DEFAULT NULL,
  `BEEF` int(11) DEFAULT NULL,
  `BREAD` int(11) DEFAULT NULL,
  `FISH` int(11) DEFAULT NULL,
  `FRUIT` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_household_information`
--

CREATE TABLE `t_household_information` (
  `HOUSEHOLD_ID` int(11) NOT NULL,
  `HOME_OWNERSHIP` varchar(50) DEFAULT NULL,
  `PERSON_STAYING_IN_HOUSEHOLD` varchar(50) DEFAULT NULL,
  `HOME_MATERIALS` varchar(10) DEFAULT NULL,
  `STREET_ADDRESS` varchar(50) DEFAULT NULL,
  `BARANGAY_ZONE_ADDRESS` varchar(150) DEFAULT NULL,
  `BARANGAY_ID` int(11) DEFAULT NULL,
  `NUMBER_OF_ROOMS` int(11) DEFAULT NULL,
  `TOILET_HOME` int(11) DEFAULT NULL,
  `PLAY_AREA_HOME` int(11) DEFAULT NULL,
  `BEDROOM_HOME` int(11) DEFAULT NULL,
  `DINING_ROOM_HOME` int(11) DEFAULT NULL,
  `SALA_HOME` int(11) DEFAULT NULL,
  `KITCHEN_HOME` int(11) DEFAULT NULL,
  `WATER_UTILITIES` int(11) DEFAULT NULL,
  `ELECTRICITY_UTILITIES` int(11) DEFAULT NULL,
  `AIRCON_UTILITIES` int(11) DEFAULT NULL,
  `PHONE_UTILITIES` int(11) DEFAULT NULL,
  `COMPUTER_UTILITIES` int(11) DEFAULT NULL,
  `INTERNET_UTILITIES` int(11) DEFAULT NULL,
  `TV_UTILITIES` int(11) DEFAULT NULL,
  `CD_PLAYER_UTILITIES` int(11) DEFAULT NULL,
  `RADIO_UTILITIES` int(11) DEFAULT NULL,
  `COMICS_ENTERTAINMENT` int(11) DEFAULT NULL,
  `NEWS_PAPER_ENTERTAINMENT` int(11) DEFAULT NULL,
  `PETS_ENTERTAINMENT` int(11) DEFAULT NULL,
  `BOOKS_ENTERTAINMENT` int(11) DEFAULT NULL,
  `STORY_BOOKS_ENTERTAINMENT` int(11) DEFAULT NULL,
  `TOYS_ENTERTAINMENT` int(11) DEFAULT NULL,
  `BOARD_GAMES_ENTERTAINMENT` int(11) DEFAULT NULL,
  `PUZZLES_ENTERTAINMENT` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_household_information`
--

INSERT INTO `t_household_information` (`HOUSEHOLD_ID`, `HOME_OWNERSHIP`, `PERSON_STAYING_IN_HOUSEHOLD`, `HOME_MATERIALS`, `STREET_ADDRESS`, `BARANGAY_ZONE_ADDRESS`, `BARANGAY_ID`, `NUMBER_OF_ROOMS`, `TOILET_HOME`, `PLAY_AREA_HOME`, `BEDROOM_HOME`, `DINING_ROOM_HOME`, `SALA_HOME`, `KITCHEN_HOME`, `WATER_UTILITIES`, `ELECTRICITY_UTILITIES`, `AIRCON_UTILITIES`, `PHONE_UTILITIES`, `COMPUTER_UTILITIES`, `INTERNET_UTILITIES`, `TV_UTILITIES`, `CD_PLAYER_UTILITIES`, `RADIO_UTILITIES`, `COMICS_ENTERTAINMENT`, `NEWS_PAPER_ENTERTAINMENT`, `PETS_ENTERTAINMENT`, `BOOKS_ENTERTAINMENT`, `STORY_BOOKS_ENTERTAINMENT`, `TOYS_ENTERTAINMENT`, `BOARD_GAMES_ENTERTAINMENT`, `PUZZLES_ENTERTAINMENT`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(1207, 'Owned', 'Parents', 'Concrete', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:22', NULL, NULL),
(1208, 'Retired', 'Relatives', 'Concrete', NULL, NULL, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:22', NULL, NULL),
(1209, 'With Parents', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, '2019-10-10 21:15:22', NULL, NULL),
(1210, 'With Relatives', 'Parents', 'Concrete', NULL, NULL, 1, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, '2019-10-10 21:15:22', NULL, NULL),
(1211, 'Owned', 'Relatives', 'Nipa', NULL, NULL, 1, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, '2019-10-10 21:15:23', NULL, NULL),
(1212, 'Retired', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1213, 'With Parents', 'Parents', 'Concrete', NULL, NULL, 1, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, '2019-10-10 21:15:23', NULL, NULL),
(1214, 'With Relatives', 'Relatives', 'Concrete', NULL, NULL, 1, 7, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1215, 'Owned', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1216, 'Retired', 'Parents', 'Wood', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, '2019-10-10 21:15:23', NULL, NULL),
(1217, 'With Parents', 'Relatives', 'Concrete', NULL, NULL, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1218, 'With Relatives', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 5, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1219, 'Owned', 'Parents', 'Concrete', NULL, NULL, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1220, 'Retired', 'Relatives', 'Nipa', NULL, NULL, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1221, 'With Parents', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1222, 'With Relatives', 'Parents', 'Concrete', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, '2019-10-10 21:15:23', NULL, NULL),
(1223, 'Owned', 'Relatives', 'Concrete', NULL, NULL, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1224, 'Retired', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1225, 'With Parents', 'Parents', 'Concrete', NULL, NULL, 1, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, '2019-10-10 21:15:23', NULL, NULL),
(1226, 'With Relatives', 'Relatives', 'Wood', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1227, 'Owned', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, '2019-10-10 21:15:24', NULL, NULL),
(1228, 'Retired', 'Parents', 'Concrete', NULL, NULL, 1, 5, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1229, 'With Parents', 'Relatives', 'Concrete', NULL, NULL, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, '2019-10-10 21:15:24', NULL, NULL),
(1230, 'With Relatives', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1231, 'Owned', 'Parents', 'Concrete', NULL, NULL, 1, 6, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1232, 'Retired', 'Relatives', 'Nipa', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '2019-10-10 21:15:24', NULL, NULL),
(1233, 'With Parents', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 9, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1234, 'With Relatives', 'Parents', 'Concrete', NULL, NULL, 1, 8, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1235, 'Owned', 'Relatives', 'Wood', NULL, NULL, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1236, 'Retired', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 6, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1237, 'With Parents', 'Parents', 'Concrete', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, '2019-10-10 21:15:24', NULL, NULL),
(1238, 'With Relatives', 'Relatives', 'Concrete', NULL, NULL, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1239, 'Owned', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 9, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1240, 'Retired', 'Parents', 'Nipa', NULL, NULL, 1, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, '2019-10-10 21:15:24', NULL, NULL),
(1241, 'With Parents', 'Relatives', 'Concrete', NULL, NULL, 1, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, '2019-10-10 21:15:24', NULL, NULL),
(1242, 'With Relatives', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, '2019-10-10 21:15:25', NULL, NULL),
(1243, 'Owned', 'Parents', 'Wood', NULL, NULL, 1, 7, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1244, 'Retired', 'Relatives', 'Concrete', NULL, NULL, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1245, 'With Parents', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1246, 'With Relatives', 'Parents', 'Concrete', NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, '2019-10-10 21:15:25', NULL, NULL),
(1247, 'Owned', 'Relatives', 'Concrete', NULL, NULL, 1, 4, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, '2019-10-10 21:15:25', NULL, NULL),
(1248, 'Retired', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1249, 'With Parents', 'Parents', 'Wood', NULL, NULL, 1, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1250, 'With Relatives', 'Relatives', 'Concrete', NULL, NULL, 1, 6, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, '2019-10-10 21:15:25', NULL, NULL),
(1251, 'Owned', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, '2019-10-10 21:15:25', NULL, NULL),
(1252, 'Retired', 'Parents', 'Concrete', NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1253, 'With Parents', 'Relatives', 'Concrete', NULL, NULL, 1, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1254, 'With Relatives', 'Non-Relatives', 'Concrete', NULL, NULL, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1255, 'With Parents', 'Relatives', 'Concrete', NULL, NULL, 1, 7, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, '2019-10-10 21:15:25', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_adolescent`
--

CREATE TABLE `t_hs_adolescent` (
  `ADOLESCENT_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `MMRTD_DATE` date DEFAULT NULL,
  `IS_REFERRED` int(11) DEFAULT NULL,
  `DATE_OF_VISIT` date DEFAULT NULL,
  `REMARKS` varchar(50) DEFAULT NULL,
  `CS_DIABETIC` int(11) DEFAULT NULL,
  `CS_MATAAS_PRESYON` int(11) DEFAULT NULL,
  `CS_CANCER` int(11) DEFAULT NULL,
  `CS_BUKOL` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_child`
--

CREATE TABLE `t_hs_child` (
  `CHILD_ID` int(11) NOT NULL,
  `TYPE_OF_HOME_RECORD` varchar(100) DEFAULT NULL,
  `DANGERS_OBSERVED` varchar(25) DEFAULT NULL,
  `SOURCE_OF_SERVICE_RESERVED` varchar(100) DEFAULT NULL,
  `HAD_DEWORMING` int(11) DEFAULT NULL,
  `HAD_MMR_12_15_MO` int(11) DEFAULT NULL,
  `HAD_VITAMIN_A_12_59_MO` int(11) DEFAULT NULL,
  `OPT_DATE` date DEFAULT NULL,
  `OPT_WEIGHT` varchar(25) DEFAULT NULL,
  `OPT_HEIGHT` varchar(25) DEFAULT NULL,
  `GP_APRIL_DEWORMING` int(11) DEFAULT NULL,
  `GP_OCTOBER_DEWORMING` int(11) DEFAULT NULL,
  `DO_A` int(11) DEFAULT 0,
  `DO_B` int(11) DEFAULT 0,
  `DO_C` int(11) DEFAULT 0,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `INFANT_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_hs_child`
--

INSERT INTO `t_hs_child` (`CHILD_ID`, `TYPE_OF_HOME_RECORD`, `DANGERS_OBSERVED`, `SOURCE_OF_SERVICE_RESERVED`, `HAD_DEWORMING`, `HAD_MMR_12_15_MO`, `HAD_VITAMIN_A_12_59_MO`, `OPT_DATE`, `OPT_WEIGHT`, `OPT_HEIGHT`, `GP_APRIL_DEWORMING`, `GP_OCTOBER_DEWORMING`, `DO_A`, `DO_B`, `DO_C`, `RESIDENT_ID`, `INFANT_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 3117, NULL, '2019-10-04 00:07:49', NULL, 1),
(19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 3730, NULL, '2019-10-07 18:01:25', NULL, 1),
(20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 3731, NULL, '2019-10-10 15:27:30', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_chronic_cough`
--

CREATE TABLE `t_hs_chronic_cough` (
  `CHRONIC_COUGH_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `HAD_MORE_THAN_2_WEEKS` int(11) DEFAULT NULL,
  `DATE_OF_VISIT` datetime DEFAULT NULL,
  `REMARKS` varchar(500) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL,
  `NONRESIDENT_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_chronic_disease`
--

CREATE TABLE `t_hs_chronic_disease` (
  `CHRONIC_DISEASE_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `CHRONIC_DISEASE_NAME` varchar(100) DEFAULT NULL,
  `HAD_HIGH_FEVER` int(11) DEFAULT NULL,
  `DATE_OF_VISIT` datetime DEFAULT NULL,
  `REMARKS` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_elderly`
--

CREATE TABLE `t_hs_elderly` (
  `ELDERLY_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(10) DEFAULT NULL,
  `HAD_FLUE_VACCINE` int(11) DEFAULT 0,
  `HAD_PNEUMOCCOCAL` int(11) DEFAULT 0,
  `REMARKS` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATED_AT` datetime NOT NULL DEFAULT current_timestamp(),
  `UPDATED_AT` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_family_planning`
--

CREATE TABLE `t_hs_family_planning` (
  `FD_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `FP_METHOD` varchar(50) DEFAULT NULL,
  `FP_SOURCE` varchar(100) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_family_planning_users_visitations`
--

CREATE TABLE `t_hs_family_planning_users_visitations` (
  `VISITATION_ID` int(11) NOT NULL,
  `FP_ID` int(11) DEFAULT NULL,
  `VISITATION_DATE` date DEFAULT NULL,
  `VISITATION_REMARKS` varchar(255) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_infant`
--

CREATE TABLE `t_hs_infant` (
  `INFANT_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `NEW_BORN_ID` int(11) DEFAULT NULL,
  `TYPE_OF_HOME_RECORD` varchar(50) DEFAULT NULL,
  `OPT_DATE` date DEFAULT NULL,
  `OPT_WEIGHT` decimal(10,0) DEFAULT NULL,
  `OPT_HEIGHT` decimal(10,0) DEFAULT NULL,
  `GP_APRIL_VIT_A` int(11) DEFAULT NULL,
  `GP_OCTOBER_VIT_A` int(11) DEFAULT NULL,
  `DANGERS_OBSERVED` varchar(300) DEFAULT NULL,
  `SOURCE_OF_SERVICE_RECEIVED` varchar(100) DEFAULT NULL,
  `HAD_BREASTFEED` int(11) DEFAULT NULL,
  `HAD_PENTA_1` int(11) DEFAULT NULL,
  `HAD_PENTA_2` int(11) DEFAULT NULL,
  `HAD_PENTA_3` int(11) DEFAULT NULL,
  `HAD_OPV_1` int(11) DEFAULT NULL,
  `HAD_OPV_2` int(11) DEFAULT NULL,
  `HAD_OPV_3` int(11) DEFAULT NULL,
  `HAD_ROTA_1` int(11) DEFAULT NULL,
  `HAD_ROTA_2` int(11) DEFAULT NULL,
  `HAD_MEASLES` int(11) DEFAULT NULL,
  `HAD_VITAMIN_A` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL,
  `DO_A` tinyint(4) DEFAULT 0,
  `DO_B` tinyint(4) DEFAULT 0,
  `DO_C` tinyint(4) DEFAULT 0,
  `DO_D` tinyint(4) DEFAULT 0,
  `DO_E` tinyint(4) DEFAULT 0,
  `DO_F` tinyint(4) DEFAULT 0,
  `DO_G` tinyint(4) DEFAULT 0,
  `DO_H` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_newborn`
--

CREATE TABLE `t_hs_newborn` (
  `NEWBORN_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `TYPE_OF_HOME_RECORD` varchar(100) DEFAULT NULL,
  `BIRTH_WEIGHT` varchar(25) DEFAULT NULL,
  `BIRTH_LENGTH` varchar(25) DEFAULT NULL,
  `HAD_BCG` int(11) DEFAULT NULL,
  `HAD_HEPA_B` int(11) DEFAULT NULL,
  `HAD_NEWBORN_SCREENING` int(11) DEFAULT NULL,
  `HAD_BREASTFEED` int(11) DEFAULT NULL,
  `DANGERS_OBSERVED` varchar(25) DEFAULT NULL,
  `DO_A` tinyint(4) DEFAULT 0,
  `DO_B` tinyint(4) DEFAULT 0,
  `DO_C` tinyint(4) DEFAULT 0,
  `DO_D` tinyint(4) DEFAULT 0,
  `DO_E` tinyint(4) DEFAULT 0,
  `DO_F` tinyint(4) DEFAULT 0,
  `SOURCE_OF_SERVICE_RESERVED` varchar(100) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT 1,
  `NONRESIDENT_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_non_family_planning_users`
--

CREATE TABLE `t_hs_non_family_planning_users` (
  `NON_FP_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `IS_INTERESTED_IN_FP` int(11) DEFAULT NULL,
  `REASONS_NOT_USING` varchar(100) DEFAULT NULL,
  `DATE_OF_VISIT` date DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_post_partum`
--

CREATE TABLE `t_hs_post_partum` (
  `POST_PATRUM_ID` int(11) NOT NULL,
  `PREGNANT_ID` int(11) DEFAULT NULL,
  `BIRTH_PLACE` varchar(50) DEFAULT NULL,
  `BIRTH_COORDINATOR` varchar(50) DEFAULT NULL,
  `DANGERS_OBSERVED` varchar(50) DEFAULT NULL,
  `IS_FP_USER` int(11) DEFAULT NULL,
  `INTERESTED_IN_FP` int(11) DEFAULT NULL,
  `SOURCE_OF_SERVICE_RECEIVED` varchar(100) DEFAULT NULL,
  `BIRH_DATE` date DEFAULT NULL,
  `HAD_BREASTFEED_1_HR` int(11) DEFAULT NULL,
  `HAD_POSTNATAL_24_HRS` int(11) DEFAULT NULL,
  `HAD_POSTNATAL_72_HRS` int(11) DEFAULT NULL,
  `HAD_POSTNATAL_7_DAYS` int(11) DEFAULT NULL,
  `DO_A` int(11) DEFAULT NULL,
  `DO_B` int(11) DEFAULT NULL,
  `DO_C` int(11) DEFAULT NULL,
  `DO_D` int(11) DEFAULT NULL,
  `FERROUS_SULFATE` tinyint(255) DEFAULT NULL,
  `VITAMIN_A` varchar(255) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_pregnant`
--

CREATE TABLE `t_hs_pregnant` (
  `PREGNANT_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `NONRESIDENT_ID` int(11) DEFAULT NULL,
  `TYPE_OF_HOME_RECORD` varchar(100) DEFAULT NULL,
  `NUMBER_OF_MONTHS_PREGNANT` int(11) DEFAULT NULL,
  `HAD_BIRTH_PLAN` int(11) DEFAULT NULL,
  `BLOOD_TYPE` varchar(5) DEFAULT NULL,
  `DANGERS_OBSERVED` varchar(25) DEFAULT NULL,
  `DUE_DATE` date DEFAULT NULL,
  `PREGNANCY_CONCLUSION` varchar(100) DEFAULT NULL,
  `HAD_FERRO_SULFATE_FOLIC_ACID` int(11) DEFAULT NULL,
  `HAD_TETANOUS_TOXOID_1` int(11) DEFAULT NULL,
  `HAD_TETANOUS_TOXOID_2` int(11) DEFAULT NULL,
  `HAD_TETANOUS_TOXOID_3` int(11) DEFAULT NULL,
  `HAD_TETANOUS_TOXOID_4` int(11) DEFAULT NULL,
  `HAD_TETANOUS_TOXOID_5` int(11) DEFAULT NULL,
  `PRENATAL_CHECKUP_1TRI` int(11) DEFAULT NULL,
  `PRENATAL_CHECKUP_2TRI` int(11) DEFAULT NULL,
  `PRENATAL_CHECKUP_3TRI` int(11) DEFAULT NULL,
  `DO_A` tinyint(4) DEFAULT 0,
  `DO_B` tinyint(4) DEFAULT 0,
  `DO_C` tinyint(4) DEFAULT 0,
  `DO_D` tinyint(4) DEFAULT 0,
  `DO_E` tinyint(4) DEFAULT 0,
  `DO_F` tinyint(4) DEFAULT 0,
  `DO_G` tinyint(4) DEFAULT 0,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_pwd`
--

CREATE TABLE `t_hs_pwd` (
  `PWD_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `DISABILITY` varchar(100) DEFAULT NULL,
  `DATE_OF_DEATH` date DEFAULT NULL,
  `REASON_OF_DEATH` varchar(100) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_issuance`
--

CREATE TABLE `t_issuance` (
  `ISSUANCE_ID` int(11) NOT NULL,
  `ISSUANCE_TYPE_ID` int(11) DEFAULT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `BUSINESS_ID` int(11) DEFAULT NULL,
  `ISSUANCE_PURPOSE` varchar(100) DEFAULT NULL,
  `ISSUANCE_DATE` date DEFAULT NULL,
  `ISSUANCE_NUMBER` varchar(50) DEFAULT NULL,
  `TIME_RECEIVED` datetime DEFAULT NULL,
  `RECEIVED_BY` varchar(255) DEFAULT NULL,
  `STATUS` varchar(50) DEFAULT NULL,
  `REMARKS` varchar(150) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT current_timestamp(),
  `UPDATED_AT` datetime DEFAULT current_timestamp(),
  `ACTIVE_FLAG` int(11) DEFAULT NULL,
  `OR_NUMBER` varchar(50) DEFAULT NULL,
  `OR_AMOUNT` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_issuance`
--

INSERT INTO `t_issuance` (`ISSUANCE_ID`, `ISSUANCE_TYPE_ID`, `RESIDENT_ID`, `BUSINESS_ID`, `ISSUANCE_PURPOSE`, `ISSUANCE_DATE`, `ISSUANCE_NUMBER`, `TIME_RECEIVED`, `RECEIVED_BY`, `STATUS`, `REMARKS`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `OR_NUMBER`, `OR_AMOUNT`) VALUES
(56, 13, 3156, NULL, 'pirpose', '2019-10-03', '2019104001', NULL, 'Rodel Bautista Duterte', 'Issued', 'pirpose', '2019-10-04 02:12:40', '2019-10-04 02:12:40', NULL, '0001', '400'),
(57, 16, 3462, NULL, NULL, '2019-10-08', '20191080057', NULL, 'Rodel Bautista Duterte', 'Issued', 'For Special Program for the Employment of Students', '2019-10-08 19:44:21', '2019-10-08 19:44:21', NULL, '543', '4532'),
(58, 16, 3462, NULL, NULL, '2019-10-10', '201910100058', NULL, 'RODEL B DUTERTE', 'Issued', 'For Special Program for the Employment of Students', '2019-10-10 17:48:21', '2019-10-10 17:48:21', NULL, '0112', '2e');

-- --------------------------------------------------------

--
-- Table structure for table `t_mothers_profile`
--

CREATE TABLE `t_mothers_profile` (
  `MOTHERS_ID` int(11) NOT NULL,
  `IS_PREGNANT` int(11) DEFAULT NULL,
  `MOTHER_MOTHER_TONGUE` varchar(25) DEFAULT NULL,
  `MOTHER_OTHER_DIALECTS` varchar(50) DEFAULT NULL,
  `MOTHER_EDUCATIONAL_ATTAINMENT` varchar(50) DEFAULT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_nonresident_basic_info`
--

CREATE TABLE `t_nonresident_basic_info` (
  `NONRESIDENT_ID` int(11) NOT NULL,
  `FIRST_NAME` varchar(100) DEFAULT NULL,
  `MIDDLE_NAME` varchar(50) DEFAULT NULL,
  `LAST_NAME` varchar(50) DEFAULT NULL,
  `SEX` varchar(20) DEFAULT NULL,
  `BIRTHDATE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_ordinance`
--

CREATE TABLE `t_ordinance` (
  `ORDINANCE_ID` int(11) NOT NULL,
  `BARANGAY_OFFICIAL_ID` int(11) DEFAULT NULL,
  `ORDINANCE_TITLE` varchar(50) DEFAULT NULL,
  `ORDINANCE_CATEGORY_ID` int(11) DEFAULT NULL,
  `ORDINANCE_DESCRIPTION` varchar(100) DEFAULT NULL,
  `ORDINANCE_REMARKS` varchar(50) DEFAULT NULL,
  `ORDINANCE_SANCTION` varchar(50) DEFAULT NULL,
  `ORDINANCE_AUTHOR` varchar(50) DEFAULT NULL,
  `FILE_NAME` varchar(50) NOT NULL DEFAULT 'NONE',
  `CREATED_AT` datetime DEFAULT current_timestamp(),
  `UPDATED_AT` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `ACTIVE_FLAG` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_ordinance`
--

INSERT INTO `t_ordinance` (`ORDINANCE_ID`, `BARANGAY_OFFICIAL_ID`, `ORDINANCE_TITLE`, `ORDINANCE_CATEGORY_ID`, `ORDINANCE_DESCRIPTION`, `ORDINANCE_REMARKS`, `ORDINANCE_SANCTION`, `ORDINANCE_AUTHOR`, `FILE_NAME`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(7, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 02:11:00', NULL, 1),
(8, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:17:51', NULL, 1),
(9, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:18:57', NULL, 1),
(10, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:18:57', NULL, 1),
(11, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:46:37', NULL, 1),
(12, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:47:36', NULL, 1),
(13, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:47:38', NULL, 1),
(14, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 14:28:45', NULL, 1),
(15, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 14:28:45', NULL, 1),
(16, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 14:29:34', NULL, 1),
(17, NULL, 'SAMPLE ORDINACEN', 6, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 14:29:34', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_patawag`
--

CREATE TABLE `t_patawag` (
  `PATAWAG_ID` int(10) UNSIGNED NOT NULL,
  `BLOTTER_ID` int(10) UNSIGNED NOT NULL,
  `PATAWAG_SCHED_DATETIME` datetime NOT NULL,
  `PATAWAG_SCHED_PLACE` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STATUS` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `ACTIVE_FLAG` int(11) NOT NULL DEFAULT 1,
  `CREATED_AT` timestamp NULL DEFAULT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_resident_basic_info`
--

CREATE TABLE `t_resident_basic_info` (
  `RESIDENT_ID` int(11) NOT NULL,
  `HOUSEHOLD_ID` int(11) DEFAULT NULL,
  `LASTNAME` varchar(50) DEFAULT NULL,
  `MIDDLENAME` varchar(50) DEFAULT NULL,
  `FIRSTNAME` varchar(50) DEFAULT NULL,
  `ADDRESS_UNIT_NO` varchar(50) DEFAULT NULL,
  `ADDRESS_PHASE` varchar(50) DEFAULT NULL,
  `ADDRESS_BLOCK_NO` varchar(50) DEFAULT NULL,
  `ADDRESS_HOUSE_NO` varchar(50) DEFAULT NULL,
  `ADDRESS_STREET_NO` varchar(50) DEFAULT NULL,
  `ADDRESS_STREET` varchar(50) DEFAULT NULL,
  `ADDRESS_SUBDIVISION` varchar(50) DEFAULT NULL,
  `ADDRESS_BUILDING` varchar(50) DEFAULT NULL,
  `QUALIFIER` varchar(25) DEFAULT NULL,
  `DATE_OF_BIRTH` date DEFAULT NULL,
  `PLACE_OF_BIRTH` varchar(50) DEFAULT NULL,
  `SEX` varchar(50) DEFAULT NULL,
  `CIVIL_STATUS` varchar(25) DEFAULT NULL,
  `IS_OFW` int(11) DEFAULT NULL,
  `OCCUPATION` varchar(50) DEFAULT NULL,
  `WORK_STATUS` varchar(25) DEFAULT NULL,
  `DATE_STARTED_WORKING` date DEFAULT NULL,
  `CITIZENSHIP` varchar(25) DEFAULT NULL,
  `RELATION_TO_HOUSEHOLD_HEAD` varchar(50) DEFAULT NULL,
  `DATE_OF_ARRIVAL` date DEFAULT NULL,
  `ARRIVAL_STATUS` int(11) DEFAULT NULL,
  `IS_INDIGENOUS` int(11) DEFAULT NULL,
  `CONTACT_NUMBER` varchar(25) DEFAULT NULL,
  `TIN_NO` varchar(50) DEFAULT NULL,
  `SSS_NO` varchar(255) DEFAULT NULL,
  `GSIS_NO` int(11) DEFAULT NULL,
  `EMAIL_ADDRESS` varchar(255) DEFAULT NULL,
  `IS_REGISTERED_VOTER` int(11) DEFAULT NULL,
  `EDUCATIONAL_ATTAINMENT` varchar(255) DEFAULT NULL,
  `PERSONS STAYING IN THE HOUSHOLD` varchar(255) DEFAULT NULL,
  `FROM_WHAT_COUNTRY` varchar(255) DEFAULT NULL,
  `PLACE_OF_DELIVERY` varchar(255) DEFAULT NULL,
  `BIRTH_ATTENDANT` varchar(255) DEFAULT NULL,
  `FAMILY_VISITED` varchar(255) DEFAULT NULL,
  `REASONFOR_VISIT` varchar(255) DEFAULT NULL,
  `DISABILITY` varchar(255) DEFAULT NULL,
  `PLACE_OF_SCHOOL` varchar(255) DEFAULT NULL,
  `RELIGION` varchar(255) DEFAULT NULL,
  `LOT_OWNERSHIP` varchar(255) DEFAULT NULL,
  `TYPE_OF_DOCUMENT` varchar(255) DEFAULT NULL,
  `ISSUED_DATE` date DEFAULT NULL,
  `WHERE_DOCUMENT_ISSUED` varchar(255) CHARACTER SET latin7 DEFAULT NULL,
  `SKILLS_DEVELOPMENT_TRAINING` varchar(255) DEFAULT NULL,
  `IS_RBI_COMPLETE` int(11) DEFAULT 0,
  `IS_MIC_COMPLETE` int(11) DEFAULT 0,
  `PROFILE_PICTURE` varchar(255) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT current_timestamp(),
  `UPDATED_AT` datetime DEFAULT current_timestamp(),
  `ACTIVE_FLAG` int(11) UNSIGNED DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_resident_basic_info`
--

INSERT INTO `t_resident_basic_info` (`RESIDENT_ID`, `HOUSEHOLD_ID`, `LASTNAME`, `MIDDLENAME`, `FIRSTNAME`, `ADDRESS_UNIT_NO`, `ADDRESS_PHASE`, `ADDRESS_BLOCK_NO`, `ADDRESS_HOUSE_NO`, `ADDRESS_STREET_NO`, `ADDRESS_STREET`, `ADDRESS_SUBDIVISION`, `ADDRESS_BUILDING`, `QUALIFIER`, `DATE_OF_BIRTH`, `PLACE_OF_BIRTH`, `SEX`, `CIVIL_STATUS`, `IS_OFW`, `OCCUPATION`, `WORK_STATUS`, `DATE_STARTED_WORKING`, `CITIZENSHIP`, `RELATION_TO_HOUSEHOLD_HEAD`, `DATE_OF_ARRIVAL`, `ARRIVAL_STATUS`, `IS_INDIGENOUS`, `CONTACT_NUMBER`, `TIN_NO`, `SSS_NO`, `GSIS_NO`, `EMAIL_ADDRESS`, `IS_REGISTERED_VOTER`, `EDUCATIONAL_ATTAINMENT`, `PERSONS STAYING IN THE HOUSHOLD`, `FROM_WHAT_COUNTRY`, `PLACE_OF_DELIVERY`, `BIRTH_ATTENDANT`, `FAMILY_VISITED`, `REASONFOR_VISIT`, `DISABILITY`, `PLACE_OF_SCHOOL`, `RELIGION`, `LOT_OWNERSHIP`, `TYPE_OF_DOCUMENT`, `ISSUED_DATE`, `WHERE_DOCUMENT_ISSUED`, `SKILLS_DEVELOPMENT_TRAINING`, `IS_RBI_COMPLETE`, `IS_MIC_COMPLETE`, `PROFILE_PICTURE`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(3785, 1207, 'DUTERTE', 'BAUTISTA', 'RODEL', '146', 'Phase 1', NULL, '146', NULL, 'Oriole Street', NULL, NULL, 'JR', '2019-01-01', 'Tondo Manila', 'Male', 'Single', 1, 'None', 'Not Applicable', '1970-01-01', 'Filipino', 'Parents', '2019-01-01', 2, 1, '9187781278', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:22', '2019-10-10 21:15:22', 1),
(3786, 1208, 'CERVANTES', 'GONZALES', 'LEA MAE', '68', 'Phase 2', NULL, '68', NULL, 'Aspen Street', NULL, NULL, '', '1999-01-11', 'Polangui Albay', 'Female', 'Single', 0, 'Software Engineer', 'Employed', '2019-07-09', 'Filipino', 'Parents', '2003-02-07', 2, 1, '9091232879', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:22', '2019-10-10 21:15:22', 1),
(3787, 1209, 'ZENAROSA', '', 'JOHN EDCEL', '12', 'Phase 7', NULL, '12', NULL, 'Gaya Gaya Street', NULL, NULL, 'JR', '1999-04-27', 'Quezon City', 'Male', 'Single', 0, 'Programmer', 'Employed', '2018-04-27', 'Filipino', 'Parents', '2000-03-09', 2, 1, '9127348732', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:22', '2019-10-10 21:15:22', 1),
(3788, 1210, 'CABATANA', 'OZCAN', 'REDIYN', '30', 'Phase 8', NULL, '30', NULL, 'Astor Street', NULL, NULL, '', '1980-07-07', 'Quezon City', 'Female', 'Single', 0, 'Graphic Artist', 'Employed', '2001-02-03', 'Filipino', 'Parents', '1998-09-04', 2, 1, '9438924982', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3789, 1211, 'ESPIRIDION', 'DELOS SANTOS', 'RELYN', '20', 'Phase 8', NULL, '20', NULL, 'Astor Street', NULL, NULL, '', '1980-03-03', 'Quezon City', 'Female', 'Single', 0, 'Programmer', 'Employed', '2004-09-03', 'Filipino', 'Parents', '1999-02-08', 2, 1, '9324722219', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3790, 1212, 'FERNANDEZ', 'UY', 'JOHN HENRY', '17', 'Phase 4', NULL, '17', NULL, 'Yen Street', NULL, NULL, '', '2018-02-09', 'Quezon City', 'Male', 'Single', 0, NULL, 'Unemployed', '1970-01-01', 'Filipino', 'Parents', '2001-09-09', 2, 1, '9187791200', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3791, 1213, 'TELESFORO', 'TIU', 'RENNA JANE', '39', 'Phase 1', NULL, '39', NULL, 'Baht Street', NULL, NULL, '', '1980-02-02', 'Quezon City', 'Female', 'Married', 0, 'Data Engineer', 'Employed', '2000-03-03', 'Filipino', 'Parents', '2004-03-02', 2, 0, '9294798123', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3792, 1214, 'RAMOS', 'SANCHEZ', 'JEAN ANN', '19', 'Phase 1', NULL, '19', NULL, 'Baht Street', NULL, NULL, '', '1990-08-08', 'Quezon City', 'Female', 'Single', 0, 'Database Administrator', 'Employed', '2010-04-09', 'Filipino', 'Parents', '1999-09-03', 2, 1, '9284319801', NULL, NULL, NULL, NULL, 0, 'High School', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3793, 1215, 'DELA CRUZ', 'SANTOS', 'JOSHUA MARIE', '12', 'Phase 1', NULL, '12', NULL, 'Baht Street', NULL, NULL, '', '1989-08-09', 'Quezon City', 'Female', 'Single', 1, 'Data Analyst', 'Employed', '2011-03-02', 'Filipino', 'Sibling', '2007-08-09', 2, 1, '9287349029', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3794, 1216, 'GADEN', 'ARCEGA', 'JOHN', '28', 'Phase 1', NULL, '28', NULL, 'Peso Street', NULL, NULL, '', '1980-07-03', 'Quezon City', 'Male', 'Single', 0, 'Software Engineer', 'Employed', '2002-04-07', 'Filipino', 'Parents', '2008-02-01', 2, 1, '9189903312', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3795, 1217, 'CERVANTES', 'GONZALES', 'SARAH JANE', '27', 'Phase 2', NULL, '27', NULL, 'Peso Street', NULL, NULL, '', '1990-09-09', 'Quezon City', 'Female', 'Widowed', 0, 'Doctor', 'Employed', '2001-03-02', 'Filipino', 'Parents', '2001-04-04', 2, 1, '9170932417', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3796, 1218, 'CERVANTES', 'GONZALES', 'MARIA', '32', 'Phase 2', NULL, '32', NULL, 'Peso Street', NULL, NULL, '', '2019-04-02', 'Quezon City', 'Female', 'Single', 0, NULL, 'Not Applicable', '1970-01-01', 'Filipino', 'Parents', '1997-02-01', 2, 1, '9213083438', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3797, 1219, 'YACAP', 'BUSANTE', 'JOHN NORRY', '34', 'Phase 3', NULL, '34', NULL, 'Pound Street', NULL, NULL, '', '1987-03-09', 'Quezon City', 'Male', 'Single', 0, 'Chef', 'Employed', '2007-09-09', 'Filipino', 'Sibling', '1999-03-02', 2, 1, '9241098327', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3798, 1220, 'ABUDA', 'CERVANTES', 'JAIRAH', '43', 'Phase 7', NULL, '43', NULL, 'Namapa Street', NULL, NULL, '', '1980-04-08', 'Quezon City', 'Female', 'Single', 0, 'Teacher', 'Employed', '2003-03-04', 'Filipino', 'Parents', '2010-04-04', 2, 0, '9380821839', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3799, 1221, 'TALAGTAG', 'GONZALES', 'RANDY', '70', 'Phase 8', NULL, '70', NULL, 'Astor Street', NULL, NULL, '', '1980-09-02', 'Quezon City', 'Male', 'Single', 0, 'Programmer', 'Employed', '2001-02-08', 'Filipino', 'Parents', '2008-04-02', 2, 1, '9132732922', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3800, 1222, 'ABUDA', 'CERVANTES', 'JOSALYN', '47', 'Phase 7', NULL, '47', NULL, 'Namapa Street', NULL, NULL, '', '1980-04-02', 'Tondo Manila', 'Female', 'Single', 1, 'Doctor', 'Employed', '2002-09-03', 'Filipino', 'Parents', '2018-03-02', 2, 1, '9213987273', NULL, NULL, NULL, NULL, 0, 'High School', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3801, 1223, 'CERVANTES', 'GONZALES', 'ELA', '70', 'Phase 2', NULL, '70', NULL, 'Aspen Street', NULL, NULL, '', '1981-08-01', 'Quezon City', 'Female', 'Married', 0, 'Software Engineer', 'Employed', '2003-07-08', 'Filipino', 'Parents', '2014-04-09', 2, 1, '9322329272', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3802, 1224, 'OZCAN', 'CERVANTES', 'ELLIE LAURAINE', '73', 'Phase 2', NULL, '73', NULL, 'Aspen Street', NULL, NULL, '', '1982-03-09', 'Polangui Albay', 'Female', 'Single', 0, 'Document Analyst', 'Employed', '2001-09-07', 'Filipino', 'Parents', '2000-03-02', 2, 1, '9993243432', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:23', '2019-10-10 21:15:23', 1),
(3803, 1225, 'CERVANTES', 'BALANG', 'MARTIN', '69', 'Phase 2', NULL, '69', NULL, 'Ames Street', NULL, NULL, 'JR', '2019-09-09', 'Polangui Albay', 'Male', 'Single', 0, NULL, 'Not Applicable', '1970-01-01', 'Filipino', 'Cousin', '1999-09-02', 2, 1, '9242247232', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3804, 1226, 'CARDINAS', 'GUMABAO', 'HAZELLE ANNE', '21', 'Phase 4', NULL, '21', NULL, 'Yen Street', NULL, NULL, '', '1981-04-02', 'Quezon City', 'Female', 'Single', 0, 'Teacher', 'Employed', '2004-04-09', 'Filipino', 'Parents', '2009-02-08', 2, 1, '9342143094', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3805, 1227, 'LUPAZ', 'REYS', 'KAISHA', '24', 'Phase 4', NULL, '24', NULL, 'Yen Street', NULL, NULL, '', '1987-08-09', 'Quezon City', 'Female', 'Single', 0, 'Document Analyst', 'Employed', '2008-08-07', 'Filipino', 'Parents', '2010-03-03', 2, 1, '9123223209', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3806, 1228, 'MACAPANS', 'LAZO', 'CHRISTINE', '74', 'Phase 9', NULL, '74', NULL, 'Gomez Street', NULL, NULL, '', '1987-07-03', 'Tondo Manila', 'Female', 'Single', 0, NULL, 'Unemployed', '1970-01-01', 'Filipino', 'Parents', '2002-02-01', 2, 1, '9389029328', NULL, NULL, NULL, NULL, 0, 'High School', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3807, 1229, 'FLORES', 'TAN', 'HANNAH', '16', 'Phase 2', NULL, '16', NULL, 'Narra Street', NULL, NULL, '', '1982-07-09', 'Quezon City', 'Female', 'Married', 0, 'Data Scientist', 'Employed', '2004-02-07', 'Filipino', 'Parents', '2002-09-07', 2, 1, '9114432324', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3808, 1230, 'RUBIO', 'GONZALES', 'DENNIS', '99', 'Phase 3', NULL, '99', NULL, 'Jaena Street', NULL, NULL, '', '1981-04-04', 'Tondo Manila', 'Male', 'Single', 1, 'Nurse', 'Employed', '2003-09-09', 'Filipino', 'Sibling', '2001-08-08', 2, 1, '9224348434', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3809, 1231, 'PINCA', 'CERVANTES', 'REYSHA', '33', 'Phase 4', NULL, '33', NULL, 'Alden Street', NULL, NULL, '', '1981-03-02', 'Quezon City', 'Female', 'Single', 0, 'Chef', 'Employed', '2003-02-09', 'Filipino', 'Parents', '1999-04-02', 2, 1, '9994334273', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3810, 1232, 'GOMEZ', 'REYES', 'LUIS', '27', 'Phase 1', NULL, '27', NULL, 'Ilang Ilang Street', NULL, NULL, '', '1987-07-09', 'Quezon City', 'Male', 'Single', 0, 'Teacher', 'Employed', '2009-07-07', 'Filipino', 'Parents', '2000-07-09', 2, 1, '9322318323', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3811, 1233, 'MIRAFLOR', 'PEREZ', 'WARREN', '71', 'Phase 3', NULL, '71', NULL, 'Sampaguita Street', NULL, NULL, '', '1999-01-09', 'Quezon City', 'Male', 'Single', 0, NULL, 'Unemployed', '1970-01-01', 'Filipino', 'Parents', '2009-03-02', 2, 1, '9442342318', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3812, 1234, 'PINCA', 'CERVANTES', 'RENOAH DAE', '3', 'Phase 4', NULL, '3', NULL, 'Alden Street', NULL, NULL, '', '1989-09-03', 'Quezon City', 'Female', 'Widowed', 0, 'Doctor', 'Employed', '2007-09-07', 'Filipino', 'Parents', '2007-07-02', 2, 1, '9213243982', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3813, 1235, 'MENDOZA', 'LAO', 'PAUL VINCENT', '32', 'Phase 2', NULL, '32', NULL, 'Rizal Street', NULL, NULL, '', '1989-03-09', 'Quezon City', 'Male', 'Single', 0, 'Programmer', 'Employed', '2010-08-07', 'Filipino', 'Parents', '2000-03-03', 2, 1, '9724342397', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3814, 1236, 'SIGUAN', 'VICTORIA', 'MANUELLE', '74', 'Phase 9', NULL, '74', NULL, 'Gomez Street', NULL, NULL, '', '1989-07-07', 'Quezon City', 'Female', 'Single', 0, 'Software Engineer', 'Employed', '2010-03-03', 'Filipino', 'Parents', '1998-09-09', 2, 0, '9231428742', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3815, 1237, 'SANOY', 'QUINTO', 'MICAH', '70', 'Phase 9', NULL, '70', NULL, 'Gomez Street', NULL, NULL, '', '1981-02-13', 'Quezon City', 'Female', 'Single', 1, 'Nurse', 'Employed', '2003-04-02', 'Filipino', 'Parents', '2008-02-07', 2, 1, '9324343797', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3816, 1238, 'LOPEZ', 'TEODORO', 'MATEO', '39', 'Phase 3', NULL, '39', NULL, 'Lapu Lapu Street', NULL, NULL, '', '1987-03-28', 'Tondo Manila', 'Male', 'Single', 0, 'Document Analyst', 'Employed', '2009-07-08', 'Filipino', 'Parents', '2011-03-09', 2, 1, '9214334944', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3817, 1239, 'REYES', 'CRUZ', 'PAULO', '10', 'Phase 2', NULL, '10', NULL, 'Narra Street', NULL, NULL, '', '1982-04-21', 'Quezon City', 'Male', 'Single', 0, 'Teacher', 'Employed', '2003-04-03', 'Filipino', 'Parents', '2001-09-08', 2, 1, '9327443473', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3818, 1240, 'CRUZ', 'TAN', 'CHARLENE', '7', 'Phase 4', NULL, '7', NULL, 'Alden Street', NULL, NULL, '', '1981-02-19', 'Quezon City', 'Female', 'Single', 0, 'Lawyer', 'Employed', '2002-02-09', 'Filipino', 'Sibling', '1998-09-02', 2, 1, '9243423244', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:24', '2019-10-10 21:15:24', 1),
(3819, 1241, 'ALOBOG', 'RUBIO', 'VINCE', '72', 'Phase 9', NULL, '72', NULL, 'Gomez Street', NULL, NULL, '', '1980-01-19', 'Quezon City', 'Male', 'Single', 0, 'Teacher', 'Employed', '2001-03-09', 'Filipino', 'Parents', '2000-03-09', 2, 1, '9723202213', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3820, 1242, 'LAPORE', 'LAPUZ', 'ROLANDO', '29', 'Phase 2', NULL, '29', NULL, 'Peso Street', NULL, NULL, '', '1989-08-07', 'Quezon City', 'Male', 'Single', 0, 'Teacher', 'Employed', '2007-01-04', 'Filipino', 'Parents', '2009-04-04', 2, 1, '9193442021', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3821, 1243, 'DAQUIZ', 'LAZARO', 'RACHEL ANNE', '11', 'Phase 4', NULL, '11', NULL, 'Alden Street', NULL, NULL, '', '1981-04-27', 'Quezon City', 'Female', 'Single', 0, 'Software Engineer', 'Employed', '2003-04-09', 'Filipino', 'Parents', '2004-02-10', 2, 1, '9923242397', NULL, NULL, NULL, NULL, 0, 'High School', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3822, 1244, 'CASIMIRO', 'TIU', 'JERALD', '89', 'Phase 1', NULL, '89', NULL, 'Baht Street', NULL, NULL, '', '1987-07-21', 'Quezon City', 'Male', 'Single', 0, 'Programmer', 'Employed', '2009-03-03', 'Filipino', 'Parents', '2011-03-09', 2, 1, '9220129923', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3823, 1245, 'VALDEZ', 'DELA CRUZ', 'ALYSSA', '22', 'Phase 4', NULL, '22', NULL, 'Avon Street', NULL, NULL, '', '1987-04-19', 'Quezon City', 'Female', 'Single', 0, 'Data Engineer', 'Employed', '2009-09-04', 'Filipino', 'Parents', '2000-04-10', 2, 1, '9992434389', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3824, 1246, 'GUMABAO', 'CHUA', 'MICHELLE', '27', 'Phase 4', NULL, '27', NULL, 'Avon Street', NULL, NULL, '', '1989-03-17', 'Quezon City', 'Female', 'Single', 0, 'Nurse', 'Employed', '2010-02-01', 'Filipino', 'Parents', '2012-02-01', 2, 1, '9231982724', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3825, 1247, 'LAURE', 'TOMAS', 'EYA', '23', 'Phase 4', NULL, '23', NULL, 'Avon Street', NULL, NULL, '', '1980-01-12', 'Polangui Albay', 'Female', 'Widowed', 0, NULL, 'Unemployed', '1970-01-01', 'Filipino', 'Parents', '2007-09-02', 2, 1, '9217478989', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3826, 1248, 'GALANG', 'TIU', 'VICTONARA', '13', 'Phase 4', NULL, '13', NULL, 'Alden Street', NULL, NULL, '', '1987-02-24', 'Quezon City', 'Female', 'Single', 0, 'Data Analyst', 'Employed', '2008-02-08', 'Filipino', 'Parents', '2001-08-07', 2, 0, '9987243291', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3827, 1249, 'PANALIGAN', 'ROSALES', 'JERICO', '30', 'Phase 4', NULL, '30', NULL, 'Alden Street', NULL, NULL, '', '1981-03-19', 'Quezon City', 'Male', 'Single', 0, 'Business Administrator', 'Employed', '2003-09-02', 'Filipino', 'Parents', '2011-09-09', 2, 1, '9983234112', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3828, 1250, 'DY', 'TAN', 'KIM', '18', 'Phase 2', NULL, '18', NULL, 'Peso Street', NULL, NULL, '', '1987-03-17', 'Quezon City', 'Female', 'Single', 0, 'Data Scientist', 'Employed', '2008-08-07', 'Filipino', 'Cousin', '2004-02-01', 2, 1, '9134373234', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3829, 1251, 'BARON', 'CORTEZ', 'MAJOY', '9', 'Phase 2', NULL, '9', NULL, 'Peso Street', NULL, NULL, '', '1989-03-23', 'Quezon City', 'Female', 'Single', 0, 'Business Administrator', 'Employed', '2007-07-02', 'Filipino', 'Parents', '1999-04-01', 2, 1, '9281239193', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3830, 1252, 'HALCON', 'OSCAR', 'NHADLEY', '40', 'Phase 7', NULL, '40', NULL, 'Namapa Street', NULL, NULL, '', '1989-04-12', 'Quezon City', 'Male', 'Single', 0, 'Software Engineer', 'Employed', '2007-03-07', 'Filipino', 'Parents', '2013-03-08', 2, 1, '9279172329', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3831, 1253, 'MAU', 'SANTOS', 'KALEI', '30', 'Phase 1', NULL, '30', NULL, 'Ilang Ilang Street', NULL, NULL, '', '1987-03-29', 'Quezon City', 'Female', 'Single', 0, 'Programmer', 'Employed', '2008-09-08', 'Filipino', 'Parents', '2010-02-09', 2, 1, '9323823129', NULL, NULL, NULL, NULL, 0, 'High School', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3832, 1254, 'MACANDILI', 'TIAMZON', 'DAWN', '27', 'Phase 1', NULL, '27', NULL, 'Ilang Ilang Street', NULL, NULL, '', '1981-02-12', 'Tondo Manila', 'Female', 'Single', 0, 'Lawyer', 'Employed', '2003-02-09', 'Filipino', 'Parents', '2003-03-09', 2, 1, '9390219823', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3833, 1255, 'TIAMZON', 'HO', 'CHRISTINE', '27', 'Phase 1', NULL, '27', NULL, 'Ilang Ilang Street', NULL, NULL, '', '1981-07-19', 'Quezon City', 'Female', 'Married', 0, 'Teacher', 'Employed', '2003-09-09', 'Filipino', 'Parents', '2011-09-02', 2, 1, '9123084290', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3834, 1255, 'RAMOS', '', 'JEAN', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02', 'Commonwealth', 'Female', 'Married', 1, 'None', 'None', '1970-01-01', 'Filipino', 'Spouse', '2019-04-03', NULL, NULL, NULL, NULL, NULL, NULL, '43590', 0, 'Elementary School', NULL, 'Canada', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3835, 1255, 'VELGA', 'A', 'SHIELA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02', 'Commonwealth', 'Female', 'Married', 1, 'None', 'None', '1970-01-01', 'Filipino', 'Spouse', '2019-04-03', NULL, NULL, NULL, NULL, NULL, NULL, '43590', 0, 'Elementary School', NULL, 'Canada', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_transient_record`
--

CREATE TABLE `t_transient_record` (
  `TRANSIENT_RECORD_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `CITIZENSHIP_ACQUISITION` varchar(50) DEFAULT NULL,
  `NATURALIZED_DATE` date DEFAULT NULL,
  `CERTIFICATE_NO` varchar(50) DEFAULT NULL,
  `PERIOD_OF_STAY_START_DATE` date DEFAULT NULL,
  `PERIOD_OF_STAY_END_DATE` date DEFAULT NULL,
  `REASON_FOR_COMING` varchar(255) DEFAULT NULL,
  `CREATED_AT` date DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `t_users`
--

CREATE TABLE `t_users` (
  `USER_ID` int(11) NOT NULL,
  `BARANGAY_ID` int(11) DEFAULT NULL,
  `BARANGAY_OFFICIAL_ID` int(11) DEFAULT NULL,
  `POSITION_ID` int(11) DEFAULT NULL,
  `FIRSTNAME` varchar(25) DEFAULT NULL,
  `MIDDLENAME` varchar(25) DEFAULT NULL,
  `LASTNAME` varchar(25) DEFAULT NULL,
  `USERNAME` varchar(100) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `EMAIL_VERIFIED_AT` date DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  `SECRET_QUESTION` varchar(100) DEFAULT NULL,
  `SECRET_ANSWER` varchar(100) DEFAULT NULL,
  `PERMIS_RESIDENT_BASIC_INFO` int(11) DEFAULT NULL,
  `PERMIS_FAMILY_PROFILE` int(11) DEFAULT NULL,
  `PERMIS_COMMUNITY_PROFILE` int(11) DEFAULT NULL,
  `PERMIS_BARANGAY_OFFICIAL` int(11) DEFAULT NULL,
  `PERMIS_BUSINESSES` int(11) DEFAULT NULL,
  `PERMIS_ISSUANCE_OF_FORMS` int(11) DEFAULT NULL,
  `PERMIS_ORDINANCES` int(11) DEFAULT NULL,
  `PERMIS_BLOTTER` int(11) DEFAULT NULL,
  `PERMIS_PATAWAG` int(11) DEFAULT NULL,
  `PERMIS_SYSTEM_REPORT` int(11) DEFAULT NULL,
  `PERMIS_HEALTH_SERVICES` int(11) DEFAULT NULL,
  `PERMIS_DATA_MIGRATION` int(11) DEFAULT NULL,
  `PERMIS_USER_ACCOUNTS` int(11) DEFAULT NULL,
  `PERMIS_BARANGAY_CONFIG` int(11) DEFAULT NULL,
  `REMEMBER_TOKEN` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL,
  `PERMIS_BUSINESS_APPROVAL` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_users`
--

INSERT INTO `t_users` (`USER_ID`, `BARANGAY_ID`, `BARANGAY_OFFICIAL_ID`, `POSITION_ID`, `FIRSTNAME`, `MIDDLENAME`, `LASTNAME`, `USERNAME`, `EMAIL`, `EMAIL_VERIFIED_AT`, `PASSWORD`, `SECRET_QUESTION`, `SECRET_ANSWER`, `PERMIS_RESIDENT_BASIC_INFO`, `PERMIS_FAMILY_PROFILE`, `PERMIS_COMMUNITY_PROFILE`, `PERMIS_BARANGAY_OFFICIAL`, `PERMIS_BUSINESSES`, `PERMIS_ISSUANCE_OF_FORMS`, `PERMIS_ORDINANCES`, `PERMIS_BLOTTER`, `PERMIS_PATAWAG`, `PERMIS_SYSTEM_REPORT`, `PERMIS_HEALTH_SERVICES`, `PERMIS_DATA_MIGRATION`, `PERMIS_USER_ACCOUNTS`, `PERMIS_BARANGAY_CONFIG`, `REMEMBER_TOKEN`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `PERMIS_BUSINESS_APPROVAL`) VALUES
(31, 1, NULL, 6, 'Duterte', 'B', 'Rodel', 'admin', 'rodlduterteb@gmail.com', NULL, '$2y$10$QMvLhsa2Ch6ZE9OFvD13uOcYNLr3D4oiZVtkEcNxlcFyUpqeRoEza', 'null', 'nulllang', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '2019-08-02 17:18:40', NULL, 1, 0),
(57, NULL, 37, 36, NULL, NULL, NULL, 'REDIYN.CABATANA', 'rdoel@gmail.com', NULL, '$2y$10$Gp5rI.Hsdy56qTpUNC.WdOeSwrshrVA7CCOy2P8sInVikf6XB2i9C', NULL, NULL, 1, 1, NULL, NULL, 1, 1, 1, 1, 1, 1, 1, NULL, NULL, NULL, NULL, '2019-10-11 17:24:45', NULL, 1, NULL),
(59, NULL, 39, 37, NULL, NULL, NULL, 'LEAMAE.CERVANTES', 'leah@gmail.com', NULL, '$2y$10$NIsIa4si2W9rETbBiV9WvOXH0AlzqsOLpv0EqbZ0Qb0Tn.qb3Llgu', NULL, NULL, 1, 1, NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2019-10-11 19:59:18', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_adminaccount`
-- (See below for the actual view)
--
CREATE TABLE `v_adminaccount` (
`USER_ID` int(11)
,`BARANGAY_ID` int(11)
,`FULL_NAME` varchar(76)
,`POSITION_NAME` varchar(50)
,`USERNAME` varchar(100)
,`PASSWORD` varchar(100)
,`EMAIL` varchar(50)
,`BARANGAY_NAME` varchar(255)
,`BARANGAY_SEAL` varchar(150)
,`ACTIVE_FLAG` int(11)
,`MUNICIPAL_SEAL` varchar(50)
,`MUNICIPAL_NAME` varchar(50)
,`PROVINCE_NAME` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_dpoaccount`
-- (See below for the actual view)
--
CREATE TABLE `v_dpoaccount` (
`USER_ID` int(11)
,`BARANGAY_ID` int(11)
,`DPO_Name` varchar(76)
,`POSITION_NAME` varchar(50)
,`USERNAME` varchar(100)
,`PASSWORD` varchar(100)
,`EMAIL` varchar(50)
,`BARANGAY_NAME` varchar(255)
,`BARANGAY_SEAL` varchar(150)
,`ACTIVE_FLAG` int(11)
,`PERMIS_BARANGAY_CONFIG` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_generatectrno`
-- (See below for the actual view)
--
CREATE TABLE `v_generatectrno` (
`CTR_NO` varchar(8)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_realbarangayofficialsaccount`
-- (See below for the actual view)
--
CREATE TABLE `v_realbarangayofficialsaccount` (
`BARANGAY_OFFICIAL_ID` int(11)
,`BARANGAY_ID` int(11)
,`USER_ID` int(11)
,`FULLNAME` varchar(152)
,`USERNAME` varchar(100)
,`PASSWORD` varchar(100)
,`BARANGAY_NAME` varchar(255)
,`POSITION_NAME` varchar(50)
,`EMAIL` varchar(50)
,`START_TERM` date
,`END_TERM` date
,`PERMIS_RESIDENT_BASIC_INFO` int(11)
,`PERMIS_FAMILY_PROFILE` int(11)
,`PERMIS_COMMUNITY_PROFILE` int(11)
,`PERMIS_BLOTTER` int(11)
,`PERMIS_PATAWAG` int(11)
,`PERMIS_BARANGAY_OFFICIAL` int(11)
,`PERMIS_BUSINESSES` int(11)
,`PERMIS_ISSUANCE_OF_FORMS` int(11)
,`PERMIS_ORDINANCES` int(11)
,`PERMIS_SYSTEM_REPORT` int(11)
,`PERMIS_HEALTH_SERVICES` int(11)
,`PERMIS_DATA_MIGRATION` int(11)
,`PERMIS_USER_ACCOUNTS` int(11)
,`PERMIS_BARANGAY_CONFIG` int(11)
,`PERMIS_BUSINESS_APPROVAL` int(11)
,`ACTIVE_FLAG` int(11)
,`BARANGAY_SEAL` varchar(150)
,`MUNICIPAL_SEAL` varchar(50)
,`MUNICIPAL_NAME` varchar(50)
,`PROVINCE_NAME` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_useraccount`
-- (See below for the actual view)
--
CREATE TABLE `v_useraccount` (
`POSITION_NAME` varchar(50)
,`BARANGAY_NAME` varchar(255)
,`FIRSTNAME` varchar(25)
,`MIDDLENAME` varchar(25)
,`LASTNAME` varchar(25)
,`USERNAME` varchar(100)
,`PASSWORD` varchar(100)
,`EMAIL` varchar(50)
,`ACTIVE_FLAG` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_useraccounts`
-- (See below for the actual view)
--
CREATE TABLE `v_useraccounts` (
`BARANGAY_OFFICIAL_ID` int(11)
,`POSITION_NAME` varchar(50)
,`BARANGAY_NAME` varchar(255)
,`LASTNAME` varchar(25)
,`FIRSTNAME` varchar(25)
,`MIDDLENAME` varchar(25)
,`USERNAME` varchar(100)
,`PASSWORD` varchar(100)
,`ACTIVE_FLAG` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `v_adminaccount`
--
DROP TABLE IF EXISTS `v_adminaccount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_adminaccount`  AS  select `u`.`USER_ID` AS `USER_ID`,`bs`.`BARANGAY_ID` AS `BARANGAY_ID`,concat(`u`.`FIRSTNAME`,' ',`u`.`MIDDLENAME`,`u`.`LASTNAME`) AS `FULL_NAME`,`p`.`POSITION_NAME` AS `POSITION_NAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`u`.`EMAIL` AS `EMAIL`,`bs`.`BARANGAY_NAME` AS `BARANGAY_NAME`,`bs`.`BARANGAY_SEAL` AS `BARANGAY_SEAL`,`bs`.`ACTIVE_FLAG` AS `ACTIVE_FLAG`,`mi`.`MUNICIPAL_SEAL` AS `MUNICIPAL_SEAL`,`mi`.`MUNICIPAL_NAME` AS `MUNICIPAL_NAME`,`mi`.`PROVINCE_NAME` AS `PROVINCE_NAME` from (((`t_users` `u` join `r_barangay_information` `bs` on(`u`.`BARANGAY_ID` = `bs`.`BARANGAY_ID`)) join `r_position` `p` on(`p`.`POSITION_ID` = `u`.`POSITION_ID`)) join `r_municipal_information` `mi` on(`mi`.`MUNICIPAL_ID` = `bs`.`MUNICIPAL_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_dpoaccount`
--
DROP TABLE IF EXISTS `v_dpoaccount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_dpoaccount`  AS  select `u`.`USER_ID` AS `USER_ID`,`bs`.`BARANGAY_ID` AS `BARANGAY_ID`,concat(`u`.`FIRSTNAME`,' ',`u`.`MIDDLENAME`,`u`.`LASTNAME`) AS `DPO_Name`,`p`.`POSITION_NAME` AS `POSITION_NAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`u`.`EMAIL` AS `EMAIL`,`bs`.`BARANGAY_NAME` AS `BARANGAY_NAME`,`bs`.`BARANGAY_SEAL` AS `BARANGAY_SEAL`,`bs`.`ACTIVE_FLAG` AS `ACTIVE_FLAG`,`u`.`PERMIS_BARANGAY_CONFIG` AS `PERMIS_BARANGAY_CONFIG` from ((`t_users` `u` join `r_barangay_information` `bs` on(`u`.`USER_ID` = `bs`.`USER_ID`)) join `r_position` `p` on(`p`.`POSITION_ID` = `u`.`POSITION_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_generatectrno`
--
DROP TABLE IF EXISTS `v_generatectrno`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_generatectrno`  AS  select concat(year(current_timestamp()),month(current_timestamp()),dayofmonth(current_timestamp())) AS `CTR_NO` ;

-- --------------------------------------------------------

--
-- Structure for view `v_realbarangayofficialsaccount`
--
DROP TABLE IF EXISTS `v_realbarangayofficialsaccount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_realbarangayofficialsaccount`  AS  select `bo`.`BARANGAY_OFFICIAL_ID` AS `BARANGAY_OFFICIAL_ID`,`bo`.`BARANGAY_ID` AS `BARANGAY_ID`,`u`.`USER_ID` AS `USER_ID`,concat(`rbi`.`FIRSTNAME`,' ',`rbi`.`MIDDLENAME`,' ',`rbi`.`LASTNAME`) AS `FULLNAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`bs`.`BARANGAY_NAME` AS `BARANGAY_NAME`,`p`.`POSITION_NAME` AS `POSITION_NAME`,`u`.`EMAIL` AS `EMAIL`,`bo`.`START_TERM` AS `START_TERM`,`bo`.`END_TERM` AS `END_TERM`,`u`.`PERMIS_RESIDENT_BASIC_INFO` AS `PERMIS_RESIDENT_BASIC_INFO`,`u`.`PERMIS_FAMILY_PROFILE` AS `PERMIS_FAMILY_PROFILE`,`u`.`PERMIS_COMMUNITY_PROFILE` AS `PERMIS_COMMUNITY_PROFILE`,`u`.`PERMIS_BLOTTER` AS `PERMIS_BLOTTER`,`u`.`PERMIS_PATAWAG` AS `PERMIS_PATAWAG`,`u`.`PERMIS_BARANGAY_OFFICIAL` AS `PERMIS_BARANGAY_OFFICIAL`,`u`.`PERMIS_BUSINESSES` AS `PERMIS_BUSINESSES`,`u`.`PERMIS_ISSUANCE_OF_FORMS` AS `PERMIS_ISSUANCE_OF_FORMS`,`u`.`PERMIS_ORDINANCES` AS `PERMIS_ORDINANCES`,`u`.`PERMIS_SYSTEM_REPORT` AS `PERMIS_SYSTEM_REPORT`,`u`.`PERMIS_HEALTH_SERVICES` AS `PERMIS_HEALTH_SERVICES`,`u`.`PERMIS_DATA_MIGRATION` AS `PERMIS_DATA_MIGRATION`,`u`.`PERMIS_USER_ACCOUNTS` AS `PERMIS_USER_ACCOUNTS`,`u`.`PERMIS_BARANGAY_CONFIG` AS `PERMIS_BARANGAY_CONFIG`,`u`.`PERMIS_BUSINESS_APPROVAL` AS `PERMIS_BUSINESS_APPROVAL`,`bo`.`ACTIVE_FLAG` AS `ACTIVE_FLAG`,`bs`.`BARANGAY_SEAL` AS `BARANGAY_SEAL`,`mi`.`MUNICIPAL_SEAL` AS `MUNICIPAL_SEAL`,`mi`.`MUNICIPAL_NAME` AS `MUNICIPAL_NAME`,`mi`.`PROVINCE_NAME` AS `PROVINCE_NAME` from (((((`t_users` `u` join `t_barangay_official` `bo` on(`bo`.`BARANGAY_OFFICIAL_ID` = `u`.`BARANGAY_OFFICIAL_ID`)) join `r_barangay_information` `bs` on(`bs`.`BARANGAY_ID` = `bo`.`BARANGAY_ID`)) join `t_resident_basic_info` `rbi` on(`bo`.`RESIDENT_ID` = `rbi`.`RESIDENT_ID`)) join `r_position` `p` on(`p`.`POSITION_ID` = `u`.`POSITION_ID`)) join `r_municipal_information` `mi` on(`mi`.`MUNICIPAL_ID` = `bs`.`MUNICIPAL_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_useraccount`
--
DROP TABLE IF EXISTS `v_useraccount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_useraccount`  AS  select `p`.`POSITION_NAME` AS `POSITION_NAME`,`bs`.`BARANGAY_NAME` AS `BARANGAY_NAME`,`u`.`FIRSTNAME` AS `FIRSTNAME`,`u`.`MIDDLENAME` AS `MIDDLENAME`,`u`.`LASTNAME` AS `LASTNAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`u`.`EMAIL` AS `EMAIL`,`u`.`ACTIVE_FLAG` AS `ACTIVE_FLAG` from (((`t_users` `u` join `r_position` `p` on(`p`.`POSITION_ID` = `u`.`POSITION_ID`)) left join `r_barangay_information` `bs` on(`u`.`USER_ID` = `bs`.`USER_ID`)) left join `t_barangay_official` `bo` on(`u`.`BARANGAY_OFFICIAL_ID` = `bo`.`BARANGAY_OFFICIAL_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_useraccounts`
--
DROP TABLE IF EXISTS `v_useraccounts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_useraccounts`  AS  select `u`.`BARANGAY_OFFICIAL_ID` AS `BARANGAY_OFFICIAL_ID`,`p`.`POSITION_NAME` AS `POSITION_NAME`,ifnull(`bi`.`BARANGAY_NAME`,'Null') AS `BARANGAY_NAME`,`u`.`LASTNAME` AS `LASTNAME`,`u`.`FIRSTNAME` AS `FIRSTNAME`,`u`.`MIDDLENAME` AS `MIDDLENAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`u`.`ACTIVE_FLAG` AS `ACTIVE_FLAG` from (((`t_users` `u` left join `t_barangay_official` `bo` on(`u`.`BARANGAY_OFFICIAL_ID` = `bo`.`BARANGAY_OFFICIAL_ID`)) join `r_position` `p` on(`u`.`POSITION_ID` = `p`.`POSITION_ID`)) left join `r_barangay_information` `bi` on(`bo`.`BARANGAY_ID` = `bi`.`BARANGAY_ID`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `r_barangay_information`
--
ALTER TABLE `r_barangay_information`
  ADD PRIMARY KEY (`BARANGAY_ID`) USING BTREE;

--
-- Indexes for table `r_barangay_zone`
--
ALTER TABLE `r_barangay_zone`
  ADD PRIMARY KEY (`BARANGAY_ZONE_ID`) USING BTREE,
  ADD KEY `FK_B_ID_BRGY_INFO` (`BARANGAY_ID`) USING BTREE;

--
-- Indexes for table `r_bf_facilities_equipment`
--
ALTER TABLE `r_bf_facilities_equipment`
  ADD PRIMARY KEY (`FACILITY_EQUIPMENT_ID`) USING BTREE,
  ADD KEY `FACILITY_EQUIPMENT_ID` (`FACILITY_EQUIPMENT_ID`) USING BTREE,
  ADD KEY `FACILITY_EQUIPMENT_ID_2` (`FACILITY_EQUIPMENT_ID`) USING BTREE,
  ADD KEY `FACILITY_EQUIPMENT_ID_3` (`FACILITY_EQUIPMENT_ID`) USING BTREE;

--
-- Indexes for table `r_bf_line_of_business`
--
ALTER TABLE `r_bf_line_of_business`
  ADD PRIMARY KEY (`LINE_OF_BUSINESS_ID`) USING BTREE,
  ADD KEY `LINE_OF_BUSINESS_ID` (`LINE_OF_BUSINESS_ID`) USING BTREE,
  ADD KEY `LINE_OF_BUSINESS_ID_2` (`LINE_OF_BUSINESS_ID`) USING BTREE,
  ADD KEY `LINE_OF_BUSINESS_ID_3` (`LINE_OF_BUSINESS_ID`) USING BTREE,
  ADD KEY `LINE_OF_BUSINESS_ID_4` (`LINE_OF_BUSINESS_ID`) USING BTREE,
  ADD KEY `LINE_OF_BUSINESS_ID_5` (`LINE_OF_BUSINESS_ID`) USING BTREE;

--
-- Indexes for table `r_blotter_subjects`
--
ALTER TABLE `r_blotter_subjects`
  ADD PRIMARY KEY (`BLOTTER_SUBJECT_ID`) USING BTREE;

--
-- Indexes for table `r_business_nature`
--
ALTER TABLE `r_business_nature`
  ADD PRIMARY KEY (`BUSINESS_NATURE_ID`) USING BTREE;

--
-- Indexes for table `r_issuance_category`
--
ALTER TABLE `r_issuance_category`
  ADD PRIMARY KEY (`ISSUANCE_CATEGORY_ID`) USING BTREE;

--
-- Indexes for table `r_municipal_information`
--
ALTER TABLE `r_municipal_information`
  ADD PRIMARY KEY (`MUNICIPAL_ID`) USING BTREE;

--
-- Indexes for table `r_ordinance_category`
--
ALTER TABLE `r_ordinance_category`
  ADD PRIMARY KEY (`ORDINANCE_CATEGORY_ID`) USING BTREE;

--
-- Indexes for table `r_position`
--
ALTER TABLE `r_position`
  ADD PRIMARY KEY (`POSITION_ID`) USING BTREE;

--
-- Indexes for table `r_resident_type`
--
ALTER TABLE `r_resident_type`
  ADD PRIMARY KEY (`TYPE_ID`) USING BTREE;

--
-- Indexes for table `t_barangay_official`
--
ALTER TABLE `t_barangay_official`
  ADD PRIMARY KEY (`BARANGAY_OFFICIAL_ID`) USING BTREE,
  ADD KEY `FK_BO_ID_BRGY_INFO` (`BARANGAY_ID`) USING BTREE,
  ADD KEY `FK_R_ID_T_RESIDENTS` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_bf_barangay_certification`
--
ALTER TABLE `t_bf_barangay_certification`
  ADD PRIMARY KEY (`BARANGAY_CERTIFICATION_ID`) USING BTREE,
  ADD KEY `fk_BarangayCertification_MainLgu` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `fk_BarangayCertification_PaymentDetails` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `fk_BarangayCertufication_Resident` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_bf_barangay_clearance`
--
ALTER TABLE `t_bf_barangay_clearance`
  ADD PRIMARY KEY (`BARANGAY_CLEARANCE_ID`) USING BTREE,
  ADD KEY `fk_BarangayClearance_MainLgu` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `fk_BarangayClearance_PaymentDetails` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `fk_BarangayClearance_ScopeOfWork` (`SCOPE_OF_WORK_ID`) USING BTREE,
  ADD KEY `fk_BarangayClearance_Business` (`BUSINESS_ID`) USING BTREE;

--
-- Indexes for table `t_bf_business_activity`
--
ALTER TABLE `t_bf_business_activity`
  ADD PRIMARY KEY (`BUSINESS_ACTIVITY_ID`) USING BTREE,
  ADD KEY `fk_BusinessActivity_LineOfBusiness` (`LINE_OF_BUSINESS_ID`) USING BTREE,
  ADD KEY `fk_BusinessActivity_Issuance` (`BUSINESS_ID`) USING BTREE;

--
-- Indexes for table `t_bf_business_permit`
--
ALTER TABLE `t_bf_business_permit`
  ADD PRIMARY KEY (`BUSINESS_PERMIT_ID`) USING BTREE,
  ADD KEY `fk_BusinessPermit_BfMainLgu` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `fk_BusinessPermit_PaymentDetails` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `fk_BusinessPermit_Business` (`BUSINESS_ID`) USING BTREE;

--
-- Indexes for table `t_bf_certified_record`
--
ALTER TABLE `t_bf_certified_record`
  ADD PRIMARY KEY (`CERTIFIED_RECORD_ID`) USING BTREE,
  ADD KEY `fk_CertifiedRecord_MainLgu` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `fk_CertifiedRecord_PaymentDetails` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `fk_CertifiedRecord_Resident` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_bf_main_lgu`
--
ALTER TABLE `t_bf_main_lgu`
  ADD PRIMARY KEY (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_2` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_3` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_4` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_5` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_6` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_7` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_8` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_9` (`BF_MAIN_LGU_ID`) USING BTREE,
  ADD KEY `BF_MAIN_LGU_ID_10` (`BF_MAIN_LGU_ID`) USING BTREE;

--
-- Indexes for table `t_bf_payment_details`
--
ALTER TABLE `t_bf_payment_details`
  ADD PRIMARY KEY (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID_2` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID_3` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID_4` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID_5` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID_6` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID_7` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID_8` (`PAYMENT_DETAILS_ID`) USING BTREE,
  ADD KEY `PAYMENT_DETAILS_ID_9` (`PAYMENT_DETAILS_ID`) USING BTREE;

--
-- Indexes for table `t_bf_scope_of_work`
--
ALTER TABLE `t_bf_scope_of_work`
  ADD PRIMARY KEY (`SCOPE_OF_WORK_ID`) USING BTREE,
  ADD KEY `SCOPE_OF_WORK_ID` (`SCOPE_OF_WORK_ID`) USING BTREE,
  ADD KEY `SCOPE_OF_WORK_ID_2` (`SCOPE_OF_WORK_ID`) USING BTREE;

--
-- Indexes for table `t_bf_uof_facility_equipment`
--
ALTER TABLE `t_bf_uof_facility_equipment`
  ADD PRIMARY KEY (`UOF_FACILITY_ID`) USING BTREE,
  ADD KEY `fk_UOFFacilityEquipment_UOF` (`USE_OF_FACILITY_EQUIPMENT_ID`) USING BTREE,
  ADD KEY `fk_UOFFacilityEquipment_RFacilityEquipment` (`FACILITY_ID`) USING BTREE;

--
-- Indexes for table `t_bf_use_of_facility_equipment`
--
ALTER TABLE `t_bf_use_of_facility_equipment`
  ADD PRIMARY KEY (`USE_OF_FACILITY_EQUIPMENT_ID`) USING BTREE,
  ADD KEY `fk_UseOfFacilityEquipment_Issuance` (`ISSUANCE_ID`) USING BTREE;

--
-- Indexes for table `t_blotter`
--
ALTER TABLE `t_blotter`
  ADD PRIMARY KEY (`BLOTTER_ID`) USING BTREE,
  ADD KEY `t_blotter_blotter_subject_foreign` (`BLOTTER_SUBJECT_ID`) USING BTREE,
  ADD KEY `t_blotter_accused_resident_foreign` (`ACCUSED_RESIDENT`) USING BTREE;

--
-- Indexes for table `t_business_approval`
--
ALTER TABLE `t_business_approval`
  ADD PRIMARY KEY (`APPROVAL_ID`) USING BTREE,
  ADD KEY `fk_Approval_Business` (`BUSINESS_ID`) USING BTREE;

--
-- Indexes for table `t_business_information`
--
ALTER TABLE `t_business_information`
  ADD PRIMARY KEY (`BUSINESS_ID`) USING BTREE,
  ADD KEY `FK_B_N_ID_TBINFO` (`BUSINESS_NATURE_ID`) USING BTREE,
  ADD KEY `FK_B_Z_ID_TBZONE` (`BARANGAY_ZONE_ID`) USING BTREE;

--
-- Indexes for table `t_children_profile`
--
ALTER TABLE `t_children_profile`
  ADD PRIMARY KEY (`CHILDREN_ID`) USING BTREE,
  ADD KEY `FK_CP_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_family_header`
--
ALTER TABLE `t_family_header`
  ADD PRIMARY KEY (`FAMILY_HEADER_ID`) USING BTREE;

--
-- Indexes for table `t_family_information`
--
ALTER TABLE `t_family_information`
  ADD PRIMARY KEY (`FAMILY_INFORMATION_ID`) USING BTREE;

--
-- Indexes for table `t_fathers_profile`
--
ALTER TABLE `t_fathers_profile`
  ADD PRIMARY KEY (`FATHERS_ID`) USING BTREE,
  ADD KEY `FK_FP_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_food_eaten`
--
ALTER TABLE `t_food_eaten`
  ADD PRIMARY KEY (`FOOD_EATEN_ID`) USING BTREE,
  ADD KEY `FK_C_ID_CPROFILE` (`CHILDREN_ID`) USING BTREE;

--
-- Indexes for table `t_household_information`
--
ALTER TABLE `t_household_information`
  ADD PRIMARY KEY (`HOUSEHOLD_ID`) USING BTREE,
  ADD KEY `FK_B_ID_HOUSEHOLDINFO` (`BARANGAY_ID`) USING BTREE;

--
-- Indexes for table `t_hs_adolescent`
--
ALTER TABLE `t_hs_adolescent`
  ADD PRIMARY KEY (`ADOLESCENT_ID`) USING BTREE,
  ADD KEY `FK_HS_A_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_child`
--
ALTER TABLE `t_hs_child`
  ADD PRIMARY KEY (`CHILD_ID`) USING BTREE,
  ADD KEY `FK_HS_C_INFANT_ID` (`INFANT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_chronic_cough`
--
ALTER TABLE `t_hs_chronic_cough`
  ADD PRIMARY KEY (`CHRONIC_COUGH_ID`) USING BTREE,
  ADD KEY `FK_HS_CC_R_ID` (`RESIDENT_ID`) USING BTREE,
  ADD KEY `FK_ChronicCough_NonResident` (`NONRESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_chronic_disease`
--
ALTER TABLE `t_hs_chronic_disease`
  ADD PRIMARY KEY (`CHRONIC_DISEASE_ID`) USING BTREE,
  ADD KEY `FK_HS_CD_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_elderly`
--
ALTER TABLE `t_hs_elderly`
  ADD PRIMARY KEY (`ELDERLY_ID`) USING BTREE,
  ADD KEY `fk_elderly_resident_id` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_family_planning`
--
ALTER TABLE `t_hs_family_planning`
  ADD PRIMARY KEY (`FD_ID`) USING BTREE,
  ADD KEY `FK_HS_FP_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_family_planning_users_visitations`
--
ALTER TABLE `t_hs_family_planning_users_visitations`
  ADD PRIMARY KEY (`VISITATION_ID`) USING BTREE,
  ADD KEY `FK_FPUV_FP_ID` (`FP_ID`) USING BTREE;

--
-- Indexes for table `t_hs_infant`
--
ALTER TABLE `t_hs_infant`
  ADD PRIMARY KEY (`INFANT_ID`) USING BTREE,
  ADD KEY `FK_HS_INFT_NB_ID` (`NEW_BORN_ID`) USING BTREE;

--
-- Indexes for table `t_hs_newborn`
--
ALTER TABLE `t_hs_newborn`
  ADD PRIMARY KEY (`NEWBORN_ID`) USING BTREE,
  ADD KEY `FK_HS_NB_R_ID` (`RESIDENT_ID`) USING BTREE,
  ADD KEY `FK_NEWBORN_NONRESIDENT` (`NONRESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_non_family_planning_users`
--
ALTER TABLE `t_hs_non_family_planning_users`
  ADD PRIMARY KEY (`NON_FP_ID`) USING BTREE,
  ADD KEY `FK_HS_NON_FPU_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_post_partum`
--
ALTER TABLE `t_hs_post_partum`
  ADD PRIMARY KEY (`POST_PATRUM_ID`) USING BTREE,
  ADD KEY `FK_HS_PP_P_ID` (`PREGNANT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_pregnant`
--
ALTER TABLE `t_hs_pregnant`
  ADD PRIMARY KEY (`PREGNANT_ID`) USING BTREE,
  ADD KEY `FK_HS_PRG_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_hs_pwd`
--
ALTER TABLE `t_hs_pwd`
  ADD PRIMARY KEY (`PWD_ID`) USING BTREE,
  ADD KEY `FK_HS_PWD_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_issuance`
--
ALTER TABLE `t_issuance`
  ADD PRIMARY KEY (`ISSUANCE_ID`) USING BTREE,
  ADD KEY `FK_IS_TYPE_ID` (`ISSUANCE_TYPE_ID`) USING BTREE,
  ADD KEY `FK_IS_R_ID` (`RESIDENT_ID`) USING BTREE,
  ADD KEY `FK_IS_B_ID` (`BUSINESS_ID`) USING BTREE;

--
-- Indexes for table `t_mothers_profile`
--
ALTER TABLE `t_mothers_profile`
  ADD PRIMARY KEY (`MOTHERS_ID`) USING BTREE,
  ADD KEY `FK_M_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_nonresident_basic_info`
--
ALTER TABLE `t_nonresident_basic_info`
  ADD PRIMARY KEY (`NONRESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_ordinance`
--
ALTER TABLE `t_ordinance`
  ADD PRIMARY KEY (`ORDINANCE_ID`) USING BTREE,
  ADD KEY `FK_O_BO_ID` (`BARANGAY_OFFICIAL_ID`) USING BTREE,
  ADD KEY `FK_ORNIDANCE_CATEGORY` (`ORDINANCE_CATEGORY_ID`) USING BTREE;

--
-- Indexes for table `t_patawag`
--
ALTER TABLE `t_patawag`
  ADD PRIMARY KEY (`PATAWAG_ID`) USING BTREE,
  ADD KEY `t_patawag_blotter_id_foreign` (`BLOTTER_ID`) USING BTREE;

--
-- Indexes for table `t_resident_basic_info`
--
ALTER TABLE `t_resident_basic_info`
  ADD PRIMARY KEY (`RESIDENT_ID`) USING BTREE,
  ADD KEY `FK_RBI_HS_ID` (`HOUSEHOLD_ID`) USING BTREE;

--
-- Indexes for table `t_transient_record`
--
ALTER TABLE `t_transient_record`
  ADD PRIMARY KEY (`TRANSIENT_RECORD_ID`) USING BTREE;

--
-- Indexes for table `t_users`
--
ALTER TABLE `t_users`
  ADD PRIMARY KEY (`USER_ID`) USING BTREE,
  ADD KEY `FK_U_BO_ID` (`BARANGAY_OFFICIAL_ID`) USING BTREE,
  ADD KEY `FK_U_POS_ID` (`POSITION_ID`) USING BTREE,
  ADD KEY `FK_BRGY_ID` (`BARANGAY_ID`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `r_barangay_information`
--
ALTER TABLE `r_barangay_information`
  MODIFY `BARANGAY_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `r_barangay_zone`
--
ALTER TABLE `r_barangay_zone`
  MODIFY `BARANGAY_ZONE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `r_bf_facilities_equipment`
--
ALTER TABLE `r_bf_facilities_equipment`
  MODIFY `FACILITY_EQUIPMENT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `r_bf_line_of_business`
--
ALTER TABLE `r_bf_line_of_business`
  MODIFY `LINE_OF_BUSINESS_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `r_blotter_subjects`
--
ALTER TABLE `r_blotter_subjects`
  MODIFY `BLOTTER_SUBJECT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `r_business_nature`
--
ALTER TABLE `r_business_nature`
  MODIFY `BUSINESS_NATURE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `r_issuance_category`
--
ALTER TABLE `r_issuance_category`
  MODIFY `ISSUANCE_CATEGORY_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `r_municipal_information`
--
ALTER TABLE `r_municipal_information`
  MODIFY `MUNICIPAL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `r_ordinance_category`
--
ALTER TABLE `r_ordinance_category`
  MODIFY `ORDINANCE_CATEGORY_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `r_position`
--
ALTER TABLE `r_position`
  MODIFY `POSITION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `r_resident_type`
--
ALTER TABLE `r_resident_type`
  MODIFY `TYPE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `t_barangay_official`
--
ALTER TABLE `t_barangay_official`
  MODIFY `BARANGAY_OFFICIAL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `t_bf_barangay_certification`
--
ALTER TABLE `t_bf_barangay_certification`
  MODIFY `BARANGAY_CERTIFICATION_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_bf_barangay_clearance`
--
ALTER TABLE `t_bf_barangay_clearance`
  MODIFY `BARANGAY_CLEARANCE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `t_bf_business_activity`
--
ALTER TABLE `t_bf_business_activity`
  MODIFY `BUSINESS_ACTIVITY_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `t_bf_business_permit`
--
ALTER TABLE `t_bf_business_permit`
  MODIFY `BUSINESS_PERMIT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `t_bf_certified_record`
--
ALTER TABLE `t_bf_certified_record`
  MODIFY `CERTIFIED_RECORD_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_bf_main_lgu`
--
ALTER TABLE `t_bf_main_lgu`
  MODIFY `BF_MAIN_LGU_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `t_bf_payment_details`
--
ALTER TABLE `t_bf_payment_details`
  MODIFY `PAYMENT_DETAILS_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `t_bf_scope_of_work`
--
ALTER TABLE `t_bf_scope_of_work`
  MODIFY `SCOPE_OF_WORK_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `t_bf_uof_facility_equipment`
--
ALTER TABLE `t_bf_uof_facility_equipment`
  MODIFY `UOF_FACILITY_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_bf_use_of_facility_equipment`
--
ALTER TABLE `t_bf_use_of_facility_equipment`
  MODIFY `USE_OF_FACILITY_EQUIPMENT_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_blotter`
--
ALTER TABLE `t_blotter`
  MODIFY `BLOTTER_ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `t_business_approval`
--
ALTER TABLE `t_business_approval`
  MODIFY `APPROVAL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `t_business_information`
--
ALTER TABLE `t_business_information`
  MODIFY `BUSINESS_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `t_children_profile`
--
ALTER TABLE `t_children_profile`
  MODIFY `CHILDREN_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_family_header`
--
ALTER TABLE `t_family_header`
  MODIFY `FAMILY_HEADER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=842;

--
-- AUTO_INCREMENT for table `t_family_information`
--
ALTER TABLE `t_family_information`
  MODIFY `FAMILY_INFORMATION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=930;

--
-- AUTO_INCREMENT for table `t_fathers_profile`
--
ALTER TABLE `t_fathers_profile`
  MODIFY `FATHERS_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `t_food_eaten`
--
ALTER TABLE `t_food_eaten`
  MODIFY `FOOD_EATEN_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_household_information`
--
ALTER TABLE `t_household_information`
  MODIFY `HOUSEHOLD_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1256;

--
-- AUTO_INCREMENT for table `t_hs_adolescent`
--
ALTER TABLE `t_hs_adolescent`
  MODIFY `ADOLESCENT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `t_hs_child`
--
ALTER TABLE `t_hs_child`
  MODIFY `CHILD_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `t_hs_chronic_cough`
--
ALTER TABLE `t_hs_chronic_cough`
  MODIFY `CHRONIC_COUGH_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `t_hs_chronic_disease`
--
ALTER TABLE `t_hs_chronic_disease`
  MODIFY `CHRONIC_DISEASE_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_hs_elderly`
--
ALTER TABLE `t_hs_elderly`
  MODIFY `ELDERLY_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_hs_family_planning`
--
ALTER TABLE `t_hs_family_planning`
  MODIFY `FD_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_hs_family_planning_users_visitations`
--
ALTER TABLE `t_hs_family_planning_users_visitations`
  MODIFY `VISITATION_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_hs_infant`
--
ALTER TABLE `t_hs_infant`
  MODIFY `INFANT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `t_hs_newborn`
--
ALTER TABLE `t_hs_newborn`
  MODIFY `NEWBORN_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `t_hs_non_family_planning_users`
--
ALTER TABLE `t_hs_non_family_planning_users`
  MODIFY `NON_FP_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_hs_post_partum`
--
ALTER TABLE `t_hs_post_partum`
  MODIFY `POST_PATRUM_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_hs_pregnant`
--
ALTER TABLE `t_hs_pregnant`
  MODIFY `PREGNANT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `t_hs_pwd`
--
ALTER TABLE `t_hs_pwd`
  MODIFY `PWD_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_issuance`
--
ALTER TABLE `t_issuance`
  MODIFY `ISSUANCE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `t_mothers_profile`
--
ALTER TABLE `t_mothers_profile`
  MODIFY `MOTHERS_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `t_nonresident_basic_info`
--
ALTER TABLE `t_nonresident_basic_info`
  MODIFY `NONRESIDENT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `t_ordinance`
--
ALTER TABLE `t_ordinance`
  MODIFY `ORDINANCE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `t_patawag`
--
ALTER TABLE `t_patawag`
  MODIFY `PATAWAG_ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `t_resident_basic_info`
--
ALTER TABLE `t_resident_basic_info`
  MODIFY `RESIDENT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3836;

--
-- AUTO_INCREMENT for table `t_transient_record`
--
ALTER TABLE `t_transient_record`
  MODIFY `TRANSIENT_RECORD_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `t_users`
--
ALTER TABLE `t_users`
  MODIFY `USER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `r_barangay_zone`
--
ALTER TABLE `r_barangay_zone`
  ADD CONSTRAINT `FK_B_ID_BRGY_INFO` FOREIGN KEY (`BARANGAY_ID`) REFERENCES `r_barangay_information` (`BARANGAY_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `t_barangay_official`
--
ALTER TABLE `t_barangay_official`
  ADD CONSTRAINT `FK_BO_ID_BRGY_INFO` FOREIGN KEY (`BARANGAY_ID`) REFERENCES `r_barangay_information` (`BARANGAY_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_R_ID_T_RESIDENTS` FOREIGN KEY (`RESIDENT_ID`) REFERENCES `t_resident_basic_info` (`RESIDENT_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `t_bf_barangay_certification`
--
ALTER TABLE `t_bf_barangay_certification`
  ADD CONSTRAINT `fk_BarangayCertification_MainLgu` FOREIGN KEY (`BF_MAIN_LGU_ID`) REFERENCES `t_bf_main_lgu` (`BF_MAIN_LGU_ID`),
  ADD CONSTRAINT `fk_BarangayCertification_PaymentDetails` FOREIGN KEY (`PAYMENT_DETAILS_ID`) REFERENCES `t_bf_payment_details` (`PAYMENT_DETAILS_ID`),
  ADD CONSTRAINT `fk_BarangayCertufication_Resident` FOREIGN KEY (`RESIDENT_ID`) REFERENCES `t_resident_basic_info` (`RESIDENT_ID`);

--
-- Constraints for table `t_bf_business_activity`
--
ALTER TABLE `t_bf_business_activity`
  ADD CONSTRAINT `fk_BusinessActivity_Business` FOREIGN KEY (`BUSINESS_ID`) REFERENCES `t_business_information` (`BUSINESS_ID`),
  ADD CONSTRAINT `fk_BusinessActivity_LineOfBusiness` FOREIGN KEY (`LINE_OF_BUSINESS_ID`) REFERENCES `r_bf_line_of_business` (`LINE_OF_BUSINESS_ID`);

--
-- Constraints for table `t_hs_chronic_cough`
--
ALTER TABLE `t_hs_chronic_cough`
  ADD CONSTRAINT `FK_ChronicCough` FOREIGN KEY (`RESIDENT_ID`) REFERENCES `t_resident_basic_info` (`RESIDENT_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_ChronicCough_NonResident` FOREIGN KEY (`NONRESIDENT_ID`) REFERENCES `t_nonresident_basic_info` (`NONRESIDENT_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `t_hs_elderly`
--
ALTER TABLE `t_hs_elderly`
  ADD CONSTRAINT `sfk_Elderly_Resident` FOREIGN KEY (`RESIDENT_ID`) REFERENCES `t_resident_basic_info` (`RESIDENT_ID`);

--
-- Constraints for table `t_hs_newborn`
--
ALTER TABLE `t_hs_newborn`
  ADD CONSTRAINT `FK_NEWBORN_NONRESIDENT` FOREIGN KEY (`NONRESIDENT_ID`) REFERENCES `t_nonresident_basic_info` (`NONRESIDENT_ID`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `t_resident_basic_info`
--
ALTER TABLE `t_resident_basic_info`
  ADD CONSTRAINT `fk_Resident_Household` FOREIGN KEY (`HOUSEHOLD_ID`) REFERENCES `t_household_information` (`HOUSEHOLD_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
