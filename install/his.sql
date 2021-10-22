-- MySQL dump 10.11
--
-- Host: localhost    Database: his
-- ------------------------------------------------------
-- Server version	5.0.51b-community-nt-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `his`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `his` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `his`;

--
-- Table structure for table `bottle_info`
--

DROP TABLE IF EXISTS `bottle_info`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bottle_info` (
  `bottleid` bigint(20) NOT NULL auto_increment,
  `bottleno` varchar(50) default NULL COMMENT '瓶号',
  `medicineid` bigint(20) default NULL,
  `medicineno` varchar(50) default NULL COMMENT '药码',
  `weight_gross` double(18,2) default NULL COMMENT '毛重(标)',
  `weight_net` double(18,2) default NULL COMMENT '净重(标)',
  `weight_initial` double(18,2) default NULL COMMENT '初始重量',
  `weight_last` double(18,2) default NULL,
  `weight_cur` double(18,2) default NULL COMMENT '当前重量',
  `opera` int(11) default '0' COMMENT '操作者',
  `uptime` datetime default NULL COMMENT '更新时间',
  `uses_flag` tinyint(4) default '100' COMMENT '使用状态',
  `remark` varchar(50) default NULL COMMENT '备注',
  PRIMARY KEY  (`bottleid`),
  UNIQUE KEY `bottleno` (`bottleno`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='药瓶基本信息';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `bottle_info`
--

LOCK TABLES `bottle_info` WRITE;
/*!40000 ALTER TABLE `bottle_info` DISABLE KEYS */;
INSERT INTO `bottle_info` VALUES (1,'BOT202105150001',1,'H0201900',120.00,100.00,NULL,100.00,100.00,1,'2021-05-17 14:14:40',104,NULL),(2,'BOT202105150002',1,'H0201900',120.00,100.00,NULL,NULL,NULL,1,'2021-05-16 15:22:20',101,NULL),(3,'BOT202105150003',2,'H0201901',100.00,80.00,NULL,NULL,NULL,1,'2021-05-16 15:27:41',103,NULL),(4,'BOT202105160001',3,'H0201902',130.00,110.00,NULL,0.00,80.00,1,'2021-05-17 11:11:23',107,''),(5,'BOT202105170001',4,'H0201903',110.00,90.00,0.00,NULL,NULL,1,'2021-05-26 16:42:43',101,'ddddd'),(6,'BOT12345678',5,'000005',120.00,100.00,NULL,NULL,NULL,1,'2021-05-28 11:02:51',103,'');
/*!40000 ALTER TABLE `bottle_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bottle_loc_cabinet`
--

DROP TABLE IF EXISTS `bottle_loc_cabinet`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bottle_loc_cabinet` (
  `locationid` bigint(20) NOT NULL auto_increment,
  `equipmentno` varchar(50) default NULL COMMENT '设备编码',
  `bottleid` int(11) default NULL COMMENT '药瓶编码',
  `bottleno` varchar(50) default NULL COMMENT '药瓶编码',
  `medicineid` int(11) default NULL,
  `medicineno` varchar(50) default NULL,
  `cabinetid` int(11) default NULL COMMENT '药柜',
  `cellid` varchar(50) default NULL COMMENT '药柜柜格',
  `isdel` tinyint(1) default '0',
  `opera` int(11) default NULL COMMENT '操作员',
  `uptime` datetime default NULL COMMENT '更新时间',
  PRIMARY KEY  (`locationid`),
  UNIQUE KEY `medicineid` (`medicineid`),
  UNIQUE KEY `cabinet_cellid` (`cabinetid`,`cellid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='药格配置';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `bottle_loc_cabinet`
--

LOCK TABLES `bottle_loc_cabinet` WRITE;
/*!40000 ALTER TABLE `bottle_loc_cabinet` DISABLE KEYS */;
INSERT INTO `bottle_loc_cabinet` VALUES (3,NULL,1,'BOT202105150001',1,'H0201900',1,'1',0,1,'2021-05-16 15:26:15'),(4,NULL,3,'BOT202105150003',2,'H0201901',1,'2',0,1,'2021-05-16 15:27:41'),(5,NULL,4,'BOT202105160001',3,'H0201902',1,'3',0,1,'2021-05-16 15:30:16'),(9,NULL,6,NULL,5,'000005',1,'4',0,1,'2021-05-28 11:02:51');
/*!40000 ALTER TABLE `bottle_loc_cabinet` ENABLE KEYS */;
UNLOCK TABLES;

/*!50003 SET @SAVE_SQL_MODE=@@SQL_MODE*/;

DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`i3u`@`localhost` */ /*!50003 TRIGGER `bottle_loc_cabinet_insert` AFTER INSERT ON `bottle_loc_cabinet` FOR EACH ROW BEGIN
#update bottle_info set uses_flag=103 where bottleid=new.bottleid;
INSERT INTO bottle_transaction (bottleid,medicineid,opera,uptime,uses_flag) VALUES(
new.bottleid,new.medicineid,new.opera,new.uptime,103);
    END */;;

/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`i3u`@`localhost` */ /*!50003 TRIGGER `bottle_loc_cabinet_update_isdel` BEFORE UPDATE ON `bottle_loc_cabinet` FOR EACH ROW BEGIN
    if old.isdel=0 and new.isdel=1 then
INSERT INTO bottle_transaction (bottleid,medicineid,weight_cur,opera,uptime,uses_flag) VALUES(
old.bottleid,old.medicineid,new.opera,NOW(),108);
end if;
    END */;;

DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@SAVE_SQL_MODE*/;

--
-- Table structure for table `bottle_log`
--

DROP TABLE IF EXISTS `bottle_log`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bottle_log` (
  `bottle_logid` bigint(20) NOT NULL auto_increment,
  `bottleid` bigint(20) NOT NULL,
  `bottleno` varchar(50) default NULL COMMENT '瓶号',
  `medicineid` bigint(20) default NULL,
  `medicineno` varchar(50) default NULL COMMENT '药码',
  `qty` double(18,2) default NULL COMMENT '当前重量',
  `opera` int(11) default NULL COMMENT '操作者',
  `uptime` datetime default NULL COMMENT '更新时间',
  `uses_flag` tinyint(4) default '0',
  `datecode` int(11) default NULL,
  PRIMARY KEY  (`bottle_logid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药瓶使用流水账';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `bottle_log`
--

LOCK TABLES `bottle_log` WRITE;
/*!40000 ALTER TABLE `bottle_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `bottle_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bottle_transaction`
--

DROP TABLE IF EXISTS `bottle_transaction`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bottle_transaction` (
  `bottle_transactionid` bigint(20) NOT NULL auto_increment,
  `bottleid` bigint(20) NOT NULL,
  `bottleno` varchar(50) default NULL COMMENT '瓶号',
  `medicineid` bigint(20) default NULL,
  `medicineno` varchar(50) default NULL COMMENT '药码',
  `weight_cur` double(18,2) default NULL COMMENT '当前重量',
  `opera` int(11) default NULL COMMENT '操作者',
  `uptime` datetime default NULL COMMENT '更新时间',
  `uses_flag` tinyint(4) default '0' COMMENT '使用状态',
  `reftbl` varchar(50) default NULL,
  `refid` bigint(20) default NULL,
  PRIMARY KEY  (`bottle_transactionid`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='药瓶基本信息备份';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `bottle_transaction`
--

LOCK TABLES `bottle_transaction` WRITE;
/*!40000 ALTER TABLE `bottle_transaction` DISABLE KEYS */;
INSERT INTO `bottle_transaction` VALUES (1,1,NULL,1,NULL,0.00,1,'2021-05-16 15:22:12',101,'',0),(2,2,NULL,1,NULL,0.00,1,'2021-05-16 15:22:20',101,'',0),(3,3,NULL,2,NULL,0.00,1,'2021-05-16 15:22:31',101,'',0),(4,1,NULL,1,NULL,NULL,1,'2021-05-16 15:26:15',103,NULL,NULL),(5,3,NULL,2,NULL,NULL,1,'2021-05-16 15:27:41',103,NULL,NULL),(6,4,NULL,3,NULL,0.00,1,'2021-05-16 15:30:00',101,'',0),(7,4,NULL,3,NULL,NULL,1,'2021-05-16 15:30:16',103,NULL,NULL),(8,1,NULL,1,NULL,100.00,1,'2021-05-17 11:00:21',104,NULL,NULL),(9,1,NULL,1,NULL,NULL,1,'2021-05-17 11:02:07',105,NULL,NULL),(10,1,NULL,1,NULL,NULL,1,'2021-05-17 11:02:23',105,NULL,NULL),(11,1,NULL,1,NULL,NULL,1,'2021-05-17 11:02:42',105,NULL,NULL),(12,1,NULL,1,NULL,80.00,1,'2021-05-17 11:02:56',106,NULL,NULL),(13,1,NULL,1,NULL,NULL,1,'2021-05-17 11:03:21',107,NULL,NULL),(14,1,NULL,1,NULL,0.00,1,'2021-05-17 11:04:07',108,'',0),(15,4,NULL,3,NULL,0.00,1,'2021-05-17 11:09:18',104,NULL,NULL),(16,4,NULL,3,NULL,NULL,1,'2021-05-17 11:09:41',105,NULL,NULL),(17,4,NULL,3,NULL,NULL,1,'2021-05-17 11:09:52',105,NULL,NULL),(18,4,NULL,3,NULL,0.00,1,'2021-05-17 11:10:05',106,NULL,NULL),(19,4,NULL,3,NULL,0.00,1,'2021-05-17 11:10:15',106,NULL,NULL),(20,4,NULL,3,NULL,80.00,1,'2021-05-17 11:10:59',106,NULL,NULL),(21,4,NULL,3,NULL,NULL,1,'2021-05-17 11:11:23',107,NULL,NULL),(22,1,NULL,1,NULL,0.00,1,'2021-05-17 11:17:28',106,NULL,NULL),(23,1,NULL,1,NULL,100.00,1,'2021-05-17 14:03:45',104,NULL,NULL),(24,1,NULL,1,NULL,100.00,1,'2021-05-17 14:06:10',104,NULL,NULL),(25,1,NULL,1,NULL,100.00,1,'2021-05-17 14:10:30',104,NULL,NULL),(26,1,NULL,1,NULL,100.00,1,'2021-05-17 14:11:59',104,NULL,NULL),(27,1,NULL,1,NULL,100.00,1,'2021-05-17 14:13:49',104,NULL,NULL),(28,1,NULL,1,NULL,100.00,1,'2021-05-17 14:14:40',104,NULL,NULL),(29,5,NULL,4,NULL,0.00,1,'2021-05-26 16:42:43',101,'',0),(30,6,NULL,5,NULL,0.00,1,'2021-05-28 10:48:25',101,'',0),(31,6,NULL,0,NULL,NULL,1,'2021-05-28 10:48:50',103,NULL,NULL),(32,6,NULL,0,NULL,NULL,1,'2021-05-28 10:53:42',103,NULL,NULL),(33,6,NULL,0,NULL,NULL,1,'2021-05-28 11:01:39',103,NULL,NULL),(34,6,NULL,5,NULL,NULL,1,'2021-05-28 11:02:51',103,NULL,NULL);
/*!40000 ALTER TABLE `bottle_transaction` ENABLE KEYS */;
UNLOCK TABLES;

/*!50003 SET @SAVE_SQL_MODE=@@SQL_MODE*/;

DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`i3u`@`localhost` */ /*!50003 TRIGGER `bottle_transaction_insert` BEFORE INSERT ON `bottle_transaction` FOR EACH ROW BEGIN
IF new.uses_flag=104 THEN
UPDATE bottle_info SET weight_initial=IF(weight_initial,new.weight_cur,weight_initial),weight_last=weight_cur,weight_cur=new.weight_cur,uses_flag=new.uses_flag,opera=new.opera,uptime=new.uptime WHERE bottleid=new.bottleid;
ELSEIF new.uses_flag=106 THEN
UPDATE bottle_info SET weight_last=weight_cur,weight_cur=new.weight_cur,uses_flag=new.uses_flag,opera=new.opera,uptime=new.uptime WHERE bottleid=new.bottleid;
ELSE
UPDATE bottle_info SET uses_flag=new.uses_flag,opera=new.opera,uptime=new.uptime WHERE bottleid=new.bottleid;
END IF;
    END */;;

DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@SAVE_SQL_MODE*/;

--
-- Table structure for table `cabinet`
--

DROP TABLE IF EXISTS `cabinet`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cabinet` (
  `cabinetid` int(11) NOT NULL auto_increment COMMENT '序号',
  `cabinetno` varchar(20) default NULL COMMENT '柜号',
  `cabinetname` varchar(50) default NULL COMMENT '柜名',
  `layout_row` tinyint(4) default NULL COMMENT '药柜行数',
  `layout_col` tinyint(4) default NULL COMMENT '药柜列数',
  `layout_rowwidth` smallint(6) default NULL COMMENT '药格宽',
  `layout_rowheight` smallint(6) default NULL COMMENT '药格高',
  `status` tinyint(1) default NULL COMMENT '状态',
  `opera` int(11) default NULL COMMENT '操作员',
  `uptime` datetime default NULL COMMENT '更新时间',
  `bind` int(11) default NULL COMMENT '绑定设备',
  PRIMARY KEY  (`cabinetid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='药柜信息';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `cabinet`
--

LOCK TABLES `cabinet` WRITE;
/*!40000 ALTER TABLE `cabinet` DISABLE KEYS */;
INSERT INTO `cabinet` VALUES (1,'cab01','药柜1#',23,16,160,80,1,1,'2021-05-28 09:59:02',0),(2,'cab02','药柜2#',23,16,160,80,1,1,'2021-05-28 09:59:12',0);
/*!40000 ALTER TABLE `cabinet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cabinet_cell`
--

DROP TABLE IF EXISTS `cabinet_cell`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cabinet_cell` (
  `cellid` int(11) NOT NULL auto_increment,
  `cabinetid` int(11) NOT NULL,
  `cell_row` tinyint(4) NOT NULL,
  `cell_col` tinyint(4) NOT NULL,
  `op_idx` int(11) default NULL COMMENT 'modbus regs index, eg:1,2,3,4,5',
  `op_code` int(11) default NULL COMMENT 'modbus reg code,eg:0,1,2,3,4,...,15',
  `opera` int(11) default NULL,
  `uptime` datetime default NULL,
  PRIMARY KEY  (`cellid`),
  KEY `FK_cabinet_cell` (`cabinetid`),
  CONSTRAINT `FK_cabinet_cell` FOREIGN KEY (`cabinetid`) REFERENCES `cabinet` (`cabinetid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `cabinet_cell`
--

LOCK TABLES `cabinet_cell` WRITE;
/*!40000 ALTER TABLE `cabinet_cell` DISABLE KEYS */;
INSERT INTO `cabinet_cell` VALUES (1,1,1,1,1,0,0,'2021-05-14 16:13:47'),(2,1,1,2,1,1,0,'2021-05-14 16:14:03'),(3,1,1,3,1,2,0,'2021-05-14 16:14:19'),(4,1,1,4,1,3,0,'2021-05-14 16:14:34'),(5,1,1,5,1,4,0,'2021-05-14 21:03:15');
/*!40000 ALTER TABLE `cabinet_cell` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `computers`
--

DROP TABLE IF EXISTS `computers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `computers` (
  `computerid` int(11) NOT NULL auto_increment,
  `dispensaryid` int(11) default NULL,
  `computer_mac` varchar(40) default NULL COMMENT '计算机mac',
  `computer_name` varchar(40) default NULL COMMENT '计算机名',
  `computer_ip` varchar(40) default NULL COMMENT '计算机ip',
  `memo` varchar(50) default NULL COMMENT '备注',
  `opera` int(11) default NULL COMMENT '操作者',
  `uptime` datetime default NULL COMMENT '添加时间',
  `delemp` int(11) default NULL COMMENT '删除人',
  `deltime` datetime default NULL COMMENT '删除时间',
  `valid` tinyint(2) default NULL COMMENT '状态',
  PRIMARY KEY  (`computerid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='本机匹配设备';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `computers`
--

LOCK TABLES `computers` WRITE;
/*!40000 ALTER TABLE `computers` DISABLE KEYS */;
INSERT INTO `computers` VALUES (1,1,'00:50:56:C0:00:08','adminpc','192.168.0.188','',1,'2021-05-15 15:28:19',0,'0000-00-00 00:00:00',0);
/*!40000 ALTER TABLE `computers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `department` (
  `departmentid` smallint(6) NOT NULL auto_increment,
  `departname` varchar(50) default NULL COMMENT '部门名',
  `empid` smallint(6) default NULL COMMENT '工号',
  `empname` varchar(15) default NULL COMMENT '名字',
  `opera` int(11) default NULL COMMENT '操作者',
  `uptime` datetime default NULL COMMENT '更新时间',
  PRIMARY KEY  (`departmentid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='部门人员';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'技术部',NULL,NULL,0,'2021-05-12 19:35:35');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dept_category`
--

DROP TABLE IF EXISTS `dept_category`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `dept_category` (
  `dept_categoryid` tinyint(4) NOT NULL auto_increment,
  `dept_categoryname` varchar(20) default NULL,
  PRIMARY KEY  (`dept_categoryid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `dept_category`
--

LOCK TABLES `dept_category` WRITE;
/*!40000 ALTER TABLE `dept_category` DISABLE KEYS */;
INSERT INTO `dept_category` VALUES (1,'内科'),(2,'皮肤科');
/*!40000 ALTER TABLE `dept_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispensary`
--

DROP TABLE IF EXISTS `dispensary`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `dispensary` (
  `dispensaryid` int(11) NOT NULL auto_increment,
  `hospitalid` int(11) default '1',
  `dispensaryno` varchar(5) default NULL COMMENT '药房码',
  `dispensaryname` varchar(50) default NULL COMMENT '药房名',
  `memo` varchar(50) default NULL COMMENT '备注',
  `opera` int(11) default NULL COMMENT '操作员',
  `uptime` datetime default NULL COMMENT '时间',
  `delemp` int(11) default NULL COMMENT '删除人',
  `deltime` datetime default NULL COMMENT '删除时间',
  `status` tinyint(2) default NULL COMMENT '状态',
  PRIMARY KEY  (`dispensaryid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='药房基本信息';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `dispensary`
--

LOCK TABLES `dispensary` WRITE;
/*!40000 ALTER TABLE `dispensary` DISABLE KEYS */;
INSERT INTO `dispensary` VALUES (1,1,'DP01','中药制剂药房','',1,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `dispensary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `equipment` (
  `equipmentid` int(11) NOT NULL auto_increment COMMENT '序号',
  `computerid` int(11) default '1',
  `equipmentno` varchar(20) default NULL COMMENT '设备编号',
  `equipmentname` varchar(50) default NULL COMMENT '设备名',
  `ip` varchar(50) default NULL COMMENT 'ip',
  `cabinetid` int(11) default NULL COMMENT '药柜号',
  `status` tinyint(1) default NULL COMMENT '状态',
  `equipmenttypeid` tinyint(4) default NULL,
  `equipmenttype` varchar(30) default NULL COMMENT '设备类型',
  `opera` int(11) default NULL COMMENT '操作者',
  `uptime` datetime default NULL COMMENT '时间',
  PRIMARY KEY  (`equipmentid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='药柜设备';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES (1,1,'disp01','发药机1#','192.168.0.200',1,1,0,'',1,'2021-05-28 09:59:30');
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment_pos`
--

DROP TABLE IF EXISTS `equipment_pos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `equipment_pos` (
  `posid` int(11) NOT NULL auto_increment,
  `equipmentid` int(11) NOT NULL,
  `pos_idx` tinyint(4) NOT NULL,
  `opera` int(11) default NULL,
  `uptime` datetime default NULL,
  PRIMARY KEY  (`posid`),
  KEY `FK_equipment_pos` (`equipmentid`),
  CONSTRAINT `FK_equipment_pos` FOREIGN KEY (`equipmentid`) REFERENCES `equipment` (`equipmentid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `equipment_pos`
--

LOCK TABLES `equipment_pos` WRITE;
/*!40000 ALTER TABLE `equipment_pos` DISABLE KEYS */;
INSERT INTO `equipment_pos` VALUES (1,1,1,0,'2021-05-14 21:45:24'),(2,1,2,0,'2021-05-14 21:45:32'),(3,1,3,0,'2021-05-14 21:45:38'),(4,1,4,0,'2021-05-14 21:45:45'),(5,1,5,0,'2021-05-14 21:45:50');
/*!40000 ALTER TABLE `equipment_pos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment_type`
--

DROP TABLE IF EXISTS `equipment_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `equipment_type` (
  `equipmenttypeid` tinyint(4) NOT NULL auto_increment COMMENT '序号',
  `equipmenttypeno` varchar(50) default NULL COMMENT '设备类型编号',
  `equipmenttypename` varchar(50) default NULL COMMENT '设备类型名',
  `opera` int(11) default NULL COMMENT '操作者',
  `uptime` datetime default NULL COMMENT '时间',
  PRIMARY KEY  (`equipmenttypeid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='药柜设备类型';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `equipment_type`
--

LOCK TABLES `equipment_type` WRITE;
/*!40000 ALTER TABLE `equipment_type` DISABLE KEYS */;
INSERT INTO `equipment_type` VALUES (1,'SBMODEL1','SBMODEL1',0,'2021-05-08 00:00:00'),(2,'SBMODEL2','SBMODEL2',0,'2021-05-08 00:00:00');
/*!40000 ALTER TABLE `equipment_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital`
--

DROP TABLE IF EXISTS `hospital`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hospital` (
  `hospitalid` int(11) NOT NULL auto_increment,
  `hospitalname` varchar(50) default NULL COMMENT '医院名',
  `opera` int(11) default NULL COMMENT '工号',
  `uptime` datetime default NULL COMMENT '时间',
  `hospitalno` varchar(20) default NULL COMMENT '医院编号',
  PRIMARY KEY  (`hospitalid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='医院名';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `hospital`
--

LOCK TABLES `hospital` WRITE;
/*!40000 ALTER TABLE `hospital` DISABLE KEYS */;
INSERT INTO `hospital` VALUES (1,'HOSPITAL',1,'2021-05-08 00:00:00','H001');
/*!40000 ALTER TABLE `hospital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instock_log`
--

DROP TABLE IF EXISTS `instock_log`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `instock_log` (
  `instockid` bigint(20) NOT NULL auto_increment,
  `inempid` int(11) default NULL,
  `inemp` varchar(40) default NULL COMMENT '入库人',
  `receiveempid` int(11) default NULL,
  `receiveemp` varchar(40) default NULL COMMENT '接收人',
  `stockno` int(11) default NULL COMMENT '仓库号',
  `locationno` int(11) default NULL COMMENT '储位',
  `po` varchar(40) default NULL COMMENT '入库单号',
  `bottleid` bigint(20) default NULL,
  `bottleno` varchar(50) default NULL,
  `medicineid` int(11) default NULL,
  `medicineno` varchar(40) default NULL COMMENT '药编码',
  `intype` tinyint(4) default NULL COMMENT '入库类型',
  `datecode` int(11) default NULL COMMENT 'datacode',
  `validday` int(11) default NULL COMMENT '有效期',
  `weight` double(18,2) default NULL COMMENT '重量',
  `memo` varchar(50) default NULL COMMENT '备注',
  `opera` int(11) default NULL COMMENT '操作者',
  `inserttime` datetime default NULL COMMENT '插入时间',
  `delemp` int(11) default NULL COMMENT '删除人',
  `deltime` datetime default NULL COMMENT '删除时间',
  `manufacturer` varchar(40) default NULL COMMENT '厂商',
  PRIMARY KEY  (`instockid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入库log';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `instock_log`
--

LOCK TABLES `instock_log` WRITE;
/*!40000 ALTER TABLE `instock_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `instock_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `md_mc_ctrl`
--

DROP TABLE IF EXISTS `md_mc_ctrl`;
/*!50001 DROP VIEW IF EXISTS `md_mc_ctrl`*/;
/*!50001 CREATE TABLE `md_mc_ctrl` (
  `medicineid` int(11),
  `medicineid2` int(11),
  `relationtype` varchar(20),
  `controlid` int(11),
  `medication_detailid` bigint(20),
  `medication_detailid2` bigint(20),
  `medicationid` bigint(20)
) */;

--
-- Table structure for table `medi_trans`
--

DROP TABLE IF EXISTS `medi_trans`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medi_trans` (
  `transid` bigint(20) NOT NULL auto_increment,
  `medicationid` int(11) default NULL,
  `medication_detailid` bigint(20) default NULL,
  `medicineid` int(11) default NULL,
  `bottleid` int(11) default NULL,
  `cabinetid` int(11) default NULL,
  `cabinet_cellid` int(11) default NULL,
  `equipmentid` int(11) default NULL,
  `equipment_posid` int(11) default NULL,
  `equipment_pos_degree` smallint(6) default NULL,
  `qtyapply` double(18,2) default NULL,
  `qtyrelease` double(18,2) default NULL,
  `weight1` double(18,2) default NULL,
  `weight2` double(18,2) default NULL,
  `status` smallint(6) default NULL,
  `opera` int(11) default NULL,
  `uptime` datetime default NULL,
  PRIMARY KEY  (`transid`),
  UNIQUE KEY `medication_detailid` (`medication_detailid`),
  KEY `medicationid` (`medicationid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medi_trans`
--

LOCK TABLES `medi_trans` WRITE;
/*!40000 ALTER TABLE `medi_trans` DISABLE KEYS */;
INSERT INTO `medi_trans` VALUES (1,1,1,1,1,1,1,1,1,5,NULL,NULL,NULL,NULL,301,1,'2021-05-28 13:57:13'),(2,1,4,3,4,1,3,1,2,8,NULL,NULL,NULL,NULL,301,1,'2021-05-28 13:57:13');
/*!40000 ALTER TABLE `medi_trans` ENABLE KEYS */;
UNLOCK TABLES;

/*!50003 SET @SAVE_SQL_MODE=@@SQL_MODE*/;

DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`i3u`@`localhost` */ /*!50003 TRIGGER `medi_trans_update` BEFORE UPDATE ON `medi_trans` FOR EACH ROW BEGIN
if new.status=303 then
if new.weight1<=0 then
set new.bottleid=null;
end if;
INSERT INTO bottle_transaction (bottleid,medicineid,weight_cur,opera,uptime,uses_flag) VALUES(
new.bottleid,new.medicineid,new.weight1,new.opera,new.uptime,104);
ELSEIF new.status=304 OR new.status=305 then
INSERT INTO bottle_transaction (bottleid,medicineid,opera,uptime,uses_flag) VALUES(
new.bottleid,new.medicineid,new.opera,new.uptime,105);
elseif new.status=306 then
IF new.weight2<=0 THEN
SET new.bottleid=NULL;
END IF;
INSERT INTO bottle_transaction (bottleid,medicineid,weight_cur,opera,uptime,uses_flag) VALUES(
new.bottleid,new.medicineid,new.weight2,new.opera,new.uptime,106);
ELSEIF new.status=307 THEN
INSERT INTO bottle_transaction (bottleid,medicineid,opera,uptime,uses_flag) VALUES(
new.bottleid,new.medicineid,new.opera,new.uptime,107);
end if;
    END */;;

DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@SAVE_SQL_MODE*/;

--
-- Table structure for table `medication`
--

DROP TABLE IF EXISTS `medication`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medication` (
  `medicationid` bigint(20) NOT NULL auto_increment,
  `dispensaryid` int(11) default NULL,
  `medication_no` varchar(30) default NULL COMMENT '处方号',
  `dept_category` tinyint(4) default NULL COMMENT '科别',
  `doctor_no` varchar(50) default NULL COMMENT '医生',
  `type` tinyint(4) default NULL,
  `patient_idcard` varchar(50) default NULL COMMENT '证件号码',
  `patient_idcardtp` tinyint(4) default NULL COMMENT '证件类型',
  `patient_name` varchar(50) default NULL COMMENT '姓名',
  `patient_sex` varchar(5) default NULL COMMENT '性别',
  `patient_age` tinyint(4) default NULL COMMENT '年龄',
  `patient_nationality` tinyint(4) default NULL COMMENT '民族',
  `patient_phoneno` varchar(20) default NULL COMMENT '电话',
  `patient_marrital` tinyint(4) default NULL COMMENT '婚否',
  `patient_profession` tinyint(4) default NULL COMMENT '职业',
  `patient_citizenship` smallint(6) default NULL COMMENT '国籍',
  `patient_fresh` tinyint(1) default NULL COMMENT '是否首次',
  `patient_address` varchar(50) default NULL COMMENT '地址',
  `patient_fallill_time` datetime default NULL COMMENT '生病时间',
  `patient_intime` datetime default NULL COMMENT '看病时间',
  `patient_allergy` varchar(100) default NULL COMMENT '过敏史',
  `patient_historyilldes` varchar(100) default NULL COMMENT '病史',
  `patient_illshow` varchar(100) default NULL COMMENT '病表现',
  `doctory_diagnosis` varchar(100) default NULL COMMENT '诊断',
  `doctory_medicineprescript` varchar(100) default NULL COMMENT '药方',
  `doctory_medicinefundesc` varchar(100) default NULL COMMENT '药效',
  `doctory_usemethod` varchar(100) default NULL COMMENT '使用方法',
  `danji_price` double(10,2) default NULL COMMENT '单剂价格',
  `jici` int(5) default NULL COMMENT '剂次',
  `total_price` double(10,2) default NULL COMMENT '总价',
  `opera` int(11) default NULL COMMENT '操作人',
  `uptime` datetime default NULL COMMENT '更新时间',
  `status` smallint(5) unsigned default '200' COMMENT '状态',
  PRIMARY KEY  (`medicationid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='处方录入';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medication`
--

LOCK TABLES `medication` WRITE;
/*!40000 ALTER TABLE `medication` DISABLE KEYS */;
INSERT INTO `medication` VALUES (1,1,'H001000820210508175840',1,'ADMIN',41,NULL,NULL,'EMP','?',2,NULL,'134',NULL,NULL,NULL,0,'AD','2021-05-08 00:00:00','2021-05-08 00:00:00','','','T1','T1','T1','T1','T1',500.00,10,5000.00,0,'2021-05-08 00:00:00',204),(2,1,'H001000820210508180247',1,'ADMIN',41,NULL,NULL,'EMP2','',0,NULL,'',NULL,NULL,NULL,0,'','2021-05-08 00:00:00','2021-05-08 00:00:00','','','T','T','T','T','T',500.00,0,0.00,1,'2021-05-08 00:00:00',200),(3,1,'H001000820210522175840',2,'',40,NULL,NULL,'','',0,NULL,'',NULL,NULL,NULL,0,'','2021-05-22 14:59:09','2021-05-22 14:59:09','','','','','','','',0.00,3,0.00,1,NULL,204),(4,1,'H0010008202105261126',1,'',41,NULL,NULL,'','',0,NULL,'',NULL,NULL,NULL,0,'','2021-05-26 11:23:17','2021-05-26 11:23:17','','','','','','','',0.00,2,0.00,1,NULL,200);
/*!40000 ALTER TABLE `medication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medication_detail`
--

DROP TABLE IF EXISTS `medication_detail`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medication_detail` (
  `medication_detailid` bigint(20) NOT NULL auto_increment,
  `medicationid` bigint(20) NOT NULL,
  `medication_no` varchar(50) default NULL COMMENT '处方号',
  `medicineid` int(11) default NULL,
  `medicineno` varchar(50) default NULL COMMENT '药编号',
  `medicinenocn` varchar(50) default NULL COMMENT '药名',
  `price` double(10,2) default NULL COMMENT '价格',
  `jiliang` double(10,2) default NULL COMMENT '剂量',
  `xiaoji` double(10,2) default NULL COMMENT '小计',
  `status` smallint(6) default '300' COMMENT '状态',
  `time1` datetime default NULL COMMENT '时间',
  PRIMARY KEY  (`medication_detailid`),
  UNIQUE KEY `medicineid` (`medicationid`,`medicineid`),
  KEY `FK_medication_detail` (`medicationid`),
  CONSTRAINT `FK_medication_detail` FOREIGN KEY (`medicationid`) REFERENCES `medication` (`medicationid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='处方明细';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medication_detail`
--

LOCK TABLES `medication_detail` WRITE;
/*!40000 ALTER TABLE `medication_detail` DISABLE KEYS */;
INSERT INTO `medication_detail` VALUES (1,1,'H001000820210508175840',1,'H0201900','M2',50.00,5.00,250.00,300,'0000-00-00 00:00:00'),(3,2,'H001000820210508180247',1,'H0201900','M2',50.00,10.00,500.00,300,'0000-00-00 00:00:00'),(4,1,NULL,3,'H0201902','M4',50.00,8.00,400.00,300,'2021-05-16 19:46:59'),(5,3,NULL,13,'H0108200','阿胶',250.00,3.00,750.00,300,'2021-05-22 15:04:03'),(6,4,NULL,10,'000010','甘草',40.00,3.00,120.00,300,'2021-05-26 11:23:40'),(7,4,NULL,9,'000009','麦冬',30.00,2.00,60.00,300,'2021-05-26 11:25:32'),(8,4,NULL,98,'000098','人参',50.00,1.00,50.00,300,'2021-05-26 14:57:59'),(9,4,NULL,284,'000284','醋五灵脂',7.00,2.00,14.00,300,'2021-05-26 14:58:21');
/*!40000 ALTER TABLE `medication_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine_control`
--

DROP TABLE IF EXISTS `medicine_control`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medicine_control` (
  `controlid` int(11) NOT NULL auto_increment,
  `medicineid` int(11) default NULL COMMENT '药编号1',
  `medicine2id` int(11) default NULL COMMENT '要编号2',
  `explains` varchar(50) default NULL COMMENT '说明',
  `relation` tinyint(4) default NULL COMMENT '状态',
  `memo` varchar(50) default NULL COMMENT '备注',
  `opera` int(11) default NULL COMMENT '操作者',
  `uptime` datetime default NULL COMMENT '时间',
  `medicinename` varchar(40) default NULL COMMENT '药名1',
  `medicine2name` varchar(40) default NULL COMMENT '药名2',
  `delemp` int(11) default NULL COMMENT '删除人',
  `deltime` datetime default NULL COMMENT '删除时间',
  PRIMARY KEY  (`controlid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='配伍禁忌';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medicine_control`
--

LOCK TABLES `medicine_control` WRITE;
/*!40000 ALTER TABLE `medicine_control` DISABLE KEYS */;
INSERT INTO `medicine_control` VALUES (1,98,284,'',2,NULL,1,'2021-05-26 14:45:15',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `medicine_control` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine_control_type`
--

DROP TABLE IF EXISTS `medicine_control_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medicine_control_type` (
  `relationid` int(11) NOT NULL auto_increment,
  `relationtype` varchar(20) default NULL,
  `memo` varchar(100) default NULL,
  `opera` int(11) default NULL,
  `uptime` datetime default NULL,
  PRIMARY KEY  (`relationid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medicine_control_type`
--

LOCK TABLES `medicine_control_type` WRITE;
/*!40000 ALTER TABLE `medicine_control_type` DISABLE KEYS */;
INSERT INTO `medicine_control_type` VALUES (1,'反','18反',NULL,NULL),(2,'畏','19畏',NULL,NULL);
/*!40000 ALTER TABLE `medicine_control_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine_info`
--

DROP TABLE IF EXISTS `medicine_info`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medicine_info` (
  `medicineid` int(11) NOT NULL auto_increment COMMENT 'SEQ',
  `medicinecode` varchar(50) default NULL COMMENT 'HIS颗粒编码',
  `packno` varchar(50) default NULL COMMENT '包装码',
  `medicineno` varchar(50) default NULL COMMENT '药编号',
  `medicinenocn` varchar(50) default NULL COMMENT '药名中文',
  `medicinenopy` varchar(50) default NULL COMMENT '药名拼音',
  `density` double(10,2) default NULL,
  `equivalent` int(11) default NULL,
  `ispoison` tinyint(1) default '0' COMMENT '毒药',
  `isanesthetic` tinyint(1) default '0' COMMENT '麻药',
  `currentqty` double(18,2) default NULL COMMENT '当前数量',
  `price` double(18,2) default NULL COMMENT '价格',
  `warningval_jiliang` double(18,2) default NULL,
  `warningval_stock` int(5) default NULL COMMENT '库存安全值',
  `warningval_cabinet` int(5) default NULL COMMENT '药柜安全值',
  `warning_validdays` int(5) default NULL COMMENT '有效期报警值',
  `opera` int(11) default NULL COMMENT '操作员',
  `uptime` datetime default NULL COMMENT '时间',
  `publicqty` double(18,2) default NULL,
  `isdel` tinyint(1) default '0',
  PRIMARY KEY  (`medicineid`)
) ENGINE=InnoDB AUTO_INCREMENT=363 DEFAULT CHARSET=utf8 COMMENT='颗粒基本信息';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medicine_info`
--

LOCK TABLES `medicine_info` WRITE;
/*!40000 ALTER TABLE `medicine_info` DISABLE KEYS */;
INSERT INTO `medicine_info` VALUES (1,'H000001','K001','000001','百部','bb',0.91,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(2,'H000002','K002','000002','阿胶','aj',0.95,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(3,'H000003','K003','000003','当归','dg',1.05,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(4,'H000004','K004','000004','黄芪','hq',1.23,9,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(5,'H000005','K005','000005','地黄','dh',0.85,5,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(6,'H000006','K006','000006','白术','bs',0.99,8,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(7,'H000007','K007','000007','川芎','cx',0.96,7,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(8,'H000008','K008','000008','黄芩','hq',1.08,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(9,'H000009','K009','000009','麦冬','md',1.02,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(10,'H000010','K010','000010','甘草','gc',0.91,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(11,'H000011','K011','000011','熟地黄','sdh',0.95,9,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(12,'H000012','K012','000012','枸杞子','gjz',1.05,5,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(13,'H000013','K013','000013','茯苓','fl',1.23,8,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(14,'H000014','K014','000014','丹参','ds',0.85,7,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(15,'H000015','K015','000015','赤芍','cs',0.99,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(16,'H000016','K016','000016','白芍','bs',0.96,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(17,'H000017','K017','000017','酒黄精','jhj',1.08,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(18,'H000018','K018','000018','桔梗','jg',1.02,9,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(19,'H000019','K019','000019','蜜款冬花','mkdh',0.91,5,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(20,'H000020','K020','000020','三七','sq',0.95,8,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(21,'H000021','K021','000021','金银花','jyh',1.05,7,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(22,'H000022','K022','000022','防风','ff',1.23,5,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(23,'H000023','K023','000023','柴胡','cf',0.85,10,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(24,'H000024','K024','000024','山楂','sz',0.99,10,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(25,'H000025','K025','000025','玄参','xs',0.96,9,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(26,'H000026','K026','000026','百部','bb',1.08,5,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(27,'H000027','K027','000027','酒萸肉','jyr',1.02,8,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(28,'H000028','K028','000028','白芷','bz',0.91,7,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(29,'H000029','K029','000029','牛膝','nq',0.95,5,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(30,'H000030','K030','000030','陈皮','cp',1.05,10,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(31,'H000031','K031','000031','牡丹皮','mdp',1.23,10,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(32,'H000032','K032','000032','知母','zm',0.85,9,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(33,'H000033','K033','000033','炒鸡内金','cjnj',0.99,5,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(34,'H000034','K034','000034','西洋参','xys',0.96,8,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(35,'H000035','K035','000035','红花','hh',1.08,7,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(36,'H000036','K036','000036','麸炒苍术','fccs',1.02,5,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(37,'H000037','K037','000037','金樱子','jyz',0.91,10,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(38,'H000038','K038','000038','桑白皮','sbp',0.95,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(39,'H000039','K039','000039','白茅根','bmg',1.05,9,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(40,'H000040','K040','000040','茵陈','yc',1.23,5,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(41,'H000041','K041','000041','射干','sg',0.85,8,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(42,'H000042','K042','000042','土茯苓','tfl',0.99,7,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(43,'H000043','K043','000043','木香','mx',0.96,5,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(44,'H000044','K044','000044','银柴胡','ych',1.08,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(45,'H000045','K045','000045','炒蒺藜','cjl',1.02,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(46,'H000046','K046','000046','独活','dh',0.91,9,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(47,'H000047','K047','000047','党参','ds',0.95,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(48,'H000048','K048','000048','山药','sy',1.05,8,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(49,'H000049','K049','000049','天冬','td',1.23,7,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(50,'H000050','K050','000050','醋延胡索','cyhs',0.85,5,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(51,'H000051','K051','000051','瓜蒌皮','glp',0.99,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(52,'H000052','K052','000052','炙甘草','zgc',0.96,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(53,'H000053','K053','000053','野菊花','yjh',1.08,9,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(54,'H000054','K054','000054','葛根','gg',1.02,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(55,'H000055','K055','000055','法半夏','fbx',0.91,8,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(56,'H000056','K056','000056','薏苡仁','yyr',0.95,7,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(57,'H000057','K057','000057','杜仲','dz',1.05,5,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(58,'H000058','K058','000058','麸炒枳壳','fczk',1.23,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(59,'H000059','K059','000059','浙贝母','zbm',0.85,10,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(60,'H000060','K060','000060','荆芥','jj',0.99,9,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(61,'H000061','K061','000061','巴戟天','bjt',0.96,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(62,'H000062','K062','000062','蜈蚣','wg',1.08,8,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(63,'H000063','K063','000063','泽泻','zx',1.02,7,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(64,'H000064','K064','000064','太子参','tzs',0.91,5,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(65,'H000065','K065','000065','醋五味子','cwwz',0.95,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(66,'H000066','K066','000066','酒女贞子','jnzz',1.05,10,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(67,'H000067','K067','000067','韭菜子','jcz',1.23,9,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(68,'H000068','K068','000068','蜜枇杷叶','mppy',0.85,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(69,'H000069','K069','000069','续断','xd',0.99,8,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(70,'H000070','K070','000070','酒苁蓉','jcr',0.96,7,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(71,'H000071','K071','000071','南沙参','nss',1.08,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(72,'H000072','K072','000072','燀苦杏仁','nss',1.02,10,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(73,'H000073','K073','000073','蒲公英','nss',0.91,10,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(74,'H000074','K074','000074','白鲜皮','nss',0.95,9,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(75,'H000075','K075','000075','姜厚朴','nss',1.05,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(76,'H000076','K076','000076','菊花','nss',1.23,8,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(77,'H000077','K077','000077','百合','nss',0.85,7,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(78,'H000078','K078','000078','栀子','nss',0.99,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(79,'H000079','K079','000079','川牛膝','nss',0.96,10,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(80,'H000080','K080','000080','炒麦芽','nss',1.08,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(81,'H000081','K081','000081','地骨皮','nss',1.02,9,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(82,'H000082','K082','000082','锁阳','nss',0.91,5,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(83,'H000083','K083','000083','败酱草','nss',0.95,8,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(84,'H000084','K084','000084','灵芝','nss',1.05,7,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(85,'H000085','K085','000085','石菖蒲','nss',1.23,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(86,'H000086','K086','000086','佛手','nss',0.85,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(87,'H000087','K087','000087','醋香附','nss',0.99,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(88,'H000088','K088','000088','炒牛蒡子','nss',0.96,9,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(89,'H000089','K089','000089','炒没药','nss',1.08,5,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(90,'H000090','K090','000090','连翘','nss',1.02,8,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(91,'H000091','K091','000091','天花粉','nss',0.91,7,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(92,'H000092','K092','000092','前胡','nss',0.95,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(93,'H000093','K093','000093','黄连','nss',1.05,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(94,'H000094','K094','000094','焦山楂','nss',1.23,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(95,'H000095','K095','000095','白前','nss',0.85,9,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(96,'H000096','K096','000096','天麻','nss',0.99,5,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(97,'H000097','K097','000097','墨旱莲','nss',0.96,8,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(98,'H000098','K098','000098','人参','nss',1.08,7,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(99,'H000099','K099','000099','盐补骨脂','nss',1.02,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(100,'H000100','K100','000100','砂仁','nss',0.91,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(101,'H000101','K101','000101','芦根','nss',0.95,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(102,'H000102','K102','000102','玉竹','nss',1.05,9,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(103,'H000103','K103','000103','皂角刺','nss',1.23,5,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(104,'H000104','K104','000104','乌梅','nss',0.85,8,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(105,'H000105','K105','000105','郁金','nss',0.99,7,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(106,'H000106','K106','000106','大青叶','nss',0.96,5,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(107,'H000107','K107','000107','羌活','nss',1.08,10,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(108,'H000108','K108','000108','大枣','nss',1.02,10,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(109,'H000109','K109','000109','桑寄生','nss',0.91,9,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(110,'H000110','K110','000110','浮小麦','nss',0.95,5,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(111,'H000111','K111','000111','盐益智仁','nss',1.05,8,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(112,'H000112','K112','000112','炮山甲','nss',1.23,7,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(113,'H000113','K113','000113','鱼腥草','nss',0.85,5,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(114,'H000114','K114','000114','山慈菇','nss',0.99,10,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(115,'H000115','K115','000115','白花蛇舌草','nss',0.96,10,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(116,'H000116','K116','000116','淫羊藿','nss',1.08,9,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(117,'H000117','K117','000117','赤小豆','nss',1.02,5,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(118,'H000118','K118','000118','桑椹','nss',0.91,8,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(119,'H000119','K119','000119','蝉蜕','nss',0.95,7,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(120,'H000120','K120','000120','麸炒枳实','nss',1.05,5,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(121,'H000121','K121','000121','重楼','nss',1.23,10,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(122,'H000122','K122','000122','炒川楝子','nss',0.85,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(123,'H000123','K123','000123','炙黄芪','nss',0.99,9,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(124,'H000124','K124','000124','徐长卿','nss',0.96,5,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(125,'H000125','K125','000125','凌霄花','nss',1.08,8,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(126,'H000126','K126','000126','蜜麻黄','nss',1.02,7,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(127,'H000127','K127','000127','桂枝','nss',0.91,5,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(128,'H000128','K128','000128','白及','nss',0.95,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(129,'H000129','K129','000129','炒酸枣仁','nss',1.05,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(130,'H000130','K130','000130','苦参','nss',1.23,9,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(131,'H000131','K131','000131','芡实','nss',0.85,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(132,'H000132','K132','000132','紫河车','nss',0.99,8,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(133,'H000133','K133','000133','桑叶','nss',0.96,7,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(134,'H000134','K134','000134','鹿角胶','nss',1.08,5,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(135,'H000135','K135','000135','炒僵蚕','nss',1.02,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(136,'H000136','K136','000136','车前草','nss',0.91,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(137,'H000137','K137','000137','制何首乌','nss',0.95,9,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(138,'H000138','K138','000138','紫花地丁','nss',1.05,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(139,'H000139','K139','000139','蜜紫菀','nss',1.23,8,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(140,'H000140','K140','000140','燀桃仁','nss',0.85,7,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(141,'H000141','K141','000141','土鳖虫','nss',0.99,5,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(142,'H000142','K142','000142','黄柏','nss',0.96,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(143,'H000143','K143','000143','乌药','nss',1.08,10,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(144,'H000144','K144','000144','大黄','nss',1.02,9,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(145,'H000145','K145','000145','鸡血藤','nss',0.91,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(146,'H000146','K146','000146','威灵仙','nss',0.95,8,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(147,'H000147','K147','000147','大血藤','nss',1.05,7,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(148,'H000148','K148','000148','制远志','nss',1.23,5,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(149,'H000149','K149','000149','木瓜','nss',0.85,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(150,'H000150','K150','000150','烫水蛭','nss',0.99,10,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(151,'H000151','K151','000151','广地龙','nss',0.96,9,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(152,'H000152','K152','000152','侧柏叶','nss',1.08,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(153,'H000153','K153','000153','夏枯草','nss',1.02,8,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(154,'H000154','K154','000154','薄荷','nss',0.91,7,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(155,'H000155','K155','000155','建曲','nss',0.95,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(156,'H000156','K156','000156','青黛','nss',1.05,10,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(157,'H000157','K157','000157','天葵子','nss',1.23,10,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(158,'H000158','K158','000158','沙苑子','nss',0.85,9,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(159,'H000159','K159','000159','炒莱菔子','nss',0.99,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(160,'H000160','K160','000160','全蝎','nss',0.96,8,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(161,'H000161','K161','000161','半枝莲','nss',1.08,7,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(162,'H000162','K162','000162','合欢皮','nss',1.02,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(163,'H000163','K163','000163','豆蔻','nss',0.91,10,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(164,'H000164','K164','000164','白果','nss',0.95,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(165,'H000165','K165','000165','龙胆','nss',1.05,9,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(166,'H000166','K166','000166','炒白术','nss',1.23,5,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(167,'H000167','K167','000167','升麻','nss',0.85,8,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(168,'H000168','K168','000168','石斛','nss',0.99,7,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(169,'H000169','K169','000169','益母草','nss',0.96,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(170,'H000170','K170','000170','火麻仁','nss',1.08,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(171,'H000171','K171','000171','旋覆花','nss',1.02,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(172,'H000172','K172','000172','广金钱草','nss',0.91,9,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(173,'H000173','K173','000173','仙茅','nss',0.95,5,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(174,'H000174','K174','000174','虎杖','nss',1.05,8,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(175,'H000175','K175','000175','秦艽','nss',1.23,7,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(176,'H000176','K176','000176','忍冬藤','nss',0.85,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(177,'H000177','K177','000177','紫草','nss',0.99,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(178,'H000178','K178','000178','制川乌','nss',0.96,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(179,'H000179','K179','000179','醋青皮','nss',1.08,9,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(180,'H000180','K180','000180','制乳香','nss',1.02,5,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(181,'H000181','K181','000181','煅牡蛎','nss',0.91,10,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(182,'H000182','K182','000182','青蒿','nss',0.95,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(183,'H000183','K183','000183','瓜蒌仁','nss',1.05,9,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(184,'H000184','K184','000184','细辛','nss',1.23,5,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(185,'H000185','K185','000185','炒紫苏子','nss',0.85,8,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(186,'H000186','K186','000186','红景天','nss',0.99,7,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(187,'H000187','K187','000187','路路通','nss',0.96,5,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(188,'H000188','K188','000188','首乌藤','nss',1.08,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(189,'H000189','K189','000189','广藿香','nss',1.02,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(190,'H000190','K190','000190','钩藤','nss',0.91,9,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(191,'H000191','K191','000191','醋三棱','nss',0.95,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(192,'H000192','K192','000192','石膏','nss',1.05,8,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(193,'H000193','K193','000193','片姜黄','nss',1.23,7,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(194,'H000194','K194','000194','醋莪术','nss',0.85,5,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(195,'H000195','K195','000195','炒谷芽','nss',0.99,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(196,'H000196','K196','000196','粉萆薢','nss',0.96,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(197,'H000197','K197','000197','牡蛎','nss',1.08,9,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(198,'H000198','K198','000198','茯神','nss',1.02,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(199,'H000199','K199','000199','天竺黄','nss',0.91,8,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(200,'H000200','K200','000200','烫狗脊','nss',0.95,7,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(201,'H000201','K201','000201','五加皮','nss',1.05,5,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(202,'H000202','K202','000202','覆盆子','nss',1.23,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(203,'H000203','K203','000203','淡竹叶','nss',0.85,10,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(204,'H000204','K204','000204','川贝母','nss',0.99,9,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(205,'H000205','K205','000205','桑枝','nss',0.96,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(206,'H000206','K206','000206','炒槐花','nss',1.08,8,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(207,'H000207','K207','000207','附片','nss',1.02,7,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(208,'H000208','K208','000208','刺猬皮','nss',0.91,5,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(209,'H000209','K209','000209','猫爪草','nss',0.95,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(210,'H000210','K210','000210','葶苈子','nss',1.05,10,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(211,'H000211','K211','000211','莲子','nss',1.23,9,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(212,'H000212','K212','000212','麦芽','nss',0.85,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(213,'H000213','K213','000213','沉香','nss',0.99,8,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(214,'H000214','K214','000214','醋鳖甲','nss',0.96,7,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(215,'H000215','K215','000215','诃子','nss',1.08,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(216,'H000216','K216','000216','酒乌梢蛇','nss',1.02,10,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(217,'H000217','K217','000217','制草乌','nss',0.91,10,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(218,'H000218','K218','000218','炒蔓荆子','nss',0.95,9,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(219,'H000219','K219','000219','蛇床子','nss',1.05,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(220,'H000220','K220','000220','阿胶','nss',1.23,8,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(221,'H000221','K221','000221','紫苏叶','nss',0.85,7,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(222,'H000222','K222','000222','木蝴蝶','nss',0.99,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(223,'H000223','K223','000223','薤白','nss',0.96,10,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(224,'H000224','K224','000224','小蓟','nss',1.08,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(225,'H000225','K225','000225','木通','nss',1.02,9,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(226,'H000226','K226','000226','麻黄根','nss',0.91,5,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(227,'H000227','K227','000227','紫苏梗','nss',0.95,8,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(228,'H000228','K228','000228','透骨草','nss',1.05,7,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(229,'H000229','K229','000229','荔枝核','nss',1.23,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(230,'H000230','K230','000230','平地木','nss',0.85,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(231,'H000231','K231','000231','竹茹','nss',0.99,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(232,'H000232','K232','000232','泽兰','nss',0.96,9,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(233,'H000233','K233','000233','煅龙骨','nss',1.08,5,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(234,'H000234','K234','000234','骨碎补','nss',1.02,8,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(235,'H000235','K235','000235','炒苍耳子','nss',0.91,7,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(236,'H000236','K236','000236','荷叶','nss',0.95,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(237,'H000237','K237','000237','炒王不留行','nss',1.05,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(238,'H000238','K238','000238','贯众','nss',1.23,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(239,'H000239','K239','000239','小通草','nss',0.85,9,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(240,'H000240','K240','000240','鹿角霜','nss',0.99,5,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(241,'H000241','K241','000241','马齿苋','nss',0.96,8,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(242,'H000242','K242','000242','仙鹤草','nss',1.08,7,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(243,'H000243','K243','000243','豨莶草','nss',1.02,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(244,'H000244','K244','000244','大腹皮','nss',0.91,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(245,'H000245','K245','000245','盐车前子','nss',0.95,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(246,'H000246','K246','000246','滑石','nss',1.05,9,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(247,'H000247','K247','000247','千年健','nss',1.23,5,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(248,'H000248','K248','000248','炒白扁豆','nss',0.85,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(249,'H000249','K249','000249','茜草','nss',0.99,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(250,'H000250','K250','000250','炒决明子','nss',0.96,9,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(251,'H000251','K251','000251','莲子心','nss',1.08,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(252,'H000252','K252','000252','干姜','nss',1.02,8,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(253,'H000253','K253','000253','醋龟甲','nss',0.91,7,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(254,'H000254','K254','000254','肉桂','nss',0.95,5,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(255,'H000255','K255','000255','胖大海','nss',1.05,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(256,'H000256','K256','000256','地肤子','nss',1.23,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(257,'H000257','K257','000257','黑芝麻','nss',0.85,9,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(258,'H000258','K258','000258','槟榔','nss',0.99,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(259,'H000259','K259','000259','佩兰','nss',0.96,8,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(260,'H000260','K260','000260','水牛角','nss',1.08,7,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(261,'H000261','K261','000261','金荞麦','nss',1.02,5,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(262,'H000262','K262','000262','炒芥子','nss',0.91,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(263,'H000263','K263','000263','桑螵蛸','nss',0.95,10,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(264,'H000264','K264','000264','制吴茱萸','nss',1.05,9,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(265,'H000265','K265','000265','龙眼肉','nss',1.23,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(266,'H000266','K266','000266','龙齿','nss',0.85,8,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(267,'H000267','K267','000267','珍珠母','nss',0.99,7,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(268,'H000268','K268','000268','地锦草','nss',0.96,5,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(269,'H000269','K269','000269','胡黄连','nss',1.08,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(270,'H000270','K270','000270','橘红','nss',1.02,10,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(271,'H000271','K271','000271','玫瑰花','nss',0.91,9,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(272,'H000272','K272','000272','地榆','nss',0.95,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(273,'H000273','K273','000273','穿破石','nss',1.05,8,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(274,'H000274','K274','000274','络石藤','nss',1.23,7,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(275,'H000275','K275','000275','大蓟','nss',0.85,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(276,'H000276','K276','000276','石榴皮','nss',0.99,10,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(277,'H000277','K277','000277','海金沙','nss',0.96,10,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(278,'H000278','K278','000278','马勃','nss',1.08,9,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(279,'H000279','K279','000279','龙骨','nss',1.02,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(280,'H000280','K280','000280','蜂房','nss',0.91,8,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(281,'H000281','K281','000281','艾叶','nss',0.95,7,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(282,'H000282','K282','000282','猪苓','nss',1.05,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(283,'H000283','K283','000283','石韦','nss',1.23,10,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(284,'H000284','K284','000284','醋五灵脂','nss',0.85,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(285,'H000285','K285','000285','煅赭石','nss',0.99,9,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(286,'H000286','K286','000286','蒲黄','nss',0.96,5,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(287,'H000287','K287','000287','蒲黄炭','nss',1.08,8,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(288,'H000288','K288','000288','胆南星','nss',1.02,7,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(289,'H000289','K289','000289','煅瓦楞子','nss',0.91,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(290,'H000290','K290','000290','昆布','nss',0.95,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(291,'H000291','K291','000291','海浮石','nss',1.05,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(292,'H000292','K292','000292','麻黄','nss',1.23,9,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(293,'H000293','K293','000293','萹蓄','nss',0.85,5,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(294,'H000294','K294','000294','海藻','nss',0.99,8,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(295,'H000295','K295','000295','熟大黄','nss',0.96,7,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(296,'H000296','K296','000296','灯心草','nss',1.08,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(297,'H000297','K297','000297','煅石决明','nss',1.02,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(298,'H000298','K298','000298','冬瓜子','nss',0.91,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(299,'H000299','K299','000299','浮萍','nss',0.95,9,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(300,'H000300','K300','000300','辛夷','nss',1.05,5,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(301,'H000301','K301','000301','盐小茴香','nss',1.23,8,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(302,'H000302','K302','000302','鸡冠花','nss',0.85,7,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(303,'H000303','K303','000303','石见穿','nss',0.99,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(304,'H000304','K304','000304','防己','nss',0.96,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(305,'H000305','K305','000305','郁李仁','nss',1.08,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(306,'H000306','K306','000306','柏子仁','nss',1.02,9,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(307,'H000307','K307','000307','盐橘核','nss',0.91,5,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(308,'H000308','K308','000308','制天南星','nss',0.95,8,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(309,'H000309','K309','000309','月季花','nss',1.05,7,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(310,'H000310','K310','000310','密蒙花','nss',1.23,5,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(311,'H000311','K311','000311','刺五加','nss',0.85,10,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(312,'H000312','K312','000312','芒硝','nss',0.99,10,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(313,'H000313','K313','000313','山豆根','nss',0.96,9,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(314,'H000314','K314','000314','藁本','nss',1.08,5,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(315,'H000315','K315','000315','煅磁石','nss',1.02,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(316,'H000316','K316','000316','丝瓜络','nss',0.91,10,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(317,'H000317','K317','000317','龙葵','nss',0.95,9,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(318,'H000318','K318','000318','煅自然铜','nss',1.05,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(319,'H000319','K319','000319','刘寄奴','nss',1.23,8,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(320,'H000320','K320','000320','藕节','nss',0.85,7,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(321,'H000321','K321','000321','鬼箭羽','nss',0.99,5,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(322,'H000322','K322','000322','炮姜','nss',0.96,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(323,'H000323','K323','000323','艾叶炭','nss',1.08,10,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(324,'H000324','K324','000324','香薷','nss',1.02,9,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(325,'H000325','K325','000325','地榆炭','nss',0.91,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(326,'H000326','K326','000326','藕节炭','nss',0.95,8,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(327,'H000327','K327','000327','桔叶','nss',1.05,7,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(328,'H000328','K328','000328','血竭','nss',1.23,5,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(329,'H000329','K329','000329','苏木','nss',0.85,10,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(330,'H000330','K330','000330','赤石脂','nss',0.99,10,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(331,'H000331','K331','000331','藏青果','nss',0.96,9,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(332,'H000332','K332','000332','肿节风','nss',1.08,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(333,'H000333','K333','000333','菝葜','nss',1.02,8,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(334,'H000334','K334','000334','降香','nss',0.91,7,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(335,'H000335','K335','000335','茯苓皮','nss',0.95,5,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(336,'H000336','K336','000336','制白附子','nss',1.05,10,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(337,'H000337','K337','000337','谷精草','nss',1.23,10,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(338,'H000338','K338','000338','绞股蓝','nss',0.85,9,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(339,'H000339','K339','000339','半边莲','nss',0.99,5,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(340,'H000340','K340','000340','秦皮','nss',0.96,8,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(341,'H000341','K341','000341','高良姜','nss',1.08,7,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(342,'H000342','K342','000342','橘络','nss',1.02,5,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(343,'H000343','K343','000343','茺蔚子','nss',0.91,10,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(344,'H000344','K344','000344','木贼','nss',0.95,10,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(345,'H000345','K345','000345','荆芥炭','nss',1.05,9,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(346,'H000346','K346','000346','北沙参','nss',1.23,5,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(347,'H000347','K347','000347','檀香','nss',0.85,8,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(348,'H000348','K348','000348','海风藤','nss',0.99,7,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(349,'H000349','K349','000349','青葙子','nss',0.96,5,0,0,NULL,50.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(350,'H000350','K350','000350','苎麻根','nss',1.08,10,0,0,NULL,50.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(351,'H000351','K351','000351','白薇','nss',1.02,10,0,0,NULL,30.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(352,'H000352','K352','000352','田基黄','nss',0.91,9,0,0,NULL,40.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(353,'H000353','K353','000353','青风藤','nss',0.95,5,0,0,NULL,15.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(354,'H000354','K354','000354','花椒','nss',1.05,8,0,0,NULL,13.00,9.00,10,60,NULL,NULL,NULL,NULL,0),(355,'H000355','K355','000355','千里光','nss',1.23,7,0,0,NULL,10.00,8.00,10,60,NULL,NULL,NULL,NULL,0),(356,'H000356','K356','000356','玉米须','nss',0.85,5,0,0,NULL,7.00,15.00,10,60,NULL,NULL,NULL,NULL,0),(357,'H000357','K357','000357','九节菖蒲','nss',0.99,10,0,0,NULL,30.00,10.00,10,60,NULL,NULL,NULL,NULL,0),(358,'H000358','K358','000358','白蔹','nss',0.96,10,0,0,NULL,40.00,12.00,10,60,NULL,NULL,NULL,NULL,0),(359,'H000359','K359','000359','蛤壳','nss',1.08,9,0,0,NULL,4.00,14.00,10,60,NULL,NULL,NULL,NULL,0),(360,'H000360','K360','000360','血余炭','nss',1.02,5,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(361,'H000361','K361','000361','菟丝子','nss',0.96,8,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0),(362,'H000362','K362','000362','炒九香虫','nss',0.90,7,0,0,NULL,6.00,16.00,10,60,NULL,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `medicine_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine_loc_cabinet`
--

DROP TABLE IF EXISTS `medicine_loc_cabinet`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medicine_loc_cabinet` (
  `locationid` bigint(20) NOT NULL auto_increment,
  `equipmentno` varchar(50) default NULL COMMENT '设备编码',
  `medicineid` int(11) default NULL COMMENT '药物编码',
  `medicineno` varchar(50) default NULL COMMENT '药物编码',
  `cabinetid` int(11) default NULL COMMENT '柜号',
  `layoutid_row` tinyint(4) default NULL COMMENT '药行',
  `layoutid_col` tinyint(4) default NULL COMMENT '药列',
  `layout_row` tinyint(4) default NULL COMMENT '药柜行数',
  `layout_col` tinyint(4) default NULL COMMENT '药柜列数',
  `layout_rowwidth` smallint(6) default NULL COMMENT '药格宽',
  `layout_rowheight` smallint(6) default NULL COMMENT '药格高',
  `medicine_location` varchar(50) default NULL COMMENT 'LOCATION',
  `medicine_cur_qty` int(11) default NULL COMMENT '当前数量',
  `opera` int(11) default NULL COMMENT '操作员',
  `uptime` datetime default NULL COMMENT '更新时间',
  `bottleid` bigint(20) default NULL COMMENT '瓶号',
  PRIMARY KEY  (`locationid`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='调剂设备药格配置';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medicine_loc_cabinet`
--

LOCK TABLES `medicine_loc_cabinet` WRITE;
/*!40000 ALTER TABLE `medicine_loc_cabinet` DISABLE KEYS */;
INSERT INTO `medicine_loc_cabinet` VALUES (1,'SBNO1',1,'H0201900',1,1,1,10,10,80,40,'',1000,0,'2021-05-08 00:00:00',0),(2,'SBNO1',2,'H0201901',1,2,1,10,10,80,40,'',1000,0,'2021-05-08 00:00:00',0),(3,'SBNO1',3,'H0201902',1,3,1,10,10,80,40,'',1000,0,'2021-05-08 00:00:00',0),(4,'SBNO1',4,'H0201903',1,4,1,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0),(5,'SBNO1',5,'H0201904',1,5,1,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0),(6,'SBNO1',6,'H0201905',1,6,1,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0),(7,'SBNO1',7,'H0201906',1,7,1,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0),(8,'SBNO1',8,'H0201907',1,8,1,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0),(9,'SBNO1',9,'H0201908',1,9,1,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0),(10,'SBNO1',10,'H0201909',1,10,1,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0),(11,'SBNO1',11,'H0201910',1,1,2,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0),(12,'SBNO1',12,'H0201911',1,2,2,10,10,80,40,'',0,0,'2021-05-08 00:00:00',0);
/*!40000 ALTER TABLE `medicine_loc_cabinet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicineequipment_base`
--

DROP TABLE IF EXISTS `medicineequipment_base`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medicineequipment_base` (
  `equipmentno` varchar(50) default NULL COMMENT '设备编号',
  `equipmentname` varchar(50) default NULL COMMENT '设备名',
  `ip` varchar(50) default NULL COMMENT 'ip',
  `status` tinyint(1) default NULL COMMENT '状态',
  `equipmenttype` varchar(30) default NULL COMMENT '设备类型',
  `opera` varchar(15) default NULL COMMENT '操作者',
  `uptime` date default NULL COMMENT '时间',
  `seq` int(5) default NULL COMMENT '序号',
  `bindstatus` varchar(2) default NULL COMMENT '绑定状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药柜设备基本信息';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medicineequipment_base`
--

LOCK TABLES `medicineequipment_base` WRITE;
/*!40000 ALTER TABLE `medicineequipment_base` DISABLE KEYS */;
INSERT INTO `medicineequipment_base` VALUES ('SBNO1','SBNO1','192.168.0.200',1,'SBMODEL1','ADMIN','2021-05-08',1,'');
/*!40000 ALTER TABLE `medicineequipment_base` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `menu` (
  `tableid` varchar(50) default NULL COMMENT 'tableid',
  `menuid` varchar(50) default NULL COMMENT '菜单id',
  `menuname` varchar(50) default NULL COMMENT '菜单名',
  `parentmenu` varchar(50) default NULL COMMENT '父菜单',
  `grade` varchar(50) default NULL COMMENT '层',
  `flag` varchar(50) default NULL COMMENT 'flag',
  `href` varchar(200) default NULL COMMENT 'href',
  `uptime` date default NULL COMMENT '时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `mt_cc_b_m`
--

DROP TABLE IF EXISTS `mt_cc_b_m`;
/*!50001 DROP VIEW IF EXISTS `mt_cc_b_m`*/;
/*!50001 CREATE TABLE `mt_cc_b_m` (
  `bottleno` varchar(50),
  `medicineno` varchar(50),
  `medicinenocn` varchar(50),
  `medicinenopy` varchar(50),
  `jiliang` double(10,2),
  `statusname` varchar(10),
  `cabinetname` varchar(50),
  `cell` varbinary(9),
  `equipmentname` varchar(50),
  `pos_idx` tinyint(4),
  `equipment_pos_degree` double(14,6),
  `qtyapply` double(18,2),
  `qtyrelease` double(18,2),
  `weight1` double(18,2),
  `weight2` double(18,2),
  `op_idx` int(11),
  `op_code` int(11),
  `price` double(10,2),
  `xiaoji` double(10,2),
  `medication_no` varchar(50),
  `computer_name` varchar(40),
  `status` int(6),
  `time1` datetime,
  `equipmentid` int(11),
  `equipment_posid` int(11),
  `mqtt_light` varbinary(45),
  `mqtt_pos` varbinary(40),
  `mqtt_ind_shangdai` varchar(41),
  `mqtt_ind_fengdai` varchar(40),
  `mqtt_ind_startstop` varchar(42),
  `mqtt_getweight` varchar(38),
  `mqtt_return_finish` varchar(42),
  `transid` bigint(20),
  `computerid` int(11),
  `cabinetid` int(11),
  `cellid` int(11),
  `bottleid` bigint(20),
  `medicineid` int(11),
  `medication_detailid` bigint(20),
  `medicationid` bigint(20)
) */;

--
-- Table structure for table `status_option`
--

DROP TABLE IF EXISTS `status_option`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `status_option` (
  `idx` smallint(5) unsigned NOT NULL auto_increment,
  `used4` varchar(20) NOT NULL,
  `typename` varchar(10) NOT NULL,
  `statustype` tinyint(3) unsigned NOT NULL,
  `statuscode` smallint(5) unsigned NOT NULL,
  `statusname` varchar(10) default NULL,
  `remark` varchar(100) default NULL,
  PRIMARY KEY  (`idx`),
  UNIQUE KEY `pk_tc_tablestatus` (`used4`,`statuscode`),
  KEY `statuscode` (`statuscode`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `status_option`
--

LOCK TABLES `status_option` WRITE;
/*!40000 ALTER TABLE `status_option` DISABLE KEYS */;
INSERT INTO `status_option` VALUES (1,'bottle','status',1,100,'采购待入库','未入库前的状态'),(2,'bottle','status',1,101,'采购入库',NULL),(3,'bottle','status',1,102,'领药出库',NULL),(4,'bottle','status',1,103,'领药上柜',NULL),(5,'bottle','status',1,104,'发药称重',NULL),(6,'bottle','status',1,105,'上药机',NULL),(7,'bottle','status',1,106,'下机称重',NULL),(8,'bottle','status',1,107,'发药回柜',NULL),(9,'bottle','status',1,108,'退药回库',NULL),(10,'bottle','status',1,109,'药瓶回收',NULL),(11,'medication','status',2,200,'处方录入',NULL),(12,'medication','status',2,201,'录入完成',NULL),(13,'medication','status',2,202,'已确认',NULL),(14,'medication','status',2,203,'核验失败',NULL),(15,'medication','status',2,204,'已核验',NULL),(16,'medication','status',2,205,'待发药',NULL),(17,'medication','status',2,206,'发药中',NULL),(18,'medication','status',2,207,'发药失败',NULL),(19,'medication','status',2,208,'发药完成',NULL),(20,'medication','status',2,209,'已交付',NULL),(21,'medication_detail','status',3,300,'录入',NULL),(22,'medication_detail','status',3,301,'待发药',NULL),(23,'medication_detail','status',3,302,'取药',NULL),(24,'medication_detail','status',3,303,'发药称重',NULL),(25,'medication_detail','status',3,304,'上药机',NULL),(26,'medication_detail','status',3,305,'发药中',NULL),(27,'medication_detail','status',3,306,'下机称重',NULL),(28,'medication_detail','status',3,307,'回柜',NULL),(29,'medication_detail','status',3,308,'发药失败',NULL),(30,'medication_detail','status',3,309,'发药成功',NULL),(31,'medication','type',4,40,'外用',NULL),(32,'medication','type',4,41,'口服',NULL);
/*!40000 ALTER TABLE `status_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stockbaseinfo`
--

DROP TABLE IF EXISTS `stockbaseinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `stockbaseinfo` (
  `stockid` int(11) NOT NULL auto_increment,
  `dispensaryid` int(11) default NULL,
  `stockno` varchar(5) default NULL COMMENT '药库码',
  `stockname` varchar(50) default NULL COMMENT '药库名',
  `guige` varchar(50) default NULL COMMENT '规格',
  `locations` varchar(50) default NULL COMMENT '位置',
  `memo` varchar(50) default NULL COMMENT '备注',
  `opera` int(11) default NULL COMMENT '操作员',
  `uptime` datetime default NULL COMMENT '时间',
  `delemp` int(11) default NULL COMMENT '删除人',
  `deltime` datetime default NULL COMMENT '删除时间',
  `status` tinyint(2) default NULL COMMENT '状态',
  PRIMARY KEY  (`stockid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC COMMENT='药房仓库基本信息';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `stockbaseinfo`
--

LOCK TABLES `stockbaseinfo` WRITE;
/*!40000 ALTER TABLE `stockbaseinfo` DISABLE KEYS */;
INSERT INTO `stockbaseinfo` VALUES (1,1,'1','CANGKUNO2','AA','3F','AA',1,'2021-05-08 00:00:00',0,'0000-00-00 00:00:00',1),(2,1,'2','CANGKUNO1','TT','2F','TT',0,'2021-05-08 00:00:00',0,'0000-00-00 00:00:00',127);
/*!40000 ALTER TABLE `stockbaseinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stocklocationinfo`
--

DROP TABLE IF EXISTS `stocklocationinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `stocklocationinfo` (
  `locationid` int(11) NOT NULL auto_increment,
  `stockid` int(11) NOT NULL,
  `stockno` varchar(5) default NULL COMMENT '仓库编号',
  `location_no` varchar(50) default NULL COMMENT '位置码',
  `location_name` varchar(50) default NULL COMMENT '位置名',
  `location_guige` varchar(50) default NULL COMMENT '位置规格',
  `location_status` varchar(2) default NULL COMMENT '位置状态',
  `memo` varchar(50) default NULL COMMENT '备注',
  `opera` int(11) default NULL COMMENT '操作员',
  `insert_time` datetime default NULL COMMENT '时间',
  `delemp` int(11) default NULL COMMENT '删除人',
  `deltime` datetime default NULL COMMENT '删除时间',
  PRIMARY KEY  (`locationid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='储位信息';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `stocklocationinfo`
--

LOCK TABLES `stocklocationinfo` WRITE;
/*!40000 ALTER TABLE `stocklocationinfo` DISABLE KEYS */;
INSERT INTO `stocklocationinfo` VALUES (1,1,'1','001','CHUWEI1','1','1','',0,'2021-05-08 00:00:00',0,'0000-00-00 00:00:00'),(2,1,'1','002','CHUWEI1','1','1','',0,'2021-05-08 00:00:00',0,'0000-00-00 00:00:00');
/*!40000 ALTER TABLE `stocklocationinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_role` (
  `role_id` int(11) NOT NULL auto_increment COMMENT '角色id',
  `role_name` varchar(50) default NULL COMMENT '角色名',
  `layout` varchar(50) default NULL COMMENT '菜单id',
  `insert_time` datetime default NULL COMMENT '操作时间',
  `insert_emp` int(11) default NULL,
  `opera` int(11) default NULL COMMENT '操作员',
  `del_opera` int(11) default NULL COMMENT '删除人',
  `del_time` datetime default NULL COMMENT '删除时间',
  PRIMARY KEY  (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='角色';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,'admin','layout/ucin/his/common.xml','2021-05-12 11:16:11',0,0,NULL,NULL);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL auto_increment,
  `user_name` varchar(30) default NULL COMMENT '用户名',
  `user_pass` varchar(50) default NULL COMMENT '密码',
  `user_role` tinyint(4) default NULL COMMENT '类型',
  `ap_name` varchar(30) default NULL COMMENT 'AP',
  `user_str` varchar(100) default NULL,
  `dept_info` smallint(6) default NULL COMMENT '部门',
  `memo` varchar(100) default NULL COMMENT '备注',
  `real_name` varchar(30) default NULL COMMENT '真实名字',
  PRIMARY KEY  (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='登录用户';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','e10adc3949ba59abbe56e057f20f883e',1,'','',0,'','张三');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xiefang_detail`
--

DROP TABLE IF EXISTS `xiefang_detail`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `xiefang_detail` (
  `xiefang_detailid` int(11) NOT NULL auto_increment,
  `xiefangid` int(11) default NULL COMMENT '协方号',
  `medicineid` int(11) default NULL,
  `medicinenopy` varchar(50) default NULL COMMENT '协方名拼音',
  `medicinenocn` varchar(50) default NULL COMMENT '协方名汉子',
  `medicine_pweight` int(10) default NULL COMMENT '参考剂量',
  `delemp` int(11) default NULL COMMENT '删除人',
  `deltime` datetime default NULL COMMENT '删除时间',
  `medicineno` varchar(50) default NULL COMMENT '药物编码',
  PRIMARY KEY  (`xiefang_detailid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='协方明细';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `xiefang_detail`
--

LOCK TABLES `xiefang_detail` WRITE;
/*!40000 ALTER TABLE `xiefang_detail` DISABLE KEYS */;
INSERT INTO `xiefang_detail` VALUES (1,1,1,'bb','百部',3,NULL,NULL,'H0201900'),(2,1,13,'aj','阿胶',5,NULL,NULL,'H0108200');
/*!40000 ALTER TABLE `xiefang_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xiefang_t`
--

DROP TABLE IF EXISTS `xiefang_t`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `xiefang_t` (
  `xiefangid` int(11) NOT NULL auto_increment,
  `xiefang_no` varchar(50) default NULL COMMENT '协方编号',
  `xiefang_name` varchar(50) default NULL COMMENT '协方名',
  `xiefang_forill` varchar(50) default NULL COMMENT '协方针对',
  `xiefang_jianyiji` int(10) default NULL COMMENT '协方建议剂次',
  `xiefang_chuchu` varchar(50) default NULL COMMENT '协方出处',
  `dept_category` tinyint(4) default NULL,
  `medication_type` tinyint(4) default NULL,
  `opera` int(11) default NULL COMMENT '操作员',
  `huanzhe_fallill_time` smallint(6) default NULL,
  `deltime` datetime default NULL COMMENT '删除时间',
  `delemp` int(20) default NULL COMMENT '删除人',
  `status` tinyint(2) default NULL COMMENT '状态',
  PRIMARY KEY  (`xiefangid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='协方';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `xiefang_t`
--

LOCK TABLES `xiefang_t` WRITE;
/*!40000 ALTER TABLE `xiefang_t` DISABLE KEYS */;
INSERT INTO `xiefang_t` VALUES (1,'4444444','5fasfa','sfasfa',0,'fasdfa',NULL,NULL,1,2021,NULL,NULL,NULL);
/*!40000 ALTER TABLE `xiefang_t` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'his'
--
DELIMITER ;;
/*!50003 DROP PROCEDURE IF EXISTS `PrepareMed` */;;
/*!50003 SET SESSION SQL_MODE=""*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`i3u`@`localhost`*/ /*!50003 PROCEDURE `PrepareMed`(medid INT,userid INT)
BEGIN
DECLARE dt DATE;
DECLARE i INT;
#IF cc!='' THEN
#IF dtStart IS NULL AND dtEnd IS NULL THEN
#SELECT calendar_start_date,calendar_end_date INTO dtStart,dtEnd FROM bom_calendars WHERE calendar_code=cc;
#END IF;
#IF dtStart IS NOT NULL AND dtEnd IS NOT NULL THEN
SET i=1;
#    SELECT SUBDATE(dtStart,DATE_FORMAT(dtStart,'%w')-7) INTO dt;
WHILE i<6 DO
INSERT INTO his.medi_trans 
(medicationid,medication_detailid,medicineid,bottleid,cabinetid,cabinet_cellid,equipmentid,equipment_posid,equipment_pos_degree,qtyapply,qtyrelease,weight1,weight2,STATUS,opera,uptime)
SELECT 	medicationid,medication_detailid,medicineid,bottleid,cabinetid,cellid,equipmentid,i,equipment_pos_degree,qtyapply,qtyrelease,weight1,weight2,301,userid,NOW() FROM mt_cc_b_m WHERE medicationid=medid and status=300 limit 0,1;
SET i = i+1;
END WHILE;
#END IF;
#END IF;
    END */;;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE*/;;
DELIMITER ;

--
-- Current Database: `his`
--

USE `his`;

--
-- Final view structure for view `md_mc_ctrl`
--

/*!50001 DROP TABLE `md_mc_ctrl`*/;
/*!50001 DROP VIEW IF EXISTS `md_mc_ctrl`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`i3u`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `md_mc_ctrl` AS (select `d`.`medicineid` AS `medicineid`,`d2`.`medicineid` AS `medicineid2`,`mct`.`relationtype` AS `relationtype`,`mc`.`controlid` AS `controlid`,`d`.`medication_detailid` AS `medication_detailid`,`d2`.`medication_detailid` AS `medication_detailid2`,`d`.`medicationid` AS `medicationid` from (((`medicine_control` `mc` join `medication_detail` `d` on((`d`.`medicineid` = `mc`.`medicineid`))) join `medication_detail` `d2` on(((`d2`.`medicineid` = `mc`.`medicine2id`) and (`d`.`medicationid` = `d2`.`medicationid`)))) left join `medicine_control_type` `mct` on((`mc`.`relation` = `mct`.`relationid`)))) */;

--
-- Final view structure for view `mt_cc_b_m`
--

/*!50001 DROP TABLE `mt_cc_b_m`*/;
/*!50001 DROP VIEW IF EXISTS `mt_cc_b_m`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`i3u`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mt_cc_b_m` AS (select `b`.`bottleno` AS `bottleno`,`m`.`medicineno` AS `medicineno`,`m`.`medicinenocn` AS `medicinenocn`,`m0`.`medicinenopy` AS `medicinenopy`,`m`.`jiliang` AS `jiliang`,`st`.`statusname` AS `statusname`,`c`.`cabinetname` AS `cabinetname`,concat(`cc`.`cell_row`,_utf8'-',`cc`.`cell_col`) AS `cell`,`e`.`equipmentname` AS `equipmentname`,`ep`.`pos_idx` AS `pos_idx`,ifnull(`mt`.`equipment_pos_degree`,if(isnull(`m0`.`density`),NULL,(`m`.`jiliang` / `m0`.`density`))) AS `equipment_pos_degree`,`mt`.`qtyapply` AS `qtyapply`,`mt`.`qtyrelease` AS `qtyrelease`,`mt`.`weight1` AS `weight1`,`mt`.`weight2` AS `weight2`,`cc`.`op_idx` AS `op_idx`,`cc`.`op_code` AS `op_code`,`m`.`price` AS `price`,`m`.`xiaoji` AS `xiaoji`,`m`.`medication_no` AS `medication_no`,`cp`.`computer_name` AS `computer_name`,ifnull(`mt`.`status`,`m`.`status`) AS `status`,`m`.`time1` AS `time1`,`e`.`equipmentid` AS `equipmentid`,`mt`.`equipment_posid` AS `equipment_posid`,concat(_utf8'devices/',`c`.`cabinetno`,_utf8'/light',`cc`.`op_idx`) AS `mqtt_light`,concat(_utf8'devices/',`e`.`equipmentno`,_utf8'/plc_pos',`ep`.`pos_idx`) AS `mqtt_pos`,concat(_utf8'devices/',`e`.`equipmentno`,_utf8'/ind_shangdai') AS `mqtt_ind_shangdai`,concat(_utf8'devices/',`e`.`equipmentno`,_utf8'/ind_fengdai') AS `mqtt_ind_fengdai`,concat(_utf8'devices/',`e`.`equipmentno`,_utf8'/ind_startstop') AS `mqtt_ind_startstop`,concat(_utf8'devices/',`e`.`equipmentno`,_utf8'/getweight') AS `mqtt_getweight`,concat(_utf8'devices/',`e`.`equipmentno`,_utf8'/return_finish') AS `mqtt_return_finish`,`mt`.`transid` AS `transid`,`cp`.`computerid` AS `computerid`,`c`.`cabinetid` AS `cabinetid`,`cc`.`cellid` AS `cellid`,`b`.`bottleid` AS `bottleid`,`m`.`medicineid` AS `medicineid`,`m`.`medication_detailid` AS `medication_detailid`,`m`.`medicationid` AS `medicationid` from ((((((((((`medication_detail` `m` left join `medicine_info` `m0` on((`m`.`medicineid` = `m0`.`medicineid`))) left join `bottle_loc_cabinet` `bc` on((`bc`.`medicineid` = `m0`.`medicineid`))) left join `cabinet_cell` `cc` on((`cc`.`cellid` = `bc`.`cellid`))) left join `cabinet` `c` on((`c`.`cabinetid` = `cc`.`cabinetid`))) left join `bottle_info` `b` on((`b`.`bottleid` = `bc`.`bottleid`))) left join `medi_trans` `mt` on((`mt`.`medication_detailid` = `m`.`medication_detailid`))) left join `status_option` `st` on((ifnull(`mt`.`status`,`m`.`status`) = `st`.`statuscode`))) left join `equipment` `e` on((`e`.`cabinetid` = `c`.`cabinetid`))) left join `equipment_pos` `ep` on((`ep`.`posid` = `mt`.`equipment_posid`))) left join `computers` `cp` on((`cp`.`computerid` = `e`.`computerid`)))) */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-28  6:08:15
