-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 16, 2025 alle 00:40
-- Versione del server: 10.4.32-MariaDB
-- Versione PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fortnet`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `like_post`
--

CREATE TABLE `like_post` (
  `id_user` int(11) NOT NULL,
  `id_post` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `like_post`
--

INSERT INTO `like_post` (`id_user`, `id_post`) VALUES
(1, 1),
(1, 2),
(1, 10),
(10, 10),
(11, 10);

-- --------------------------------------------------------

--
-- Struttura della tabella `post`
--

CREATE TABLE `post` (
  `id_post` int(11) NOT NULL,
  `title` varchar(30) NOT NULL DEFAULT 'Insert title here',
  `body` varchar(255) NOT NULL DEFAULT 'Insert body here'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `post`
--

INSERT INTO `post` (`id_post`, `title`, `body`) VALUES
(1, 'new web', 'service'),
(2, 'season 2 cap 3', 'bananita announcement'),
(10, 'fortnite new network', 'introducing fortnite new network: fortnet!');

-- --------------------------------------------------------

--
-- Struttura della tabella `utenti`
--

CREATE TABLE `utenti` (
  `id_user` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `password` varchar(255) NOT NULL,
  `token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `utenti`
--

INSERT INTO `utenti` (`id_user`, `username`, `password`, `token`) VALUES
(1, 'gappero', 'perogap', '$2y$10$4nsmpAVtwGKy12wPIYZP.uBc7agxo.9Z1q9Gs6K3OdNq6C9NRQGQO'),
(2, 'mongols', 'fire', NULL),
(10, 'pargo', 'letto', NULL),
(11, 'mango', 'losco', NULL),
(13, 'skiski', 'toilet', NULL),
(14, 'dop dop', 'yes yes', NULL);

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `like_post`
--
ALTER TABLE `like_post`
  ADD PRIMARY KEY (`id_user`,`id_post`),
  ADD KEY `FKPost_Costraints` (`id_post`);

--
-- Indici per le tabelle `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id_post`);

--
-- Indici per le tabelle `utenti`
--
ALTER TABLE `utenti`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `post`
--
ALTER TABLE `post`
  MODIFY `id_post` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT per la tabella `utenti`
--
ALTER TABLE `utenti`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `like_post`
--
ALTER TABLE `like_post`
  ADD CONSTRAINT `FKPost_Costraints` FOREIGN KEY (`id_post`) REFERENCES `post` (`id_post`),
  ADD CONSTRAINT `FKUser_Costraints` FOREIGN KEY (`id_user`) REFERENCES `utenti` (`id_user`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;