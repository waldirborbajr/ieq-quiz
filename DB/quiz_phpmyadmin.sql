-- phpMyAdmin SQL Dump
-- version 2.11.6
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tempo de Geração: Set 25, 2008 as 11:48 PM
-- Versão do Servidor: 5.0.51
-- Versão do PHP: 5.2.6

SET FOREIGN_KEY_CHECKS=0;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Banco de Dados: `quiz`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `wquiz_answer`
--

DROP TABLE IF EXISTS `wquiz_answer`;
CREATE TABLE IF NOT EXISTS `wquiz_answer` (
  `id_answer` int(11) NOT NULL auto_increment,
  `id_question` int(11) default NULL,
  `answer` varchar(80) default NULL,
  `correct` char(1) default NULL,
  PRIMARY KEY  (`id_answer`),
  KEY `id_question` (`id_question`)
) TYPE=InnoDB  AUTO_INCREMENT=16 ;

--
-- Extraindo dados da tabela `wquiz_answer`
--

INSERT INTO `wquiz_answer` (`id_answer`, `id_question`, `answer`, `correct`) VALUES
(1, 1, 'resp1.1121212', '0'),
(2, 1, 'resp1.2', '0'),
(3, 1, 'resp1.3', '1'),
(4, 1, 'resp1.4', '0'),
(5, 1, 'resp1.5', '0'),
(6, 2, 'resp2.1', '1'),
(7, 2, 'resp2.2', '0'),
(8, 2, 'resp2.3', '1'),
(9, 2, 'resp2.4', '0'),
(10, 2, 'resp2.5', '0'),
(11, 3, 'resp3.1', '0'),
(12, 3, 'resp3.2', '0'),
(13, 3, 'resp3.3', '0'),
(14, 3, 'resp3.4', '1'),
(15, 3, 'resp3.5', '1');

-- --------------------------------------------------------

--
-- Estrutura da tabela `wquiz_person`
--

DROP TABLE IF EXISTS `wquiz_person`;
CREATE TABLE IF NOT EXISTS `wquiz_person` (
  `id_person` int(11) NOT NULL auto_increment,
  `name` varchar(80) default NULL,
  `email` varchar(80) default NULL,
  `phone` varchar(20) default NULL,
  `password` varchar(80) default NULL,
  PRIMARY KEY  (`id_person`)
) TYPE=InnoDB  AUTO_INCREMENT=22 ;

--
-- Extraindo dados da tabela `wquiz_person`
--

INSERT INTO `wquiz_person` (`id_person`, `name`, `email`, `phone`, `password`) VALUES
(4, 'e', 'e', 'e', 'ZQ=='),
(5, 'a', 'a', 'a', 'YQ=='),
(19, 'teste', 'aurelio@forbellone.com', '9664-1621', 'dGVzdGU='),
(20, 'Ronaldo Ribeiro', 'rrzero@bol.com.br', '32064131', 'Y2h1Y2tuaWdodDU2'),
(21, 'Waldir Borba Junior', 'wborbajr@gmail.com', '41 999772146', 'QHNlbmhh');

-- --------------------------------------------------------

--
-- Estrutura da tabela `wquiz_person_answers`
--

DROP TABLE IF EXISTS `wquiz_person_answers`;
CREATE TABLE IF NOT EXISTS `wquiz_person_answers` (
  `id_person_answer` int(10) unsigned NOT NULL auto_increment,
  `id_question` int(10) unsigned default NULL,
  `id_answer` int(10) unsigned default NULL,
  `laptime` time default NULL,
  `id_quiz` int(10) unsigned default NULL,
  `id_person` int(10) unsigned default NULL,
  PRIMARY KEY  (`id_person_answer`)
) TYPE=InnoDB  AUTO_INCREMENT=37 ;

--
-- Extraindo dados da tabela `wquiz_person_answers`
--

INSERT INTO `wquiz_person_answers` (`id_person_answer`, `id_question`, `id_answer`, `laptime`, `id_quiz`, `id_person`) VALUES
(34, 2, 8, '00:00:02', 1, 5),
(35, 3, 14, '00:00:01', 1, 5),
(36, 1, 1, '00:00:01', 1, 5);

