-- MySQL dump 10.13  Distrib 8.4.6, for Linux (x86_64)
--
-- Host: localhost    Database: dasar_python_db
-- ------------------------------------------------------
-- Server version	8.4.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `dasar_python_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `dasar_python_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `dasar_python_db`;

--
-- Table structure for table `api_documentation`
--

DROP TABLE IF EXISTS `api_documentation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_documentation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `method_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parameters` json DEFAULT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_documentation_method_type_url_040802fd_uniq` (`method_type`,`url`),
  KEY `api_documen_url_b0782d_idx` (`url`),
  KEY `api_documen_method__c36e3c_idx` (`method_type`),
  KEY `api_documen_is_acti_8df1ab_idx` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_documentation`
--

LOCK TABLES `api_documentation` WRITE;
/*!40000 ALTER TABLE `api_documentation` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_documentation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (1,'Super Admin');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add api access log',6,'add_apiaccesslog'),(22,'Can change api access log',6,'change_apiaccesslog'),(23,'Can delete api access log',6,'delete_apiaccesslog'),(24,'Can view api access log',6,'view_apiaccesslog'),(25,'Can add ms log data',7,'add_mslogdata'),(26,'Can change ms log data',7,'change_mslogdata'),(27,'Can delete ms log data',7,'delete_mslogdata'),(28,'Can view ms log data',7,'view_mslogdata'),(29,'Can add User',8,'add_user'),(30,'Can change User',8,'change_user'),(31,'Can delete User',8,'delete_user'),(32,'Can view User',8,'view_user'),(33,'Can add Permission Control',9,'add_permissioncontrol'),(34,'Can change Permission Control',9,'change_permissioncontrol'),(35,'Can delete Permission Control',9,'delete_permissioncontrol'),(36,'Can view Permission Control',9,'view_permissioncontrol'),(37,'Can add Permission Function',10,'add_permissionfunction'),(38,'Can change Permission Function',10,'change_permissionfunction'),(39,'Can delete Permission Function',10,'delete_permissionfunction'),(40,'Can view Permission Function',10,'view_permissionfunction'),(41,'Can add Permission Module',11,'add_permissionmodule'),(42,'Can change Permission Module',11,'change_permissionmodule'),(43,'Can delete Permission Module',11,'delete_permissionmodule'),(44,'Can view Permission Module',11,'view_permissionmodule'),(45,'Can add Permission Rule',12,'add_permissionrule'),(46,'Can change Permission Rule',12,'change_permissionrule'),(47,'Can delete Permission Rule',12,'delete_permissionrule'),(48,'Can view Permission Rule',12,'view_permissionrule'),(49,'Can add Role Rule',13,'add_rolerule'),(50,'Can change Role Rule',13,'change_rolerule'),(51,'Can delete Role Rule',13,'delete_rolerule'),(52,'Can view Role Rule',13,'view_rolerule'),(53,'Can add User Table Selection',14,'add_usertableselection'),(54,'Can change User Table Selection',14,'change_usertableselection'),(55,'Can delete User Table Selection',14,'delete_usertableselection'),(56,'Can view User Table Selection',14,'view_usertableselection'),(57,'Can add Menu Item',15,'add_menuitem'),(58,'Can change Menu Item',15,'change_menuitem'),(59,'Can delete Menu Item',15,'delete_menuitem'),(60,'Can view Menu Item',15,'view_menuitem'),(61,'Can add Menu Category',16,'add_menucategory'),(62,'Can change Menu Category',16,'change_menucategory'),(63,'Can delete Menu Category',16,'delete_menucategory'),(64,'Can view Menu Category',16,'view_menucategory'),(65,'Can add API Documentation',17,'add_apidocumentation'),(66,'Can change API Documentation',17,'change_apidocumentation'),(67,'Can delete API Documentation',17,'delete_apidocumentation'),(68,'Can view API Documentation',17,'view_apidocumentation'),(69,'Can add Combo Box Config',18,'add_comboboxconfig'),(70,'Can change Combo Box Config',18,'change_comboboxconfig'),(71,'Can delete Combo Box Config',18,'delete_comboboxconfig'),(72,'Can view Combo Box Config',18,'view_comboboxconfig');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `combo_box_configs`
--

DROP TABLE IF EXISTS `combo_box_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `combo_box_configs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `config` json NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `combo_box_configs`
--

LOCK TABLES `combo_box_configs` WRITE;
/*!40000 ALTER TABLE `combo_box_configs` DISABLE KEYS */;
/*!40000 ALTER TABLE `combo_box_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_users_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (8,'accounts','user'),(1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'contenttypes','contenttype'),(6,'esimpeg_core','apiaccesslog'),(7,'esimpeg_core','mslogdata'),(17,'manajemen_aplikasi','apidocumentation'),(18,'manajemen_aplikasi','comboboxconfig'),(16,'manajemen_aplikasi','menucategory'),(15,'manajemen_aplikasi','menuitem'),(9,'manajemen_aplikasi','permissioncontrol'),(10,'manajemen_aplikasi','permissionfunction'),(11,'manajemen_aplikasi','permissionmodule'),(12,'manajemen_aplikasi','permissionrule'),(13,'manajemen_aplikasi','rolerule'),(14,'manajemen_aplikasi','usertableselection'),(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-03-09 10:49:34.307153'),(2,'contenttypes','0002_remove_content_type_name','2026-03-09 10:49:34.331656'),(3,'auth','0001_initial','2026-03-09 10:49:34.404990'),(4,'auth','0002_alter_permission_name_max_length','2026-03-09 10:49:34.422395'),(5,'auth','0003_alter_user_email_max_length','2026-03-09 10:49:34.426396'),(6,'auth','0004_alter_user_username_opts','2026-03-09 10:49:34.429973'),(7,'auth','0005_alter_user_last_login_null','2026-03-09 10:49:34.433296'),(8,'auth','0006_require_contenttypes_0002','2026-03-09 10:49:34.434322'),(9,'auth','0007_alter_validators_add_error_messages','2026-03-09 10:49:34.437233'),(10,'auth','0008_alter_user_username_max_length','2026-03-09 10:49:34.440573'),(11,'auth','0009_alter_user_last_name_max_length','2026-03-09 10:49:34.443688'),(12,'auth','0010_alter_group_name_max_length','2026-03-09 10:49:34.450172'),(13,'auth','0011_update_proxy_permissions','2026-03-09 10:49:34.454022'),(14,'auth','0012_alter_user_first_name_max_length','2026-03-09 10:49:34.458315'),(15,'accounts','0001_initial','2026-03-09 10:49:34.468066'),(16,'accounts','0002_user_groups_user_user_permissions','2026-03-09 10:49:34.560113'),(17,'accounts','0003_alter_user_email','2026-03-09 10:49:34.580238'),(18,'accounts','0004_remove_user_id_status','2026-03-09 10:49:34.600446'),(19,'admin','0001_initial','2026-03-09 10:49:34.643679'),(20,'admin','0002_logentry_remove_auto_add','2026-03-09 10:49:34.648531'),(21,'admin','0003_logentry_add_action_flag_choices','2026-03-09 10:49:34.652577'),(22,'esimpeg_core','0001_initial','2026-03-09 10:49:34.719981'),(23,'esimpeg_core','0002_rename_table_to_ms_log_api','2026-03-09 10:49:34.748488'),(24,'esimpeg_core','0003_add_ms_log_data','2026-03-09 10:49:34.796193'),(25,'esimpeg_core','0004_add_hybrid_fields_to_ms_log_data','2026-03-09 10:49:34.876447'),(26,'manajemen_aplikasi','0001_initial','2026-03-09 10:49:35.010445'),(27,'manajemen_aplikasi','0002_usertableselection','2026-03-09 10:49:35.049567'),(28,'manajemen_aplikasi','0003_menuitem','2026-03-09 10:49:35.073118'),(29,'manajemen_aplikasi','0004_menucategory','2026-03-09 10:49:35.086113'),(30,'manajemen_aplikasi','0005_alter_permissionrule_control_and_more','2026-03-09 10:49:35.110300'),(31,'manajemen_aplikasi','0006_apidocumentation','2026-03-09 10:49:35.141543'),(32,'manajemen_aplikasi','0007_rename_api_doc_url_idx_api_documen_url_b0782d_idx_and_more','2026-03-09 10:49:35.158691'),(33,'manajemen_aplikasi','0008_comboboxconfig','2026-03-09 10:49:35.170191'),(34,'sessions','0001_initial','2026-03-09 10:49:35.182675');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_categories`
--

DROP TABLE IF EXISTS `menu_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_categories`
--

LOCK TABLES `menu_categories` WRITE;
/*!40000 ALTER TABLE `menu_categories` DISABLE KEYS */;
INSERT INTO `menu_categories` VALUES (1,6,'Beranda',0,1,'2026-03-09 10:49:35.493081','2026-03-09 10:49:35.493098'),(2,1,'Pengaturan Sistem',1,1,'2026-03-09 10:49:35.494799','2026-03-09 10:49:35.494818'),(3,5,'Master Data',2,1,'2026-03-09 10:49:35.496364','2026-03-09 10:49:35.496378'),(4,2,'Data Pegawai',3,1,'2026-03-09 10:49:35.497779','2026-03-09 10:49:35.497792'),(5,3,'Laporan Data',4,1,'2026-03-09 10:49:35.499089','2026-03-09 10:49:35.499101'),(6,4,'Manajemen Integrasi',5,1,'2026-03-09 10:49:35.500465','2026-03-09 10:49:35.500479'),(7,0,'Menu Lainnya',99,1,'2026-03-09 10:49:35.502055','2026-03-09 10:49:35.502069');
/*!40000 ALTER TABLE `menu_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission_key` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `external_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL,
  `category` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menu_items_parent_id_7032fad2_fk_menu_items_id` (`parent_id`),
  CONSTRAINT `menu_items_parent_id_7032fad2_fk_menu_items_id` FOREIGN KEY (`parent_id`) REFERENCES `menu_items` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_items`
--

LOCK TABLES `menu_items` WRITE;
/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;
INSERT INTO `menu_items` VALUES (1,'Beranda','dashboard.dashboard_main.view','dashboard:index',NULL,'fas fa-home','module',1,6,1,'2026-03-09 10:49:35.526386','2026-03-09 10:49:35.526405',NULL),(2,'Pengaturan Aplikasi',NULL,NULL,NULL,'fas fa-cogs','menuItem',1,1,1,'2026-03-09 10:49:35.533511','2026-03-09 10:49:35.533529',NULL),(3,'Manajemen Akses Granular','pengaturan.manajemen_permission.view','manajemen_aplikasi:dashboard',NULL,'fas fa-shield-alt','module',1,1,1,'2026-03-09 10:49:35.535984','2026-03-09 10:49:35.536006',2),(4,'Manajemen Menu','pengaturan.manajemen_menu.view','manajemen_aplikasi:menu_list',NULL,'fas fa-sitemap','module',2,1,1,'2026-03-09 10:49:35.538670','2026-03-09 11:02:48.822610',2),(90,'Dokumentasi API','pengaturan.api_documentation.view','manajemen_aplikasi:api_documentation_list',NULL,'fas fa-book','module',3,1,1,'2026-03-09 10:49:35.726489','2026-03-09 10:49:35.726508',2),(91,'Dokumentasi AJAX','pengaturan.api_documentation.view','manajemen_aplikasi:ajax_documentation_list',NULL,'fas fa-bolt','module',4,1,1,'2026-03-09 10:49:35.728621','2026-03-09 10:49:35.728639',2),(92,'Manajemen Fungsi','pengaturan.permission_function.view','manajemen_aplikasi:function_list',NULL,'fas fa-bolt','module',5,1,1,'2026-03-09 10:49:35.730537','2026-03-09 10:49:35.730554',2),(93,'Manajemen Kontrol','pengaturan.permission_control.view','manajemen_aplikasi:control_list',NULL,'fas fa-database','module',6,1,1,'2026-03-09 10:49:35.732419','2026-03-09 10:49:35.732434',2),(94,'Manajemen Module','pengaturan.permission_module.view','manajemen_aplikasi:module_list',NULL,'fas fa-th-large','module',7,1,1,'2026-03-09 10:49:35.734077','2026-03-09 10:49:35.734090',2),(95,'Manajemen Rules','pengaturan.permission_rule.view','manajemen_aplikasi:rule_list',NULL,'fas fa-gavel','module',8,1,1,'2026-03-09 10:49:35.735731','2026-03-09 10:49:35.735744',2),(96,'Manajemen Role','pengaturan.permission_role.view','manajemen_aplikasi:roles_list',NULL,'fas fa-user-tag','module',9,1,1,'2026-03-09 10:49:35.737562','2026-03-09 10:49:35.737578',2),(97,'Manajemen User','pengaturan.permission_user.view','manajemen_aplikasi:users_list',NULL,'fas fa-users-cog','module',10,1,1,'2026-03-09 10:49:35.739327','2026-03-09 10:49:35.739341',2),(98,'Akun Saya',NULL,NULL,NULL,'fas fa-user-circle','menuItem',99,0,1,'2026-03-09 10:49:35.740972','2026-03-09 10:49:35.740983',NULL),(99,'Pengaturan Akun',NULL,'accounts:profile',NULL,'fas fa-user-circle','module',1,0,1,'2026-03-09 10:49:35.743377','2026-03-09 10:49:35.743393',98),(100,'Ganti Password',NULL,'accounts:change_password',NULL,'fas fa-key','module',2,0,1,'2026-03-09 10:49:35.745345','2026-03-09 10:49:35.745367',98),(101,'Logout',NULL,'accounts:logout',NULL,'fas fa-sign-out-alt','module',100,0,1,'2026-03-09 10:49:35.746815','2026-03-09 10:49:35.746829',NULL);
/*!40000 ALTER TABLE `menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_log_api`
--

DROP TABLE IF EXISTS `ms_log_api`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_log_api` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `method` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `endpoint` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_url` longtext COLLATE utf8mb4_unicode_ci,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` longtext COLLATE utf8mb4_unicode_ci,
  `request_headers` json DEFAULT NULL,
  `request_body` json DEFAULT NULL,
  `query_params` json DEFAULT NULL,
  `status_code` smallint NOT NULL,
  `response_size` int DEFAULT NULL,
  `response_time` decimal(8,3) DEFAULT NULL,
  `api_version` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rate_limit_hit` tinyint(1) NOT NULL,
  `error_message` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `api_access_log_endpoint_bd956e63` (`endpoint`),
  KEY `api_access_log_ip_address_891afb22` (`ip_address`),
  KEY `api_access_log_status_code_aed1bf5e` (`status_code`),
  KEY `api_access_log_created_at_9b2bc6b2` (`created_at`),
  KEY `ms_log_api_method_878072_idx` (`method`,`endpoint`),
  KEY `ms_log_api_user_id_91e99a_idx` (`user_id`,`created_at`),
  CONSTRAINT `api_access_log_user_id_97c9e751_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_log_api`
--

LOCK TABLES `ms_log_api` WRITE;
/*!40000 ALTER TABLE `ms_log_api` DISABLE KEYS */;
INSERT INTO `ms_log_api` VALUES (1,'POST','/','http://localhost:8007/',NULL,'172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"*/*\", \"Content-Type\": \"multipart/form-data; boundary=----WebKitFormBoundaryiSuEqCP3K2ehktnK\"}',NULL,NULL,403,2506,0.020,NULL,0,NULL,'2026-03-09 10:50:21.959104',NULL),(2,'GET','/dashboard/','http://localhost:8007/dashboard/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,500,157288,0.030,NULL,0,NULL,'2026-03-09 10:50:35.559841',1),(3,'GET','/dashboard/','http://localhost:8007/dashboard/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,500,215080,0.203,NULL,0,NULL,'2026-03-09 10:52:33.239175',1),(4,'GET','/manajemen-aplikasi/api-documentation/','http://localhost:8007/manajemen-aplikasi/api-documentation/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,403,92481,0.121,NULL,0,NULL,'2026-03-09 10:54:48.161022',1),(5,'GET','/login/','http://localhost:8007/login/',NULL,'172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,200,27975,0.003,NULL,0,NULL,'2026-03-09 10:54:51.102587',NULL),(6,'POST','/login/','http://localhost:8007/login/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"*/*\", \"Content-Type\": \"multipart/form-data; boundary=----WebKitFormBoundaryfYhdIAnKUEhKPdBw\"}',NULL,NULL,200,111,0.175,NULL,0,NULL,'2026-03-09 10:55:04.278662',1),(7,'GET','/manajemen-aplikasi/menu/','http://localhost:8007/manajemen-aplikasi/menu/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,403,92478,0.033,NULL,0,NULL,'2026-03-09 10:55:13.105690',1),(8,'GET','/manajemen-aplikasi/combobox-config/','http://localhost:8007/manajemen-aplikasi/combobox-config/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,403,92479,0.096,NULL,0,NULL,'2026-03-09 10:55:17.250489',1),(9,'GET','/manajemen-aplikasi/ajax-documentation/','http://localhost:8007/manajemen-aplikasi/ajax-documentation/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,403,92481,0.015,NULL,0,NULL,'2026-03-09 10:55:27.013707',1),(10,'GET','/login/','http://localhost:8007/login/',NULL,'172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,200,27975,0.001,NULL,0,NULL,'2026-03-09 10:58:53.230114',NULL),(11,'POST','/login/','http://localhost:8007/login/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"*/*\", \"Content-Type\": \"multipart/form-data; boundary=----WebKitFormBoundaryquoy2LVa7wEWDEcx\"}',NULL,NULL,200,111,0.172,NULL,0,NULL,'2026-03-09 10:59:04.778696',1),(12,'GET','/manajemen-aplikasi/combobox-config/','http://localhost:8007/manajemen-aplikasi/combobox-config/','Prakom@admin2025.com','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','{\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\"}',NULL,NULL,500,185641,0.055,NULL,0,NULL,'2026-03-09 10:59:24.141714',1);
/*!40000 ALTER TABLE `ms_log_api` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_log_data`
--

DROP TABLE IF EXISTS `ms_log_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_log_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `table_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` int DEFAULT NULL,
  `old_data` json DEFAULT NULL,
  `new_data` json DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `via` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ms_log_data_user_id_ea5c0fe4` (`user_id`),
  KEY `ms_log_data_action_ef9f1a84` (`action`),
  KEY `ms_log_data_table_name_1b9e3902` (`table_name`),
  KEY `ms_log_data_ip_address_b0d3b095` (`ip_address`),
  KEY `ms_log_data_created_at_64f811a7` (`created_at`),
  KEY `ms_log_data_user_id_f24e30_idx` (`user_id`,`created_at`),
  KEY `ms_log_data_action_1025af_idx` (`action`,`table_name`),
  KEY `ms_log_data_via_f9a1ef_idx` (`via`,`created_at`),
  KEY `ms_log_data_via_ca62a27c` (`via`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_log_data`
--

LOCK TABLES `ms_log_data` WRITE;
/*!40000 ALTER TABLE `ms_log_data` DISABLE KEYS */;
INSERT INTO `ms_log_data` VALUES (1,1,'login','users',1,NULL,'{\"user_data\": {\"id\": 1, \"name\": \"Prakom Admin\", \"email\": \"Prakom@admin2025.com\"}, \"login_time\": \"\"}','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','2026-03-09 10:50:32.430785','2026-03-09 10:50:32.430796','Login via web','Prakom@admin2025.com','web'),(2,NULL,'login_failed','users',NULL,'{\"reason\": \"Invalid password\", \"attempted_username\": \"Prakom@admin2025.com\"}',NULL,'172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','2026-03-09 10:52:20.338732','2026-03-09 10:52:20.338770','Failed login attempt via web','Prakom@admin2025.com','web'),(3,NULL,'login_failed','users',NULL,'{\"reason\": \"Invalid password\", \"attempted_username\": \"Prakom@admin2025.com\"}',NULL,'172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','2026-03-09 10:52:23.931736','2026-03-09 10:52:23.931775','Failed login attempt via web','Prakom@admin2025.com','web'),(4,1,'login','users',1,NULL,'{\"user_data\": {\"id\": 1, \"name\": \"Prakom Admin\", \"email\": \"Prakom@admin2025.com\"}, \"login_time\": \"\"}','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','2026-03-09 10:52:29.826760','2026-03-09 10:52:29.826784','Login via web','Prakom@admin2025.com','web'),(5,1,'login','users',1,NULL,'{\"user_data\": {\"id\": 1, \"name\": \"Prakom Admin\", \"email\": \"Prakom@admin2025.com\"}, \"login_time\": \"\"}','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','2026-03-09 10:54:36.586810','2026-03-09 10:54:36.586833','Login via web','Prakom@admin2025.com','web'),(6,1,'login','users',1,NULL,'{\"user_data\": {\"id\": 1, \"name\": \"Prakom Admin\", \"email\": \"Prakom@admin2025.com\"}, \"login_time\": \"\"}','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','2026-03-09 10:55:04.181892','2026-03-09 10:55:04.181909','Login via web','Prakom@admin2025.com','web'),(7,1,'login','users',1,NULL,'{\"user_data\": {\"id\": 1, \"name\": \"Prakom Admin\", \"email\": \"Prakom@admin2025.com\"}, \"login_time\": \"\"}','172.22.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0','2026-03-09 10:59:04.679434','2026-03-09 10:59:04.679455','Login via web','Prakom@admin2025.com','web');
/*!40000 ALTER TABLE `ms_log_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_controls`
--

DROP TABLE IF EXISTS `permission_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_controls` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nama_kontrol` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_kontrol` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi_kontrol` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama_kontrol` (`nama_kontrol`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_controls`
--

LOCK TABLES `permission_controls` WRITE;
/*!40000 ALTER TABLE `permission_controls` DISABLE KEYS */;
INSERT INTO `permission_controls` VALUES (1,'dashboard_main','Dashboard Utama','Halaman dashboard utama','2026-03-09 10:49:35.269024','2026-03-09 10:49:35.269038'),(2,'dashboard_analytics','Dashboard Analytics','Analytics dan statistik','2026-03-09 10:49:35.270437','2026-03-09 10:49:35.270450'),(3,'ms_pegawai','Master Pegawai','Data master pegawai','2026-03-09 10:49:35.272094','2026-03-09 10:49:35.272110'),(4,'pegawai_siasn','Pegawai SIASN','Data pegawai dari SIASN','2026-03-09 10:49:35.273550','2026-03-09 10:49:35.273563'),(5,'pegawai_profil','Profil Pegawai','Profil detail pegawai','2026-03-09 10:49:35.274890','2026-03-09 10:49:35.274902'),(6,'riwayat_jabatan','Riwayat Jabatan','Riwayat jabatan pegawai','2026-03-09 10:49:35.276194','2026-03-09 10:49:35.276208'),(7,'riwayat_pendidikan','Riwayat Pendidikan','Riwayat pendidikan pegawai','2026-03-09 10:49:35.277646','2026-03-09 10:49:35.277660'),(8,'riwayat_penghargaan','Riwayat Penghargaan','Riwayat penghargaan pegawai','2026-03-09 10:49:35.279136','2026-03-09 10:49:35.279150'),(9,'siasn_dashboard','SIASN Dashboard','Dashboard integrasi SIASN','2026-03-09 10:49:35.280723','2026-03-09 10:49:35.280740'),(10,'siasn_cache','SIASN Cache','Data cache SIASN','2026-03-09 10:49:35.282140','2026-03-09 10:49:35.282152'),(11,'siasn_logs','SIASN Logs','Log API SIASN','2026-03-09 10:49:35.283506','2026-03-09 10:49:35.283518'),(12,'siasn_token','SIASN Token','Token akses SIASN','2026-03-09 10:49:35.284832','2026-03-09 10:49:35.284845'),(13,'laporan_pegawai','Laporan Pegawai','Laporan data pegawai','2026-03-09 10:49:35.286419','2026-03-09 10:49:35.286434'),(14,'laporan_statistik','Laporan Statistik','Laporan statistik','2026-03-09 10:49:35.287926','2026-03-09 10:49:35.287940'),(15,'manajemen_user','Manajemen User','Manajemen pengguna sistem','2026-03-09 10:49:35.289397','2026-03-09 10:49:35.289410'),(16,'manajemen_permission','Manajemen Permission','Manajemen permission & roles','2026-03-09 10:49:35.290703','2026-03-09 10:49:35.290714'),(17,'permission_dashboard','Permission Dashboard',NULL,'2026-03-09 10:49:35.319246','2026-03-09 10:49:35.319270'),(18,'permission_function','Permission Functions',NULL,'2026-03-09 10:49:35.321145','2026-03-09 10:49:35.321165'),(19,'permission_control','Permission Controls',NULL,'2026-03-09 10:49:35.322641','2026-03-09 10:49:35.322657'),(20,'permission_module','Permission Modules',NULL,'2026-03-09 10:49:35.324053','2026-03-09 10:49:35.324067'),(21,'permission_rule','Permission Rules',NULL,'2026-03-09 10:49:35.325576','2026-03-09 10:49:35.325599'),(22,'permission_role','Roles Management',NULL,'2026-03-09 10:49:35.327318','2026-03-09 10:49:35.327335'),(23,'permission_user','Users Management',NULL,'2026-03-09 10:49:35.328893','2026-03-09 10:49:35.328908'),(24,'permission_role_rule','Role → Rules Assignment',NULL,'2026-03-09 10:49:35.330329','2026-03-09 10:49:35.330343'),(25,'manajemen_menu','Manajemen Menu',NULL,'2026-03-09 10:56:33.420132','2026-03-09 10:56:33.420157'),(26,'menu_category','Kategori Menu',NULL,'2026-03-09 10:56:33.422607','2026-03-09 10:56:33.422626'),(28,'api_documentation','Dokumentasi API',NULL,'2026-03-09 10:56:33.491154','2026-03-09 10:56:33.491177');
/*!40000 ALTER TABLE `permission_controls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_functions`
--

DROP TABLE IF EXISTS `permission_functions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_functions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nama_fungsi` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_fungsi` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi_fungsi` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama_fungsi` (`nama_fungsi`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_functions`
--

LOCK TABLES `permission_functions` WRITE;
/*!40000 ALTER TABLE `permission_functions` DISABLE KEYS */;
INSERT INTO `permission_functions` VALUES (1,'view','Lihat','Melihat/menampilkan data','2026-03-09 10:49:35.251218','2026-03-09 10:49:35.251244'),(2,'create','Tambah','Menambah data baru','2026-03-09 10:49:35.253143','2026-03-09 10:49:35.253164'),(3,'edit','Ubah','Mengubah data yang ada','2026-03-09 10:49:35.254894','2026-03-09 10:49:35.332325'),(4,'delete','Hapus','Menghapus data','2026-03-09 10:49:35.256579','2026-03-09 10:49:35.256595'),(5,'bulk_delete','Hapus Banyak','Menghapus banyak data sekaligus (bulk/multi delete)','2026-03-09 10:49:35.258568','2026-03-09 10:49:35.258585'),(6,'export','Export','Export data ke file (Excel/PDF)','2026-03-09 10:49:35.260119','2026-03-09 10:49:35.260133'),(7,'import','Import','Import data dari file','2026-03-09 10:49:35.261449','2026-03-09 10:49:35.261460'),(8,'approve','Approve','Menyetujui data/pengajuan','2026-03-09 10:49:35.262837','2026-03-09 10:49:35.262850'),(9,'reject','Reject','Menolak data/pengajuan','2026-03-09 10:49:35.264160','2026-03-09 10:49:35.264178'),(10,'print','Cetak','Mencetak data/laporan','2026-03-09 10:49:35.265622','2026-03-09 10:49:35.265634'),(11,'sync','Sinkronisasi','Sinkronisasi data dengan sistem lain','2026-03-09 10:49:35.266896','2026-03-09 10:49:35.266908');
/*!40000 ALTER TABLE `permission_functions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_modules`
--

DROP TABLE IF EXISTS `permission_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_modules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nama_module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi_module` longtext COLLATE utf8mb4_unicode_ci,
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama_module` (`nama_module`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_modules`
--

LOCK TABLES `permission_modules` WRITE;
/*!40000 ALTER TABLE `permission_modules` DISABLE KEYS */;
INSERT INTO `permission_modules` VALUES (1,'dashboard','Dashboard','Dashboard utama sistem','fas fa-tachometer-alt',1,1,'2026-03-09 10:49:35.292940','2026-03-09 10:49:35.292956'),(2,'pegawai','Data Pegawai','Manajemen data pegawai','fas fa-users',2,1,'2026-03-09 10:49:35.294419','2026-03-09 10:49:35.294431'),(3,'riwayat','Riwayat','Riwayat pegawai','fas fa-history',3,1,'2026-03-09 10:49:35.295708','2026-03-09 10:49:35.295719'),(4,'siasn','SIASN Integration','Integrasi dengan SIASN','fas fa-sync-alt',4,1,'2026-03-09 10:49:35.296942','2026-03-09 10:49:35.296953'),(5,'laporan','Laporan','Laporan dan analytics','fas fa-chart-bar',5,1,'2026-03-09 10:49:35.298743','2026-03-09 10:49:35.298759'),(6,'pengaturan','Pengaturan','Pengaturan sistem','fas fa-cogs',99,1,'2026-03-09 10:49:35.300439','2026-03-09 10:49:35.317366');
/*!40000 ALTER TABLE `permission_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_rules`
--

DROP TABLE IF EXISTS `permission_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_rules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `control_id` bigint NOT NULL,
  `function_id` bigint NOT NULL,
  `module_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permission_rules_module_id_control_id_function_id_5fe5886d_uniq` (`module_id`,`control_id`,`function_id`),
  KEY `permission_rules_control_id_5aacb27a_fk_permission_controls_id` (`control_id`),
  KEY `permission_rules_function_id_3d4b34ce_fk_permission_functions_id` (`function_id`),
  CONSTRAINT `permission_rules_control_id_5aacb27a_fk_permission_controls_id` FOREIGN KEY (`control_id`) REFERENCES `permission_controls` (`id`),
  CONSTRAINT `permission_rules_function_id_3d4b34ce_fk_permission_functions_id` FOREIGN KEY (`function_id`) REFERENCES `permission_functions` (`id`),
  CONSTRAINT `permission_rules_module_id_d7ebba46_fk_permission_modules_id` FOREIGN KEY (`module_id`) REFERENCES `permission_modules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_rules`
--

LOCK TABLES `permission_rules` WRITE;
/*!40000 ALTER TABLE `permission_rules` DISABLE KEYS */;
INSERT INTO `permission_rules` VALUES (1,1,'2026-03-09 10:49:35.306333','2026-03-09 10:49:35.306361',1,1,1),(2,1,'2026-03-09 10:49:35.308053','2026-03-09 10:49:35.308066',3,1,2),(3,1,'2026-03-09 10:49:35.309743','2026-03-09 10:49:35.309756',3,2,2),(4,1,'2026-03-09 10:49:35.311583','2026-03-09 10:49:35.311601',3,3,2),(5,1,'2026-03-09 10:49:35.313753','2026-03-09 10:49:35.313775',9,1,4),(6,1,'2026-03-09 10:49:35.335176','2026-03-09 10:49:35.335192',17,1,6),(7,1,'2026-03-09 10:49:35.336737','2026-03-09 10:49:35.336747',17,2,6),(8,1,'2026-03-09 10:49:35.338142','2026-03-09 10:49:35.338150',17,3,6),(9,1,'2026-03-09 10:49:35.339593','2026-03-09 10:49:35.339603',17,4,6),(10,1,'2026-03-09 10:49:35.341334','2026-03-09 10:49:35.341361',17,5,6),(11,1,'2026-03-09 10:49:35.343070','2026-03-09 10:49:35.343081',17,6,6),(12,1,'2026-03-09 10:49:35.344585','2026-03-09 10:49:35.344595',18,1,6),(13,1,'2026-03-09 10:49:35.346058','2026-03-09 10:49:35.346068',18,2,6),(14,1,'2026-03-09 10:49:35.348126','2026-03-09 10:49:35.348141',18,3,6),(15,1,'2026-03-09 10:49:35.349865','2026-03-09 10:49:35.349876',18,4,6),(16,1,'2026-03-09 10:49:35.351344','2026-03-09 10:49:35.351359',18,5,6),(17,1,'2026-03-09 10:49:35.352878','2026-03-09 10:49:35.352891',18,6,6),(18,1,'2026-03-09 10:49:35.354822','2026-03-09 10:49:35.354839',19,1,6),(19,1,'2026-03-09 10:49:35.356598','2026-03-09 10:49:35.356611',19,2,6),(20,1,'2026-03-09 10:49:35.358215','2026-03-09 10:49:35.358231',19,3,6),(21,1,'2026-03-09 10:49:35.359797','2026-03-09 10:49:35.359809',19,4,6),(22,1,'2026-03-09 10:49:35.361777','2026-03-09 10:49:35.361797',19,5,6),(23,1,'2026-03-09 10:49:35.363627','2026-03-09 10:49:35.363641',19,6,6),(24,1,'2026-03-09 10:49:35.365274','2026-03-09 10:49:35.365286',20,1,6),(25,1,'2026-03-09 10:49:35.366780','2026-03-09 10:49:35.366791',20,2,6),(26,1,'2026-03-09 10:49:35.368389','2026-03-09 10:49:35.368406',20,3,6),(27,1,'2026-03-09 10:49:35.370235','2026-03-09 10:49:35.370248',20,4,6),(28,1,'2026-03-09 10:49:35.371936','2026-03-09 10:49:35.371951',20,5,6),(29,1,'2026-03-09 10:49:35.373501','2026-03-09 10:49:35.373512',20,6,6),(30,1,'2026-03-09 10:49:35.375106','2026-03-09 10:49:35.375123',21,1,6),(31,1,'2026-03-09 10:49:35.376890','2026-03-09 10:49:35.376902',21,2,6),(32,1,'2026-03-09 10:49:35.378359','2026-03-09 10:49:35.378369',21,3,6),(33,1,'2026-03-09 10:49:35.379923','2026-03-09 10:49:35.379937',21,4,6),(34,1,'2026-03-09 10:49:35.381360','2026-03-09 10:49:35.381369',21,5,6),(35,1,'2026-03-09 10:49:35.383222','2026-03-09 10:49:35.383237',21,6,6),(36,1,'2026-03-09 10:49:35.384968','2026-03-09 10:49:35.384987',22,1,6),(37,1,'2026-03-09 10:49:35.386669','2026-03-09 10:49:35.386682',22,2,6),(38,1,'2026-03-09 10:49:35.388264','2026-03-09 10:49:35.388279',22,3,6),(39,1,'2026-03-09 10:49:35.390143','2026-03-09 10:49:35.390157',22,4,6),(40,1,'2026-03-09 10:49:35.392702','2026-03-09 10:49:35.392719',22,5,6),(41,1,'2026-03-09 10:49:35.394433','2026-03-09 10:49:35.394445',22,6,6),(42,1,'2026-03-09 10:49:35.396342','2026-03-09 10:49:35.396367',23,1,6),(43,1,'2026-03-09 10:49:35.398322','2026-03-09 10:49:35.398337',23,2,6),(44,1,'2026-03-09 10:49:35.399948','2026-03-09 10:49:35.399960',23,3,6),(45,1,'2026-03-09 10:49:35.401477','2026-03-09 10:49:35.401488',23,4,6),(46,1,'2026-03-09 10:49:35.402995','2026-03-09 10:49:35.403007',23,5,6),(47,1,'2026-03-09 10:49:35.404617','2026-03-09 10:49:35.404628',23,6,6),(48,1,'2026-03-09 10:49:35.406114','2026-03-09 10:49:35.406125',24,1,6),(49,0,'2026-03-09 10:49:35.407921','2026-03-09 10:49:35.407935',24,2,6),(50,1,'2026-03-09 10:49:35.409439','2026-03-09 10:49:35.409452',24,3,6),(51,0,'2026-03-09 10:49:35.411530','2026-03-09 10:49:35.411551',24,4,6),(52,0,'2026-03-09 10:49:35.413128','2026-03-09 10:49:35.413141',24,5,6),(53,0,'2026-03-09 10:49:35.414862','2026-03-09 10:49:35.414878',24,6,6),(54,0,'2026-03-09 10:49:35.753253','2026-03-09 10:49:35.753272',15,1,6),(55,1,'2026-03-09 10:49:35.757824','2026-03-09 10:49:35.757843',16,1,6),(56,1,'2026-03-09 10:56:33.427097','2026-03-09 10:56:33.427114',25,1,6),(57,1,'2026-03-09 10:56:33.428955','2026-03-09 10:56:33.428971',25,2,6),(58,1,'2026-03-09 10:56:33.430613','2026-03-09 10:56:33.430626',25,3,6),(59,1,'2026-03-09 10:56:33.432202','2026-03-09 10:56:33.432214',25,4,6),(60,1,'2026-03-09 10:56:33.433668','2026-03-09 10:56:33.433679',26,1,6),(61,1,'2026-03-09 10:56:33.435185','2026-03-09 10:56:33.435197',26,2,6),(62,1,'2026-03-09 10:56:33.436700','2026-03-09 10:56:33.436711',26,3,6),(63,1,'2026-03-09 10:56:33.438157','2026-03-09 10:56:33.438167',26,4,6),(68,1,'2026-03-09 10:56:33.494837','2026-03-09 10:56:33.494855',28,1,6),(69,1,'2026-03-09 10:56:33.496756','2026-03-09 10:56:33.496775',28,2,6),(70,1,'2026-03-09 10:56:33.498560','2026-03-09 10:56:33.498574',28,3,6),(71,1,'2026-03-09 10:56:33.500308','2026-03-09 10:56:33.500322',28,4,6);
/*!40000 ALTER TABLE `permission_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_rules`
--

DROP TABLE IF EXISTS `role_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_rules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `role_id` int NOT NULL,
  `rule_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_rules_role_id_rule_id_a25929b8_uniq` (`role_id`,`rule_id`),
  KEY `role_rules_rule_id_a9f4b229_fk_permission_rules_id` (`rule_id`),
  CONSTRAINT `role_rules_role_id_927ebd0c_fk_auth_group_id` FOREIGN KEY (`role_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `role_rules_rule_id_a9f4b229_fk_permission_rules_id` FOREIGN KEY (`rule_id`) REFERENCES `permission_rules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_rules`
--

LOCK TABLES `role_rules` WRITE;
/*!40000 ALTER TABLE `role_rules` DISABLE KEYS */;
INSERT INTO `role_rules` VALUES (1,'2026-03-09 10:49:35.424056','2026-03-09 10:49:35.424081',1,22),(2,'2026-03-09 10:49:35.425880','2026-03-09 10:49:35.425895',1,19),(3,'2026-03-09 10:49:35.427656','2026-03-09 10:49:35.427673',1,21),(4,'2026-03-09 10:49:35.429248','2026-03-09 10:49:35.429263',1,20),(5,'2026-03-09 10:49:35.430677','2026-03-09 10:49:35.430690',1,23),(6,'2026-03-09 10:49:35.432309','2026-03-09 10:49:35.432323',1,18),(7,'2026-03-09 10:49:35.433823','2026-03-09 10:49:35.433835',1,10),(8,'2026-03-09 10:49:35.435273','2026-03-09 10:49:35.435284',1,7),(9,'2026-03-09 10:49:35.436822','2026-03-09 10:49:35.436839',1,9),(10,'2026-03-09 10:49:35.438580','2026-03-09 10:49:35.438593',1,8),(11,'2026-03-09 10:49:35.440243','2026-03-09 10:49:35.440255',1,11),(12,'2026-03-09 10:49:35.441681','2026-03-09 10:49:35.441692',1,6),(13,'2026-03-09 10:49:35.442969','2026-03-09 10:49:35.442979',1,16),(14,'2026-03-09 10:49:35.444618','2026-03-09 10:49:35.444633',1,13),(15,'2026-03-09 10:49:35.446468','2026-03-09 10:49:35.446482',1,15),(16,'2026-03-09 10:49:35.448065','2026-03-09 10:49:35.448075',1,14),(17,'2026-03-09 10:49:35.449453','2026-03-09 10:49:35.449465',1,17),(18,'2026-03-09 10:49:35.450884','2026-03-09 10:49:35.450898',1,12),(19,'2026-03-09 10:49:35.452768','2026-03-09 10:49:35.452788',1,28),(20,'2026-03-09 10:49:35.454461','2026-03-09 10:49:35.454476',1,25),(21,'2026-03-09 10:49:35.455962','2026-03-09 10:49:35.455974',1,27),(22,'2026-03-09 10:49:35.457427','2026-03-09 10:49:35.457439',1,26),(23,'2026-03-09 10:49:35.459060','2026-03-09 10:49:35.459078',1,29),(24,'2026-03-09 10:49:35.460741','2026-03-09 10:49:35.460754',1,24),(25,'2026-03-09 10:49:35.462114','2026-03-09 10:49:35.462122',1,40),(26,'2026-03-09 10:49:35.463405','2026-03-09 10:49:35.463414',1,37),(27,'2026-03-09 10:49:35.464705','2026-03-09 10:49:35.464712',1,39),(28,'2026-03-09 10:49:35.466442','2026-03-09 10:49:35.466460',1,38),(29,'2026-03-09 10:49:35.467951','2026-03-09 10:49:35.467961',1,41),(30,'2026-03-09 10:49:35.469222','2026-03-09 10:49:35.469231',1,36),(31,'2026-03-09 10:49:35.470544','2026-03-09 10:49:35.470554',1,50),(32,'2026-03-09 10:49:35.471806','2026-03-09 10:49:35.471814',1,48),(33,'2026-03-09 10:49:35.473598','2026-03-09 10:49:35.473616',1,34),(34,'2026-03-09 10:49:35.475109','2026-03-09 10:49:35.475121',1,31),(35,'2026-03-09 10:49:35.476481','2026-03-09 10:49:35.476493',1,33),(36,'2026-03-09 10:49:35.477851','2026-03-09 10:49:35.477861',1,32),(37,'2026-03-09 10:49:35.479167','2026-03-09 10:49:35.479177',1,35),(38,'2026-03-09 10:49:35.480682','2026-03-09 10:49:35.480695',1,30),(39,'2026-03-09 10:49:35.482205','2026-03-09 10:49:35.482216',1,46),(40,'2026-03-09 10:49:35.483569','2026-03-09 10:49:35.483580',1,43),(41,'2026-03-09 10:49:35.484951','2026-03-09 10:49:35.484961',1,45),(42,'2026-03-09 10:49:35.486445','2026-03-09 10:49:35.486461',1,44),(43,'2026-03-09 10:49:35.488180','2026-03-09 10:49:35.488193',1,47),(44,'2026-03-09 10:49:35.489714','2026-03-09 10:49:35.489726',1,42),(45,'2026-03-09 10:49:35.754931','2026-03-09 10:49:35.754945',1,54),(46,'2026-03-09 10:49:35.759599','2026-03-09 10:49:35.759614',1,55),(51,'2026-03-09 10:56:33.453687','2026-03-09 10:56:33.453696',1,57),(52,'2026-03-09 10:56:33.455125','2026-03-09 10:56:33.455135',1,59),(53,'2026-03-09 10:56:33.456727','2026-03-09 10:56:33.456739',1,58),(54,'2026-03-09 10:56:33.458246','2026-03-09 10:56:33.458257',1,56),(55,'2026-03-09 10:56:33.460266','2026-03-09 10:56:33.460275',1,61),(56,'2026-03-09 10:56:33.461717','2026-03-09 10:56:33.461727',1,63),(57,'2026-03-09 10:56:33.463187','2026-03-09 10:56:33.463197',1,62),(58,'2026-03-09 10:56:33.464641','2026-03-09 10:56:33.464650',1,60),(59,'2026-03-09 10:56:33.503041','2026-03-09 10:56:33.503057',1,69),(60,'2026-03-09 10:56:33.504498','2026-03-09 10:56:33.504511',1,71),(61,'2026-03-09 10:56:33.505831','2026-03-09 10:56:33.505842',1,70),(62,'2026-03-09 10:56:33.507142','2026-03-09 10:56:33.507154',1,68),(63,'2026-03-09 10:56:35.565729','2026-03-09 10:56:35.565752',1,1),(64,'2026-03-09 10:56:35.567902','2026-03-09 10:56:35.567923',1,3),(65,'2026-03-09 10:56:35.569583','2026-03-09 10:56:35.569598',1,4),(66,'2026-03-09 10:56:35.570997','2026-03-09 10:56:35.571007',1,2),(67,'2026-03-09 10:56:35.572416','2026-03-09 10:56:35.572424',1,5);
/*!40000 ALTER TABLE `role_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_table_selections`
--

DROP TABLE IF EXISTS `user_table_selections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_table_selections` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `page_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `selected_ids` json NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_table_selections_user_id_page_key_21f25960_uniq` (`user_id`,`page_key`),
  KEY `user_table__user_id_73bc0f_idx` (`user_id`,`page_key`),
  CONSTRAINT `user_table_selections_user_id_a0018d71_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_table_selections`
--

LOCK TABLES `user_table_selections` WRITE;
/*!40000 ALTER TABLE `user_table_selections` DISABLE KEYS */;
INSERT INTO `user_table_selections` VALUES (1,'modules_dashboard','[]','2026-03-09 10:55:20.582728',1),(2,'function_list','[]','2026-03-09 10:55:23.580850',1),(3,'api_documentation_list','[]','2026-03-09 10:59:18.183474',1),(4,'ajax_documentation_list','[]','2026-03-09 11:03:48.607463',1);
/*!40000 ALTER TABLE `user_table_selections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `id_pegawai` int DEFAULT NULL,
  `user_id_opd` int DEFAULT NULL,
  `image` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'argon2$argon2id$v=19$m=102400,t=2,p=8$MTMxZExPZFFEWXRSUFIwUjl4VXpvMw$26RDnY0EeuRKgataFC9+ueXeUJrF7bNuUeffj3P2L/g','2026-03-09 10:59:04.677329','Prakom Admin','Prakom@admin2025.com','Prakom@admin2025.com',1,'2026-03-09 10:49:35.766849',NULL,NULL,'','2026-03-09 10:49:35.851717'),(2,'argon2$argon2id$v=19$m=102400,t=2,p=8$OGhkRHZ2WEdtSkUxRWN2aDBBMWNLUg$kavTbf98QXvXtKjhP415e5Z2nVac2ZCnhRYfcU6sfRw',NULL,'Pegawai Biasa',NULL,'199411192019031001',1,'2026-03-09 10:49:35.863616',NULL,NULL,'','2026-03-09 10:49:36.037093'),(3,'argon2$argon2id$v=19$m=102400,t=2,p=8$UDYyR2ViTUxIZjR4UTkwTXIzWEhXVg$cyUH/Bty8wxuyvm8XKuosaq5ifZWVH958ryJ+qPsPfs',NULL,'','admin@esimpeg.com','admin',1,'2026-03-09 10:51:53.124850',NULL,NULL,'','2026-03-09 10:51:53.228041');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_groups`
--

DROP TABLE IF EXISTS `users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_groups_user_id_group_id_fc7788e8_uniq` (`user_id`,`group_id`),
  KEY `users_groups_group_id_2f3517aa_fk_auth_group_id` (`group_id`),
  CONSTRAINT `users_groups_group_id_2f3517aa_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `users_groups_user_id_f500bee5_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_groups`
--

LOCK TABLES `users_groups` WRITE;
/*!40000 ALTER TABLE `users_groups` DISABLE KEYS */;
INSERT INTO `users_groups` VALUES (1,1,1);
/*!40000 ALTER TABLE `users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_user_permissions`
--

DROP TABLE IF EXISTS `users_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_permissions_user_id_permission_id_3b86cbdf_uniq` (`user_id`,`permission_id`),
  KEY `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` (`permission_id`),
  CONSTRAINT `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `users_user_permissions_user_id_92473840_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_user_permissions`
--

LOCK TABLES `users_user_permissions` WRITE;
/*!40000 ALTER TABLE `users_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'dasar_python_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-09  4:10:52
