# HeidiSQL Dump 
#
# --------------------------------------------------------
# Host:                 127.0.0.1
# Database:             quiz
# Server version:       5.0.51b-community-nt
# Server OS:            Win32
# Target-Compatibility: MySQL 3.23
# max_allowed_packet:   1048576
# HeidiSQL version:     3.2 Revision: 1129
# --------------------------------------------------------

/*!40100 SET CHARACTER SET latin1*/;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0*/;


#
# Table structure for table 'wquiz_answer'
#

CREATE TABLE /*!32312 IF NOT EXISTS*/ `wquiz_answer` (
  `id_answer` int(11) NOT NULL auto_increment,
  `id_question` int(11) default NULL,
  `answer` varchar(80) default NULL,
  `correct` char(1) default NULL,
  PRIMARY KEY  (`id_answer`),
  KEY `id_question` (`id_question`),
  CONSTRAINT `fk_question_answer` FOREIGN KEY (`id_question`) REFERENCES `wquiz_question` (`id_question`) ON DELETE CASCADE
) TYPE=InnoDB AUTO_INCREMENT=19 /*!40100 DEFAULT CHARSET=latin1*/;



#
# Dumping data for table 'wquiz_answer'
#

LOCK TABLES `wquiz_answer` WRITE;
/*!40000 ALTER TABLE `wquiz_answer` DISABLE KEYS*/;
REPLACE INTO `wquiz_answer` (`id_answer`, `id_question`, `answer`, `correct`) VALUES
	(1,1,'resp1.1121212','0'),
	(2,1,'resp1.2','0'),
	(3,1,'resp1.3','1'),
	(4,1,'resp1.4','0'),
	(5,1,'resp1.5','0'),
	(6,2,'resp2.1','1'),
	(7,2,'resp2.2','0'),
	(8,2,'resp2.3','1'),
	(9,2,'resp2.4','0'),
	(10,2,'resp2.5','0'),
	(11,3,'resp3.1','0'),
	(12,3,'resp3.2','0'),
	(13,3,'resp3.3','0'),
	(14,3,'resp3.4','1'),
	(15,3,'resp3.5','1'),
	(16,4,'my_quiz_is_beautiful',NULL),
	(17,4,'RES01',NULL),
	(18,4,'RES03','1');
/*!40000 ALTER TABLE `wquiz_answer` ENABLE KEYS*/;
UNLOCK TABLES;


#
# Table structure for table 'wquiz_person'
#

CREATE TABLE /*!32312 IF NOT EXISTS*/ `wquiz_person` (
  `id_person` int(11) NOT NULL auto_increment,
  `name` varchar(80) default NULL,
  `email` varchar(80) default NULL,
  `phone` varchar(20) default NULL,
  `password` varchar(80) default NULL,
  PRIMARY KEY  (`id_person`)
) TYPE=InnoDB AUTO_INCREMENT=23 /*!40100 DEFAULT CHARSET=latin1*/;



#
# Dumping data for table 'wquiz_person'
#

LOCK TABLES `wquiz_person` WRITE;
/*!40000 ALTER TABLE `wquiz_person` DISABLE KEYS*/;
REPLACE INTO `wquiz_person` (`id_person`, `name`, `email`, `phone`, `password`) VALUES
	(4,'e','e','e','ZQ=='),
	(5,'a','a','a','YQ=='),
	(19,'teste','aurelio@forbellone.com','9664-1621','dGVzdGU='),
	(20,'Ronaldo Ribeiro','rrzero@bol.com.br','32064131','Y2h1Y2tuaWdodDU2'),
	(21,'Waldir Borba Junior','wborbajr@gmail.com','41 999772146','QHNlbmhh'),
	(22,'j','j','j','ag==');
/*!40000 ALTER TABLE `wquiz_person` ENABLE KEYS*/;
UNLOCK TABLES;


#
# Table structure for table 'wquiz_person_answers'
#

CREATE TABLE /*!32312 IF NOT EXISTS*/ `wquiz_person_answers` (
  `id_person_answer` int(10) unsigned NOT NULL auto_increment,
  `id_question` int(10) unsigned default NULL,
  `id_answer` int(10) unsigned default NULL,
  `laptime` time default NULL,
  `id_quiz` int(10) unsigned default NULL,
  `id_person` int(10) unsigned default NULL,
  PRIMARY KEY  (`id_person_answer`)
) TYPE=InnoDB AUTO_INCREMENT=37 /*!40100 DEFAULT CHARSET=latin1*/;



#
# Dumping data for table 'wquiz_person_answers'
#

# (No data found.)



#
# Table structure for table 'wquiz_person_quiz'
#

