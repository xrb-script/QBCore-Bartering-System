-- --------------------------------------------------------
--
-- Struktura e Tabeles per `player_bartering_points` (QBCore)
--
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `player_bartering_points` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL UNIQUE COMMENT 'QBCore Player Citizen ID',
  `points` INT(11) NOT NULL DEFAULT 0 COMMENT 'Bartering Points',
  `cancel_streak` INT(11) NOT NULL DEFAULT 0 COMMENT 'Consecutive Contract Cancel Streak',
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid_unique` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- Struktura e Tabeles per `bartering_system_state` (QBCore)
--
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `bartering_system_state` (
  `state_key` VARCHAR(50) NOT NULL COMMENT 'Identifier for system state (e.g., current_location_index)',
  `state_value` VARCHAR(255) NOT NULL COMMENT 'Value of the system state',
  PRIMARY KEY (`state_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- Vendosja e Vlerave Fillestare (QBCore)
--
-- --------------------------------------------------------
INSERT IGNORE INTO `bartering_system_state` (`state_key`, `state_value`) VALUES
	('current_location_index', '1'),
	('contracts_at_location', '0');