-- --------------------------------------------------------

--
-- Estrutura da tabela `wquiz_person_quiz`
--

DROP TABLE IF EXISTS `wquiz_person_quiz`;
CREATE TABLE IF NOT EXISTS `wquiz_person_quiz` (
  `id_person_quiz` int(11) NOT NULL auto_increment,
  `id_quiz` int(11) default NULL,
  `id_person` int(11) default NULL,
  `points` int(11) default NULL,
  `totaltime` time default NULL,
  `date` datetime default NULL,
  PRIMARY KEY  (`id_person_quiz`),
  KEY `id_person` (`id_person`),
  KEY `id_quiz` (`id_quiz`)
) TYPE=InnoDB  AUTO_INCREMENT=21 ;

--
-- Extraindo dados da tabela `wquiz_person_quiz`
--

INSERT INTO `wquiz_person_quiz` (`id_person_quiz`, `id_quiz`, `id_person`, `points`, `totaltime`, `date`) VALUES
(17, 1, 5, 2, '00:00:04', '2008-09-25 23:09:09'),
(18, 1, 4, 3, '00:00:20', NULL),
(19, 1, 19, 3, '00:00:04', NULL),
(20, 1, 21, 4, '00:00:04', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `wquiz_question`
--

DROP TABLE IF EXISTS `wquiz_question`;
CREATE TABLE IF NOT EXISTS `wquiz_question` (
  `id_question` int(11) NOT NULL auto_increment,
  `question` varchar(80) default NULL,
  `id_quiz` int(11) default NULL,
  PRIMARY KEY  (`id_question`),
  KEY `id_quiz` (`id_quiz`)
) TYPE=InnoDB  AUTO_INCREMENT=4 ;

--
-- Extraindo dados da tabela `wquiz_question`
--

INSERT INTO `wquiz_question` (`id_question`, `question`, `id_quiz`) VALUES
(1, 'Pergunta 1111', 1),
(2, 'Pergunta 2', 1),
(3, 'Pergunta 3', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `wquiz_quiz`
--

DROP TABLE IF EXISTS `wquiz_quiz`;
CREATE TABLE IF NOT EXISTS `wquiz_quiz` (
  `id_quiz` int(11) NOT NULL auto_increment,
  `description` varchar(80) default NULL,
  `ativo` char(1) NOT NULL,
  PRIMARY KEY  (`id_quiz`)
) TYPE=InnoDB  AUTO_INCREMENT=4 ;

--
-- Extraindo dados da tabela `wquiz_quiz`
--

INSERT INTO `wquiz_quiz` (`id_quiz`, `description`, `ativo`) VALUES
(1, 'QUIZ', '1'),
(2, 'TESTE', '0'),
(3, 'NOVO QUIZ', '0');

--
-- Restrições para as tabelas dumpadas
--

--
-- Restrições para a tabela `wquiz_answer`
--
ALTER TABLE `wquiz_answer`
  ADD CONSTRAINT `fk_question_answer` FOREIGN KEY (`id_question`) REFERENCES `wquiz_question` (`id_question`) ON DELETE CASCADE;

--
-- Restrições para a tabela `wquiz_person_quiz`
--
ALTER TABLE `wquiz_person_quiz`
  ADD CONSTRAINT `fk_person_person_quiz` FOREIGN KEY (`id_person`) REFERENCES `wquiz_person` (`id_person`),
  ADD CONSTRAINT `fk_quiz_person_quiz` FOREIGN KEY (`id_quiz`) REFERENCES `wquiz_quiz` (`id_quiz`);

--
-- Restrições para a tabela `wquiz_question`
--
ALTER TABLE `wquiz_question`
  ADD CONSTRAINT `fk_quiz_question` FOREIGN KEY (`id_quiz`) REFERENCES `wquiz_quiz` (`id_quiz`) ON DELETE CASCADE;

SET FOREIGN_KEY_CHECKS=1;