CREATE TABLE /*!32312 IF NOT EXISTS*/ `wquiz_person_quiz` (
  `id_person_quiz` int(11) NOT NULL auto_increment,
  `id_quiz` int(11) default NULL,
  `id_person` int(11) default NULL,
  `points` int(11) default NULL,
  `totaltime` time default NULL,
  `date` datetime default NULL,
  PRIMARY KEY  (`id_person_quiz`),
  KEY `id_person` (`id_person`),
  KEY `id_quiz` (`id_quiz`),
  CONSTRAINT `fk_person_person_quiz` FOREIGN KEY (`id_person`) REFERENCES `wquiz_person` (`id_person`),
  CONSTRAINT `fk_quiz_person_quiz` FOREIGN KEY (`id_quiz`) REFERENCES `wquiz_quiz` (`id_quiz`)
) TYPE=InnoDB AUTO_INCREMENT=21 /*!40100 DEFAULT CHARSET=latin1*/;



#
# Dumping data for table 'wquiz_person_quiz'
#

# (No data found.)



#
# Table structure for table 'wquiz_question'
#

CREATE TABLE /*!32312 IF NOT EXISTS*/ `wquiz_question` (
  `id_question` int(11) NOT NULL auto_increment,
  `question` varchar(80) default NULL,
  `id_quiz` int(11) default NULL,
  PRIMARY KEY  (`id_question`),
  KEY `id_quiz` (`id_quiz`),
  CONSTRAINT `fk_quiz_question` FOREIGN KEY (`id_quiz`) REFERENCES `wquiz_quiz` (`id_quiz`) ON DELETE CASCADE
) TYPE=InnoDB AUTO_INCREMENT=8 /*!40100 DEFAULT CHARSET=latin1*/;



#
# Dumping data for table 'wquiz_question'
#

LOCK TABLES `wquiz_question` WRITE;
/*!40000 ALTER TABLE `wquiz_question` DISABLE KEYS*/;
REPLACE INTO `wquiz_question` (`id_question`, `question`, `id_quiz`) VALUES
	(1,'Pergunta 1111',1),
	(2,'Pergunta 2',1),
	(3,'Pergunta 3',1),
	(4,'pergunta 001',5),
	(5,'Pergunta 002',5),
	(6,'Pergunta 003',5),
	(7,'PERGU',5);
/*!40000 ALTER TABLE `wquiz_question` ENABLE KEYS*/;
UNLOCK TABLES;


#
# Table structure for table 'wquiz_quiz'
#

CREATE TABLE /*!32312 IF NOT EXISTS*/ `wquiz_quiz` (
  `id_quiz` int(11) NOT NULL auto_increment,
  `description` varchar(80) default NULL,
  `ativo` char(1) NOT NULL,
  PRIMARY KEY  (`id_quiz`)
) TYPE=InnoDB AUTO_INCREMENT=6 /*!40100 DEFAULT CHARSET=latin1*/;



#
# Dumping data for table 'wquiz_quiz'
#

LOCK TABLES `wquiz_quiz` WRITE;
/*!40000 ALTER TABLE `wquiz_quiz` DISABLE KEYS*/;
REPLACE INTO `wquiz_quiz` (`id_quiz`, `description`, `ativo`) VALUES
	(1,'QUIZ','1'),
	(2,'TESTE','0'),
	(3,'NOVO QUIZ','0'),
	(4,'my_quiz_is_beautiful','1'),
	(5,'my new quiz','1');
/*!40000 ALTER TABLE `wquiz_quiz` ENABLE KEYS*/;
UNLOCK TABLES;


#
# Table structure for table 'wquiz_rules'
#

CREATE TABLE /*!32312 IF NOT EXISTS*/ `wquiz_rules` (
  `id_rule` tinyint(3) unsigned NOT NULL auto_increment,
  `rule_description` text,
  PRIMARY KEY  (`id_rule`),
  KEY `id_rule` (`id_rule`)
) TYPE=InnoDB AUTO_INCREMENT=2 /*!40100 DEFAULT CHARSET=latin1*/;



#
# Dumping data for table 'wquiz_rules'
#

LOCK TABLES `wquiz_rules` WRITE;
/*!40000 ALTER TABLE `wquiz_rules` DISABLE KEYS*/;
REPLACE INTO `wquiz_rules` (`id_rule`, `rule_description`) VALUES
	(1,'caasda das asda sdasda\rOlha aqui tem um regulamento tal qual sei la....');
/*!40000 ALTER TABLE `wquiz_rules` ENABLE KEYS*/;
UNLOCK TABLES;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS*/;
