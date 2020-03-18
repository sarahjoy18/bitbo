-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 19, 2019 at 07:43 AM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.2.13

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gethousehold_mebers` (IN `header_id` INT)  BEGIN

	SELECT TB.FAMILY_HEADER_ID
		, CONCAT(T.LASTNAME, ' ', T.FIRSTNAME, ' ', T.MIDDLENAME) AS FULLNAME
		, LASTNAME
		, FIRSTNAME
		, MIDDLENAME
		, QUALIFIER
		, T.CONTACT_NUMBER
		, T.ADDRESS_HOUSE_NO
		
		, T.ADDRESS_STREET
		, T.ADDRESS_PHASE
	  , T.PLACE_OF_BIRTH
		, T.DATE_OF_BIRTH
		, T.SEX
		, T.CIVIL_STATUS
		, T.CITIZENSHIP
		, T.OCCUPATION
		, T.RELATION_TO_HOUSEHOLD_HEAD
		, T.ADDRESS_HOUSE_NO

FROM T_RESIDENT_BASIC_INFO AS T
INNER JOIN T_HOUSEHOLD_INFORMATION AS HI 
ON T.HOUSEHOLD_ID = HI.HOUSEHOLD_ID
INNER JOIN T_HOUSEHOLD_MEMBERS AS TH 
ON T.RESIDENT_ID = TH.RESIDENT_ID
INNER JOIN T_HOUSEHOLD_BATCH AS TB
ON TH.FAMILY_HEADER_ID = TB.FAMILY_HEADER_ID
WHERE TB.FAMILY_HEADER_ID = header_id;
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
	,`u`.`PERMIS_APPLICATION_FORM` AS `PERMIS_APPLICATION_FORM`
	,`u`.`PERMIS_APPLICATION_FORM_EVALUATION` AS `PERMIS_APPLICATION_FORM_EVALUATION`
	
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_house_no` (IN `header_id` INT)  BEGIN

	SELECT T.ADDRESS_HOUSE_NO

FROM T_RESIDENT_BASIC_INFO AS T
INNER JOIN T_HOUSEHOLD_INFORMATION AS HI 
ON T.HOUSEHOLD_ID = HI.HOUSEHOLD_ID
INNER JOIN T_HOUSEHOLD_MEMBERS AS TH 
ON T.RESIDENT_ID = TH.RESIDENT_ID
INNER JOIN T_HOUSEHOLD_BATCH AS TB
ON TH.FAMILY_HEADER_ID = TB.FAMILY_HEADER_ID
WHERE TB.FAMILY_HEADER_ID = header_id
LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_municipal_info` (IN `barangay_id` INT)  BEGIN

SELECT MI.MUNICIPAL_NAME, MI.PROVINCE_NAME, MI.REGION , BI.BARANGAY_NAME
FROM r_barangay_information AS BI
INNER JOIN r_municipal_information AS MI
ON BI.MUNICIPAL_ID = MI.MUNICIPAL_ID
WHERE BI.BARANGAY_ID = barangay_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_residents_not_official` ()  BEGIN
	SELECT RESIDENT_ID, CONCAT(FIRSTNAME,' ',LASTNAME) AS FULLNAME FROM t_resident_basic_info
	WHERE RESIDENT_ID NOT IN (SELECT RESIDENT_ID FROM t_barangay_official);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_resident_info` (IN `search_val` VARCHAR(100))  BEGIN
SELECT RESIDENT_ID
, LASTNAME
, FIRSTNAME
, MIDDLENAME
, QUALIFIER
, SEX
, DATE_OF_BIRTH
, CIVIL_STATUS
, OCCUPATION
, CITIZENSHIP
, RELATION_TO_HOUSEHOLD_HEAD
, CONTACT_NUMBER
, DATE_OF_BIRTH
, PLACE_OF_BIRTH
, ADDRESS_UNIT_NO
, ADDRESS_PHASE
, ADDRESS_HOUSE_NO
, ADDRESS_STREET
, ADDRESS_STREET_NO
, ADDRESS_SUBDIVISION
, ADDRESS_BUILDING
, DATE_STARTED_WORKING
, DATE_OF_ARRIVAL
FROM t_resident_basic_info
WHERE RESIDENT_ID NOT IN (SELECT RESIDENT_ID FROM t_barangay_official) 
	AND CONCAT(FIRSTNAME,' ', LASTNAME) LIKE CONCAT('%',search_val, '%')
	AND FIRSTNAME LIKE CONCAT('%',search_val, '%') OR LASTNAME  LIKE CONCAT('%',search_val, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_resident_foradding_member` (IN `search_val` VARCHAR(255))  BEGIN
	SELECT T.RESIDENT_ID
	, CONCAT(FIRSTNAME,' ', LASTNAME) AS FULLNAME
	, CONCAT(MONTHNAME(DATE_OF_BIRTH),' ',DAY(DATE_OF_BIRTH),', ',YEAR(DATE_OF_BIRTH)) AS DATE_OF_BIRTH
	, PLACE_OF_BIRTH
	, CONCAT(ADDRESS_HOUSE_NO,' ',ADDRESS_STREET_NO, ' ',ADDRESS_STREET) AS FULL_ADDRESS
	, PROFILE_PICTURE
	FROM t_resident_basic_info AS T
	LEFT JOIN t_household_members AS HM
	ON T.RESIDENT_ID = HM.RESIDENT_ID
	WHERE T.RESIDENT_ID NOT IN (SELECT RESIDENT_ID FROM t_household_members)
	AND
	 LASTNAME LIKE CONCAT((SELECT LASTNAME FROM t_resident_basic_info AS T 
									LEFT JOIN t_household_members AS HM
									ON T.RESIDENT_ID = HM.RESIDENT_ID
									WHERE LASTNAME LIKE CONCAT(search_val,'%') GROUP BY LASTNAME),'%');
--  OR FIRSTNAME LIKE CONCAT('%',(SELECT FIRSTNAME FROM t_resident_basic_info AS T 
-- 									LEFT JOIN t_household_members AS HM
-- 									ON T.RESIDENT_ID = HM.RESIDENT_ID
-- 									WHERE FIRSTNAME LIKE CONCAT('%',search_val,'%') GROUP BY FIRSTNAME),'%')
--  OR CONCAT(FIRSTNAME,' ',LASTNAME) LIKE CONCAT('%',(SELECT CONCAT(FIRSTNAME,' ',LASTNAME) AS FULLNAME FROM t_resident_basic_info AS T 
-- 									LEFT JOIN t_household_members AS HM
-- 									ON T.RESIDENT_ID = HM.RESIDENT_ID
-- 									WHERE CONCAT(FIRSTNAME,' ',LASTNAME) LIKE CONCAT('%',search_val,'%') GROUP BY FULLNAME),'%')
--  OR CONCAT(LASTNAME,' ',FIRSTNAME) LIKE CONCAT('%',(SELECT CONCAT(LASTNAME,' ',FIRSTNAME) AS FULLNAME FROM t_resident_basic_info AS T 
-- 									LEFT JOIN t_household_members AS HM
-- 									ON T.RESIDENT_ID = HM.RESIDENT_ID
-- 									WHERE CONCAT(LASTNAME,' ',FIRSTNAME) LIKE CONCAT('%',search_val,'%') GROUP BY FULLNAME),'%');
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
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE_FLAG` int(11) DEFAULT '1',
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
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE_FLAG` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_barangay_zone`
--

INSERT INTO `r_barangay_zone` (`BARANGAY_ZONE_ID`, `BARANGAY_ZONE_NAME`, `BARANGAY_ZONE_DESC`, `BARANGAY_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(6, 'ASPEN', NULL, NULL, '2019-10-04 00:23:32', '2019-10-04 00:23:32', 1);

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
(16, 'Retailer'),
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
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE_FLAG` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_business_nature`
--

