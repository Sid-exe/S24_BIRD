-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: 68.183.83.1    Database: S24_BIRD
-- ------------------------------------------------------
-- Server version	8.0.37-0ubuntu0.22.04.3

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
-- Table structure for table `alias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `type` enum('symbol','uniprot') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `dataset_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `alias_idx1` (`protein_id`),
  KEY `alias_idx2` (`dataset_id`),
  CONSTRAINT `fk_alias_dataset` FOREIGN KEY (`dataset_id`) REFERENCES `dataset` (`id`),
  CONSTRAINT `fk_alias_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=155511 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `anatomy`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `anatomy` (
  `id` varchar(50) DEFAULT NULL,
  `label` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `xrefs` varchar(50) DEFAULT NULL,
  `anatomy_id` varchar(50) DEFAULT NULL,
  `anatomy_label` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clinvar`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinvar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `clinvar_phenotype_id` int NOT NULL,
  `alleleid` int NOT NULL,
  `type` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `review_status` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `clinical_significance` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `clin_sig_simple` int DEFAULT NULL,
  `last_evaluated` date DEFAULT NULL,
  `dbsnp_rs` int DEFAULT NULL,
  `dbvarid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `origin` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `origin_simple` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `assembly` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `chr` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `chr_acc` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `start` int DEFAULT NULL,
  `stop` int DEFAULT NULL,
  `number_submitters` int DEFAULT NULL,
  `tested_in_gtr` tinyint(1) DEFAULT NULL,
  `submitter_categories` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clinvar_idx1` (`protein_id`),
  KEY `clinvar_idx2` (`clinvar_phenotype_id`),
  CONSTRAINT `fk_clinvar__clinvar_phenotype` FOREIGN KEY (`clinvar_phenotype_id`) REFERENCES `clinvar_phenotype` (`id`),
  CONSTRAINT `fk_clinvar_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1543669 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clinvar_phenotype`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinvar_phenotype` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=143016 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clinvar_phenotype_xref`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinvar_phenotype_xref` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clinvar_phenotype_id` int NOT NULL,
  `source` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `clinvar_phenotype_idx1` (`clinvar_phenotype_id`),
  CONSTRAINT `fk_clinvar_phenotype_xref__clinvar_phenotype` FOREIGN KEY (`clinvar_phenotype_id`) REFERENCES `clinvar_phenotype` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1264325 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cmpd_activity`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cmpd_activity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `target_id` int NOT NULL,
  `catype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `cmpd_id_in_src` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `cmpd_name_in_src` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `smiles` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `act_value` decimal(10,8) DEFAULT NULL,
  `act_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `reference` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `pubmed_ids` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `cmpd_pubchem_cid` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cmpd_activity_idx1` (`catype`),
  KEY `cmpd_activity_idx2` (`target_id`),
  CONSTRAINT `fk_chembl_activity__target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cmpd_activity__cmpd_activity_type` FOREIGN KEY (`catype`) REFERENCES `cmpd_activity_type` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=776592 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cmpd_activity_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cmpd_activity_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compartment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compartment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ctype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `target_id` int DEFAULT NULL,
  `protein_id` int DEFAULT NULL,
  `go_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `go_term` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `evidence` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `zscore` decimal(4,3) DEFAULT NULL,
  `conf` decimal(2,1) DEFAULT NULL,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `reliability` enum('Supported','Approved','Validated') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `compartment_idx1` (`ctype`),
  KEY `compartment_idx2` (`target_id`),
  KEY `compartment_idx3` (`protein_id`),
  CONSTRAINT `fk_compartment__compartment_type` FOREIGN KEY (`ctype`) REFERENCES `compartment_type` (`name`),
  CONSTRAINT `fk_compartment_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_compartment_target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1724993 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compartment_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compartment_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_type` (
  `name` varchar(7) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dataset` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `source` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `app` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `app_version` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `comments` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dbinfo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dbinfo` (
  `dbname` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `schema_ver` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `data_ver` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `owner` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `is_copy` tinyint(1) NOT NULL DEFAULT '0',
  `dump_file` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disease`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disease` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dtype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `protein_id` int DEFAULT NULL,
  `nhprotein_id` int DEFAULT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `did` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `evidence` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `zscore` decimal(4,3) DEFAULT NULL,
  `conf` decimal(2,1) DEFAULT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `reference` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `drug_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `log2foldchange` decimal(5,3) DEFAULT NULL,
  `pvalue` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `score` decimal(16,15) DEFAULT NULL,
  `source` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `O2S` decimal(16,13) DEFAULT NULL,
  `S2O` decimal(16,13) DEFAULT NULL,
  `mondoid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `disease_idx1` (`dtype`),
  KEY `disease_idx2` (`protein_id`),
  KEY `disease_idx3` (`nhprotein_id`),
  KEY `fk_disease_mondo` (`mondoid`),
  CONSTRAINT `fk_disease__disease_type` FOREIGN KEY (`dtype`) REFERENCES `disease_type` (`name`),
  CONSTRAINT `fk_disease_mondo` FOREIGN KEY (`mondoid`) REFERENCES `mondo` (`mondoid`),
  CONSTRAINT `fk_disease_nhprotein` FOREIGN KEY (`nhprotein_id`) REFERENCES `nhprotein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_disease_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=885372 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disease_data`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disease_data` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `located_in` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disease_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disease_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `do`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `do` (
  `doid` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `def` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`doid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `do_parent`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `do_parent` (
  `doid` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `parent_id` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  KEY `fk_do_parent__do` (`doid`),
  CONSTRAINT `fk_do_parent__do` FOREIGN KEY (`doid`) REFERENCES `do` (`doid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `do_xref`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `do_xref` (
  `doid` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `db` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`doid`,`db`,`value`),
  KEY `do_xref__idx2` (`db`,`value`),
  CONSTRAINT `fk_do_xref__do` FOREIGN KEY (`doid`) REFERENCES `do` (`doid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drgc_resource`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drgc_resource` (
  `id` int NOT NULL AUTO_INCREMENT,
  `target_id` int NOT NULL,
  `resource_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `json` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `drgc_resource_idx1` (`target_id`),
  CONSTRAINT `fk_drgc_resource__target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3301 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drug_activity`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_activity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `target_id` int NOT NULL,
  `drug` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `act_value` decimal(10,8) DEFAULT NULL,
  `act_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `action_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `has_moa` tinyint(1) NOT NULL,
  `source` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `reference` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `smiles` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `cmpd_chemblid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nlm_drug_info` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `cmpd_pubchem_cid` int DEFAULT NULL,
  `dcid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `drug_activity_idx1` (`target_id`),
  CONSTRAINT `fk_drug_activity__target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4004 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drug_drug_interaction`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_drug_interaction` (
  `drugbank_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `related_drug_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `related_drug_description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `related_drug_drugbank_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drug_names`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_names` (
  `drug_id` varchar(50) NOT NULL,
  `drug_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`drug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drugbank`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drugbank` (
  `rowid` bigint unsigned NOT NULL AUTO_INCREMENT,
  `drugbank_id` varchar(60) DEFAULT NULL,
  `jsondata` json DEFAULT NULL,
  `name` varchar(250) DEFAULT NULL,
  `description` text,
  `uniprot_id` varchar(60) DEFAULT NULL,
  `kegg_drug_id` varchar(60) DEFAULT NULL,
  `kegg_compound_id` varchar(60) DEFAULT NULL,
  `product_id` varchar(60) DEFAULT NULL,
  `therap_target_id` varchar(60) DEFAULT NULL,
  `pharm_gkb_id` varchar(60) DEFAULT NULL,
  `genbank_gene_id` varchar(60) DEFAULT NULL,
  `wiki_id` varchar(240) DEFAULT NULL,
  `pubchem_substance_id` varchar(60) DEFAULT NULL,
  `chembl_id` varchar(60) DEFAULT NULL,
  UNIQUE KEY `rowid` (`rowid`),
  UNIQUE KEY `drugbank_id` (`drugbank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15236 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dto`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dto` (
  `dtoid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `parent_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `def` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`dtoid`),
  KEY `dto_idx1` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expression`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expression` (
  `id` int NOT NULL AUTO_INCREMENT,
  `etype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `target_id` int DEFAULT NULL,
  `protein_id` int DEFAULT NULL,
  `tissue` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `qual_value` enum('Not detected','Low','Medium','High') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `number_value` decimal(12,6) DEFAULT NULL,
  `boolean_value` tinyint(1) DEFAULT NULL,
  `string_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `pubmed_id` int DEFAULT NULL,
  `evidence` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `zscore` decimal(4,3) DEFAULT NULL,
  `conf` decimal(2,1) DEFAULT NULL,
  `oid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `confidence` tinyint(1) DEFAULT NULL,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `cell_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `uberon_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `expression_idx1` (`etype`),
  KEY `expression_idx2` (`target_id`),
  KEY `expression_idx3` (`protein_id`),
  KEY `fk_expression_uberon` (`uberon_id`),
  CONSTRAINT `fk_expression__expression_type` FOREIGN KEY (`etype`) REFERENCES `expression_type` (`name`),
  CONSTRAINT `fk_expression__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_expression__target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_expression_uberon` FOREIGN KEY (`uberon_id`) REFERENCES `uberon` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=31294596 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expression_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expression_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `data_type` varchar(7) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`),
  UNIQUE KEY `expression_type_idx1` (`name`,`data_type`),
  KEY `fk_expression_type__data_type` (`data_type`),
  CONSTRAINT `fk_expression_type__data_type` FOREIGN KEY (`data_type`) REFERENCES `data_type` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `extlink`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `extlink` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `source` enum('GlyGen','Prokino','Dark Kinome','Reactome','ClinGen','GENEVA','TIGA') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `extlink_idx1` (`protein_id`),
  CONSTRAINT `fk_extlink_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=79781 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feature`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feature` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `srcid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `evidence` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `begin` int DEFAULT NULL,
  `end` int DEFAULT NULL,
  `position` int DEFAULT NULL,
  `original` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `variation` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `feature_idx1` (`protein_id`),
  CONSTRAINT `fk_feature_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=697491 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_attribute` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `gat_id` int NOT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gene_attribute_idx1` (`protein_id`),
  KEY `gene_attribute_idx2` (`gat_id`),
  CONSTRAINT `fk_gene_attribute__gene_attribute_type` FOREIGN KEY (`gat_id`) REFERENCES `gene_attribute_type` (`id`),
  CONSTRAINT `fk_gene_attribute__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43451769 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_attribute_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_attribute_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `association` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `resource_group` enum('omics','genomics','proteomics','physical interactions','transcriptomics','structural or functional annotations','disease or phenotype associations') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `measurement` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `attribute_group` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `attribute_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `pubmed_ids` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gene_attribute_type_idx1` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `generif`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generif` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `pubmed_ids` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `years` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `generif_idx1` (`protein_id`),
  CONSTRAINT `fk_generif_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=898091 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `goa`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goa` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `go_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `go_term` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `evidence` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `goeco` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `assigned_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `goa_idx1` (`protein_id`),
  CONSTRAINT `fk_goa_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=273868 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gtex`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gtex` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int DEFAULT NULL,
  `tissue` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `gender` enum('F','M') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tpm` decimal(12,6) NOT NULL,
  `tpm_rank` decimal(4,3) DEFAULT NULL,
  `tpm_rank_bysex` decimal(4,3) DEFAULT NULL,
  `tpm_level` enum('Not detected','Low','Medium','High') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tpm_level_bysex` enum('Not detected','Low','Medium','High') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tpm_f` decimal(12,6) DEFAULT NULL,
  `tpm_m` decimal(12,6) DEFAULT NULL,
  `log2foldchange` decimal(4,3) DEFAULT NULL,
  `tau` decimal(4,3) DEFAULT NULL,
  `tau_bysex` decimal(4,3) DEFAULT NULL,
  `uberon_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `expression_idx1` (`protein_id`),
  CONSTRAINT `fk_gtex_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1834981 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gwas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gwas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `disease_trait` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `snps` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `pmid` int DEFAULT NULL,
  `study` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `context` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `intergenic` tinyint(1) DEFAULT NULL,
  `p_value` double DEFAULT NULL,
  `or_beta` float DEFAULT NULL,
  `cnv` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `mapped_trait` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `mapped_trait_uri` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `gwas_idx1` (`protein_id`),
  CONSTRAINT `fk_gwas_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=610275 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hgram_cdf`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hgram_cdf` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `attr_count` int NOT NULL,
  `attr_cdf` decimal(17,16) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hgram_cdf_idx1` (`protein_id`),
  KEY `hgram_cdf_idx2` (`type`),
  CONSTRAINT `fk_hgram_cdf__gene_attribute_type` FOREIGN KEY (`type`) REFERENCES `gene_attribute_type` (`name`),
  CONSTRAINT `fk_hgram_cdf__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `homologene`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homologene` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int DEFAULT NULL,
  `nhprotein_id` int DEFAULT NULL,
  `groupid` int NOT NULL,
  `taxid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `homologene_idx1` (`protein_id`),
  KEY `homologene_idx2` (`nhprotein_id`),
  CONSTRAINT `fk_homologene_nhprotein` FOREIGN KEY (`nhprotein_id`) REFERENCES `nhprotein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_homologene_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41622 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `idg_evol`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `idg_evol` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tcrd_ver` tinyint(1) NOT NULL,
  `tcrd_dbid` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `uniprot` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `sym` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `geneid` int DEFAULT NULL,
  `tdl` varchar(6) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `fam` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idg_evol_idx1` (`uniprot`),
  KEY `idg_evol_idx2` (`sym`),
  KEY `idg_evol_idx3` (`geneid`),
  KEY `idg_evol_idx4` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5119 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `info_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `info_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `data_type` varchar(7) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `unit` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`),
  UNIQUE KEY `info_type_idx1` (`name`,`data_type`),
  UNIQUE KEY `expression_type_idx1` (`name`,`data_type`),
  KEY `fk_info_type__data_type` (`data_type`),
  CONSTRAINT `fk_info_type__data_type` FOREIGN KEY (`data_type`) REFERENCES `data_type` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lincs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lincs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `cellid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `zscore` decimal(8,6) NOT NULL,
  `pert_dcid` int NOT NULL,
  `pert_smiles` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lincs_idx1` (`protein_id`),
  CONSTRAINT `fk_lincs_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=168293881 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locsig`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locsig` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `signal` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `pmids` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `compartment_idx1` (`protein_id`),
  CONSTRAINT `fk_locsig_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=131071 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meddra_indications`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meddra_indications` (
  `drug_id` varchar(100) NOT NULL,
  `umls_as_label` varchar(100) NOT NULL,
  `source` varchar(100) NOT NULL,
  `concept_name` varchar(100) NOT NULL,
  `concept_type` varchar(50) NOT NULL,
  `umls_id` varchar(100) NOT NULL,
  `meddra_concept_name` varchar(255) NOT NULL,
  PRIMARY KEY (`drug_id`,`umls_id`,`concept_name`,`concept_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mondo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mondo` (
  `mondoid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `def` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `comment` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`mondoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mondo_parent`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mondo_parent` (
  `mondoid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `parentid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  KEY `mondo_parent_idx1` (`mondoid`),
  CONSTRAINT `fk_mondo_parent__mondo` FOREIGN KEY (`mondoid`) REFERENCES `mondo` (`mondoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mondo_xref`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mondo_xref` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mondoid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `db` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `equiv_to` tinyint(1) NOT NULL DEFAULT '0',
  `source_info` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `did` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mondo_xref_idx1` (`mondoid`),
  CONSTRAINT `fk_mondo_xref__mondo` FOREIGN KEY (`mondoid`) REFERENCES `mondo` (`mondoid`)
) ENGINE=InnoDB AUTO_INCREMENT=353943 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mpo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mpo` (
  `mpid` char(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `parent_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `def` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`mpid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nhprotein`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nhprotein` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uniprot` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `sym` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `species` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `taxid` int NOT NULL,
  `geneid` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nhprotein_idx1` (`uniprot`)
) ENGINE=InnoDB AUTO_INCREMENT=25412 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `omim`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `omim` (
  `mim` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`mim`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `omim_ps`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `omim_ps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `omim_ps_id` char(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `mim` int DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_omim_ps__omim` (`mim`),
  CONSTRAINT `fk_omim_ps__omim` FOREIGN KEY (`mim`) REFERENCES `omim` (`mim`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ortholog`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ortholog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `taxid` int NOT NULL,
  `species` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `db_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `geneid` int DEFAULT NULL,
  `symbol` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `mod_url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `sources` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ortholog_idx1` (`protein_id`),
  CONSTRAINT `fk_ortholog_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=693996 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ortholog_disease`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ortholog_disease` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `did` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ortholog_id` int NOT NULL,
  `score` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ortholog_disease_idx1` (`protein_id`),
  KEY `ortholog_disease_idx2` (`ortholog_id`),
  CONSTRAINT `fk_ortholog_disease__ortholog` FOREIGN KEY (`ortholog_id`) REFERENCES `ortholog` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ortholog_disease__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2162656 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `p2pc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `p2pc` (
  `panther_class_id` int NOT NULL,
  `protein_id` int NOT NULL,
  KEY `p2pc_idx1` (`panther_class_id`),
  KEY `p2pc_idx2` (`protein_id`),
  CONSTRAINT `fk_p2pc__panther_class` FOREIGN KEY (`panther_class_id`) REFERENCES `panther_class` (`id`),
  CONSTRAINT `fk_p2pc_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `panther_class`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `panther_class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pcid` char(7) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `parent_pcids` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `panther_class_idx1` (`pcid`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `patent_count`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patent_count` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `year` int NOT NULL,
  `count` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `patent_count_idx1` (`protein_id`),
  CONSTRAINT `fk_patent_count__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41264 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathway`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pathway` (
  `id` int NOT NULL AUTO_INCREMENT,
  `target_id` int DEFAULT NULL,
  `protein_id` int DEFAULT NULL,
  `pwtype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `id_in_source` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `pathway_idx1` (`target_id`),
  KEY `pathway_idx2` (`protein_id`),
  KEY `pathway_idx3` (`pwtype`),
  CONSTRAINT `fk_pathway__pathway_type` FOREIGN KEY (`pwtype`) REFERENCES `pathway_type` (`name`),
  CONSTRAINT `fk_pathway_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pathway_target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=243794 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathway_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pathway_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phenotype`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phenotype` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ptype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `protein_id` int DEFAULT NULL,
  `nhprotein_id` int DEFAULT NULL,
  `trait` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `top_level_term_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `top_level_term_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `term_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `term_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `term_description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `p_value` double DEFAULT NULL,
  `percentage_change` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `effect_size` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `procedure_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `parameter_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `gp_assoc` tinyint(1) DEFAULT NULL,
  `statistical_method` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `sex` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `phenotype_idx1` (`ptype`),
  KEY `phenotype_idx2` (`protein_id`),
  KEY `phenotype_idx3` (`nhprotein_id`),
  CONSTRAINT `fk_phenotype__phenotype_type` FOREIGN KEY (`ptype`) REFERENCES `phenotype_type` (`name`),
  CONSTRAINT `fk_phenotype_nhprotein` FOREIGN KEY (`nhprotein_id`) REFERENCES `nhprotein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_phenotype_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=184944 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phenotype_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phenotype_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ontology` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`),
  UNIQUE KEY `phenotype_type_idx1` (`name`,`ontology`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pmscore`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pmscore` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `year` int NOT NULL,
  `score` decimal(12,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pmscore_idx1` (`protein_id`),
  CONSTRAINT `fk_pmscore_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=480984 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ppi`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ppi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ppitype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `protein1_id` int NOT NULL,
  `protein1_str` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `protein2_id` int NOT NULL,
  `protein2_str` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `p_int` decimal(10,9) DEFAULT NULL,
  `p_ni` decimal(10,9) DEFAULT NULL,
  `p_wrong` decimal(10,9) DEFAULT NULL,
  `evidence` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `interaction_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `score` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ppi_idx1` (`protein1_id`),
  KEY `ppi_idx2` (`protein2_id`),
  KEY `ppi_idx3` (`ppitype`),
  CONSTRAINT `fk_ppi_protein1` FOREIGN KEY (`protein1_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ppi_protein2` FOREIGN KEY (`protein2_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10183704 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ppi_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ppi_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protein`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protein` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `uniprot` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `up_version` int DEFAULT NULL,
  `geneid` int DEFAULT NULL,
  `sym` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `family` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `chr` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `seq` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `dtoid` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `stringid` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dtoclass` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `protein_idx1` (`uniprot`),
  UNIQUE KEY `protein_idx2` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=20436 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protein2pubmed`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protein2pubmed` (
  `protein_id` int NOT NULL,
  `pubmed_id` int NOT NULL,
  KEY `protein2pubmed_idx1` (`protein_id`),
  KEY `protein2pubmed_idx2` (`pubmed_id`),
  CONSTRAINT `fk_protein2pubmed__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_protein2pubmed__pubmed` FOREIGN KEY (`pubmed_id`) REFERENCES `pubmed` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `provenance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provenance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dataset_id` int NOT NULL,
  `table_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `column_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `where_clause` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `comment` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `provenance_idx1` (`dataset_id`),
  CONSTRAINT `fk_provenance_dataset` FOREIGN KEY (`dataset_id`) REFERENCES `dataset` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ptscore`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ptscore` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `year` int NOT NULL,
  `score` decimal(12,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ptscore_idx1` (`protein_id`),
  CONSTRAINT `fk_ptscore_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1356608 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pubmed`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pubmed` (
  `id` int NOT NULL,
  `title` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `journal` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `date` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `authors` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `abstract` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rat_qtl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rat_qtl` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nhprotein_id` int NOT NULL,
  `rgdid` int NOT NULL,
  `qtl_rgdid` int NOT NULL,
  `qtl_symbol` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `qtl_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `trait_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `measurement_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `associated_disease` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `phenotype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `p_value` decimal(20,19) DEFAULT NULL,
  `lod` float(6,3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rat_qtl_idx1` (`nhprotein_id`),
  CONSTRAINT `fk_rat_qtl__nhprotein` FOREIGN KEY (`nhprotein_id`) REFERENCES `nhprotein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rat_term`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rat_term` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rgdid` int NOT NULL,
  `term_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `obj_symbol` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `term_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `qualifier` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `evidence` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ontology` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rat_term_idx1` (`rgdid`,`term_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117603 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rdo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rdo` (
  `doid` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `def` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`doid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rdo_xref`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rdo_xref` (
  `doid` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `db` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`doid`,`db`,`value`),
  KEY `rdo_xref__idx2` (`db`,`value`),
  CONSTRAINT `fk_rdo_xref__do` FOREIGN KEY (`doid`) REFERENCES `rdo` (`doid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `symptoms`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `symptoms` (
  `symptom_name` varchar(50) DEFAULT NULL,
  `disease_name` varchar(50) DEFAULT NULL,
  `cooccurs` int DEFAULT NULL,
  `tfidf_score` double DEFAULT NULL,
  `disease_id` varchar(50) DEFAULT NULL,
  `symptom_id` varchar(50) DEFAULT NULL,
  `doid_code` varchar(50) DEFAULT NULL,
  `doid_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t2tc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t2tc` (
  `target_id` int NOT NULL,
  `protein_id` int DEFAULT NULL,
  `nucleic_acid_id` int DEFAULT NULL,
  KEY `t2tc_idx1` (`target_id`),
  KEY `t2tc_idx2` (`protein_id`),
  CONSTRAINT `fk_t2tc__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`),
  CONSTRAINT `fk_t2tc__target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `target`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `target` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ttype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `comment` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `tdl` enum('Tclin+','Tclin','Tchem+','Tchem','Tbio','Tgray','Tdark') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `idg` tinyint(1) NOT NULL DEFAULT '0',
  `fam` enum('Enzyme','Epigenetic','GPCR','IC','Kinase','NR','oGPCR','TF','TF; Epigenetic','Transporter') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `famext` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20436 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdl_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdl_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `itype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `target_id` int DEFAULT NULL,
  `protein_id` int DEFAULT NULL,
  `nucleic_acid_id` int DEFAULT NULL,
  `string_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `number_value` decimal(12,6) DEFAULT NULL,
  `integer_value` int DEFAULT NULL,
  `date_value` date DEFAULT NULL,
  `boolean_value` tinyint(1) DEFAULT NULL,
  `curration_level` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tdl_info_idx1` (`itype`),
  KEY `tdl_info_idx2` (`target_id`),
  KEY `tdl_info_idx3` (`protein_id`),
  CONSTRAINT `fk_tdl_info__info_type` FOREIGN KEY (`itype`) REFERENCES `info_type` (`name`),
  CONSTRAINT `fk_tdl_info__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tdl_info__target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=232812 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `techdev_contact`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `techdev_contact` (
  `id` int NOT NULL,
  `contact_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `contact_email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `date` date DEFAULT NULL,
  `grant_number` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `pi` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `techdev_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `techdev_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contact_id` int DEFAULT NULL,
  `protein_id` int DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `publication_pcmid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `publication_pmid` int DEFAULT NULL,
  `resource_url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `data_url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `techdev_info_idx1` (`contact_id`),
  KEY `techdev_info_idx2` (`protein_id`),
  CONSTRAINT `fk_techdev_info__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_techdev_info__techdev_contact` FOREIGN KEY (`contact_id`) REFERENCES `techdev_contact` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tiga`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tiga` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `ensg` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `efoid` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `trait` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `n_study` int DEFAULT NULL,
  `n_snp` int DEFAULT NULL,
  `n_snpw` decimal(6,3) DEFAULT NULL,
  `geneNtrait` int DEFAULT NULL,
  `geneNstudy` int DEFAULT NULL,
  `traitNgene` int DEFAULT NULL,
  `traitNstudy` int DEFAULT NULL,
  `pvalue_mlog_median` decimal(7,3) DEFAULT NULL,
  `pvalue_mlog_max` decimal(8,3) DEFAULT NULL,
  `or_median` decimal(8,3) DEFAULT NULL,
  `n_beta` int DEFAULT NULL,
  `study_N_mean` int DEFAULT NULL,
  `rcras` decimal(5,3) DEFAULT NULL,
  `meanRank` decimal(18,12) DEFAULT NULL,
  `meanRankScore` decimal(18,14) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tiga_idx1` (`protein_id`),
  CONSTRAINT `fk_tiga_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1513946 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tiga_provenance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tiga_provenance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ensg` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `efoid` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `study_acc` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `pubmedid` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=873784 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinx_articlerank`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinx_articlerank` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importance_id` int NOT NULL,
  `pmid` int NOT NULL,
  `rank` int NOT NULL,
  `datalevel` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tinx_articlerank_idx1` (`importance_id`),
  CONSTRAINT `fk_tinx_articlerank__tinx_importance` FOREIGN KEY (`importance_id`) REFERENCES `tinx_importance` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=100000000 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinx_disease`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinx_disease` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `summary` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `score` decimal(34,16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9689 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinx_importance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinx_importance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `disease_id` int NOT NULL,
  `score` decimal(34,16) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tinx_importance_idx1` (`protein_id`),
  KEY `tinx_importance_idx2` (`disease_id`),
  CONSTRAINT `fk_tinx_importance__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tinx_importance__tinx_disease` FOREIGN KEY (`disease_id`) REFERENCES `tinx_disease` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17335956 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinx_novelty`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinx_novelty` (
  `id` int NOT NULL AUTO_INCREMENT,
  `protein_id` int NOT NULL,
  `score` decimal(34,16) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tinx_novelty_idx1` (`protein_id`),
  CONSTRAINT `fk_tinx_novelty__protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18817 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `tinx_target`
--

SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `tinx_target` AS SELECT 
 1 AS `target_id`,
 1 AS `protein_id`,
 1 AS `uniprot`,
 1 AS `sym`,
 1 AS `tdl`,
 1 AS `fam`,
 1 AS `family`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `uberon`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uberon` (
  `uid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `def` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `comment` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uberon_main_with_children`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uberon_main_with_children` (
  `main_uberon_id` varchar(50) DEFAULT NULL,
  `children` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uberon_main_with_mesh_umls`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uberon_main_with_mesh_umls` (
  `main_uberon_id` varchar(50) DEFAULT NULL,
  `mesh_ids` varchar(256) DEFAULT NULL,
  `umls_ids` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uberon_parent`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uberon_parent` (
  `uid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `parent_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  KEY `uberon_parent_idx1` (`uid`),
  CONSTRAINT `fk_uberon_parent__uberon` FOREIGN KEY (`uid`) REFERENCES `uberon` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uberon_xref`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uberon_xref` (
  `uid` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `db` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`uid`,`db`,`value`),
  KEY `uberon_xref_idx1` (`uid`),
  CONSTRAINT `fk_uberon_xref__uberon` FOREIGN KEY (`uid`) REFERENCES `uberon` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `viral_ppi`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viral_ppi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `viral_protein_id` int NOT NULL,
  `protein_id` int DEFAULT NULL,
  `dataSource` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `finalLR` decimal(20,12) NOT NULL,
  `pdbIDs` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `highConfidence` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `viral_protein_id_idx` (`viral_protein_id`),
  KEY `protein_id_idx` (`protein_id`),
  KEY `high_conf_idx` (`highConfidence`),
  CONSTRAINT `protein_id` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`),
  CONSTRAINT `viral_protein_id` FOREIGN KEY (`viral_protein_id`) REFERENCES `viral_protein` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=282529 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `viral_protein`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viral_protein` (
  `id` int NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ncbi` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `virus_id` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `virus_id_idx` (`virus_id`),
  CONSTRAINT `virus_id` FOREIGN KEY (`virus_id`) REFERENCES `virus` (`virusTaxid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `virus`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `virus` (
  `virusTaxid` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `nucleic1` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nucleic2` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `order` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `family` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `subfamily` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `genus` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `species` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`virusTaxid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vitamin`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vitamin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Vitamin_name` varchar(255) DEFAULT NULL,
  `Vitamin_id` int DEFAULT NULL,
  `protein_id` int DEFAULT NULL,
  `Uniprot` varchar(255) DEFAULT NULL,
  `geneid` int DEFAULT NULL,
  `Reviewed` varchar(255) DEFAULT NULL,
  `Entry_Name` varchar(255) DEFAULT NULL,
  `Protein_names` varchar(8000) DEFAULT NULL,
  `Gene_Names` varchar(255) DEFAULT NULL,
  `Organism` varchar(255) DEFAULT NULL,
  `Length` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_vitamin_protein` (`protein_id`),
  CONSTRAINT `fk_vitamin_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5535 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xref`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xref` (
  `id` int NOT NULL AUTO_INCREMENT,
  `xtype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `target_id` int DEFAULT NULL,
  `protein_id` int DEFAULT NULL,
  `nucleic_acid_id` int DEFAULT NULL,
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `xtra` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dataset_id` int NOT NULL,
  `nhprotein_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `xref_idx3` (`xtype`,`target_id`,`value`),
  UNIQUE KEY `xref_idx5` (`xtype`,`protein_id`,`value`),
  KEY `xref_idx1` (`xtype`),
  KEY `xref_idx2` (`target_id`),
  KEY `xref_idx4` (`protein_id`),
  KEY `xref_idx6` (`dataset_id`),
  KEY `fk_xref_nhprotein` (`nhprotein_id`),
  CONSTRAINT `fk_xref__xref_type` FOREIGN KEY (`xtype`) REFERENCES `xref_type` (`name`),
  CONSTRAINT `fk_xref_dataset` FOREIGN KEY (`dataset_id`) REFERENCES `dataset` (`id`),
  CONSTRAINT `fk_xref_nhprotein` FOREIGN KEY (`nhprotein_id`) REFERENCES `nhprotein` (`id`),
  CONSTRAINT `fk_xref_protein` FOREIGN KEY (`protein_id`) REFERENCES `protein` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_xref_target` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2735479 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xref_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xref_type` (
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `eg_q_url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'S24_BIRD'
--

--
-- Final view structure for view `tinx_target`
--

/*!50001 DROP VIEW IF EXISTS `tinx_target`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`smathias`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `tinx_target` AS select `t`.`id` AS `target_id`,`p`.`id` AS `protein_id`,`p`.`uniprot` AS `uniprot`,`p`.`sym` AS `sym`,`t`.`tdl` AS `tdl`,`t`.`fam` AS `fam`,`p`.`family` AS `family` from ((`target` `t` join `t2tc`) join `protein` `p`) where ((`t`.`id` = `t2tc`.`target_id`) and (`t2tc`.`protein_id` = `p`.`id`) and `p`.`id` in (select distinct `tinx_novelty`.`protein_id` from `tinx_novelty`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-30 19:55:33