INSERT INTO `r_business_nature` (`BUSINESS_NATURE_ID`, `BUSINESS_NATURE_NAME`, `BUSINESS_NATURE_DESCRIPTION`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(1, 'Accommodation and Food Service', NULL, '2019-10-14 10:58:40', '2019-10-14 10:58:40', 1),
(2, 'Administrative and Support', NULL, '2019-10-14 10:58:40', '2019-10-14 10:58:40', 1),
(3, 'Agriculture, Forestry, Fishing and Hunting ', NULL, '2019-10-14 10:58:40', '2019-10-14 10:58:40', 1),
(4, 'Arts, Entertainment and Recreation ', NULL, '2019-10-14 10:58:40', '2019-10-14 10:58:40', 1),
(5, 'Construction ', NULL, '2019-10-14 10:58:40', '2019-10-14 10:58:40', 1),
(6, 'Educational service', NULL, '2019-10-14 10:59:29', '2019-10-14 10:59:29', 1),
(7, 'Finance and Insurance ', NULL, '2019-10-14 10:59:29', '2019-10-14 10:59:29', 1),
(8, 'Health care and Social Assistance ', NULL, '2019-10-14 10:59:29', '2019-10-14 10:59:29', 1),
(9, 'Information and cultural industries ', NULL, '2019-10-14 10:59:29', '2019-10-14 10:59:29', 1),
(10, 'Manufacturing', NULL, '2019-10-14 10:59:29', '2019-10-14 10:59:29', 1),
(11, 'Retailer', NULL, '2019-10-31 19:06:58', '2019-10-31 19:06:58', 1);

-- --------------------------------------------------------

--
-- Table structure for table `r_municipal_information`
--

CREATE TABLE `r_municipal_information` (
  `MUNICIPAL_ID` int(11) NOT NULL,
  `MUNICIPAL_NAME` varchar(50) NOT NULL,
  `PROVINCE_NAME` varchar(50) NOT NULL,
  `MUNICIPAL_SEAL` varchar(50) NOT NULL,
  `CREATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `REGION` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `r_municipal_information`
--

INSERT INTO `r_municipal_information` (`MUNICIPAL_ID`, `MUNICIPAL_NAME`, `PROVINCE_NAME`, `MUNICIPAL_SEAL`, `CREATED_AT`, `UPDATED_AT`, `REGION`) VALUES
(1, 'Tanay', 'Rizal', 'tanay_logo.jpg', '2019-09-26 23:08:22', '2019-11-15 16:18:57', 'Calabarzon (Region IV-A)');

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
-- Table structure for table `r_paper_type`
--

CREATE TABLE `r_paper_type` (
  `PAPER_TYPE_ID` int(11) NOT NULL,
  `PAPER_TYPE_NAME` varchar(100) NOT NULL,
  `PAPER_TYPE_CATEGORY` varchar(100) NOT NULL,
  `PAPER_TYPE_DECRIPTION` varchar(250) DEFAULT NULL,
  `CREATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) NOT NULL DEFAULT '1',
  `PAPER_TYPE_CODE` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `r_paper_type`
--

INSERT INTO `r_paper_type` (`PAPER_TYPE_ID`, `PAPER_TYPE_NAME`, `PAPER_TYPE_CATEGORY`, `PAPER_TYPE_DECRIPTION`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `PAPER_TYPE_CODE`) VALUES
(0, 'Patient Record Form', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF07'),
(1, 'Application Barangay Business Permit Form', 'Form', 'Business', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF01'),
(2, 'Application Barangay Clearance Form', 'Form', 'Business', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF02'),
(3, 'Request Barangay Certification Form', 'Form', 'Resident', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF03'),
(4, 'Application Use Of Barangay Property Facilities', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF04'),
(5, 'Request Freedom Of Information', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF05'),
(6, 'Transient Registration Form', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF06'),
(8, 'Socio Demographic Profile', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF08'),
(9, 'VAWC Intake Form', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF09'),
(10, 'Request Assistance', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF9'),
(11, 'Referral Form', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF10'),
(12, 'Application Barangay Protection Order', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF11'),
(13, 'Feedback Form', 'Form', '', '2019-10-13 19:10:01', '0000-00-00 00:00:00', 1, 'BF100'),
(14, 'Barangay Business Permit', 'Clearance', 'Business', '2019-10-13 19:21:28', NULL, 1, 'FM-BBP-001'),
(15, 'Barangay Clearance Building', 'Clearance', 'Business', '2019-10-13 19:21:28', NULL, 1, 'FM-BC-001A'),
(16, 'Barangay Clearance Business', 'Clearance', 'Business', '2019-10-13 19:21:28', NULL, 1, 'FM-BC-001B'),
(17, 'Barangay Clearance Zonal', 'Clearance', 'Business', '2019-10-13 19:21:28', NULL, 1, 'FM-BC-001C'),
(18, 'Barangay Clearance Tricycle', 'Clearance', 'Business', '2019-10-13 19:21:28', NULL, 1, 'FM-BC-001D'),
(19, 'Barangay Clearance General Purposes', 'Clearance', 'Business', '2019-10-13 19:21:28', NULL, 1, 'FM-BC-001E'),
(20, 'Barangay Clearance Inhabitant', 'Clearance', NULL, '2019-10-13 19:21:28', NULL, 1, 'FM-BC-001F'),
(21, 'Barangay Clearance Negative', 'Clearance', NULL, '2019-10-13 19:21:28', NULL, 1, 'FM-BC-001X'),
(22, 'Barangay Certificate Residency', 'Certification', 'Resident', '2019-10-13 19:21:28', NULL, 1, 'FM-BCert-001A'),
(23, 'Barangay Certificate Calamity Loan SSS-GSIS', 'Certification', 'Resident', '2019-10-13 19:24:21', NULL, 1, 'FM-BCert-001B'),
(24, 'Barangay Certificate Calamity Loan OFW', 'Certification', 'Resident', '2019-10-13 19:24:21', NULL, 1, 'FM-BCert-001C'),
(25, 'Barangay Certificate SPES', 'Certification', 'Resident', '2019-10-13 19:24:21', NULL, 1, 'FM-BCert-001D'),
(26, 'Barangay Certificate Solo Parent', 'Certification', 'Resident', '2019-10-13 19:24:21', NULL, 1, 'FM-BCert-001E'),
(27, 'Barangay Certificate Indigency', 'Certification', 'Resident', '2019-10-13 19:24:21', NULL, 1, 'FM-BCert-001F'),
(28, 'Permit Use Of Barangay Property Facility', 'Unknown', NULL, '2019-10-13 19:26:37', NULL, 1, 'FM-BPermit');

-- --------------------------------------------------------

--
-- Table structure for table `r_position`
--

CREATE TABLE `r_position` (
  `POSITION_ID` int(11) NOT NULL,
  `POSITION_NAME` varchar(50) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `r_position`
--

INSERT INTO `r_position` (`POSITION_ID`, `POSITION_NAME`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(6, 'Admin', '2019-07-30 12:15:06', NULL, 1),
(35, 'Secretary', '2019-10-03 23:45:06', NULL, 1),
(36, 'Census Officer', '2019-10-03 23:45:06', NULL, 1),
(37, 'Barangay Chairman', '2019-10-03 23:45:07', NULL, 1),
(38, 'Chief Tanod', '2019-10-16 10:21:37', NULL, 1),
(39, 'Lupon', '2019-10-16 10:56:52', NULL, 1);

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
-- Table structure for table `t_application_form`
--

CREATE TABLE `t_application_form` (
  `FORM_ID` int(11) NOT NULL,
  `FORM_DATE` datetime DEFAULT CURRENT_TIMESTAMP,
  `FORM_TIME` time DEFAULT NULL,
  `TIME_RECEIVED` time DEFAULT NULL,
  `RECEIVED_BY` varchar(250) DEFAULT NULL,
  `FORM_NUMBER` varchar(50) DEFAULT NULL,
  `PAPER_TYPE_ID` int(11) DEFAULT NULL,
  `REQUESTED_PAPER_TYPE_ID` int(11) NOT NULL,
  `STATUS` varchar(20) DEFAULT NULL,
  `BUSINESS_ID` int(11) DEFAULT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `APPLICANT_NAME` varchar(250) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_application_form`
--

INSERT INTO `t_application_form` (`FORM_ID`, `FORM_DATE`, `FORM_TIME`, `TIME_RECEIVED`, `RECEIVED_BY`, `FORM_NUMBER`, `PAPER_TYPE_ID`, `REQUESTED_PAPER_TYPE_ID`, `STATUS`, `BUSINESS_ID`, `RESIDENT_ID`, `APPLICANT_NAME`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(10, '2019-10-16 21:22:36', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 15, 'Approved', 62, NULL, NULL, '2019-10-16 21:22:36', NULL, 1),
(11, '2019-10-16 21:28:43', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 16, 'Approved', 62, NULL, NULL, '2019-10-16 21:28:43', NULL, 1),
(12, '2019-10-16 21:33:54', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 17, 'Approved', 60, NULL, NULL, '2019-10-16 21:33:54', NULL, 1),
(13, '2019-10-16 21:37:57', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 18, 'Approved', 63, NULL, NULL, '2019-10-16 21:37:57', NULL, 1),
(14, '2019-10-16 21:43:12', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 19, 'Declined', 63, NULL, NULL, '2019-10-16 21:43:12', NULL, 1),
(15, '2019-10-16 21:43:36', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 1, 14, 'Approved', 62, NULL, NULL, '2019-10-16 21:43:36', NULL, 1),
(16, '2019-10-16 21:45:31', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 15, 'Approved', 62, NULL, NULL, '2019-10-16 21:45:31', NULL, 1),
(17, '2019-10-22 13:24:18', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 1, 14, 'Approved', 66, NULL, NULL, '2019-10-22 13:24:18', NULL, 1),
(18, '2019-10-23 16:52:40', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 19, 'Approved', 61, NULL, NULL, '2019-10-23 16:52:40', NULL, 1),
(26, '2019-10-23 23:54:22', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 3, 22, 'Approved', NULL, 3806, NULL, '2019-10-23 23:54:22', NULL, 1),
(27, '2019-10-24 00:12:53', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 3, 23, 'Approved', NULL, 3807, NULL, '2019-10-24 00:12:53', NULL, 1),
(28, '2019-10-24 00:13:58', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 3, 24, 'Approved', NULL, 3825, NULL, '2019-10-24 00:13:58', NULL, 1),
(29, '2019-10-24 00:14:21', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 3, 25, 'Approved', NULL, 3802, NULL, '2019-10-24 00:14:21', NULL, 1),
(33, '2019-10-24 00:19:58', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 3, 26, 'Approved', NULL, 3808, NULL, '2019-10-24 00:19:58', NULL, 1),
(34, '2019-10-24 00:21:04', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 3, 27, 'Approved', NULL, 3825, NULL, '2019-10-24 00:21:04', NULL, 1),
(35, '2019-10-25 10:27:42', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 19, 'Pending', 62, NULL, NULL, '2019-10-25 10:27:42', NULL, 1),
(36, '2019-10-25 18:28:30', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 17, 'Approved', 60, NULL, NULL, '2019-10-25 18:28:30', NULL, 1),
(37, '2019-10-26 20:46:13', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 3, 22, 'Pending', NULL, 3808, NULL, '2019-10-26 20:46:13', NULL, 1),
(38, '2019-10-29 23:48:09', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 1, 14, 'Pending', 75, NULL, NULL, '2019-10-29 23:48:09', NULL, 1),
(39, '2019-10-29 23:52:28', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 1, 14, 'Pending', 75, NULL, NULL, '2019-10-29 23:52:28', NULL, 1),
(40, '2019-10-30 21:23:46', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 1, 14, 'Approved', 79, NULL, NULL, '2019-10-30 21:23:46', NULL, 1),
(41, '2019-10-30 21:39:46', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 16, 'Declined', 79, NULL, NULL, '2019-10-30 21:39:46', NULL, 1),
(42, '2019-10-30 21:42:53', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 16, 'Approved', 81, NULL, NULL, '2019-10-30 21:42:53', NULL, 1),
(43, '2019-10-31 13:44:09', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 1, 14, 'Approved', 82, NULL, NULL, '2019-10-31 13:44:09', NULL, 1),
(44, '2019-10-31 13:48:37', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 2, 16, 'Approved', 82, NULL, NULL, '2019-10-31 13:48:37', NULL, 1),
(45, '2019-11-06 17:19:35', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 1, 14, 'Pending', 63, NULL, NULL, '2019-11-06 17:19:35', NULL, 1),
(46, '2019-11-15 19:39:24', NULL, NULL, 'Shiela Mae A. Velga', 'XXXX-XXX', 3, 27, 'Approved', NULL, 3836, NULL, '2019-11-15 19:39:24', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_application_form_evaluation`
--

CREATE TABLE `t_application_form_evaluation` (
  `AF_EVALUATION_ID` int(11) NOT NULL,
  `FORM_ID` int(11) DEFAULT NULL,
  `EVALUATED_BY` varchar(250) DEFAULT NULL,
  `DATE_EVALUATED` datetime DEFAULT CURRENT_TIMESTAMP,
  `EVALUATION_STATUS` varchar(50) DEFAULT NULL,
  `REMARKS` varchar(500) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_application_form_evaluation`
--

INSERT INTO `t_application_form_evaluation` (`AF_EVALUATION_ID`, `FORM_ID`, `EVALUATED_BY`, `DATE_EVALUATED`, `EVALUATION_STATUS`, `REMARKS`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(6, 10, 'Shiela Mae Velga', '2019-10-16 00:00:00', 'Approved', 'remarks remakrs remaera', '2019-10-17 02:05:17', NULL, 1),
(7, 14, 'Shiela Mae Velga', '2019-10-16 00:00:00', 'Declined', 'remarks remakrs remaera', '2019-10-17 02:07:11', NULL, 1),
(8, 12, 'RYAN AUREUS', '2019-10-16 00:00:00', 'Approved', 'remarks remakrs remaera', '2019-10-17 02:12:15', NULL, 1),
(9, 15, 'Shiela Mae Velga', '2019-10-17 00:00:00', 'Approved', 'Ok', '2019-10-17 12:26:13', NULL, 1),
(10, 16, 'fsa', '2019-10-22 00:00:00', 'Approved', 'Ok', '2019-10-22 12:39:56', NULL, 1),
(11, NULL, NULL, '2019-10-22 00:00:00', NULL, NULL, '2019-10-22 13:09:06', NULL, 1),
(12, 13, 'fdsa', '2019-10-22 00:00:00', 'Pending', 'remarks remakrs remaera', '2019-10-22 13:17:22', NULL, 1),
(13, 13, 'fdsaf', '2019-10-22 00:00:00', 'Approved', 'remarks remakrs remaera', '2019-10-22 13:17:36', NULL, 1),
(14, 17, '999', '2019-10-22 00:00:00', 'Approved', 'remarks remakrs remaera', '2019-10-22 13:24:37', NULL, 1),
(15, NULL, NULL, '2019-10-22 00:00:00', NULL, NULL, '2019-10-22 13:24:50', NULL, 1),
(16, NULL, NULL, '2019-10-22 00:00:00', NULL, NULL, '2019-10-22 18:45:18', NULL, 1),
(17, 11, 'Albert Kobe Andrada', '2019-10-23 00:00:00', 'Approved', 'Ok', '2019-10-23 16:00:21', NULL, 1),
(18, 18, 'Boy D. Roberto', '2019-10-23 00:00:00', 'Approved', 'remarks remakrs remaera', '2019-10-23 16:53:12', NULL, 1),
(19, 26, 'Albert Kobe Andrada', '2019-10-25 00:00:00', 'Approved', 'remarks remakrs remaera', '2019-10-25 14:19:21', NULL, 1),
(20, 36, 'Albert Kobe Andrada', '2019-10-25 00:00:00', 'Pending', '8765', '2019-10-25 18:29:02', NULL, 1),
(21, 36, 'Albert Kobe Andrada', '2019-10-25 00:00:00', 'Approved', '876543', '2019-10-25 18:30:12', NULL, 1),
(22, 33, 'Boy D. Roberto', '2019-10-25 00:00:00', 'Approved', 'Ok', '2019-10-25 18:51:40', NULL, 1),
(23, 29, 'Boy D. Roberto', '2019-10-25 00:00:00', 'Approved', 'Ok', '2019-10-25 18:52:24', NULL, 1),
(24, 27, 'Albert Kobe Andrada', '2019-10-25 00:00:00', 'Approved', 'Ok', '2019-10-25 18:52:40', NULL, 1),
(25, 28, 'Albert Kobe Andrada', '2019-10-25 00:00:00', 'Approved', 'Ok', '2019-10-25 18:52:58', NULL, 1),
(26, 34, 'Albert Kobe Andrada', '2019-10-25 00:00:00', 'Approved', 'Ok', '2019-10-25 18:53:11', NULL, 1),
(27, 40, 'Sebio D. Roberto', '2019-10-30 00:00:00', 'Approved', 'No Issue', '2019-10-30 21:25:52', NULL, 1),
(28, 41, NULL, '2019-10-30 00:00:00', 'Declined', NULL, '2019-10-30 21:42:03', NULL, 1),
(29, 42, 'Sebio D. Roberto', '2019-10-30 00:00:00', 'Approved', 'For Printing', '2019-10-30 21:44:46', NULL, 1),
(30, 43, 'Sebio D. Roberto', '2019-10-31 00:00:00', 'Approved', 'No Issue', '2019-10-31 13:45:36', NULL, 1),
(31, 44, 'Sebio D. Roberto', '2019-10-31 00:00:00', 'Approved', 'Ok', '2019-10-31 13:49:41', NULL, 1),
(32, 46, NULL, '2019-11-15 00:00:00', 'Approved', 'Ok', '2019-11-15 19:40:20', NULL, 1);

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
(39, 3786, 1, '2019-10-10', '2022-10-10', '26-2312345', '2019-10-11 19:59:17', NULL, 1),
(40, 3797, 1, '2019-10-08', '2022-10-08', '23-1231234', '2019-10-16 18:22:13', NULL, 1),
(41, 3794, 1, '2019-10-14', '2022-10-14', '23-0012344', '2019-10-16 19:05:48', NULL, 1),
(42, 3838, 1, '2019-10-06', '2022-10-06', '23-0023123', '2019-10-26 02:58:16', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_barangay_certification`
--

CREATE TABLE `t_bf_barangay_certification` (
  `BARANGAY_CERTIFICATION_ID` int(11) NOT NULL,
  `REQUESTOR_NAME` varchar(250) DEFAULT NULL,
  `SSS_NO` varchar(50) DEFAULT NULL,
  `CALAMITY_NAME` varchar(100) DEFAULT NULL,
  `CALAMITY_DATE` date DEFAULT NULL,
  `COUNTRY` varchar(100) DEFAULT NULL,
  `CATEGORY_SINGLE_PARENT` varchar(100) DEFAULT NULL,
  `PURPOSE` varchar(500) DEFAULT NULL,
  `FORM_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATE_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_bf_barangay_certification`
--

INSERT INTO `t_bf_barangay_certification` (`BARANGAY_CERTIFICATION_ID`, `REQUESTOR_NAME`, `SSS_NO`, `CALAMITY_NAME`, `CALAMITY_DATE`, `COUNTRY`, `CATEGORY_SINGLE_PARENT`, `PURPOSE`, `FORM_ID`, `CREATED_AT`, `UPDATE_AT`, `ACTIVE_FLAG`) VALUES
(2, NULL, NULL, NULL, NULL, NULL, NULL, 'Scholarship purpose', 26, '2019-10-23 23:54:22', NULL, 1),
(3, NULL, '987653', 'typhoon Hagibis', '2019-09-30', NULL, NULL, NULL, 27, '2019-10-24 00:12:53', NULL, 1),
(4, NULL, '765354', 'Magnitude 6.5 Earthquake', '2019-10-22', 'South Africa', NULL, NULL, 28, '2019-10-24 00:13:58', NULL, 1),
(5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29, '2019-10-24 00:14:21', NULL, 1),
(6, 'Shiela', NULL, NULL, NULL, NULL, 'Widowed Parent', NULL, 33, '2019-10-24 00:19:59', NULL, 1),
(7, NULL, NULL, NULL, NULL, NULL, NULL, 'Scholarship application', 34, '2019-10-24 00:21:05', NULL, 1),
(8, NULL, NULL, NULL, NULL, NULL, NULL, 'Scholarship application', 37, '2019-10-26 20:46:13', NULL, 1),
(9, NULL, NULL, NULL, NULL, NULL, NULL, 'scholarship', 46, '2019-11-15 19:39:24', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_barangay_clearance`
--

CREATE TABLE `t_bf_barangay_clearance` (
  `BARANGAY_CLEARANCE_ID` int(11) NOT NULL,
  `REGISTERED_NAME` varchar(150) DEFAULT NULL,
  `APPLICANT_NAME` varchar(250) DEFAULT NULL,
  `KIND_OF_BUSINESS` varchar(50) DEFAULT NULL,
  `CONSTRUCTION_ADDRESS` varchar(100) DEFAULT NULL,
  `PROJECT_LOCATION` varchar(250) DEFAULT NULL,
  `SCOPE_OF_WORK_ID` int(11) DEFAULT NULL,
  `OCCUPANCY_TYPE` varchar(50) DEFAULT NULL,
  `KIND_OF_SIGNAGE` varchar(50) DEFAULT NULL,
  `SIGNAGE_WORDINGS` varchar(50) DEFAULT NULL,
  `NO_STOREYS_BUILDING` varchar(50) DEFAULT NULL,
  `START_DATE_INSTALLATION` date DEFAULT NULL,
  `END_COMPLETION` date DEFAULT NULL,
  `OCT_TCT_NUMBER` varchar(50) DEFAULT NULL,
  `TAX_DECLARATION` varchar(50) DEFAULT NULL,
  `BUSINESS_AREA` varchar(50) DEFAULT NULL,
  `AREA_CLASSIFICATION` varchar(250) DEFAULT NULL,
  `PURPOSE` varchar(250) DEFAULT NULL,
  `D_DRIVER_LICENSE_NO` varchar(50) DEFAULT NULL,
  `D_MUDGUARD_NO` varchar(50) DEFAULT NULL,
  `D_CR_NO` varchar(50) DEFAULT NULL,
  `D_OR_NO` varchar(50) DEFAULT NULL,
  `FORM_ID` int(11) NOT NULL,
  `CREATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_bf_barangay_clearance`
--

INSERT INTO `t_bf_barangay_clearance` (`BARANGAY_CLEARANCE_ID`, `REGISTERED_NAME`, `APPLICANT_NAME`, `KIND_OF_BUSINESS`, `CONSTRUCTION_ADDRESS`, `PROJECT_LOCATION`, `SCOPE_OF_WORK_ID`, `OCCUPANCY_TYPE`, `KIND_OF_SIGNAGE`, `SIGNAGE_WORDINGS`, `NO_STOREYS_BUILDING`, `START_DATE_INSTALLATION`, `END_COMPLETION`, `OCT_TCT_NUMBER`, `TAX_DECLARATION`, `BUSINESS_AREA`, `AREA_CLASSIFICATION`, `PURPOSE`, `D_DRIVER_LICENSE_NO`, `D_MUDGUARD_NO`, `D_CR_NO`, `D_OR_NO`, `FORM_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(2, NULL, 'Irish Bolante Ricarte', NULL, '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '2019-10-16 21:22:36', NULL, 1),
(3, 'WBB Toy Shop', NULL, NULL, '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11, '2019-10-16 21:28:43', NULL, 1),
(4, NULL, 'Elah Aureus Andrada', NULL, 'L 13 Blk 167 Commonwealth Ave. Ext., Q.C.', '99999', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '99999', '99999', '300', '99999', '99999', NULL, NULL, NULL, NULL, 12, '2019-10-16 21:33:54', NULL, 1),
(5, 'AUE Daycare Center', 'Albert Kobe A. Andrada', NULL, 'Unit 509 Mf Tiaoqui Building, Plaza Sta Cruz, Sta. Cruz', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '88888888', '88888888', '88888888', '88888888', 13, '2019-10-16 21:37:57', NULL, 1),
(6, 'AUE Daycare Center', NULL, NULL, 'Unit 509 Mf Tiaoqui Building, Plaza Sta Cruz, Sta. Cruz', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'This tis thjfhak oisf', NULL, NULL, NULL, NULL, 14, '2019-10-16 21:43:12', NULL, 1),
(7, NULL, 'Irish Bolante Ricarte', NULL, '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, '2019-10-16 21:45:31', NULL, 1),
(8, 'SMAV Restaurant', NULL, NULL, 'Narra Building 4/F Unit 2276 Pasong Tamo Ext. Magallanes fa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Christmas Party Party', NULL, NULL, NULL, NULL, 18, '2019-10-23 16:52:41', NULL, 1),
(9, 'WBB Toy Shop', NULL, NULL, 'Shawshaw 15 Unit 1603 Shaw Blvd N / A fa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Halloween Party', NULL, NULL, NULL, NULL, 35, '2019-10-25 10:27:42', NULL, 1),
(10, NULL, 'Elah Aureus Andrada', NULL, 'Andrada 167 Unit 13 Commownealth Ave. Ext Lagro fas', '0987654321', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0987654321', '0987654321', '300', '0987654321', 'AKEA Upholstery', NULL, NULL, NULL, NULL, 36, '2019-10-25 18:28:30', NULL, 1),
(11, 'Daiso Japan Surplus', NULL, NULL, 'Molave Building 3 Unit 109 Don Chino', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41, '2019-10-30 21:39:46', NULL, 1),
(12, 'Simplicity Retail Store', NULL, NULL, 'Narra Building 7 Unit 90 Cuanso', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 42, '2019-10-30 21:42:53', NULL, 1),
(13, 'Bisekleta and Motorsiklo', NULL, NULL, 'Acasia Building 10 Unit 4 Molave Street', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 44, '2019-10-31 13:48:37', NULL, 1);

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

--
-- Dumping data for table `t_bf_business_activity`
--

INSERT INTO `t_bf_business_activity` (`BUSINESS_ACTIVITY_ID`, `LINE_OF_BUSINESS_ID`, `NO_OF_UNITS`, `CAPITALIZATION`, `GROSS_RECEIPTS_ESSENTIAL`, `GROSS_RECEIPTS_NON_ESSENTIAL`, `BUSINESS_ID`) VALUES
(2, 10, '2', 'f', 'fdsa', 'fdas', 65),
(3, 13, '2', 'fasfsda', NULL, NULL, 66),
(4, 18, '1', 'FD', NULL, NULL, 60),
(5, 5, NULL, NULL, NULL, NULL, 61),
(6, 15, '1', NULL, NULL, NULL, 62),
(7, 14, '5', NULL, NULL, NULL, 63),
(10, 16, '2', NULL, '21', '21', 71),
(11, 3, '2', '54332', NULL, NULL, 74),
(12, 3, '2', NULL, '987654', '8765', 75),
(13, 13, '2', NULL, '30000', '1000', 76),
(14, 5, '9', NULL, '20000', '1000', 77),
(15, 16, '1', '32132', NULL, NULL, 78),
(16, 16, '1', NULL, '24000', '1000', 79),
(17, 16, '2', '34321', NULL, NULL, 80),
(18, 16, '2', NULL, '49000', '1000', 81),
(19, 16, '1', '100000', NULL, NULL, 82),
(24, 5, '2', '543', NULL, NULL, 87),
(25, 16, '1', NULL, '54325', '43235', 88),
(26, 15, '1', NULL, '54325', '43235', 89);

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_business_permit`
--

CREATE TABLE `t_bf_business_permit` (
  `BUSINESS_PERMIT_ID` int(11) NOT NULL,
  `AMENDMENT_FROM` varchar(50) DEFAULT NULL,
  `AMENDMENT_TO` varchar(50) DEFAULT NULL,
  `IS_ENJOYING_TAZ_INCENTIVE` tinyint(4) DEFAULT NULL,
  `SPECIFY_REASON` varchar(50) DEFAULT NULL,
  `TAX_YEAR` varchar(50) DEFAULT NULL,
  `QUARTER` varchar(50) DEFAULT NULL,
  `BARANGAY_PERMIT` varchar(50) DEFAULT NULL,
  `BUSINESS_TAX` varchar(50) DEFAULT NULL,
  `GARBAGE_FEE` varchar(50) DEFAULT NULL,
  `SIGNBOARD` varchar(50) DEFAULT NULL,
  `CTC` varchar(50) DEFAULT NULL,
  `FORM_ID` int(11) NOT NULL,
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_bf_business_permit`
--

INSERT INTO `t_bf_business_permit` (`BUSINESS_PERMIT_ID`, `AMENDMENT_FROM`, `AMENDMENT_TO`, `IS_ENJOYING_TAZ_INCENTIVE`, `SPECIFY_REASON`, `TAX_YEAR`, `QUARTER`, `BARANGAY_PERMIT`, `BUSINESS_TAX`, `GARBAGE_FEE`, `SIGNBOARD`, `CTC`, `FORM_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(6, NULL, NULL, NULL, NULL, '2019', '43', '43', '43', '43', '43', '43', 15, '2019-10-16 21:43:36', NULL, 1),
(7, NULL, NULL, NULL, NULL, '2019', '999', '999', '999', '999', '999', '999', 17, '2019-10-22 13:24:18', NULL, 1),
(8, NULL, NULL, NULL, NULL, '2019', NULL, NULL, NULL, NULL, NULL, NULL, 38, '2019-10-29 23:48:09', NULL, 1),
(9, NULL, NULL, NULL, NULL, '2019', NULL, NULL, NULL, NULL, NULL, NULL, 39, '2019-10-29 23:52:28', NULL, 1),
(10, NULL, NULL, NULL, NULL, '2019', '999', '999', '999', '500', '999', '999', 40, '2019-10-30 21:23:46', NULL, 1),
(11, NULL, NULL, NULL, NULL, '2019', '500', '500', '500', '500', '500', '500', 43, '2019-10-31 13:44:09', NULL, 1),
(12, NULL, NULL, NULL, NULL, '2019', NULL, NULL, NULL, NULL, NULL, NULL, 45, '2019-11-06 17:19:36', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_bf_scope_of_work`
--

CREATE TABLE `t_bf_scope_of_work` (
  `SCOPE_OF_WORK_ID` int(11) NOT NULL,
  `SCOPE_OF_WORK_NAME` varchar(50) NOT NULL,
  `SCOPE_OF_WORK_SPECIFY` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_bf_scope_of_work`
--

INSERT INTO `t_bf_scope_of_work` (`SCOPE_OF_WORK_ID`, `SCOPE_OF_WORK_NAME`, `SCOPE_OF_WORK_SPECIFY`) VALUES
(3, 'Repair', 'Painting and no wordings'),
(4, 'Installation', 'Operating System');

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
  `NO_OF_PATAWAG` int(11) NOT NULL DEFAULT '0',
  `ACTIVE_FLAG` int(11) NOT NULL DEFAULT '1',
  `CREATED_AT` timestamp NULL DEFAULT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_blotter`
--

INSERT INTO `t_blotter` (`BLOTTER_ID`, `BLOTTER_SUBJECT_ID`, `USER_ID`, `BARANGAY_ID`, `BLOTTER_CODE`, `INCIDENT_DATE`, `INCIDENT_AREA`, `COMPLAINT_NAME`, `ACCUSED_RESIDENT`, `COMPLAINT_STATEMENT`, `RESOLUTION`, `COMPLAINT_DATE`, `CLOSED_DATE`, `STATUS`, `RESPONDENT`, `BLOTTER_SUBJECT`, `NO_OF_PATAWAG`, `ACTIVE_FLAG`, `CREATED_AT`, `UPDATED_AT`) VALUES
(12, NULL, NULL, NULL, 'BLOT-12', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'sample', '2019-09-23', '2019-11-18', 'For Referral', 'Glen', 'Missing person', 0, 1, NULL, NULL),
(13, NULL, NULL, NULL, 'BLOT-13', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'asg', '2019-09-23', '2019-11-18', 'Resolved', 'Glen', 'Missing person', 0, 1, NULL, NULL),
(14, NULL, NULL, NULL, 'BLOT-14', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'sample remark', '2019-09-23', '2019-11-18', 'For Referral', 'Glen', 'Missing person', 0, 1, NULL, NULL),
(15, NULL, NULL, NULL, 'BLOT-15', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'Walang solusyon', '2019-09-23', '2019-09-23', 'Pending', 'Glen', 'Missing person', 0, 1, NULL, NULL),
(16, NULL, NULL, NULL, 'BLOT-16', '2019-09-29', 'pup  quezon city', 'Jean', NULL, 'Naiwanan ko lang po saglit tapos nawala na siya.', 'Walang solusyon', '2019-09-23', '2019-09-23', 'Pending', 'Glen', 'Missing person', 0, 1, NULL, NULL);

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
(63, 63, 'Evaluated', 'Shiela Mae Velga', '2019-10-14 00:00:00'),
(64, 61, 'Evaluated', 'Elah A. Andrada', '2019-10-19 00:00:00'),
(65, 66, 'Evaluated', 'RYAN AUREUS', '2019-10-22 00:00:00'),
(66, 74, 'Evaluated', 'RYAN AUREUS', '2019-10-29 00:00:00'),
(67, 75, 'Evaluated', 'RYAN AUREUS', '2019-10-29 00:00:00'),
(68, 76, 'Evaluated', 'RYAN AUREUS', '2019-10-29 00:00:00'),
(69, 77, 'Evaluated', 'Shiela Mae Velga', '2019-10-29 00:00:00'),
(70, 78, 'Evaluated', 'RYAN AUREUS', '2019-10-30 00:00:00'),
(71, 79, 'Evaluated', 'RYAN AUREUS', '2019-10-30 00:00:00'),
(72, 80, 'Evaluated', 'Shiela Mae Velga', '2019-10-30 00:00:00'),
(73, 81, 'Evaluated', 'Shiela Mae Velga', '2019-10-30 00:00:00'),
(74, 82, 'Evaluated', 'Shiela Mae Velga', '2019-10-31 00:00:00'),
(75, 65, 'Evaluated', NULL, '2019-11-06 00:00:00'),
(76, 87, 'Evaluated', 'RYAN AUREUS', '2019-11-07 00:00:00'),
(77, 88, 'Evaluated', 'RYAN AUREUS', '2019-11-07 00:00:00'),
(78, 92, 'Evaluated', 'REDIYN.CABATANA', '2019-11-14 00:00:00'),
(79, 95, 'Evaluated', 'REDIYN.CABATANA', '2019-11-15 00:00:00');

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
  `BUILDING_NUMBER` varchar(50) DEFAULT NULL,
  `BUILDING_NAME` varchar(50) DEFAULT NULL,
  `UNIT_NO` varchar(50) DEFAULT NULL,
  `STREET` varchar(50) DEFAULT NULL,
  `SITIO` varchar(50) DEFAULT NULL,
  `SUBDIVISION` varchar(50) DEFAULT NULL,
  `BUSINESS_OR_NUMBER` varchar(50) DEFAULT NULL,
  `BUSINESS_OR_ACQUIRED_DATE` date DEFAULT NULL,
  `BARANGAY_ZONE_ID` int(11) DEFAULT NULL,
  `TIN_NO` varchar(50) DEFAULT NULL,
  `DTI_REGISTRATION_NO` varchar(50) DEFAULT NULL,
  `DTI_NO_DATE` date DEFAULT NULL,
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
  `NO_FEMALE_EMPLOYEE` int(11) DEFAULT NULL,
  `NO_MALE_EMPLOYEE` int(11) DEFAULT NULL,
  `NO_FEMALE_LGU` int(11) DEFAULT NULL,
  `NO_MALE_LGU` int(11) DEFAULT NULL,
  `LESSOR_NAME` varchar(150) DEFAULT NULL,
  `LESSOR_ADDRESS` varchar(150) DEFAULT NULL,
  `LESSOR_POSTAL` varchar(50) DEFAULT NULL,
  `LESSOR_CONTACT_NO` varchar(50) DEFAULT NULL,
  `LESSOR_TELEPHONE` varchar(50) DEFAULT NULL,
  `LESSOR_MOBILE_NO` varchar(50) DEFAULT NULL,
  `LESSOR_EMAIL_ADD` varchar(100) DEFAULT NULL,
  `MONTHLY_RENTAL` varchar(50) DEFAULT NULL,
  `REFERENCED_BUSINESS_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT NULL,
  `STATUS` varchar(50) DEFAULT NULL,
  `NEW_RENEW_STATUS` varchar(50) DEFAULT 'New'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_business_information`
--

INSERT INTO `t_business_information` (`BUSINESS_ID`, `BUSINESS_NAME`, `TRADE_NAME`, `BUSINESS_NATURE_ID`, `BUSINESS_OWNER_FIRSTNAME`, `BUSINESS_OWNER_MIDDLENAME`, `BUSINESS_OWNER_LASTNAME`, `BUSINESS_ADDRESS`, `BUILDING_NUMBER`, `BUILDING_NAME`, `UNIT_NO`, `STREET`, `SITIO`, `SUBDIVISION`, `BUSINESS_OR_NUMBER`, `BUSINESS_OR_ACQUIRED_DATE`, `BARANGAY_ZONE_ID`, `TIN_NO`, `DTI_REGISTRATION_NO`, `DTI_NO_DATE`, `TYPE_OF_BUSINESS`, `BUSINESS_POSTAL_CODE`, `BUSINESS_EMAIL_ADD`, `BUSINESS_TELEPHONE_NO`, `BUSINESS_MOBILE_NO`, `OWNER_ADDRESS`, `OWNER_POSTAL_CODE`, `OWNER_EMAIL_ADD`, `OWNER_TELEPHONE_NO`, `OWNER_MOBILE_NO`, `EMERGENCY_CONTACT_PERSON`, `EMERGENCY_PERSON_CONTACT_NO`, `EMERGENCY_PERSON_EMAIL_ADD`, `BUSINESS_AREA`, `NO_EMPLOYEE_ESTABLISHMENT`, `NO_EMPLOYEE_LGU`, `NO_FEMALE_EMPLOYEE`, `NO_MALE_EMPLOYEE`, `NO_FEMALE_LGU`, `NO_MALE_LGU`, `LESSOR_NAME`, `LESSOR_ADDRESS`, `LESSOR_POSTAL`, `LESSOR_CONTACT_NO`, `LESSOR_TELEPHONE`, `LESSOR_MOBILE_NO`, `LESSOR_EMAIL_ADD`, `MONTHLY_RENTAL`, `REFERENCED_BUSINESS_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `STATUS`, `NEW_RENEW_STATUS`) VALUES
(60, 'AKEA Upholstery', 'AKEA', 10, 'Elah', 'Aureus', 'Andrada', 'L 13 Blk 167 Commonwealth Ave. Ext., Q.C.', '167', 'Andrada', '13', 'Commownealth Ave. Ext', 'Lagro', 'fas', '2019032101', '2018-10-01', NULL, '99999-9999-9999  ', '4214431', NULL, 'Corporation', '1001', 'akea@gmail.com', '9863528', '09173926382', 'Lot 13 Blk 167 Commonwealth Ave. Ext.', '1001', 'elah@gmail.com', '926812', '09284658291', 'Albert T. Andrada', '09371837465', 'albert@gmail.com', '300', 2, 0, NULL, NULL, NULL, NULL, NULL, NULL, '5452', NULL, '876534', '5423636543', NULL, NULL, NULL, NULL, NULL, NULL, 'Approved', 'New'),
(61, 'SMAV Restaurant', 'SMAV', 1, 'Shiela Mae', 'Aureus', 'Velga', '4/F Narra Building 2276 Pasong Tamo ExtensionBrgy. Magallanes 1231', '4/F', 'Narra Building', '2276', 'Pasong Tamo Ext.', 'Magallanes', 'fa', '2019432232', '2019-10-01', NULL, '88888-8888-8888', '4324341', NULL, 'Partnership', '1000', 'smav@gmail.com', '4389294', '09237187238', '4/F Narra Building2276 Pasong Tamo ExtensionBrgy. Magallanes 1231', '1000', '', '037828', '09321987990', 'Albert Kobe A. Andrada', '09328723871', 'kobe@gmail.com', '350', 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, '54235', '0987654325', '0987654323123', '09876541234', NULL, NULL, NULL, NULL, NULL, NULL, 'Approved', 'New'),
(62, 'WBB Toy Shop', 'We Bare Bears', 10, 'Irish', 'Bolante', 'Ricarte', '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', '15', 'Shawshaw', '1603', 'Shaw Blvd', 'N / A', 'fa', '2019023803', '2019-01-01', NULL, '77777-7777-7777', '4320943', NULL, 'Partnership', '2009', 'wbb@gmail.com', '4923948', '09327812738', '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', '2009', 'irish@gmail.com', '984399', '09378277212', 'Joven C. Bolante', '08382787392', 'joven@gmail.com', '475', 3, 2, NULL, NULL, NULL, NULL, 'Liezl Vargas', '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', '5345', '0948392849', '76346534', '909877632', 'liezl@gmail.com', '25,000.00', NULL, NULL, NULL, NULL, 'Approved', 'New'),
(63, 'AUE Daycare Center', 'Andrada Uston Engr', 6, 'Ofelia', 'Cantillana', 'Aureus', 'Unit 509 Mf Tiaoqui Building, Plaza Sta Cruz, Sta. Cruz', '12', 'Tiaoqui', '509', 'Plaza Sta Cruz ', 'Sta. Cruz', 'fa', '2019090024', '2019-05-05', NULL, '66666-6666-6666', '4320092', NULL, 'Single', '2010', 'uae@gmail.com', '9473920', '09273846757', 'Unit 509 Mf Tiaoqui Building, Plaza Sta Cruz, Sta. Cruz', '2010', 'ofelia@gmail.com', '9739240', '091783837423', 'Leovigildo D. Aureus', '09367393942', 'leovigildo@gmail.com', '500', 7, 7, NULL, NULL, NULL, NULL, 'Angel Grace Hernandez', 'Pasong Putik, Zone 1 Seventh Sabath', '534', '6363726', '2332132', '09348731432', 'shiela@gmail.com', '54343', NULL, '2019-10-14 00:00:00', NULL, NULL, 'Approved', 'New'),
(65, 'fasfdsa', 'fdas', 3, 'fdasf', NULL, 'sdafsa', NULL, NULL, 'fdsa', NULL, 'fdas', 'fdsa', 'fas', 'fdas', NULL, NULL, NULL, NULL, NULL, 'Partnership', 'fdasfdas', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '9876', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5423542', NULL, '54352532', '0987645431', NULL, NULL, NULL, '2019-10-21 00:00:00', NULL, NULL, 'Declined', 'New'),
(66, 'GFSD', 'GFSD', 3, 'GS', NULL, 'GSD', NULL, '136', 'Andrada', '13', 'Commonwealth Ave. Ext.', 'Lagro', '', 'GDFSG', NULL, NULL, NULL, NULL, NULL, 'Partnership', 'fdsa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5432', NULL, NULL, NULL, NULL, NULL, NULL, 'dsaf', NULL, '5423', NULL, '876743', '098765421', NULL, NULL, NULL, '2019-10-21 00:00:00', NULL, NULL, 'Approved', 'New'),
(71, 'AKEA Upholstery', 'AKEA', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'XXXXX-XXXXX', NULL, NULL, '43124', '431431', NULL, 'Corporation', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '545', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5423', NULL, '09875654143', '0978634', NULL, NULL, 60, '2019-10-28 00:00:00', NULL, NULL, 'Pending', 'Renew'),
(73, 'AKEA Upholstery', 'AKEA', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Corporation', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5423', NULL, '98675625', '987562', NULL, NULL, 71, NULL, NULL, NULL, NULL, 'Renew'),
(74, 'Swifties Corned Beef', 'SWIFTIES', 3, 'Ryan', 'Aureus', 'Cantillana', NULL, '88', 'Annex', '9', 'Peso St.', NULL, NULL, '504932', '2019-10-16', NULL, '9889778698', '7987987', NULL, 'Corporation', '1118', 'r_aureus@yahoo.com', '09399033244', '09876543678', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', '1118', 'r_aureus@yahoo.com', '09399033244', '09876543678', 'Sevethian Esteban', '54390829138', 'SFd@gmail.cpom', '43', 2, 3, NULL, NULL, NULL, NULL, 'RYAN AUREUS', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', '5432', '09399033244', '09399033244', '09399033244', 'r_aureus@yahoo.com', '65323', NULL, '2019-10-29 00:00:00', NULL, NULL, 'Approved', NULL),
(75, 'Swifties Corned Beefs', 'SWIFTIES', 10, 'Ryan', 'Aureus', 'Cantillana', NULL, '88', 'Annex B', '9', 'Peso St.', NULL, NULL, '504932', NULL, NULL, '9889778698', '7987987', NULL, 'Corporation', '1118', 'r_aureus@yahoo.com', '09399033244', '09876543678', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', '1118', 'r_aureus@yahoo.com', '09399033244', '09876543678', 'Sevethian Esteban', '54390829138', 'SFd@gmail.cpom', '8768', 2, 3, NULL, NULL, NULL, NULL, 'RYAN AUREUS', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', '54235423', '09399033244', '9874536', '86537642645', 'r_aureus@yahoo.com', '65323', 74, '2019-10-29 00:00:00', NULL, NULL, 'Approved', 'Renew'),
(76, 'GFSDS', 'GFSDS', 5, 'Shiela Mae', 'Aureus', 'Velga', NULL, '136', 'Andrada', '13', 'Commonwealth Ave. Ext.', 'Lagro', NULL, 'GDFSG', NULL, NULL, '87652', '9876531', NULL, 'Partnership', 'fdsa', NULL, NULL, NULL, 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', '1118', 'r_aureus@yahoo.com', '09399033244', '09399033244', NULL, NULL, 'r_aureus@yahoo.com', '5432', NULL, NULL, NULL, NULL, NULL, NULL, 'RYAN AUREUS', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', NULL, '09399033244', NULL, NULL, 'r_aureus@yahoo.com', '5432', 66, '2019-10-29 00:00:00', NULL, NULL, 'Approved', 'Renew'),
(77, 'SMAV Restaurant', 'SMAV', 1, 'Shiela Mae', 'Aureus', 'Velga', NULL, '4/F', 'Narra Building', '2276', 'Pasong Tamo Ext.', 'Magallanes', 'fa', '2019432232', NULL, NULL, '88888-8888-8888', '4324341', NULL, 'Partnership', '1000', 'smav@gmail.com', '4389294', '09237187238', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', '1118', 'r_aureus@yahoo.com', '09399033244', '09321987990', 'Albert Kobe A. Andrada', '09328723871', 'r_aureus@yahoo.com', '350', 10, 1, NULL, NULL, NULL, NULL, 'RYAN AUREUS', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', NULL, '09399033244', NULL, NULL, 'r_aureus@yahoo.com', '7645', 61, '2019-10-29 00:00:00', NULL, NULL, 'Approved', 'Renew'),
(78, 'Daiso Japan Surplus', 'Daiso', 10, 'Francisco', 'Jocson', 'Basan', NULL, '3', 'Molave Building', '109', 'Don Chino', NULL, NULL, '100039-983', '2019-10-16', NULL, 'P99995389', '973721220', NULL, 'Single', '1118', 'terryfr@fishingoo.com', '09399033244', '868-0934', '3/F Molave Building 2231 Don Chino Roces Avenue 1200', '1118', 'terryfr@fishingoo.com', '868-0934', '09399033244', 'Shiela Mae Velga', '09105081128', 'shielavelga@yahoo.com', '200', 3, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-30 00:00:00', NULL, NULL, 'Approved', 'New'),
(79, 'Daiso Japan Surplus', 'Daiso', 11, 'Francisco', 'Jocson', 'Basan', NULL, '3', 'Molave Building', '109', 'Don Chino', NULL, NULL, '100039-983', NULL, NULL, 'P99995389', '973721220', NULL, 'Single', '1118', 'terryfr@fishingoo.com', '09399033244', '868-0934', '3/F Molave Building 2231 Don Chino Roces Avenue 1200', '1118', 'terryfr@fishingoo.com', '868-0934', '09399033244', 'Shiela Mae Velga', '09105081128', 'shielavelga@yahoo.com', '200', 3, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 78, '2019-10-30 00:00:00', NULL, NULL, 'Approved', 'Renew'),
(80, 'Simplicity Retail Store', 'Simplicity', 1, 'Francisco', 'Jocson', 'Basan', NULL, '7', 'Narra Building', '90', 'Cuanso', NULL, NULL, '100040-009', '2019-10-09', NULL, 'P56693835', '157427610', NULL, 'Single', '2201', 'wviolet@chammy.info', '09399033244', '09399033244', 'GGB Building, Pascor Drive', '1118', 'r_aureus@yahoo.com', '09399033244', '09399033244', 'Artura Maegan Mangurun Galleros', '852-7354to46/852-7328', 'r_aureus@yahoo.com', '432', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-30 00:00:00', NULL, NULL, 'Approved', 'New'),
(81, 'Simplicity Retail Store', 'Simplicity', 11, 'Francisco', 'Jocson', 'Basan', NULL, '7', 'Narra Building', '90', 'Cuanso', NULL, NULL, '100040-009', NULL, NULL, 'P56693835', '157427610', NULL, 'Single', '2201', 'wviolet@chammy.info', '09399033244', '09399033244', 'GGB Building, Pascor Drive', '1118', 'r_aureus@yahoo.com', '09399033244', '09399033244', 'Artura Maegan Mangurun Galleros', '852-7354to46/852-7328', 'r_aureus@yahoo.com', '432', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 80, '2019-10-30 00:00:00', NULL, NULL, 'Approved', 'Renew'),
(82, 'Bisekleta and Motorsiklo', 'Bisekleta and Motorsiklo Inc', 11, 'Bisekleta and Motorsiklo', NULL, ', Inc', NULL, '10', 'Acasia Building', '4', 'Molave Street', NULL, NULL, '98765-4532', '2019-10-31', NULL, '14866339', '134265562', NULL, 'Corporation', '1118', 'bisekletamortorsiklo@gmail.com', '8673456', '09843256543', '1540 San Marcelino Street Malate 1000', '1001', 'marianoaona@gmail.com', '9891234', '09867652345', 'Joselito Korey Maglikian Ouano', '09876546534', 'joselito@gmail.com', '300', 5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-31 00:00:00', NULL, NULL, 'Approved', 'New'),
(87, 'Safe and Sound', 'Safe and Sound', 4, 'RYAN', NULL, 'AUREUS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '65344', NULL, NULL, '987653', '9876542', NULL, 'Corporation', '1118', 'r_aureus@yahoo.com', '09399033244', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-11-07 00:00:00', NULL, NULL, 'Approved', 'New'),
(88, 'Bisekleta and Motorsiklo', 'Bisekleta and Motorsiklo Inc', 3, 'Bisekleta and Motorsiklo', NULL, ', Inc', NULL, '10', 'Acasia Building', '4', 'Molave Street', NULL, NULL, '98765-4532', NULL, NULL, '14866339', '134265562', NULL, 'Corporation', '1118', 'bisekletamortorsiklo@gmail.com', '8673456', '09843256543', '1540 San Marcelino Street Malate 1000', '1001', 'marianoaona@gmail.com', '9891234', '09867652345', 'Joselito Korey Maglikian Ouano', '09876546534', 'joselito@gmail.com', '300', 5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 82, '2019-11-07 00:00:00', NULL, NULL, 'Approved', 'Renew'),
(89, 'WBB Toy Shop', 'We Bare Bears', 11, 'Irish', 'Bolante', 'Ricarte', NULL, '15', 'Shawshaw', '1603', 'Shaw Blvd', 'N / A', 'fa', '2019023803', NULL, NULL, '77777-7777-7777', '4320943', NULL, 'Partnership', '2009', 'wbb@gmail.com', '4923948', '09327812738', '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', '2009', 'irish@gmail.com', '984399', '09378277212', 'Joven C. Bolante', '08382787392', 'joven@gmail.com', '475', 3, 2, NULL, NULL, NULL, NULL, 'Liezl Vargas', '15 Shaw Blvd., Brgy. San Antonio,  N / A 1603', NULL, '76346534', NULL, NULL, 'liezl@gmail.com', '25,000.00', 62, '2019-11-11 00:00:00', NULL, NULL, 'Pending', 'Renew'),
(91, 'VAMS School Supplies', 'VAMS', 11, 'Lara', 'Quigama', 'Rabago', NULL, '98', 'Molave', '30', 'Dollar Street', NULL, NULL, '5321-3122', NULL, NULL, '498323219', '394892379', NULL, 'Single', '1101', 'r_aureus@yahoo.com', '09399033244', '09786587907', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', '1118', 'r_aureus@yahoo.com', '09399033244', '0987627156717', 'S', 'RYAN AUREUS', 'r_aureus@yahoo.com', '751', NULL, NULL, NULL, NULL, NULL, NULL, 'RYAN AUREUS', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', NULL, '09399033244', NULL, NULL, 'shiela@gmail.com', '3213321', NULL, '2019-11-12 00:00:00', NULL, NULL, 'Pending', 'New'),
(92, 'Cindy\'s Candy Shop', 'Cindy', 11, 'Cindy', 'Gabriel', 'Laura', NULL, '9', 'Molave Bldg', '3', 'Sta. Cruz Street', NULL, NULL, '87654-4533', NULL, NULL, '08762189', '47238732', NULL, 'Single', '1001', 'ccandyshop@gmail.com', '9173910', '098765427', 'lot 16 blk 167 commonwealth ave ext greater lagro quezon city', '1118', 'cindy@gmail.co,', '09399033244', '09399033244', 'Ryan Aures', '85443451', 'ryan@gmail.com', '350', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-11-14 00:00:00', NULL, NULL, 'Approved', 'New'),
(93, 'Safe and Sound', 'Safe and Sound', 5, 'RYAN', NULL, 'AUREUS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '65344', NULL, NULL, '987653', '9876542', NULL, 'Corporation', '1118', 'r_aureus@yahoo.com', '09399033244', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 87, '2019-11-14 00:00:00', NULL, NULL, 'Pending', 'Renew'),
(94, 'AUE Daycare Center', 'Andrada Uston Engr', 8, 'Ofelia', 'Cantillana', 'Aureus', NULL, '12', 'Tiaoqui', '509', 'Plaza Sta Cruz', NULL, NULL, '2019090024', NULL, NULL, '66666-6666-6666', '4320092', NULL, 'Single', '2010', 'uae@gmail.com', '9473920', '09273846757', 'Unit 509 Mf Tiaoqui Building, Plaza Sta Cruz, Sta. Cruz', '2010', 'ofelia@gmail.com', '9739240', '091783837423', 'Leovigildo D. Aureus', '09367393942', 'leovigildo@gmail.com', '500', 7, 7, NULL, NULL, NULL, NULL, 'Angel Grace Hernandez', 'Pasong Putik, Zone 1 Seventh Sabath', NULL, '2332132', NULL, NULL, 'shiela@gmail.com', '54343', 63, '2019-11-14 00:00:00', NULL, NULL, 'Pending', 'Renew'),
(95, 'TS Merchandise', 'Taylor Swat', 11, 'Sheila', 'Olive', 'Taylor', NULL, '9', 'Singag', '26', 'Kisanto Street', NULL, NULL, '98765435', NULL, NULL, '897432', '5387437892', NULL, 'Single', '9002', 'ts@gmail.com', '9738292', '09237289103', 'L32 Blk 123 Commonwealth Ave., Tanay', '8400', 'taylor@gmail.com', '7658493', '09876543244', 'Polisto San Juan', '9865423', 'polisto@gmail.com', '543', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-11-15 00:00:00', NULL, NULL, 'Approved', 'New');

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
-- Table structure for table `t_clearance_certification`
--

CREATE TABLE `t_clearance_certification` (
  `CLEARANCE_CERTIFICATION_ID` int(11) NOT NULL,
  `CONTROL_NO` varchar(50) DEFAULT NULL,
  `ISSUED_DATE` datetime DEFAULT NULL,
  `OR_NO` varchar(50) DEFAULT NULL,
  `OR_DATE` datetime DEFAULT NULL,
  `OR_AMOUNT` varchar(50) DEFAULT NULL,
  `FORM_ID` int(11) DEFAULT NULL,
  `PAPER_TYPE_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_clearance_certification`
--

INSERT INTO `t_clearance_certification` (`CLEARANCE_CERTIFICATION_ID`, `CONTROL_NO`, `ISSUED_DATE`, `OR_NO`, `OR_DATE`, `OR_AMOUNT`, `FORM_ID`, `PAPER_TYPE_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(4, 'XXXX-XXX', '2019-10-16 00:00:00', 'r34234', '2019-10-16 00:00:00', '4312', 10, 15, '2019-10-17 02:05:17', NULL, 1),
(5, 'XXXX-XXX', '2019-10-16 00:00:00', '0001', '2019-10-16 00:00:00', '322', 12, 17, '2019-10-17 02:12:16', NULL, 1),
(6, 'XXXX-XXX', '2019-10-17 00:00:00', '43948', '2019-10-17 00:00:00', '500', 15, 14, '2019-10-17 12:26:13', NULL, 1),
(7, 'XXXX-XXX', '2019-10-22 00:00:00', '00089', '2019-10-22 00:00:00', '43', 16, 15, '2019-10-22 12:39:56', NULL, 1),
(8, 'XXXX-XXX', '2019-10-22 00:00:00', 'r34234', '2019-10-03 00:00:00', '4312', 13, 18, '2019-10-22 13:17:37', NULL, 1),
(9, 'XXXX-XXX', '2019-10-22 00:00:00', 'r34234', '2019-10-19 00:00:00', '4312', 17, 14, '2019-10-22 13:24:38', NULL, 1),
(10, 'XXXX-XXX', '2019-10-23 00:00:00', '0009', '2019-10-23 00:00:00', '500', 11, 16, '2019-10-23 16:00:21', NULL, 1),
(11, 'XXXX-XXX', '2019-10-23 00:00:00', '0001', '2019-10-23 00:00:00', '322', 18, 19, '2019-10-23 16:53:12', NULL, 1),
(12, 'XXXX-XXX', '2019-10-25 00:00:00', '0009', '2019-10-24 00:00:00', '322', 26, 22, '2019-10-25 14:19:21', NULL, 1),
(13, 'XXXX-XXX', '2019-10-25 00:00:00', '0987654', '2019-10-25 00:00:00', '09876543', 36, 17, '2019-10-25 18:30:12', NULL, 1),
(14, 'XXXX-XXX', '2019-10-25 00:00:00', '0001', '2019-10-25 00:00:00', '50', 33, 26, '2019-10-25 18:51:40', NULL, 1),
(15, 'XXXX-XXX', '2019-10-25 00:00:00', '0002', '2019-10-25 00:00:00', '50', 29, 25, '2019-10-25 18:52:24', NULL, 1),
(16, 'XXXX-XXX', '2019-10-25 00:00:00', '0003', '2019-10-25 00:00:00', '43', 27, 23, '2019-10-25 18:52:40', NULL, 1),
(17, 'XXXX-XXX', '2019-10-25 00:00:00', '0004', '2019-10-25 00:00:00', '43', 28, 24, '2019-10-25 18:52:58', NULL, 1),
(18, 'XXXX-XXX', '2019-10-25 00:00:00', '0005', '2019-10-25 00:00:00', '43', 34, 27, '2019-10-25 18:53:12', NULL, 1),
(19, 'XXXX-XXX', '2019-10-30 00:00:00', '008301', '2019-10-30 00:00:00', '1500', 40, 14, '2019-10-30 21:25:52', NULL, 1),
(20, 'XXXX-XXX', '2019-10-30 00:00:00', '0008109', '2019-10-30 00:00:00', '1500', 42, 16, '2019-10-30 21:44:46', NULL, 1),
(21, 'XXXX-XXX', '2019-10-31 00:00:00', '00128', '2019-10-31 00:00:00', '500', 43, 14, '2019-10-31 13:45:36', NULL, 1),
(22, 'XXXX-XXX', '2019-10-31 00:00:00', '000231', '2019-10-31 00:00:00', '500', 44, 16, '2019-10-31 13:49:41', NULL, 1),
(23, 'XXXX-XXX', '2019-11-15 00:00:00', NULL, '2019-11-15 00:00:00', NULL, 46, 27, '2019-11-15 19:40:20', NULL, 1);

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
-- Table structure for table `t_household_batch`
--

CREATE TABLE `t_household_batch` (
  `FAMILY_HEADER_ID` int(11) NOT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `t_household_batch`
--

INSERT INTO `t_household_batch` (`FAMILY_HEADER_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(853, '2019-10-26 03:19:52', '2019-10-26 03:19:52', 1),
(854, '2019-11-08 22:57:40', '2019-11-08 22:57:40', 1);

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
(1255, 'With Parents', 'Relatives', 'Concrete', NULL, NULL, 1, 7, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, '2019-10-10 21:15:25', NULL, NULL),
(1256, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-12 21:09:50', NULL, 1),
(1257, 'With Parents', 'Parents', NULL, NULL, NULL, NULL, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, '2019-10-25 18:22:08', NULL, 1),
(1258, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-26 03:10:09', NULL, 1),
(1259, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-26 03:11:35', NULL, 1),
(1260, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-26 03:11:43', NULL, 1),
(1261, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-26 03:13:49', NULL, 1),
(1262, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-26 03:15:13', NULL, 1),
(1263, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-26 03:15:54', NULL, 1),
(1264, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-26 03:17:42', NULL, 1),
(1265, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-10-26 03:19:52', NULL, 1),
(1266, NULL, 'Parents', NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, '2019-10-26 17:27:26', NULL, 1),
(1267, 'Owned', 'Parents', 'Concrete', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-11-08 22:57:40', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_household_members`
--

CREATE TABLE `t_household_members` (
  `FAMILY_INFORMATION_ID` int(11) NOT NULL,
  `FAMILY_HEADER_ID` int(11) DEFAULT NULL,
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `t_household_members`
--

INSERT INTO `t_household_members` (`FAMILY_INFORMATION_ID`, `FAMILY_HEADER_ID`, `RESIDENT_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(942, 853, 3857, '2019-10-26 03:19:52', NULL, 1),
(943, 853, 3858, '2019-10-26 03:19:52', NULL, 1),
(944, 853, 3859, '2019-10-26 03:19:52', NULL, 1),
(945, 854, 3861, '2019-11-08 22:57:40', NULL, 1),
(946, 854, 3862, '2019-11-08 22:57:40', NULL, 1),
(947, 854, 3786, NULL, NULL, 1);

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
  `ACTIVE_FLAG` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_hs_adolescent`
--

INSERT INTO `t_hs_adolescent` (`ADOLESCENT_ID`, `RESIDENT_ID`, `MMRTD_DATE`, `IS_REFERRED`, `DATE_OF_VISIT`, `REMARKS`, `CS_DIABETIC`, `CS_MATAAS_PRESYON`, `CS_CANCER`, `CS_BUKOL`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(3, 3837, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-12 21:09:50', NULL, 1),
(4, 3840, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:10:10', NULL, 1),
(5, 3842, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:11:35', NULL, 1),
(6, 3844, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:11:43', NULL, 1),
(7, 3846, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:13:49', NULL, 1),
(8, 3847, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:13:49', NULL, 1),
(9, 3849, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:15:13', NULL, 1),
(10, 3850, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:15:13', NULL, 1),
(11, 3852, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:15:54', NULL, 1),
(12, 3853, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:15:54', NULL, 1),
(13, 3855, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:17:42', NULL, 1),
(14, 3856, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:17:42', NULL, 1),
(15, 3858, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:19:52', NULL, 1),
(16, 3859, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-26 03:19:52', NULL, 1),
(17, 3862, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-11-08 22:57:40', NULL, 1);

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
  `DO_A` int(11) DEFAULT '0',
  `DO_B` int(11) DEFAULT '0',
  `DO_C` int(11) DEFAULT '0',
  `RESIDENT_ID` int(11) DEFAULT NULL,
  `INFANT_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT '1'
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

--
-- Dumping data for table `t_hs_chronic_cough`
--

INSERT INTO `t_hs_chronic_cough` (`CHRONIC_COUGH_ID`, `RESIDENT_ID`, `HAD_MORE_THAN_2_WEEKS`, `DATE_OF_VISIT`, `REMARKS`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `NONRESIDENT_ID`) VALUES
(1, 3823, 1, '2019-11-15 00:00:00', 'jj', '2019-11-15 00:00:00', NULL, 1, NULL),
(2, 3818, 0, '2019-11-15 00:00:00', NULL, '2019-11-15 00:00:00', NULL, 1, NULL),
(3, 3833, 1, '2019-11-19 00:00:00', 'jh', '2019-11-15 00:00:00', NULL, 1, NULL);

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

--
-- Dumping data for table `t_hs_chronic_disease`
--

INSERT INTO `t_hs_chronic_disease` (`CHRONIC_DISEASE_ID`, `RESIDENT_ID`, `CHRONIC_DISEASE_NAME`, `HAD_HIGH_FEVER`, `DATE_OF_VISIT`, `REMARKS`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(1, 3833, 'b', 1, '2019-11-13 00:00:00', 'nb', '2019-11-15 00:00:00', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_hs_elderly`
--

CREATE TABLE `t_hs_elderly` (
  `ELDERLY_ID` int(11) NOT NULL,
  `RESIDENT_ID` int(10) DEFAULT NULL,
  `HAD_FLUE_VACCINE` int(11) DEFAULT '0',
  `HAD_PNEUMOCCOCAL` int(11) DEFAULT '0',
  `REMARKS` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP
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
  `DO_A` tinyint(4) DEFAULT '0',
  `DO_B` tinyint(4) DEFAULT '0',
  `DO_C` tinyint(4) DEFAULT '0',
  `DO_D` tinyint(4) DEFAULT '0',
  `DO_E` tinyint(4) DEFAULT '0',
  `DO_F` tinyint(4) DEFAULT '0',
  `DO_G` tinyint(4) DEFAULT '0',
  `DO_H` tinyint(4) DEFAULT '0'
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
  `DO_A` tinyint(4) DEFAULT '0',
  `DO_B` tinyint(4) DEFAULT '0',
  `DO_C` tinyint(4) DEFAULT '0',
  `DO_D` tinyint(4) DEFAULT '0',
  `DO_E` tinyint(4) DEFAULT '0',
  `DO_F` tinyint(4) DEFAULT '0',
  `SOURCE_OF_SERVICE_RESERVED` varchar(100) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` int(11) DEFAULT '1',
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
  `DO_A` tinyint(4) DEFAULT '0',
  `DO_B` tinyint(4) DEFAULT '0',
  `DO_C` tinyint(4) DEFAULT '0',
  `DO_D` tinyint(4) DEFAULT '0',
  `DO_E` tinyint(4) DEFAULT '0',
  `DO_F` tinyint(4) DEFAULT '0',
  `DO_G` tinyint(4) DEFAULT '0',
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
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
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
  `ORDINANCE_DESCRIPTION` varchar(100) DEFAULT NULL,
  `ORDINANCE_REMARKS` varchar(50) DEFAULT NULL,
  `ORDINANCE_SANCTION` varchar(50) DEFAULT NULL,
  `ORDINANCE_AUTHOR` varchar(50) DEFAULT NULL,
  `FILE_NAME` varchar(50) NOT NULL DEFAULT 'NONE',
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE_FLAG` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_ordinance`
--

INSERT INTO `t_ordinance` (`ORDINANCE_ID`, `BARANGAY_OFFICIAL_ID`, `ORDINANCE_TITLE`, `ORDINANCE_DESCRIPTION`, `ORDINANCE_REMARKS`, `ORDINANCE_SANCTION`, `ORDINANCE_AUTHOR`, `FILE_NAME`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(7, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 02:11:00', '0000-00-00 00:00:00', 1),
(8, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:17:51', '0000-00-00 00:00:00', 1),
(9, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:18:57', '0000-00-00 00:00:00', 1),
(10, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:18:57', '0000-00-00 00:00:00', 1),
(11, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:46:37', '0000-00-00 00:00:00', 1),
(12, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:47:36', '0000-00-00 00:00:00', 1),
(13, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 13:47:38', '0000-00-00 00:00:00', 1),
(14, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 14:28:45', '0000-00-00 00:00:00', 1),
(15, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 14:28:45', '0000-00-00 00:00:00', 1),
(16, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 14:29:34', '0000-00-00 00:00:00', 1),
(17, NULL, 'SAMPLE ORDINACEN', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'SAMPLE', 'NONE', '2019-10-04 14:29:34', '0000-00-00 00:00:00', 1),
(18, NULL, 'My', 'jogn', 'jan', 'my sample', 'Juan', 'Capture.JPG', '2019-11-18 18:46:54', NULL, 1);

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
  `ACTIVE_FLAG` int(11) NOT NULL DEFAULT '1',
  `CREATED_AT` timestamp NULL DEFAULT NULL,
  `UPDATED_AT` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_patawag`
--

INSERT INTO `t_patawag` (`PATAWAG_ID`, `BLOTTER_ID`, `PATAWAG_SCHED_DATETIME`, `PATAWAG_SCHED_PLACE`, `STATUS`, `ACTIVE_FLAG`, `CREATED_AT`, `UPDATED_AT`) VALUES
(84, 15, '2222-02-22 01:01:00', 'sample', 'Pending', 1, NULL, NULL);

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
  `IS_RBI_COMPLETE` int(11) DEFAULT '0',
  `IS_MIC_COMPLETE` int(11) DEFAULT '0',
  `PROFILE_PICTURE` varchar(255) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `ACTIVE_FLAG` int(11) UNSIGNED DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_resident_basic_info`
--

INSERT INTO `t_resident_basic_info` (`RESIDENT_ID`, `HOUSEHOLD_ID`, `LASTNAME`, `MIDDLENAME`, `FIRSTNAME`, `ADDRESS_UNIT_NO`, `ADDRESS_PHASE`, `ADDRESS_BLOCK_NO`, `ADDRESS_HOUSE_NO`, `ADDRESS_STREET_NO`, `ADDRESS_STREET`, `ADDRESS_SUBDIVISION`, `ADDRESS_BUILDING`, `QUALIFIER`, `DATE_OF_BIRTH`, `PLACE_OF_BIRTH`, `SEX`, `CIVIL_STATUS`, `IS_OFW`, `OCCUPATION`, `WORK_STATUS`, `DATE_STARTED_WORKING`, `CITIZENSHIP`, `RELATION_TO_HOUSEHOLD_HEAD`, `DATE_OF_ARRIVAL`, `ARRIVAL_STATUS`, `IS_INDIGENOUS`, `CONTACT_NUMBER`, `TIN_NO`, `SSS_NO`, `GSIS_NO`, `EMAIL_ADDRESS`, `IS_REGISTERED_VOTER`, `EDUCATIONAL_ATTAINMENT`, `PERSONS STAYING IN THE HOUSHOLD`, `FROM_WHAT_COUNTRY`, `PLACE_OF_DELIVERY`, `BIRTH_ATTENDANT`, `FAMILY_VISITED`, `REASONFOR_VISIT`, `DISABILITY`, `PLACE_OF_SCHOOL`, `RELIGION`, `LOT_OWNERSHIP`, `TYPE_OF_DOCUMENT`, `ISSUED_DATE`, `WHERE_DOCUMENT_ISSUED`, `SKILLS_DEVELOPMENT_TRAINING`, `IS_RBI_COMPLETE`, `IS_MIC_COMPLETE`, `PROFILE_PICTURE`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`) VALUES
(3785, 1207, 'DUTERTE', 'BAUTISTA', 'RODEL', '146', 'Phase 1', NULL, '146', NULL, 'Oriole Street', NULL, NULL, 'JR', '2019-01-01', 'Tondo Manila', 'Male', 'Single', 1, 'None', 'Not Applicable', '1970-01-01', 'Filipino', 'Parents', '2019-01-01', 2, 1, '9187781278', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:22', '2019-10-10 21:15:22', 1),
(3786, 1208, 'CERVANTES', 'GONZALES', 'LEA MAE', '68', 'Phase 2', NULL, '68', NULL, 'Aspen Street', NULL, NULL, '', '1999-01-11', 'Polangui Albay', 'Female', 'Single', 0, 'Software Engineer', 'Employed', '2019-07-09', 'Filipino', 'Nonrelative', '2003-02-07', 2, 1, '9091232879', NULL, NULL, NULL, NULL, 0, 'College', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:22', '2019-10-10 21:15:22', 1),
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
(3835, 1255, 'VELGA', 'A', 'SHIELA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02', 'Commonwealth', 'Female', 'Married', 1, 'None', 'None', '1970-01-01', 'Filipino', 'Spouse', '2019-04-03', NULL, NULL, NULL, NULL, NULL, NULL, '43590', 0, 'Elementary School', NULL, 'Canada', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'avatar.png', '2019-10-10 21:15:25', '2019-10-10 21:15:25', 1),
(3836, 1256, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'JR', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, 'Data Analyst', 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-12 21:09:50', '2019-10-12 21:13:03', 1),
(3837, 1256, 'lagon', 'a', 'rome', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-12 21:09:50', '2019-10-12 21:09:50', 1),
(3838, 1257, 'Velga', 'Aureus', 'Shiela Mae', '5', 'None', NULL, '4', NULL, 'Commowealth Ave. Ext', '1', '1', NULL, '1999-05-06', 'Camarines  Sur, Bicol', 'Female', NULL, 1, 'None', 'Unemployed', '1970-01-01', 'Filipino', 'Head', '1970-01-01', 1, 1, '09295545885555', NULL, NULL, NULL, NULL, 1, 'Highschool Graduate', NULL, NULL, NULL, 'Nurse', 'House', 'Christmas', 'None', 'Quezon City', NULL, NULL, NULL, NULL, NULL, 'Documentation', 0, 0, NULL, '2019-10-25 18:22:08', '2019-10-25 18:22:08', 1),
(3839, 1258, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-26 03:10:09', '2019-10-26 03:10:09', 1),
(3840, 1258, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:10:09', '2019-10-26 03:10:09', 1),
(3841, 1259, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-26 03:11:35', '2019-10-26 03:11:35', 1),
(3842, 1259, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:11:35', '2019-10-26 03:11:35', 1),
(3843, 1260, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-26 03:11:43', '2019-10-26 03:11:43', 1),
(3844, 1260, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:11:43', '2019-10-26 03:11:43', 1),
(3845, 1261, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-26 03:13:49', '2019-10-26 03:13:49', 1),
(3846, 1261, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, NULL, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:13:49', '2019-10-26 03:13:49', 1),
(3847, 1261, 'DUTERTE', 'D', 'HOSPITAL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2014-03-13', 'Bayan', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Filipino', 'Daughter', '2019-10-16', NULL, 0, '91231231', NULL, NULL, NULL, NULL, NULL, 'High School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:13:49', '2019-10-26 03:13:49', 1),
(3848, 1262, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-26 03:15:13', '2019-10-26 03:15:13', 1),
(3849, 1262, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, NULL, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:15:13', '2019-10-26 03:15:13', 1),
(3850, 1262, 'DUTERTE', 'D', 'HOSPITAL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2014-03-13', 'Bayan', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Filipino', 'Daughter', '2019-10-16', NULL, 0, '91231231', NULL, NULL, NULL, NULL, NULL, 'High School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:15:13', '2019-10-26 03:15:13', 1),
(3851, 1263, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-26 03:15:54', '2019-10-26 03:15:54', 1),
(3852, 1263, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, NULL, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:15:54', '2019-10-26 03:15:54', 1),
(3853, 1263, 'DUTERTE', 'D', 'HOSPITAL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2014-03-13', 'Bayan', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Filipino', 'Daughter', '2019-10-16', NULL, 0, '91231231', NULL, NULL, NULL, NULL, NULL, 'High School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:15:54', '2019-10-26 03:15:54', 1),
(3854, 1264, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-26 03:17:42', '2019-10-26 03:17:42', 1),
(3855, 1264, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, NULL, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:17:42', '2019-10-26 03:17:42', 1),
(3856, 1264, 'DUTERTE', 'D', 'HOSPITAL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2014-03-13', 'Bayan', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Filipino', 'Daughter', '2019-10-16', NULL, 0, '91231231', NULL, NULL, NULL, NULL, NULL, 'High School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:17:42', '2019-10-26 03:17:42', 1),
(3857, 1265, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-10-26 03:19:52', '2019-10-26 03:19:52', 1),
(3858, 1265, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, NULL, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:19:52', '2019-10-26 03:19:52', 1),
(3859, 1265, 'DUTERTE', 'D', 'HOSPITAL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2014-03-13', 'Bayan', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Filipino', 'Daughter', '2019-10-16', NULL, 0, '91231231', NULL, NULL, NULL, NULL, NULL, 'High School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 03:19:52', '2019-10-26 03:19:52', 1),
(3860, 1266, 'Alejandria', NULL, 'Micha', NULL, 'Veterans', NULL, '249', NULL, 'Oriloe', '1', NULL, NULL, '1997-05-15', 'Tondo manila', 'Female', NULL, NULL, 'Dev', 'Employed', '2016-05-15', 'Filipino', 'Head', '1970-01-01', 1, NULL, '1', NULL, NULL, NULL, NULL, 0, 'College Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Pup', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-10-26 17:27:26', '2019-10-26 17:27:26', 1),
(3861, 1267, 'DUTERTE', 'B', 'RODEL', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Tondo Manila', 'Male', 'Single', 0, NULL, 'NotApplicable', NULL, 'Filipino', 'Head', '2001-02-03', 1, 0, '9223441629', NULL, NULL, NULL, NULL, 0, 'Elementary School Graduate', NULL, NULL, 'home', 'doctor', 'government hospital', 'injured', 'blind', 'Veterans', 'Catholic', 'Owned', NULL, NULL, NULL, 'IT related', 0, 0, NULL, '2019-11-08 22:57:40', '2019-11-08 22:57:40', 1),
(3862, 1267, 'LAGON', 'A', 'ROME', NULL, 'Sitio Veterans', NULL, '123', NULL, 'Area 2 Oriole Street', NULL, NULL, 'jr', '2001-02-03', 'Caloocan City', 'Male', 'Single', NULL, NULL, 'NotApplicable', NULL, 'Visaya', 'Spouse', NULL, NULL, 0, '9223441650', NULL, NULL, NULL, NULL, NULL, 'Elementary School Graduate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2019-11-08 22:57:40', '2019-11-08 22:57:40', 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_solo_parent_children`
--

CREATE TABLE `t_solo_parent_children` (
  `CHILD_ID` int(11) NOT NULL,
  `CHILD_NAME` varchar(250) DEFAULT NULL,
  `CHILD_AGE` varchar(50) DEFAULT NULL,
  `IS_PWD` varchar(4) DEFAULT NULL,
  `BARANGAY_CERTIFICATION_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_AT` datetime DEFAULT NULL,
  `ACTIVE_FLAG` tinyint(4) DEFAULT '1',
  `CHILD_NAME_2` varchar(250) DEFAULT ' ',
  `CHILD_AGE_2` varchar(50) DEFAULT ' ',
  `IS_PWD_2` varchar(4) DEFAULT ' '
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_solo_parent_children`
--

INSERT INTO `t_solo_parent_children` (`CHILD_ID`, `CHILD_NAME`, `CHILD_AGE`, `IS_PWD`, `BARANGAY_CERTIFICATION_ID`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `CHILD_NAME_2`, `CHILD_AGE_2`, `IS_PWD_2`) VALUES
(1, 'Kobe', '7', 'No', 6, '2019-10-24 00:19:59', '0000-00-00 00:00:00', 1, ' ', ' ', ' ');

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
  `PERMIS_APPLICATION_FORM` int(11) DEFAULT NULL,
  `PERMIS_APPLICATION_FORM_EVALUATION` int(11) DEFAULT NULL,
  `REMEMBER_TOKEN` varchar(50) DEFAULT NULL,
  `IS_FIRST_LOGGED_IN` tinyint(1) NOT NULL DEFAULT '1',
  `CREATED_AT` datetime DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE_FLAG` int(11) DEFAULT NULL,
  `PERMIS_BUSINESS_APPROVAL` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `t_users`
--

INSERT INTO `t_users` (`USER_ID`, `BARANGAY_ID`, `BARANGAY_OFFICIAL_ID`, `POSITION_ID`, `FIRSTNAME`, `MIDDLENAME`, `LASTNAME`, `USERNAME`, `EMAIL`, `EMAIL_VERIFIED_AT`, `PASSWORD`, `SECRET_QUESTION`, `SECRET_ANSWER`, `PERMIS_RESIDENT_BASIC_INFO`, `PERMIS_FAMILY_PROFILE`, `PERMIS_COMMUNITY_PROFILE`, `PERMIS_BARANGAY_OFFICIAL`, `PERMIS_BUSINESSES`, `PERMIS_ISSUANCE_OF_FORMS`, `PERMIS_ORDINANCES`, `PERMIS_BLOTTER`, `PERMIS_PATAWAG`, `PERMIS_SYSTEM_REPORT`, `PERMIS_HEALTH_SERVICES`, `PERMIS_DATA_MIGRATION`, `PERMIS_USER_ACCOUNTS`, `PERMIS_BARANGAY_CONFIG`, `PERMIS_APPLICATION_FORM`, `PERMIS_APPLICATION_FORM_EVALUATION`, `REMEMBER_TOKEN`, `IS_FIRST_LOGGED_IN`, `CREATED_AT`, `UPDATED_AT`, `ACTIVE_FLAG`, `PERMIS_BUSINESS_APPROVAL`) VALUES
(31, 1, NULL, 6, 'Duterte', 'B', 'Rodel', 'admin', 'rodlduterteb@gmail.com', NULL, '$2y$10$ECCjsDobkDgWIeJlFWoAu.ldE7oTYpgoDLgVogI2USzSZkdvuZ9Mu', 'null', 'nulllang', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, '', 0, '2019-08-02 17:18:40', NULL, 1, 0),
(57, NULL, 37, 36, NULL, NULL, NULL, 'REDIYN.CABATANA', 'rdoel@gmail.com', NULL, '$2y$10$Gt.R7OPcvI2peRQ3U69CZudFWP563.dO027cWFWXiQdCJdcMPujWC', NULL, NULL, 1, 1, NULL, NULL, 0, 1, 1, 1, 1, 1, 1, NULL, NULL, NULL, 1, 1, NULL, 0, '2019-10-11 17:24:45', NULL, 1, 1),
(59, NULL, 39, 37, NULL, NULL, NULL, 'LEAMAE.CERVANTES', 'leah@gmail.com', NULL, '$2y$10$hoaJkEiS69HN.QVjs.ZIeeqIqvyNcjJWjVkwLXZWpa/zQoRj2O1J6', NULL, NULL, 1, 1, NULL, NULL, 1, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, 1, 0, NULL, 0, '2019-10-11 19:59:18', NULL, 1, 0),
(60, NULL, 40, 38, NULL, NULL, NULL, 'JOHNNORRY.YACAP', 'yacap@gmail.com', NULL, '$2y$10$2aqQMB2vO/5lxoHW6IWmTubRILbxlsbbXrUsFA8g3I8V4SPp2VoSG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 0, '2019-10-16 18:22:13', NULL, 1, NULL),
(61, NULL, 41, 39, NULL, NULL, NULL, 'JOHN.GADEN', 'gaden@gmail.com', NULL, '$2y$10$NGpFQ1Y9a2XJy.AtP6kckukDsoehjN/RPaUSB21WSAxwf7nW4b8Z.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '2019-10-16 19:05:48', NULL, 1, NULL),
(62, NULL, 42, 35, NULL, NULL, NULL, 'ShielaMae.Velga', 'smav@gmail.com', NULL, '$2y$10$6yh4ScBsSyxAzUhYOqjdQeNthPwEeyfCBMVxb7y7yQ7njIDuim5AK', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '2019-10-26 02:58:16', NULL, 1, NULL);

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
-- Stand-in structure for view `v_application_form_resident`
-- (See below for the actual view)
--
CREATE TABLE `v_application_form_resident` (
`RESIDENT_ID` int(11)
,`RESIDENT_NAME` varchar(152)
,`SEX` varchar(50)
,`CIVIL_STATUS` varchar(25)
,`AGE` bigint(21)
,`DATE_OF_BIRTH` date
,`ADDRESS` varchar(310)
,`STATUS` varchar(20)
,`FORM_ID` int(11)
,`REQUESTED_PAPER_TYPE` varchar(100)
,`FORM_PAPER_TYPE` varchar(100)
,`REQUESTED_PAPER_TYPE_ID` int(11)
,`PAPER_TYPE_ID` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_approved_application_form`
-- (See below for the actual view)
--
CREATE TABLE `v_approved_application_form` (
`BUSINESS_ID` int(11)
,`BUSINESS_NAME` varchar(50)
,`TRADE_NAME` varchar(50)
,`BUSINESS_OWNER_FIRSTNAME` varchar(150)
,`BUSINESS_OWNER_MIDDLENAME` varchar(50)
,`BUSINESS_OWNER_LASTNAME` varchar(50)
,`BUSINESS_ADDRESS` varchar(310)
,`BUSINESS_OR_NUMBER` varchar(50)
,`BUSINESS_OR_ACQUIRED_DATE` date
,`TIN_NO` varchar(50)
,`DTI_REGISTRATION_NO` varchar(50)
,`BUSINESS_POSTAL_CODE` varchar(50)
,`BUSINESS_EMAIL_ADD` varchar(100)
,`BUSINESS_TELEPHONE_NO` varchar(50)
,`BUSINESS_AREA` varchar(50)
,`BUSINESS_NATURE_NAME` varchar(100)
,`BUSINESS_PERIOD_YEAR` bigint(21)
,`BUSINESS_PERIOD_MONTH` bigint(21)
,`STATUS` varchar(20)
,`FORM_ID` int(11)
,`REQUESTED_PAPER_TYPE` varchar(100)
,`FORM_PAPER_TYPE` varchar(100)
,`REQUESTED_PAPER_TYPE_ID` int(11)
,`PAPER_TYPE_ID` int(11)
,`FORM_DATE` date
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_approved_business`
-- (See below for the actual view)
--
CREATE TABLE `v_approved_business` (
`BUSINESS_ID` int(11)
,`BUSINESS_NAME` varchar(50)
,`TRADE_NAME` varchar(50)
,`BUSINESS_OWNER_FIRSTNAME` varchar(150)
,`BUSINESS_OWNER_MIDDLENAME` varchar(50)
,`BUSINESS_OWNER_LASTNAME` varchar(50)
,`BUSINESS_ADDRESS` varchar(310)
,`BUSINESS_OR_NUMBER` varchar(50)
,`BUSINESS_OR_ACQUIRED_DATE` date
,`TIN_NO` varchar(50)
,`DTI_REGISTRATION_NO` varchar(50)
,`BUSINESS_POSTAL_CODE` varchar(50)
,`BUSINESS_EMAIL_ADD` varchar(100)
,`BUSINESS_TELEPHONE_NO` varchar(50)
,`BUSINESS_AREA` varchar(50)
,`BUSINESS_NATURE_NAME` varchar(100)
,`BUSINESS_PERIOD_YEAR` bigint(21)
,`BUSINESS_PERIOD_MONTH` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_barangay_certificate`
-- (See below for the actual view)
--
CREATE TABLE `v_barangay_certificate` (
`RESIDENT_ID` int(11)
,`RESIDENT_NAME` varchar(152)
,`SEX` varchar(50)
,`SEX_ADDRESS` varchar(3)
,`CIVIL_STATUS` varchar(25)
,`AGE` bigint(21)
,`DATE_OF_BIRTH` date
,`ADDRESS` varchar(310)
,`CONTROL_NO` varchar(50)
,`ISSUED_DATE` datetime
,`OR_NO` varchar(50)
,`OR_DATE` datetime
,`OR_AMOUNT` varchar(50)
,`PAPER_TYPE_NAME` varchar(100)
,`FORM_ID` int(11)
,`REQUESTOR_NAME` varchar(250)
,`SSS_NO` varchar(50)
,`CALAMITY_NAME` varchar(100)
,`CALAMITY_DATE` date
,`COUNTRY` varchar(100)
,`CATEGORY_SINGLE_PARENT` varchar(100)
,`PURPOSE` varchar(500)
,`CHILD_NAME` varchar(250)
,`CHILD_AGE` varchar(50)
,`IS_PWD` varchar(4)
,`CHILD_NAME_2` varchar(250)
,`CHILD_AGE_2` varchar(50)
,`IS_PWD_2` varchar(4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_barangay_clearance`
-- (See below for the actual view)
--
CREATE TABLE `v_barangay_clearance` (
`BUSINESS_OWNER` varchar(252)
,`BUSINESS_ADDRESS` varchar(310)
,`CONTROL_NO` varchar(50)
,`ISSUED_DATE` datetime
,`OR_NO` varchar(50)
,`OR_DATE` datetime
,`OR_AMOUNT` varchar(50)
,`PAPER_TYPE_NAME` varchar(100)
,`FORM_ID` int(11)
,`BUSINESS_NAME` varchar(50)
,`PROJECT_NAME` varchar(104)
,`PROJECT_LOCATION` varchar(250)
,`LINE_OF_BUSINESS_NAME` varchar(50)
,`OCT_TCT_NUMBER` varchar(50)
,`TAX_DECLARATION` varchar(50)
,`BUSINESS_AREA` varchar(50)
,`AREA_CLASSIFICATION` varchar(250)
,`PURPOSE` varchar(250)
,`D_DRIVER_LICENSE_NO` varchar(50)
,`D_MUDGUARD_NO` varchar(50)
,`D_CR_NO` varchar(50)
,`D_OR_NO` varchar(50)
,`APPLICANT_NAME` varchar(250)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_business_information`
-- (See below for the actual view)
--
CREATE TABLE `v_business_information` (
`BUSINESS_ID` int(11)
,`BUSINESS_NAME` varchar(50)
,`TRADE_NAME` varchar(50)
,`BUSINESS_OWNER` varchar(252)
,`BUSINESS_OWNER_FIRSTNAME` varchar(150)
,`BUSINESS_OWNER_MIDDLENAME` varchar(50)
,`BUSINESS_OWNER_LASTNAME` varchar(50)
,`BUSINESS_ADDRESS` varchar(310)
,`BUILDING_NAME` varchar(50)
,`BUILDING_NUMBER` varchar(50)
,`UNIT_NO` varchar(50)
,`STREET` varchar(50)
,`SITIO` varchar(50)
,`SUBDIVISION` varchar(50)
,`BUSINESS_OR_NUMBER` varchar(50)
,`BUSINESS_OR_ACQUIRED_DATE` date
,`BARANGAY_ZONE_ID` int(11)
,`TIN_NO` varchar(50)
,`DTI_REGISTRATION_NO` varchar(50)
,`TYPE_OF_BUSINESS` varchar(50)
,`BUSINESS_POSTAL_CODE` varchar(50)
,`BUSINESS_EMAIL_ADD` varchar(100)
,`BUSINESS_TELEPHONE_NO` varchar(50)
,`BUSINESS_MOBILE_NO` varchar(50)
,`OWNER_ADDRESS` varchar(150)
,`OWNER_POSTAL_CODE` varchar(50)
,`OWNER_EMAIL_ADD` varchar(100)
,`OWNER_TELEPHONE_NO` varchar(50)
,`OWNER_MOBILE_NO` varchar(50)
,`EMERGENCY_CONTACT_PERSON` varchar(150)
,`EMERGENCY_PERSON_CONTACT_NO` varchar(50)
,`EMERGENCY_PERSON_EMAIL_ADD` varchar(50)
,`BUSINESS_AREA` varchar(50)
,`NO_EMPLOYEE_ESTABLISHMENT` int(11)
,`NO_EMPLOYEE_LGU` int(11)
,`LESSOR_NAME` varchar(150)
,`LESSOR_ADDRESS` varchar(150)
,`LESSOR_POSTAL` varchar(50)
,`LESSOR_CONTACT_NO` varchar(50)
,`LESSOR_TELEPHONE` varchar(50)
,`LESSOR_MOBILE_NO` varchar(50)
,`LESSOR_EMAIL_ADD` varchar(100)
,`MONTHLY_RENTAL` varchar(50)
,`REFERENCED_BUSINESS_ID` int(11)
,`NO_OF_UNITS` varchar(50)
,`STATUS` varchar(50)
,`NEW_RENEW_STATUS` varchar(50)
,`CAPITALIZATION` varchar(50)
,`GROSS_RECEIPTS_ESSENTIAL` varchar(50)
,`GROSS_RECEIPTS_NON_ESSENTIAL` varchar(50)
,`LINE_OF_BUSINESS_NAME` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_business_nature`
-- (See below for the actual view)
--
CREATE TABLE `v_business_nature` (
`BUSINESS_NATURE_ID` int(11)
,`BUSINESS_NATURE_NAME` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_business_permit`
-- (See below for the actual view)
--
CREATE TABLE `v_business_permit` (
`BUSINESS_NAME` varchar(50)
,`BUSINESS_ADDRESS` varchar(310)
,`BUSINESS_NATURE_NAME` varchar(50)
,`TAX_YEAR` varchar(50)
,`QUARTER` varchar(50)
,`OR_NO` varchar(50)
,`OR_AMOUNT` varchar(50)
,`OR_DATE` date
,`BARANGAY_PERMIT` varchar(50)
,`BUSINESS_TAX` varchar(50)
,`GARBAGE_FEE` varchar(50)
,`SIGNBOARD` varchar(50)
,`CTC` varchar(50)
,`FORM_ID` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_declined_application_form`
-- (See below for the actual view)
--
CREATE TABLE `v_declined_application_form` (
`BUSINESS_ID` int(11)
,`BUSINESS_NAME` varchar(50)
,`TRADE_NAME` varchar(50)
,`BUSINESS_OWNER_FIRSTNAME` varchar(150)
,`BUSINESS_OWNER_MIDDLENAME` varchar(50)
,`BUSINESS_OWNER_LASTNAME` varchar(50)
,`BUSINESS_ADDRESS` varchar(310)
,`BUSINESS_OR_NUMBER` varchar(50)
,`BUSINESS_OR_ACQUIRED_DATE` date
,`TIN_NO` varchar(50)
,`DTI_REGISTRATION_NO` varchar(50)
,`BUSINESS_POSTAL_CODE` varchar(50)
,`BUSINESS_EMAIL_ADD` varchar(100)
,`BUSINESS_TELEPHONE_NO` varchar(50)
,`BUSINESS_AREA` varchar(50)
,`BUSINESS_NATURE_NAME` varchar(100)
,`BUSINESS_PERIOD_YEAR` bigint(21)
,`BUSINESS_PERIOD_MONTH` bigint(21)
,`STATUS` varchar(20)
,`FORM_ID` int(11)
,`REQUESTED_PAPER_TYPE` varchar(100)
,`FORM_PAPER_TYPE` varchar(100)
,`REQUESTED_PAPER_TYPE_ID` int(11)
,`PAPER_TYPE_ID` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_declined_business`
-- (See below for the actual view)
--
CREATE TABLE `v_declined_business` (
`BUSINESS_ID` int(11)
,`BUSINESS_NAME` varchar(50)
,`TRADE_NAME` varchar(50)
,`BUSINESS_OWNER_FIRSTNAME` varchar(150)
,`BUSINESS_OWNER_MIDDLENAME` varchar(50)
,`BUSINESS_OWNER_LASTNAME` varchar(50)
,`BUSINESS_ADDRESS` varchar(310)
,`BUSINESS_OR_NUMBER` varchar(50)
,`BUSINESS_OR_ACQUIRED_DATE` date
,`TIN_NO` varchar(50)
,`DTI_REGISTRATION_NO` varchar(50)
,`BUSINESS_POSTAL_CODE` varchar(50)
,`BUSINESS_EMAIL_ADD` varchar(100)
,`BUSINESS_TELEPHONE_NO` varchar(50)
,`BUSINESS_NATURE_NAME` varchar(100)
,`BUSINESS_PERIOD_YEAR` bigint(21)
,`BUSINESS_PERIOD_MONTH` bigint(21)
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
-- Stand-in structure for view `v_household_information`
-- (See below for the actual view)
--
CREATE TABLE `v_household_information` (
`HOUSEHOLD_ID` int(11)
,`FULLNAME` varchar(152)
,`HOME_OWNERSHIP` varchar(50)
,`PERSON_STAYING_IN_HOUSEHOLD` varchar(50)
,`HOME_MATERIALS` varchar(10)
,`LASTNAME` varchar(50)
,`FIRSTNAME` varchar(50)
,`MIDDLENAME` varchar(50)
,`TOILET_HOME` int(11)
,`PLAY_AREA_HOME` int(11)
,`BEDROOM_HOME` int(11)
,`DINING_ROOM_HOME` int(11)
,`SALA_HOME` int(11)
,`KITCHEN_HOME` int(11)
,`WATER_UTILITIES` int(11)
,`ELECTRICITY_UTILITIES` int(11)
,`AIRCON_UTILITIES` int(11)
,`PHONE_UTILITIES` int(11)
,`COMPUTER_UTILITIES` int(11)
,`INTERNET_UTILITIES` int(11)
,`TV_UTILITIES` int(11)
,`CD_PLAYER_UTILITIES` int(11)
,`RADIO_UTILITIES` int(11)
,`COMICS_ENTERTAINMENT` int(11)
,`NEWS_PAPER_ENTERTAINMENT` int(11)
,`PETS_ENTERTAINMENT` int(11)
,`BOOKS_ENTERTAINMENT` int(11)
,`STORY_BOOKS_ENTERTAINMENT` int(11)
,`TOYS_ENTERTAINMENT` int(11)
,`BOARD_GAMES_ENTERTAINMENT` int(11)
,`PUZZLES_ENTERTAINMENT` int(11)
,`NUMBER_OF_ROOMS` int(11)
,`FAMILY_HEADER_ID` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_line_of_business`
-- (See below for the actual view)
--
CREATE TABLE `v_line_of_business` (
`LINE_OF_BUSINESS_ID` int(11)
,`LINE_OF_BUSINESS_NAME` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_official_business_list`
-- (See below for the actual view)
--
CREATE TABLE `v_official_business_list` (
`BUSINESS_ID` int(11)
,`BUSINESS_NAME` varchar(50)
,`TRADE_NAME` varchar(50)
,`BUSINESS_OWNER_FIRSTNAME` varchar(150)
,`BUSINESS_OWNER_MIDDLENAME` varchar(50)
,`BUSINESS_OWNER_LASTNAME` varchar(50)
,`BUSINESS_ADDRESS` varchar(310)
,`BUSINESS_OR_NUMBER` varchar(50)
,`BUSINESS_OR_ACQUIRED_DATE` date
,`TIN_NO` varchar(50)
,`DTI_REGISTRATION_NO` varchar(50)
,`BUSINESS_POSTAL_CODE` varchar(50)
,`BUSINESS_EMAIL_ADD` varchar(100)
,`BUSINESS_TELEPHONE_NO` varchar(50)
,`BUSINESS_AREA` varchar(50)
,`BUSINESS_PERIOD_YEAR` bigint(21)
,`BUSINESS_PERIOD_MONTH` bigint(21)
,`LINE_OF_BUSINESS_NAME` varchar(50)
,`STATUS` varchar(50)
,`NEW_RENEW_STATUS` varchar(50)
,`REFERENCED_BUSINESS_ID` int(11)
,`GROSS_RECEIPTS_ESSENTIAL` varchar(50)
,`GROSS_RECEIPTS_NON_ESSENTIAL` varchar(50)
,`BUSINESS_NATURE_NAME` varchar(100)
,`GROSS_RECEIPT_TOTAL` bigint(51) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_paper_type`
-- (See below for the actual view)
--
CREATE TABLE `v_paper_type` (
`PAPER_TYPE_ID` int(11)
,`PAPER_TYPE_NAME` varchar(100)
,`PAPER_TYPE_CATEGORY` varchar(100)
,`PAPER_TYPE_DECRIPTION` varchar(250)
,`CREATED_AT` datetime
,`UPDATED_AT` datetime
,`ACTIVE_FLAG` tinyint(4)
,`PAPER_TYPE_CODE` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_pending_application_form`
-- (See below for the actual view)
--
CREATE TABLE `v_pending_application_form` (
`BUSINESS_ID` int(11)
,`BUSINESS_NAME` varchar(50)
,`TRADE_NAME` varchar(50)
,`BUSINESS_OWNER_FIRSTNAME` varchar(150)
,`BUSINESS_OWNER_MIDDLENAME` varchar(50)
,`BUSINESS_OWNER_LASTNAME` varchar(50)
,`BUSINESS_ADDRESS` varchar(310)
,`BUSINESS_OR_NUMBER` varchar(50)
,`BUSINESS_OR_ACQUIRED_DATE` date
,`TIN_NO` varchar(50)
,`DTI_REGISTRATION_NO` varchar(50)
,`BUSINESS_POSTAL_CODE` varchar(50)
,`BUSINESS_EMAIL_ADD` varchar(100)
,`BUSINESS_TELEPHONE_NO` varchar(50)
,`BUSINESS_AREA` varchar(50)
,`BUSINESS_NATURE_NAME` varchar(100)
,`BUSINESS_PERIOD_YEAR` bigint(21)
,`BUSINESS_PERIOD_MONTH` bigint(21)
,`STATUS` varchar(20)
,`FORM_ID` int(11)
,`REQUESTED_PAPER_TYPE` varchar(100)
,`FORM_PAPER_TYPE` varchar(100)
,`REQUESTED_PAPER_TYPE_ID` int(11)
,`PAPER_TYPE_ID` int(11)
,`FORM_DATE` date
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
,`PERMIS_APPLICATION_FORM` int(11)
,`PERMIS_APPLICATION_FORM_EVALUATION` int(11)
,`ACTIVE_FLAG` int(11)
,`BARANGAY_SEAL` varchar(150)
,`MUNICIPAL_SEAL` varchar(50)
,`MUNICIPAL_NAME` varchar(50)
,`PROVINCE_NAME` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_resident`
-- (See below for the actual view)
--
CREATE TABLE `v_resident` (
`RESIDENT_ID` int(11)
,`RESIDENT_NAME` varchar(152)
,`ADDRESS` varchar(311)
,`DATE_OF_BIRTH` date
,`SEX` varchar(50)
,`IS_OFW` int(11)
,`CIVIL_STATUS` varchar(25)
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
,`IS_FIRST_LOGGED_IN` tinyint(1)
,`USER_ID` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `v_adminaccount`
--
DROP TABLE IF EXISTS `v_adminaccount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_adminaccount`  AS  select `u`.`USER_ID` AS `USER_ID`,`bs`.`BARANGAY_ID` AS `BARANGAY_ID`,concat(`u`.`FIRSTNAME`,' ',`u`.`MIDDLENAME`,`u`.`LASTNAME`) AS `FULL_NAME`,`p`.`POSITION_NAME` AS `POSITION_NAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`u`.`EMAIL` AS `EMAIL`,`bs`.`BARANGAY_NAME` AS `BARANGAY_NAME`,`bs`.`BARANGAY_SEAL` AS `BARANGAY_SEAL`,`bs`.`ACTIVE_FLAG` AS `ACTIVE_FLAG`,`mi`.`MUNICIPAL_SEAL` AS `MUNICIPAL_SEAL`,`mi`.`MUNICIPAL_NAME` AS `MUNICIPAL_NAME`,`mi`.`PROVINCE_NAME` AS `PROVINCE_NAME` from (((`t_users` `u` join `r_barangay_information` `bs` on((`u`.`BARANGAY_ID` = `bs`.`BARANGAY_ID`))) join `r_position` `p` on((`p`.`POSITION_ID` = `u`.`POSITION_ID`))) join `r_municipal_information` `mi` on((`mi`.`MUNICIPAL_ID` = `bs`.`MUNICIPAL_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_application_form_resident`
--
DROP TABLE IF EXISTS `v_application_form_resident`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_application_form_resident`  AS  select `resident`.`RESIDENT_ID` AS `RESIDENT_ID`,concat(ifnull(`resident`.`FIRSTNAME`,''),' ',ifnull(`resident`.`MIDDLENAME`,''),' ',ifnull(`resident`.`LASTNAME`,'')) AS `RESIDENT_NAME`,`resident`.`SEX` AS `SEX`,`resident`.`CIVIL_STATUS` AS `CIVIL_STATUS`,timestampdiff(YEAR,`resident`.`DATE_OF_BIRTH`,curdate()) AS `AGE`,`resident`.`DATE_OF_BIRTH` AS `DATE_OF_BIRTH`,concat(if(isnull(`resident`.`ADDRESS_UNIT_NO`),'','Unit '),ifnull(`resident`.`ADDRESS_UNIT_NO`,''),' ',ifnull(`resident`.`ADDRESS_BUILDING`,''),' ',ifnull(`resident`.`ADDRESS_PHASE`,''),' ',ifnull(`resident`.`ADDRESS_BLOCK_NO`,''),' ',ifnull(`resident`.`ADDRESS_STREET`,''),' ',ifnull(`resident`.`ADDRESS_SUBDIVISION`,'')) AS `ADDRESS`,`af`.`STATUS` AS `STATUS`,`af`.`FORM_ID` AS `FORM_ID`,(select `r_paper_type`.`PAPER_TYPE_NAME` from `r_paper_type` where (`r_paper_type`.`PAPER_TYPE_ID` = `af`.`REQUESTED_PAPER_TYPE_ID`)) AS `REQUESTED_PAPER_TYPE`,(select `r_paper_type`.`PAPER_TYPE_NAME` from `r_paper_type` where (`r_paper_type`.`PAPER_TYPE_ID` = `af`.`PAPER_TYPE_ID`)) AS `FORM_PAPER_TYPE`,`af`.`REQUESTED_PAPER_TYPE_ID` AS `REQUESTED_PAPER_TYPE_ID`,`af`.`PAPER_TYPE_ID` AS `PAPER_TYPE_ID` from (`t_resident_basic_info` `resident` join `t_application_form` `af` on((`af`.`RESIDENT_ID` = `resident`.`RESIDENT_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_approved_application_form`
--
DROP TABLE IF EXISTS `v_approved_application_form`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_approved_application_form`  AS  select `b`.`BUSINESS_ID` AS `BUSINESS_ID`,`b`.`BUSINESS_NAME` AS `BUSINESS_NAME`,`b`.`TRADE_NAME` AS `TRADE_NAME`,`b`.`BUSINESS_OWNER_FIRSTNAME` AS `BUSINESS_OWNER_FIRSTNAME`,`b`.`BUSINESS_OWNER_MIDDLENAME` AS `BUSINESS_OWNER_MIDDLENAME`,`b`.`BUSINESS_OWNER_LASTNAME` AS `BUSINESS_OWNER_LASTNAME`,concat(ifnull(`b`.`BUILDING_NAME`,''),' ',ifnull(`b`.`BUILDING_NUMBER`,''),if(isnull(`b`.`UNIT_NO`),'',' Unit '),ifnull(`b`.`UNIT_NO`,''),' ',ifnull(`b`.`STREET`,''),' ',ifnull(`b`.`SITIO`,''),' ',ifnull(`b`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`b`.`BUSINESS_OR_NUMBER` AS `BUSINESS_OR_NUMBER`,`b`.`BUSINESS_OR_ACQUIRED_DATE` AS `BUSINESS_OR_ACQUIRED_DATE`,`b`.`TIN_NO` AS `TIN_NO`,`b`.`DTI_REGISTRATION_NO` AS `DTI_REGISTRATION_NO`,`b`.`BUSINESS_POSTAL_CODE` AS `BUSINESS_POSTAL_CODE`,`b`.`BUSINESS_EMAIL_ADD` AS `BUSINESS_EMAIL_ADD`,`b`.`BUSINESS_TELEPHONE_NO` AS `BUSINESS_TELEPHONE_NO`,`b`.`BUSINESS_AREA` AS `BUSINESS_AREA`,`n`.`BUSINESS_NATURE_NAME` AS `BUSINESS_NATURE_NAME`,timestampdiff(YEAR,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_YEAR`,timestampdiff(MONTH,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_MONTH`,`af`.`STATUS` AS `STATUS`,`af`.`FORM_ID` AS `FORM_ID`,(select `r_paper_type`.`PAPER_TYPE_NAME` from `r_paper_type` where (`r_paper_type`.`PAPER_TYPE_ID` = `af`.`REQUESTED_PAPER_TYPE_ID`)) AS `REQUESTED_PAPER_TYPE`,(select `r_paper_type`.`PAPER_TYPE_NAME` from `r_paper_type` where (`r_paper_type`.`PAPER_TYPE_ID` = `af`.`PAPER_TYPE_ID`)) AS `FORM_PAPER_TYPE`,`af`.`REQUESTED_PAPER_TYPE_ID` AS `REQUESTED_PAPER_TYPE_ID`,`af`.`PAPER_TYPE_ID` AS `PAPER_TYPE_ID`,cast(`af`.`FORM_DATE` as date) AS `FORM_DATE` from (((`t_business_information` `b` left join `r_business_nature` `n` on((`n`.`BUSINESS_NATURE_ID` = `b`.`BUSINESS_NATURE_ID`))) join `t_application_form` `af` on((`af`.`BUSINESS_ID` = `b`.`BUSINESS_ID`))) join `r_paper_type` `pt` on((`pt`.`PAPER_TYPE_ID` = `af`.`PAPER_TYPE_ID`))) where ((`b`.`STATUS` = 'Approved') and (`af`.`STATUS` = 'Approved')) ;

-- --------------------------------------------------------

--
-- Structure for view `v_approved_business`
--
DROP TABLE IF EXISTS `v_approved_business`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_approved_business`  AS  select `b`.`BUSINESS_ID` AS `BUSINESS_ID`,`b`.`BUSINESS_NAME` AS `BUSINESS_NAME`,`b`.`TRADE_NAME` AS `TRADE_NAME`,`b`.`BUSINESS_OWNER_FIRSTNAME` AS `BUSINESS_OWNER_FIRSTNAME`,`b`.`BUSINESS_OWNER_MIDDLENAME` AS `BUSINESS_OWNER_MIDDLENAME`,`b`.`BUSINESS_OWNER_LASTNAME` AS `BUSINESS_OWNER_LASTNAME`,concat(ifnull(`b`.`BUILDING_NAME`,''),' ',ifnull(`b`.`BUILDING_NUMBER`,''),if(isnull(`b`.`UNIT_NO`),'',' Unit '),ifnull(`b`.`UNIT_NO`,''),' ',ifnull(`b`.`STREET`,''),' ',ifnull(`b`.`SITIO`,''),' ',ifnull(`b`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`b`.`BUSINESS_OR_NUMBER` AS `BUSINESS_OR_NUMBER`,`b`.`BUSINESS_OR_ACQUIRED_DATE` AS `BUSINESS_OR_ACQUIRED_DATE`,`b`.`TIN_NO` AS `TIN_NO`,`b`.`DTI_REGISTRATION_NO` AS `DTI_REGISTRATION_NO`,`b`.`BUSINESS_POSTAL_CODE` AS `BUSINESS_POSTAL_CODE`,`b`.`BUSINESS_EMAIL_ADD` AS `BUSINESS_EMAIL_ADD`,`b`.`BUSINESS_TELEPHONE_NO` AS `BUSINESS_TELEPHONE_NO`,`b`.`BUSINESS_AREA` AS `BUSINESS_AREA`,`n`.`BUSINESS_NATURE_NAME` AS `BUSINESS_NATURE_NAME`,timestampdiff(YEAR,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_YEAR`,timestampdiff(MONTH,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_MONTH` from (`t_business_information` `b` left join `r_business_nature` `n` on((`n`.`BUSINESS_NATURE_ID` = `b`.`BUSINESS_NATURE_ID`))) where (`b`.`STATUS` = 'Approved') ;

-- --------------------------------------------------------

--
-- Structure for view `v_barangay_certificate`
--
DROP TABLE IF EXISTS `v_barangay_certificate`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_barangay_certificate`  AS  select `r`.`RESIDENT_ID` AS `RESIDENT_ID`,concat(ifnull(`r`.`FIRSTNAME`,''),' ',ifnull(`r`.`MIDDLENAME`,''),' ',ifnull(`r`.`LASTNAME`,'')) AS `RESIDENT_NAME`,`r`.`SEX` AS `SEX`,if((`r`.`SEX` = 'Female'),'her','his') AS `SEX_ADDRESS`,`r`.`CIVIL_STATUS` AS `CIVIL_STATUS`,timestampdiff(YEAR,`r`.`DATE_OF_BIRTH`,curdate()) AS `AGE`,`r`.`DATE_OF_BIRTH` AS `DATE_OF_BIRTH`,concat(if(isnull(`r`.`ADDRESS_UNIT_NO`),'','Unit '),ifnull(`r`.`ADDRESS_UNIT_NO`,''),' ',ifnull(`r`.`ADDRESS_BUILDING`,''),' ',ifnull(`r`.`ADDRESS_PHASE`,''),' ',ifnull(`r`.`ADDRESS_BLOCK_NO`,''),' ',ifnull(`r`.`ADDRESS_STREET`,''),' ',ifnull(`r`.`ADDRESS_SUBDIVISION`,'')) AS `ADDRESS`,`cc`.`CONTROL_NO` AS `CONTROL_NO`,`cc`.`ISSUED_DATE` AS `ISSUED_DATE`,`cc`.`OR_NO` AS `OR_NO`,`cc`.`OR_DATE` AS `OR_DATE`,`cc`.`OR_AMOUNT` AS `OR_AMOUNT`,`paper`.`PAPER_TYPE_NAME` AS `PAPER_TYPE_NAME`,`af`.`FORM_ID` AS `FORM_ID`,`bc`.`REQUESTOR_NAME` AS `REQUESTOR_NAME`,`bc`.`SSS_NO` AS `SSS_NO`,`bc`.`CALAMITY_NAME` AS `CALAMITY_NAME`,`bc`.`CALAMITY_DATE` AS `CALAMITY_DATE`,`bc`.`COUNTRY` AS `COUNTRY`,`bc`.`CATEGORY_SINGLE_PARENT` AS `CATEGORY_SINGLE_PARENT`,`bc`.`PURPOSE` AS `PURPOSE`,`solo`.`CHILD_NAME` AS `CHILD_NAME`,`solo`.`CHILD_AGE` AS `CHILD_AGE`,`solo`.`IS_PWD` AS `IS_PWD`,`solo`.`CHILD_NAME_2` AS `CHILD_NAME_2`,`solo`.`CHILD_AGE_2` AS `CHILD_AGE_2`,`solo`.`IS_PWD_2` AS `IS_PWD_2` from (((((`t_resident_basic_info` `r` join `t_application_form` `af` on((`af`.`RESIDENT_ID` = `r`.`RESIDENT_ID`))) join `r_paper_type` `paper` on((`paper`.`PAPER_TYPE_ID` = `af`.`REQUESTED_PAPER_TYPE_ID`))) join `t_bf_barangay_certification` `bc` on((`bc`.`FORM_ID` = `af`.`FORM_ID`))) join `t_clearance_certification` `cc` on((`cc`.`FORM_ID` = `af`.`FORM_ID`))) left join `t_solo_parent_children` `solo` on((`solo`.`BARANGAY_CERTIFICATION_ID` = `bc`.`BARANGAY_CERTIFICATION_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_barangay_clearance`
--
DROP TABLE IF EXISTS `v_barangay_clearance`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_barangay_clearance`  AS  select concat(`business`.`BUSINESS_OWNER_FIRSTNAME`,' ',`business`.`BUSINESS_OWNER_MIDDLENAME`,' ',`business`.`BUSINESS_OWNER_LASTNAME`) AS `BUSINESS_OWNER`,concat(ifnull(`business`.`BUILDING_NAME`,''),' ',ifnull(`business`.`BUILDING_NUMBER`,''),if(isnull(`business`.`UNIT_NO`),'',' Unit '),ifnull(`business`.`UNIT_NO`,''),' ',ifnull(`business`.`STREET`,''),' ',ifnull(`business`.`SITIO`,''),' ',ifnull(`business`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`clearance`.`CONTROL_NO` AS `CONTROL_NO`,`clearance`.`ISSUED_DATE` AS `ISSUED_DATE`,`clearance`.`OR_NO` AS `OR_NO`,`clearance`.`OR_DATE` AS `OR_DATE`,`clearance`.`OR_AMOUNT` AS `OR_AMOUNT`,`paper`.`PAPER_TYPE_NAME` AS `PAPER_TYPE_NAME`,`form`.`FORM_ID` AS `FORM_ID`,`business`.`BUSINESS_NAME` AS `BUSINESS_NAME`,concat(`scope_work`.`SCOPE_OF_WORK_NAME`,' of ',`scope_work`.`SCOPE_OF_WORK_SPECIFY`) AS `PROJECT_NAME`,`barangay_clearance`.`PROJECT_LOCATION` AS `PROJECT_LOCATION`,`line_business`.`LINE_OF_BUSINESS_NAME` AS `LINE_OF_BUSINESS_NAME`,`barangay_clearance`.`OCT_TCT_NUMBER` AS `OCT_TCT_NUMBER`,`barangay_clearance`.`TAX_DECLARATION` AS `TAX_DECLARATION`,`barangay_clearance`.`BUSINESS_AREA` AS `BUSINESS_AREA`,`barangay_clearance`.`AREA_CLASSIFICATION` AS `AREA_CLASSIFICATION`,`barangay_clearance`.`PURPOSE` AS `PURPOSE`,`barangay_clearance`.`D_DRIVER_LICENSE_NO` AS `D_DRIVER_LICENSE_NO`,`barangay_clearance`.`D_MUDGUARD_NO` AS `D_MUDGUARD_NO`,`barangay_clearance`.`D_CR_NO` AS `D_CR_NO`,`barangay_clearance`.`D_OR_NO` AS `D_OR_NO`,`barangay_clearance`.`APPLICANT_NAME` AS `APPLICANT_NAME` from (((((((`t_business_information` `business` join `t_application_form` `form` on((`form`.`BUSINESS_ID` = `business`.`BUSINESS_ID`))) join `r_paper_type` `paper` on((`paper`.`PAPER_TYPE_ID` = `form`.`REQUESTED_PAPER_TYPE_ID`))) join `t_bf_barangay_clearance` `barangay_clearance` on((`barangay_clearance`.`FORM_ID` = `form`.`FORM_ID`))) join `t_clearance_certification` `clearance` on((`clearance`.`FORM_ID` = `form`.`FORM_ID`))) left join `t_bf_scope_of_work` `scope_work` on((`barangay_clearance`.`SCOPE_OF_WORK_ID` = `scope_work`.`SCOPE_OF_WORK_ID`))) left join `t_bf_business_activity` `business_activity` on((`business_activity`.`BUSINESS_ID` = `business`.`BUSINESS_ID`))) left join `r_bf_line_of_business` `line_business` on((`line_business`.`LINE_OF_BUSINESS_ID` = `business_activity`.`LINE_OF_BUSINESS_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_business_information`
--
DROP TABLE IF EXISTS `v_business_information`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_business_information`  AS  select `business`.`BUSINESS_ID` AS `BUSINESS_ID`,`business`.`BUSINESS_NAME` AS `BUSINESS_NAME`,`business`.`TRADE_NAME` AS `TRADE_NAME`,concat(`business`.`BUSINESS_OWNER_FIRSTNAME`,' ',ifnull(`business`.`BUSINESS_OWNER_MIDDLENAME`,''),' ',`business`.`BUSINESS_OWNER_LASTNAME`) AS `BUSINESS_OWNER`,`business`.`BUSINESS_OWNER_FIRSTNAME` AS `BUSINESS_OWNER_FIRSTNAME`,`business`.`BUSINESS_OWNER_MIDDLENAME` AS `BUSINESS_OWNER_MIDDLENAME`,`business`.`BUSINESS_OWNER_LASTNAME` AS `BUSINESS_OWNER_LASTNAME`,concat(ifnull(`business`.`BUILDING_NAME`,''),' ',ifnull(`business`.`BUILDING_NUMBER`,''),if(isnull(`business`.`UNIT_NO`),'',' Unit '),ifnull(`business`.`UNIT_NO`,''),' ',ifnull(`business`.`STREET`,''),' ',ifnull(`business`.`SITIO`,''),' ',ifnull(`business`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`business`.`BUILDING_NAME` AS `BUILDING_NAME`,`business`.`BUILDING_NUMBER` AS `BUILDING_NUMBER`,`business`.`UNIT_NO` AS `UNIT_NO`,`business`.`STREET` AS `STREET`,`business`.`SITIO` AS `SITIO`,`business`.`SUBDIVISION` AS `SUBDIVISION`,`business`.`BUSINESS_OR_NUMBER` AS `BUSINESS_OR_NUMBER`,`business`.`BUSINESS_OR_ACQUIRED_DATE` AS `BUSINESS_OR_ACQUIRED_DATE`,`business`.`BARANGAY_ZONE_ID` AS `BARANGAY_ZONE_ID`,`business`.`TIN_NO` AS `TIN_NO`,`business`.`DTI_REGISTRATION_NO` AS `DTI_REGISTRATION_NO`,`business`.`TYPE_OF_BUSINESS` AS `TYPE_OF_BUSINESS`,`business`.`BUSINESS_POSTAL_CODE` AS `BUSINESS_POSTAL_CODE`,`business`.`BUSINESS_EMAIL_ADD` AS `BUSINESS_EMAIL_ADD`,`business`.`BUSINESS_TELEPHONE_NO` AS `BUSINESS_TELEPHONE_NO`,`business`.`BUSINESS_MOBILE_NO` AS `BUSINESS_MOBILE_NO`,`business`.`OWNER_ADDRESS` AS `OWNER_ADDRESS`,`business`.`OWNER_POSTAL_CODE` AS `OWNER_POSTAL_CODE`,`business`.`OWNER_EMAIL_ADD` AS `OWNER_EMAIL_ADD`,`business`.`OWNER_TELEPHONE_NO` AS `OWNER_TELEPHONE_NO`,`business`.`OWNER_MOBILE_NO` AS `OWNER_MOBILE_NO`,`business`.`EMERGENCY_CONTACT_PERSON` AS `EMERGENCY_CONTACT_PERSON`,`business`.`EMERGENCY_PERSON_CONTACT_NO` AS `EMERGENCY_PERSON_CONTACT_NO`,`business`.`EMERGENCY_PERSON_EMAIL_ADD` AS `EMERGENCY_PERSON_EMAIL_ADD`,`business`.`BUSINESS_AREA` AS `BUSINESS_AREA`,`business`.`NO_EMPLOYEE_ESTABLISHMENT` AS `NO_EMPLOYEE_ESTABLISHMENT`,`business`.`NO_EMPLOYEE_LGU` AS `NO_EMPLOYEE_LGU`,`business`.`LESSOR_NAME` AS `LESSOR_NAME`,`business`.`LESSOR_ADDRESS` AS `LESSOR_ADDRESS`,`business`.`LESSOR_POSTAL` AS `LESSOR_POSTAL`,`business`.`LESSOR_CONTACT_NO` AS `LESSOR_CONTACT_NO`,`business`.`LESSOR_TELEPHONE` AS `LESSOR_TELEPHONE`,`business`.`LESSOR_MOBILE_NO` AS `LESSOR_MOBILE_NO`,`business`.`LESSOR_EMAIL_ADD` AS `LESSOR_EMAIL_ADD`,`business`.`MONTHLY_RENTAL` AS `MONTHLY_RENTAL`,`business`.`REFERENCED_BUSINESS_ID` AS `REFERENCED_BUSINESS_ID`,`activity`.`NO_OF_UNITS` AS `NO_OF_UNITS`,`business`.`STATUS` AS `STATUS`,`business`.`NEW_RENEW_STATUS` AS `NEW_RENEW_STATUS`,`activity`.`CAPITALIZATION` AS `CAPITALIZATION`,`activity`.`GROSS_RECEIPTS_ESSENTIAL` AS `GROSS_RECEIPTS_ESSENTIAL`,`activity`.`GROSS_RECEIPTS_NON_ESSENTIAL` AS `GROSS_RECEIPTS_NON_ESSENTIAL`,`lob`.`LINE_OF_BUSINESS_NAME` AS `LINE_OF_BUSINESS_NAME` from ((`t_business_information` `business` left join `t_bf_business_activity` `activity` on((`activity`.`BUSINESS_ID` = `business`.`BUSINESS_ID`))) left join `r_bf_line_of_business` `lob` on((`lob`.`LINE_OF_BUSINESS_ID` = `activity`.`LINE_OF_BUSINESS_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_business_nature`
--
DROP TABLE IF EXISTS `v_business_nature`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_business_nature`  AS  select `r_business_nature`.`BUSINESS_NATURE_ID` AS `BUSINESS_NATURE_ID`,`r_business_nature`.`BUSINESS_NATURE_NAME` AS `BUSINESS_NATURE_NAME` from `r_business_nature` where (`r_business_nature`.`ACTIVE_FLAG` = 1) ;

-- --------------------------------------------------------

--
-- Structure for view `v_business_permit`
--
DROP TABLE IF EXISTS `v_business_permit`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_business_permit`  AS  select `business`.`BUSINESS_NAME` AS `BUSINESS_NAME`,concat(ifnull(`business`.`BUILDING_NAME`,''),' ',ifnull(`business`.`BUILDING_NUMBER`,''),if(isnull(`business`.`UNIT_NO`),'',' Unit '),ifnull(`business`.`UNIT_NO`,''),' ',ifnull(`business`.`STREET`,''),' ',ifnull(`business`.`SITIO`,''),' ',ifnull(`business`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`lob`.`LINE_OF_BUSINESS_NAME` AS `BUSINESS_NATURE_NAME`,`permit`.`TAX_YEAR` AS `TAX_YEAR`,`permit`.`QUARTER` AS `QUARTER`,`clearance`.`OR_NO` AS `OR_NO`,`clearance`.`OR_AMOUNT` AS `OR_AMOUNT`,cast(`clearance`.`OR_DATE` as date) AS `OR_DATE`,`permit`.`BARANGAY_PERMIT` AS `BARANGAY_PERMIT`,`permit`.`BUSINESS_TAX` AS `BUSINESS_TAX`,`permit`.`GARBAGE_FEE` AS `GARBAGE_FEE`,`permit`.`SIGNBOARD` AS `SIGNBOARD`,`permit`.`CTC` AS `CTC`,`form`.`FORM_ID` AS `FORM_ID` from (((((`t_business_information` `business` join `t_application_form` `form` on((`business`.`BUSINESS_ID` = `form`.`BUSINESS_ID`))) join `t_bf_business_permit` `permit` on((`permit`.`FORM_ID` = `form`.`FORM_ID`))) join `t_clearance_certification` `clearance` on((`clearance`.`FORM_ID` = `form`.`FORM_ID`))) left join `t_bf_business_activity` `activity` on((`activity`.`BUSINESS_ID` = `business`.`BUSINESS_ID`))) left join `r_bf_line_of_business` `lob` on((`lob`.`LINE_OF_BUSINESS_ID` = `activity`.`LINE_OF_BUSINESS_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_declined_application_form`
--
DROP TABLE IF EXISTS `v_declined_application_form`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_declined_application_form`  AS  select `b`.`BUSINESS_ID` AS `BUSINESS_ID`,`b`.`BUSINESS_NAME` AS `BUSINESS_NAME`,`b`.`TRADE_NAME` AS `TRADE_NAME`,`b`.`BUSINESS_OWNER_FIRSTNAME` AS `BUSINESS_OWNER_FIRSTNAME`,`b`.`BUSINESS_OWNER_MIDDLENAME` AS `BUSINESS_OWNER_MIDDLENAME`,`b`.`BUSINESS_OWNER_LASTNAME` AS `BUSINESS_OWNER_LASTNAME`,concat(ifnull(`b`.`BUILDING_NAME`,''),' ',ifnull(`b`.`BUILDING_NUMBER`,''),if(isnull(`b`.`UNIT_NO`),'',' Unit '),ifnull(`b`.`UNIT_NO`,''),' ',ifnull(`b`.`STREET`,''),' ',ifnull(`b`.`SITIO`,''),' ',ifnull(`b`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`b`.`BUSINESS_OR_NUMBER` AS `BUSINESS_OR_NUMBER`,`b`.`BUSINESS_OR_ACQUIRED_DATE` AS `BUSINESS_OR_ACQUIRED_DATE`,`b`.`TIN_NO` AS `TIN_NO`,`b`.`DTI_REGISTRATION_NO` AS `DTI_REGISTRATION_NO`,`b`.`BUSINESS_POSTAL_CODE` AS `BUSINESS_POSTAL_CODE`,`b`.`BUSINESS_EMAIL_ADD` AS `BUSINESS_EMAIL_ADD`,`b`.`BUSINESS_TELEPHONE_NO` AS `BUSINESS_TELEPHONE_NO`,`b`.`BUSINESS_AREA` AS `BUSINESS_AREA`,`n`.`BUSINESS_NATURE_NAME` AS `BUSINESS_NATURE_NAME`,timestampdiff(YEAR,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_YEAR`,timestampdiff(MONTH,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_MONTH`,`af`.`STATUS` AS `STATUS`,`af`.`FORM_ID` AS `FORM_ID`,(select `r_paper_type`.`PAPER_TYPE_NAME` from `r_paper_type` where (`r_paper_type`.`PAPER_TYPE_ID` = `af`.`REQUESTED_PAPER_TYPE_ID`)) AS `REQUESTED_PAPER_TYPE`,(select `r_paper_type`.`PAPER_TYPE_NAME` from `r_paper_type` where (`r_paper_type`.`PAPER_TYPE_ID` = `af`.`PAPER_TYPE_ID`)) AS `FORM_PAPER_TYPE`,`af`.`REQUESTED_PAPER_TYPE_ID` AS `REQUESTED_PAPER_TYPE_ID`,`af`.`PAPER_TYPE_ID` AS `PAPER_TYPE_ID` from (((`t_business_information` `b` left join `r_business_nature` `n` on((`n`.`BUSINESS_NATURE_ID` = `b`.`BUSINESS_NATURE_ID`))) join `t_application_form` `af` on((`af`.`BUSINESS_ID` = `b`.`BUSINESS_ID`))) join `r_paper_type` `pt` on((`pt`.`PAPER_TYPE_ID` = `af`.`PAPER_TYPE_ID`))) where ((`b`.`STATUS` = 'Approved') and (`af`.`STATUS` = 'Declined')) ;

-- --------------------------------------------------------

--
-- Structure for view `v_declined_business`
--
DROP TABLE IF EXISTS `v_declined_business`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_declined_business`  AS  select `b`.`BUSINESS_ID` AS `BUSINESS_ID`,`b`.`BUSINESS_NAME` AS `BUSINESS_NAME`,`b`.`TRADE_NAME` AS `TRADE_NAME`,`b`.`BUSINESS_OWNER_FIRSTNAME` AS `BUSINESS_OWNER_FIRSTNAME`,`b`.`BUSINESS_OWNER_MIDDLENAME` AS `BUSINESS_OWNER_MIDDLENAME`,`b`.`BUSINESS_OWNER_LASTNAME` AS `BUSINESS_OWNER_LASTNAME`,concat(ifnull(`b`.`BUILDING_NAME`,''),' ',ifnull(`b`.`BUILDING_NUMBER`,''),if(isnull(`b`.`UNIT_NO`),'',' Unit '),ifnull(`b`.`UNIT_NO`,''),' ',ifnull(`b`.`STREET`,''),' ',ifnull(`b`.`SITIO`,''),' ',ifnull(`b`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`b`.`BUSINESS_OR_NUMBER` AS `BUSINESS_OR_NUMBER`,`b`.`BUSINESS_OR_ACQUIRED_DATE` AS `BUSINESS_OR_ACQUIRED_DATE`,`b`.`TIN_NO` AS `TIN_NO`,`b`.`DTI_REGISTRATION_NO` AS `DTI_REGISTRATION_NO`,`b`.`BUSINESS_POSTAL_CODE` AS `BUSINESS_POSTAL_CODE`,`b`.`BUSINESS_EMAIL_ADD` AS `BUSINESS_EMAIL_ADD`,`b`.`BUSINESS_TELEPHONE_NO` AS `BUSINESS_TELEPHONE_NO`,`n`.`BUSINESS_NATURE_NAME` AS `BUSINESS_NATURE_NAME`,timestampdiff(YEAR,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_YEAR`,timestampdiff(MONTH,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_MONTH` from (`t_business_information` `b` left join `r_business_nature` `n` on((`n`.`BUSINESS_NATURE_ID` = `b`.`BUSINESS_NATURE_ID`))) where (`b`.`STATUS` = 'Pending') ;

-- --------------------------------------------------------

--
-- Structure for view `v_dpoaccount`
--
DROP TABLE IF EXISTS `v_dpoaccount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_dpoaccount`  AS  select `u`.`USER_ID` AS `USER_ID`,`bs`.`BARANGAY_ID` AS `BARANGAY_ID`,concat(`u`.`FIRSTNAME`,' ',`u`.`MIDDLENAME`,`u`.`LASTNAME`) AS `DPO_Name`,`p`.`POSITION_NAME` AS `POSITION_NAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`u`.`EMAIL` AS `EMAIL`,`bs`.`BARANGAY_NAME` AS `BARANGAY_NAME`,`bs`.`BARANGAY_SEAL` AS `BARANGAY_SEAL`,`bs`.`ACTIVE_FLAG` AS `ACTIVE_FLAG`,`u`.`PERMIS_BARANGAY_CONFIG` AS `PERMIS_BARANGAY_CONFIG` from ((`t_users` `u` join `r_barangay_information` `bs` on((`u`.`USER_ID` = `bs`.`USER_ID`))) join `r_position` `p` on((`p`.`POSITION_ID` = `u`.`POSITION_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_generatectrno`
--
DROP TABLE IF EXISTS `v_generatectrno`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_generatectrno`  AS  select concat(year(now()),month(now()),dayofmonth(now())) AS `CTR_NO` ;

-- --------------------------------------------------------

--
-- Structure for view `v_household_information`
--
DROP TABLE IF EXISTS `v_household_information`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_household_information`  AS  select `hi`.`HOUSEHOLD_ID` AS `HOUSEHOLD_ID`,concat(`t`.`LASTNAME`,' ',`t`.`FIRSTNAME`,' ',`t`.`MIDDLENAME`) AS `FULLNAME`,`hi`.`HOME_OWNERSHIP` AS `HOME_OWNERSHIP`,`hi`.`PERSON_STAYING_IN_HOUSEHOLD` AS `PERSON_STAYING_IN_HOUSEHOLD`,`hi`.`HOME_MATERIALS` AS `HOME_MATERIALS`,`t`.`LASTNAME` AS `LASTNAME`,`t`.`FIRSTNAME` AS `FIRSTNAME`,`t`.`MIDDLENAME` AS `MIDDLENAME`,`hi`.`TOILET_HOME` AS `TOILET_HOME`,`hi`.`PLAY_AREA_HOME` AS `PLAY_AREA_HOME`,`hi`.`BEDROOM_HOME` AS `BEDROOM_HOME`,`hi`.`DINING_ROOM_HOME` AS `DINING_ROOM_HOME`,`hi`.`SALA_HOME` AS `SALA_HOME`,`hi`.`KITCHEN_HOME` AS `KITCHEN_HOME`,`hi`.`WATER_UTILITIES` AS `WATER_UTILITIES`,`hi`.`ELECTRICITY_UTILITIES` AS `ELECTRICITY_UTILITIES`,`hi`.`AIRCON_UTILITIES` AS `AIRCON_UTILITIES`,`hi`.`PHONE_UTILITIES` AS `PHONE_UTILITIES`,`hi`.`COMPUTER_UTILITIES` AS `COMPUTER_UTILITIES`,`hi`.`INTERNET_UTILITIES` AS `INTERNET_UTILITIES`,`hi`.`TV_UTILITIES` AS `TV_UTILITIES`,`hi`.`CD_PLAYER_UTILITIES` AS `CD_PLAYER_UTILITIES`,`hi`.`RADIO_UTILITIES` AS `RADIO_UTILITIES`,`hi`.`COMICS_ENTERTAINMENT` AS `COMICS_ENTERTAINMENT`,`hi`.`NEWS_PAPER_ENTERTAINMENT` AS `NEWS_PAPER_ENTERTAINMENT`,`hi`.`PETS_ENTERTAINMENT` AS `PETS_ENTERTAINMENT`,`hi`.`BOOKS_ENTERTAINMENT` AS `BOOKS_ENTERTAINMENT`,`hi`.`STORY_BOOKS_ENTERTAINMENT` AS `STORY_BOOKS_ENTERTAINMENT`,`hi`.`TOYS_ENTERTAINMENT` AS `TOYS_ENTERTAINMENT`,`hi`.`BOARD_GAMES_ENTERTAINMENT` AS `BOARD_GAMES_ENTERTAINMENT`,`hi`.`PUZZLES_ENTERTAINMENT` AS `PUZZLES_ENTERTAINMENT`,`hi`.`NUMBER_OF_ROOMS` AS `NUMBER_OF_ROOMS`,`tb`.`FAMILY_HEADER_ID` AS `FAMILY_HEADER_ID` from (((`t_resident_basic_info` `t` join `t_household_information` `hi` on((`t`.`HOUSEHOLD_ID` = `hi`.`HOUSEHOLD_ID`))) left join `t_household_members` `th` on((`t`.`RESIDENT_ID` = `th`.`RESIDENT_ID`))) left join `t_household_batch` `tb` on((`th`.`FAMILY_HEADER_ID` = `tb`.`FAMILY_HEADER_ID`))) where (lcase(`t`.`RELATION_TO_HOUSEHOLD_HEAD`) = 'HEAD') ;

-- --------------------------------------------------------

--
-- Structure for view `v_line_of_business`
--
DROP TABLE IF EXISTS `v_line_of_business`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_line_of_business`  AS  select `r_bf_line_of_business`.`LINE_OF_BUSINESS_ID` AS `LINE_OF_BUSINESS_ID`,`r_bf_line_of_business`.`LINE_OF_BUSINESS_NAME` AS `LINE_OF_BUSINESS_NAME` from `r_bf_line_of_business` ;

-- --------------------------------------------------------

--
-- Structure for view `v_official_business_list`
--
DROP TABLE IF EXISTS `v_official_business_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_official_business_list`  AS  select `b`.`BUSINESS_ID` AS `BUSINESS_ID`,`b`.`BUSINESS_NAME` AS `BUSINESS_NAME`,`b`.`TRADE_NAME` AS `TRADE_NAME`,`b`.`BUSINESS_OWNER_FIRSTNAME` AS `BUSINESS_OWNER_FIRSTNAME`,`b`.`BUSINESS_OWNER_MIDDLENAME` AS `BUSINESS_OWNER_MIDDLENAME`,`b`.`BUSINESS_OWNER_LASTNAME` AS `BUSINESS_OWNER_LASTNAME`,concat(ifnull(`b`.`BUILDING_NAME`,''),' ',ifnull(`b`.`BUILDING_NUMBER`,''),if(isnull(`b`.`UNIT_NO`),'',' Unit '),ifnull(`b`.`UNIT_NO`,''),' ',ifnull(`b`.`STREET`,''),' ',ifnull(`b`.`SITIO`,''),' ',ifnull(`b`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`b`.`BUSINESS_OR_NUMBER` AS `BUSINESS_OR_NUMBER`,`b`.`BUSINESS_OR_ACQUIRED_DATE` AS `BUSINESS_OR_ACQUIRED_DATE`,`b`.`TIN_NO` AS `TIN_NO`,`b`.`DTI_REGISTRATION_NO` AS `DTI_REGISTRATION_NO`,`b`.`BUSINESS_POSTAL_CODE` AS `BUSINESS_POSTAL_CODE`,`b`.`BUSINESS_EMAIL_ADD` AS `BUSINESS_EMAIL_ADD`,`b`.`BUSINESS_TELEPHONE_NO` AS `BUSINESS_TELEPHONE_NO`,`b`.`BUSINESS_AREA` AS `BUSINESS_AREA`,timestampdiff(YEAR,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_YEAR`,timestampdiff(MONTH,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_MONTH`,`lob`.`LINE_OF_BUSINESS_NAME` AS `LINE_OF_BUSINESS_NAME`,`b`.`STATUS` AS `STATUS`,`b`.`NEW_RENEW_STATUS` AS `NEW_RENEW_STATUS`,`b`.`REFERENCED_BUSINESS_ID` AS `REFERENCED_BUSINESS_ID`,`activity`.`GROSS_RECEIPTS_ESSENTIAL` AS `GROSS_RECEIPTS_ESSENTIAL`,`activity`.`GROSS_RECEIPTS_NON_ESSENTIAL` AS `GROSS_RECEIPTS_NON_ESSENTIAL`,`nature`.`BUSINESS_NATURE_NAME` AS `BUSINESS_NATURE_NAME`,(cast(`activity`.`GROSS_RECEIPTS_ESSENTIAL` as unsigned) + cast(`activity`.`GROSS_RECEIPTS_NON_ESSENTIAL` as unsigned)) AS `GROSS_RECEIPT_TOTAL` from (((`t_business_information` `b` left join `t_bf_business_activity` `activity` on((`activity`.`BUSINESS_ID` = `b`.`BUSINESS_ID`))) left join `r_bf_line_of_business` `lob` on((`lob`.`LINE_OF_BUSINESS_ID` = `activity`.`LINE_OF_BUSINESS_ID`))) left join `r_business_nature` `nature` on((`nature`.`BUSINESS_NATURE_ID` = `b`.`BUSINESS_NATURE_ID`))) where (not(`b`.`BUSINESS_ID` in (select `t_business_information`.`REFERENCED_BUSINESS_ID` from `t_business_information` where (`t_business_information`.`REFERENCED_BUSINESS_ID` is not null)))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_paper_type`
--
DROP TABLE IF EXISTS `v_paper_type`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_paper_type`  AS  select `r_paper_type`.`PAPER_TYPE_ID` AS `PAPER_TYPE_ID`,`r_paper_type`.`PAPER_TYPE_NAME` AS `PAPER_TYPE_NAME`,`r_paper_type`.`PAPER_TYPE_CATEGORY` AS `PAPER_TYPE_CATEGORY`,`r_paper_type`.`PAPER_TYPE_DECRIPTION` AS `PAPER_TYPE_DECRIPTION`,`r_paper_type`.`CREATED_AT` AS `CREATED_AT`,`r_paper_type`.`UPDATED_AT` AS `UPDATED_AT`,`r_paper_type`.`ACTIVE_FLAG` AS `ACTIVE_FLAG`,`r_paper_type`.`PAPER_TYPE_CODE` AS `PAPER_TYPE_CODE` from `r_paper_type` ;

-- --------------------------------------------------------

--
-- Structure for view `v_pending_application_form`
--
DROP TABLE IF EXISTS `v_pending_application_form`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_pending_application_form`  AS  select `b`.`BUSINESS_ID` AS `BUSINESS_ID`,`b`.`BUSINESS_NAME` AS `BUSINESS_NAME`,`b`.`TRADE_NAME` AS `TRADE_NAME`,`b`.`BUSINESS_OWNER_FIRSTNAME` AS `BUSINESS_OWNER_FIRSTNAME`,`b`.`BUSINESS_OWNER_MIDDLENAME` AS `BUSINESS_OWNER_MIDDLENAME`,`b`.`BUSINESS_OWNER_LASTNAME` AS `BUSINESS_OWNER_LASTNAME`,concat(ifnull(`b`.`BUILDING_NAME`,''),' ',ifnull(`b`.`BUILDING_NUMBER`,''),if(isnull(`b`.`UNIT_NO`),'',' Unit '),ifnull(`b`.`UNIT_NO`,''),' ',ifnull(`b`.`STREET`,''),' ',ifnull(`b`.`SITIO`,''),' ',ifnull(`b`.`SUBDIVISION`,'')) AS `BUSINESS_ADDRESS`,`b`.`BUSINESS_OR_NUMBER` AS `BUSINESS_OR_NUMBER`,`b`.`BUSINESS_OR_ACQUIRED_DATE` AS `BUSINESS_OR_ACQUIRED_DATE`,`b`.`TIN_NO` AS `TIN_NO`,`b`.`DTI_REGISTRATION_NO` AS `DTI_REGISTRATION_NO`,`b`.`BUSINESS_POSTAL_CODE` AS `BUSINESS_POSTAL_CODE`,`b`.`BUSINESS_EMAIL_ADD` AS `BUSINESS_EMAIL_ADD`,`b`.`BUSINESS_TELEPHONE_NO` AS `BUSINESS_TELEPHONE_NO`,`b`.`BUSINESS_AREA` AS `BUSINESS_AREA`,`n`.`BUSINESS_NATURE_NAME` AS `BUSINESS_NATURE_NAME`,timestampdiff(YEAR,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_YEAR`,timestampdiff(MONTH,`b`.`BUSINESS_OR_ACQUIRED_DATE`,curdate()) AS `BUSINESS_PERIOD_MONTH`,`af`.`STATUS` AS `STATUS`,`af`.`FORM_ID` AS `FORM_ID`,(select `r_paper_type`.`PAPER_TYPE_NAME` from `r_paper_type` where (`r_paper_type`.`PAPER_TYPE_ID` = `af`.`REQUESTED_PAPER_TYPE_ID`)) AS `REQUESTED_PAPER_TYPE`,(select `r_paper_type`.`PAPER_TYPE_NAME` from `r_paper_type` where (`r_paper_type`.`PAPER_TYPE_ID` = `af`.`PAPER_TYPE_ID`)) AS `FORM_PAPER_TYPE`,`af`.`REQUESTED_PAPER_TYPE_ID` AS `REQUESTED_PAPER_TYPE_ID`,`af`.`PAPER_TYPE_ID` AS `PAPER_TYPE_ID`,cast(`af`.`FORM_DATE` as date) AS `FORM_DATE` from (((`t_business_information` `b` left join `r_business_nature` `n` on((`n`.`BUSINESS_NATURE_ID` = `b`.`BUSINESS_NATURE_ID`))) join `t_application_form` `af` on((`af`.`BUSINESS_ID` = `b`.`BUSINESS_ID`))) join `r_paper_type` `pt` on((`pt`.`PAPER_TYPE_ID` = `af`.`PAPER_TYPE_ID`))) where ((`b`.`STATUS` = 'Approved') and (`af`.`STATUS` = 'Pending')) ;

-- --------------------------------------------------------

--
-- Structure for view `v_realbarangayofficialsaccount`
--
DROP TABLE IF EXISTS `v_realbarangayofficialsaccount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_realbarangayofficialsaccount`  AS  select `bo`.`BARANGAY_OFFICIAL_ID` AS `BARANGAY_OFFICIAL_ID`,`bo`.`BARANGAY_ID` AS `BARANGAY_ID`,`u`.`USER_ID` AS `USER_ID`,concat(`rbi`.`FIRSTNAME`,' ',`rbi`.`MIDDLENAME`,' ',`rbi`.`LASTNAME`) AS `FULLNAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`bs`.`BARANGAY_NAME` AS `BARANGAY_NAME`,`p`.`POSITION_NAME` AS `POSITION_NAME`,`u`.`EMAIL` AS `EMAIL`,`bo`.`START_TERM` AS `START_TERM`,`bo`.`END_TERM` AS `END_TERM`,`u`.`PERMIS_RESIDENT_BASIC_INFO` AS `PERMIS_RESIDENT_BASIC_INFO`,`u`.`PERMIS_FAMILY_PROFILE` AS `PERMIS_FAMILY_PROFILE`,`u`.`PERMIS_COMMUNITY_PROFILE` AS `PERMIS_COMMUNITY_PROFILE`,`u`.`PERMIS_BLOTTER` AS `PERMIS_BLOTTER`,`u`.`PERMIS_PATAWAG` AS `PERMIS_PATAWAG`,`u`.`PERMIS_BARANGAY_OFFICIAL` AS `PERMIS_BARANGAY_OFFICIAL`,`u`.`PERMIS_BUSINESSES` AS `PERMIS_BUSINESSES`,`u`.`PERMIS_ISSUANCE_OF_FORMS` AS `PERMIS_ISSUANCE_OF_FORMS`,`u`.`PERMIS_ORDINANCES` AS `PERMIS_ORDINANCES`,`u`.`PERMIS_SYSTEM_REPORT` AS `PERMIS_SYSTEM_REPORT`,`u`.`PERMIS_HEALTH_SERVICES` AS `PERMIS_HEALTH_SERVICES`,`u`.`PERMIS_DATA_MIGRATION` AS `PERMIS_DATA_MIGRATION`,`u`.`PERMIS_USER_ACCOUNTS` AS `PERMIS_USER_ACCOUNTS`,`u`.`PERMIS_BARANGAY_CONFIG` AS `PERMIS_BARANGAY_CONFIG`,`u`.`PERMIS_BUSINESS_APPROVAL` AS `PERMIS_BUSINESS_APPROVAL`,`u`.`PERMIS_APPLICATION_FORM` AS `PERMIS_APPLICATION_FORM`,`u`.`PERMIS_APPLICATION_FORM_EVALUATION` AS `PERMIS_APPLICATION_FORM_EVALUATION`,`bo`.`ACTIVE_FLAG` AS `ACTIVE_FLAG`,`bs`.`BARANGAY_SEAL` AS `BARANGAY_SEAL`,`mi`.`MUNICIPAL_SEAL` AS `MUNICIPAL_SEAL`,`mi`.`MUNICIPAL_NAME` AS `MUNICIPAL_NAME`,`mi`.`PROVINCE_NAME` AS `PROVINCE_NAME` from (((((`t_users` `u` join `t_barangay_official` `bo` on((`bo`.`BARANGAY_OFFICIAL_ID` = `u`.`BARANGAY_OFFICIAL_ID`))) join `r_barangay_information` `bs` on((`bs`.`BARANGAY_ID` = `bo`.`BARANGAY_ID`))) join `t_resident_basic_info` `rbi` on((`bo`.`RESIDENT_ID` = `rbi`.`RESIDENT_ID`))) join `r_position` `p` on((`p`.`POSITION_ID` = `u`.`POSITION_ID`))) join `r_municipal_information` `mi` on((`mi`.`MUNICIPAL_ID` = `bs`.`MUNICIPAL_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_resident`
--
DROP TABLE IF EXISTS `v_resident`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_resident`  AS  select `t_resident_basic_info`.`RESIDENT_ID` AS `RESIDENT_ID`,concat(`t_resident_basic_info`.`FIRSTNAME`,' ',`t_resident_basic_info`.`MIDDLENAME`,' ',`t_resident_basic_info`.`LASTNAME`) AS `RESIDENT_NAME`,concat(if(isnull(`t_resident_basic_info`.`ADDRESS_UNIT_NO`),'','Unit '),ifnull(`t_resident_basic_info`.`ADDRESS_UNIT_NO`,''),' ',ifnull(`t_resident_basic_info`.`ADDRESS_BUILDING`,''),' ',ifnull(`t_resident_basic_info`.`ADDRESS_PHASE`,''),' ',ifnull(`t_resident_basic_info`.`ADDRESS_BLOCK_NO`,''),' ',ifnull(`t_resident_basic_info`.`ADDRESS_STREET`,''),' ',ifnull(`t_resident_basic_info`.`ADDRESS_SUBDIVISION`,''),' ') AS `ADDRESS`,`t_resident_basic_info`.`DATE_OF_BIRTH` AS `DATE_OF_BIRTH`,`t_resident_basic_info`.`SEX` AS `SEX`,`t_resident_basic_info`.`IS_OFW` AS `IS_OFW`,`t_resident_basic_info`.`CIVIL_STATUS` AS `CIVIL_STATUS` from `t_resident_basic_info` ;

-- --------------------------------------------------------

--
-- Structure for view `v_useraccount`
--
DROP TABLE IF EXISTS `v_useraccount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_useraccount`  AS  select `p`.`POSITION_NAME` AS `POSITION_NAME`,`bs`.`BARANGAY_NAME` AS `BARANGAY_NAME`,`u`.`FIRSTNAME` AS `FIRSTNAME`,`u`.`MIDDLENAME` AS `MIDDLENAME`,`u`.`LASTNAME` AS `LASTNAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`u`.`EMAIL` AS `EMAIL`,`u`.`ACTIVE_FLAG` AS `ACTIVE_FLAG` from (((`t_users` `u` join `r_position` `p` on((`p`.`POSITION_ID` = `u`.`POSITION_ID`))) left join `r_barangay_information` `bs` on((`u`.`USER_ID` = `bs`.`USER_ID`))) left join `t_barangay_official` `bo` on((`u`.`BARANGAY_OFFICIAL_ID` = `bo`.`BARANGAY_OFFICIAL_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_useraccounts`
--
DROP TABLE IF EXISTS `v_useraccounts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_useraccounts`  AS  select `u`.`BARANGAY_OFFICIAL_ID` AS `BARANGAY_OFFICIAL_ID`,`p`.`POSITION_NAME` AS `POSITION_NAME`,ifnull(`bi`.`BARANGAY_NAME`,'Null') AS `BARANGAY_NAME`,`u`.`LASTNAME` AS `LASTNAME`,`u`.`FIRSTNAME` AS `FIRSTNAME`,`u`.`MIDDLENAME` AS `MIDDLENAME`,`u`.`USERNAME` AS `USERNAME`,`u`.`PASSWORD` AS `PASSWORD`,`u`.`ACTIVE_FLAG` AS `ACTIVE_FLAG`,`u`.`IS_FIRST_LOGGED_IN` AS `IS_FIRST_LOGGED_IN`,`u`.`USER_ID` AS `USER_ID` from (((`t_users` `u` left join `t_barangay_official` `bo` on((`u`.`BARANGAY_OFFICIAL_ID` = `bo`.`BARANGAY_OFFICIAL_ID`))) join `r_position` `p` on((`u`.`POSITION_ID` = `p`.`POSITION_ID`))) left join `r_barangay_information` `bi` on((`bo`.`BARANGAY_ID` = `bi`.`BARANGAY_ID`))) ;

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
-- Indexes for table `r_paper_type`
--
ALTER TABLE `r_paper_type`
  ADD PRIMARY KEY (`PAPER_TYPE_ID`);

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
-- Indexes for table `t_application_form`
--
ALTER TABLE `t_application_form`
  ADD PRIMARY KEY (`FORM_ID`),
  ADD KEY `PAPER_TYPE_ID` (`PAPER_TYPE_ID`),
  ADD KEY `FK_ApplicationForm_BusinessInformation` (`BUSINESS_ID`),
  ADD KEY `FK_ApplicationForm_Resident` (`RESIDENT_ID`),
  ADD KEY `FK_ApplicationFormRequest_PaperType` (`REQUESTED_PAPER_TYPE_ID`);

--
-- Indexes for table `t_application_form_evaluation`
--
ALTER TABLE `t_application_form_evaluation`
  ADD PRIMARY KEY (`AF_EVALUATION_ID`),
  ADD KEY `FK_ApplicationFormEvaluation_ApplicationForm` (`FORM_ID`);

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
  ADD PRIMARY KEY (`BARANGAY_CERTIFICATION_ID`),
  ADD KEY `FK_BarangayCertification_ApplicationForm` (`FORM_ID`);

--
-- Indexes for table `t_bf_barangay_clearance`
--
ALTER TABLE `t_bf_barangay_clearance`
  ADD PRIMARY KEY (`BARANGAY_CLEARANCE_ID`) USING BTREE,
  ADD KEY `fk_BarangayClearance_ScopeOfWork` (`SCOPE_OF_WORK_ID`) USING BTREE,
  ADD KEY `FK_BarangayClearance_ApplicationForm` (`FORM_ID`);

--
-- Indexes for table `t_bf_business_activity`
--
ALTER TABLE `t_bf_business_activity`
  ADD PRIMARY KEY (`BUSINESS_ACTIVITY_ID`) USING BTREE,
  ADD KEY `fk_BusinessActivity_LineOfBusiness` (`LINE_OF_BUSINESS_ID`) USING BTREE,
  ADD KEY `FK_BusinessActivity_BusinessInfo` (`BUSINESS_ID`);

--
-- Indexes for table `t_bf_business_permit`
--
ALTER TABLE `t_bf_business_permit`
  ADD PRIMARY KEY (`BUSINESS_PERMIT_ID`) USING BTREE,
  ADD KEY `FK_BusinessPermit_ApplicationForm` (`FORM_ID`);

--
-- Indexes for table `t_bf_scope_of_work`
--
ALTER TABLE `t_bf_scope_of_work`
  ADD PRIMARY KEY (`SCOPE_OF_WORK_ID`) USING BTREE,
  ADD KEY `SCOPE_OF_WORK_ID` (`SCOPE_OF_WORK_ID`) USING BTREE,
  ADD KEY `SCOPE_OF_WORK_ID_2` (`SCOPE_OF_WORK_ID`) USING BTREE;

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
  ADD KEY `FK_B_Z_ID_TBZONE` (`BARANGAY_ZONE_ID`) USING BTREE,
  ADD KEY `REFERENCED_BUSINESS_ID` (`REFERENCED_BUSINESS_ID`);

--
-- Indexes for table `t_children_profile`
--
ALTER TABLE `t_children_profile`
  ADD PRIMARY KEY (`CHILDREN_ID`) USING BTREE,
  ADD KEY `FK_CP_R_ID` (`RESIDENT_ID`) USING BTREE;

--
-- Indexes for table `t_clearance_certification`
--
ALTER TABLE `t_clearance_certification`
  ADD PRIMARY KEY (`CLEARANCE_CERTIFICATION_ID`),
  ADD KEY `FK_ClearanceCertification_ApplicationForm` (`FORM_ID`),
  ADD KEY `FK_ClearanceCertification_PaperType` (`PAPER_TYPE_ID`);

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
-- Indexes for table `t_household_batch`
--
ALTER TABLE `t_household_batch`
  ADD PRIMARY KEY (`FAMILY_HEADER_ID`) USING BTREE;

--
-- Indexes for table `t_household_information`
--
ALTER TABLE `t_household_information`
  ADD PRIMARY KEY (`HOUSEHOLD_ID`) USING BTREE,
  ADD KEY `FK_B_ID_HOUSEHOLDINFO` (`BARANGAY_ID`) USING BTREE;

--
-- Indexes for table `t_household_members`
--
ALTER TABLE `t_household_members`
  ADD PRIMARY KEY (`FAMILY_INFORMATION_ID`) USING BTREE;

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
  ADD KEY `FK_O_BO_ID` (`BARANGAY_OFFICIAL_ID`) USING BTREE;

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
-- Indexes for table `t_solo_parent_children`
--
ALTER TABLE `t_solo_parent_children`
  ADD PRIMARY KEY (`CHILD_ID`),
  ADD KEY `FK_SoloParentChild_BarangayCertificaiton` (`BARANGAY_CERTIFICATION_ID`);

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
  MODIFY `BARANGAY_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `r_barangay_zone`
--
ALTER TABLE `r_barangay_zone`
  MODIFY `BARANGAY_ZONE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `r_bf_line_of_business`
--
ALTER TABLE `r_bf_line_of_business`
  MODIFY `LINE_OF_BUSINESS_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `r_blotter_subjects`
--
ALTER TABLE `r_blotter_subjects`
  MODIFY `BLOTTER_SUBJECT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `r_business_nature`
--
ALTER TABLE `r_business_nature`
  MODIFY `BUSINESS_NATURE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
-- AUTO_INCREMENT for table `r_paper_type`
--
ALTER TABLE `r_paper_type`
  MODIFY `PAPER_TYPE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `r_position`
--
ALTER TABLE `r_position`
  MODIFY `POSITION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `r_resident_type`
--
ALTER TABLE `r_resident_type`
  MODIFY `TYPE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `t_application_form`
--
ALTER TABLE `t_application_form`
  MODIFY `FORM_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `t_application_form_evaluation`
--
ALTER TABLE `t_application_form_evaluation`
  MODIFY `AF_EVALUATION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `t_barangay_official`
--
ALTER TABLE `t_barangay_official`
  MODIFY `BARANGAY_OFFICIAL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `t_bf_barangay_certification`
--
ALTER TABLE `t_bf_barangay_certification`
  MODIFY `BARANGAY_CERTIFICATION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `t_bf_barangay_clearance`
--
ALTER TABLE `t_bf_barangay_clearance`
  MODIFY `BARANGAY_CLEARANCE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `t_bf_business_activity`
--
ALTER TABLE `t_bf_business_activity`
  MODIFY `BUSINESS_ACTIVITY_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `t_bf_business_permit`
--
ALTER TABLE `t_bf_business_permit`
  MODIFY `BUSINESS_PERMIT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `t_bf_scope_of_work`
--
ALTER TABLE `t_bf_scope_of_work`
  MODIFY `SCOPE_OF_WORK_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `t_blotter`
--
ALTER TABLE `t_blotter`
  MODIFY `BLOTTER_ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `t_business_approval`
--
ALTER TABLE `t_business_approval`
  MODIFY `APPROVAL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `t_business_information`
--
ALTER TABLE `t_business_information`
  MODIFY `BUSINESS_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `t_children_profile`
--
ALTER TABLE `t_children_profile`
  MODIFY `CHILDREN_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_clearance_certification`
--
ALTER TABLE `t_clearance_certification`
  MODIFY `CLEARANCE_CERTIFICATION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `t_fathers_profile`
--
ALTER TABLE `t_fathers_profile`
  MODIFY `FATHERS_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_food_eaten`
--
ALTER TABLE `t_food_eaten`
  MODIFY `FOOD_EATEN_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_household_batch`
--
ALTER TABLE `t_household_batch`
  MODIFY `FAMILY_HEADER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=855;

--
-- AUTO_INCREMENT for table `t_household_information`
--
ALTER TABLE `t_household_information`
  MODIFY `HOUSEHOLD_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1268;

--
-- AUTO_INCREMENT for table `t_household_members`
--
ALTER TABLE `t_household_members`
  MODIFY `FAMILY_INFORMATION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=948;

--
-- AUTO_INCREMENT for table `t_hs_adolescent`
--
ALTER TABLE `t_hs_adolescent`
  MODIFY `ADOLESCENT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `t_hs_child`
--
ALTER TABLE `t_hs_child`
  MODIFY `CHILD_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `t_hs_chronic_cough`
--
ALTER TABLE `t_hs_chronic_cough`
  MODIFY `CHRONIC_COUGH_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `t_hs_chronic_disease`
--
ALTER TABLE `t_hs_chronic_disease`
  MODIFY `CHRONIC_DISEASE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `INFANT_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_hs_newborn`
--
ALTER TABLE `t_hs_newborn`
  MODIFY `NEWBORN_ID` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `PREGNANT_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `t_ordinance`
--
ALTER TABLE `t_ordinance`
  MODIFY `ORDINANCE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `t_patawag`
--
ALTER TABLE `t_patawag`
  MODIFY `PATAWAG_ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `t_resident_basic_info`
--
ALTER TABLE `t_resident_basic_info`
  MODIFY `RESIDENT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3863;

--
-- AUTO_INCREMENT for table `t_users`
--
ALTER TABLE `t_users`
  MODIFY `USER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
