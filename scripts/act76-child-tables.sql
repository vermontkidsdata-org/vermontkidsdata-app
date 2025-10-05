-- DDL for Act 76 Child Demo Breakdown by County and AHS District SFY 23.xlsx

-- DDL for Age
-- Source worksheets: 'Age by County', 'Age by AHSD'
CREATE TABLE IF NOT EXISTS `data_act76_child_age` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `month` INT COMMENT 'Month (1-12)',
  `year` INT COMMENT 'Year (e.g., 2023)',
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `age` VARCHAR(100) COMMENT 'Category value (e.g., infant, white, hispanic)',
  `value` DOUBLE COMMENT 'The actual count/number',
  `value_suppressed` DOUBLE COMMENT 'Suppressed version of the value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`, `age`),
  INDEX `idx_month_year` (`year`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Citizenship
-- Source worksheets: 'Citizenship by County', 'Citizenship by AHSD'
CREATE TABLE IF NOT EXISTS `data_act76_child_citizenship` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `month` INT COMMENT 'Month (1-12)',
  `year` INT COMMENT 'Year (e.g., 2023)',
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `citizenship` VARCHAR(100) COMMENT 'Category value (e.g., infant, white, hispanic)',
  `value` DOUBLE COMMENT 'The actual count/number',
  `value_suppressed` DOUBLE COMMENT 'Suppressed version of the value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`, `citizenship`),
  INDEX `idx_month_year` (`year`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Ethnicity
-- Source worksheets: 'Ethnicity by County', 'Ethnicity by AHSD'
CREATE TABLE IF NOT EXISTS `data_act76_child_ethnicity` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `month` INT COMMENT 'Month (1-12)',
  `year` INT COMMENT 'Year (e.g., 2023)',
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `ethnicity` VARCHAR(100) COMMENT 'Category value (e.g., infant, white, hispanic)',
  `value` DOUBLE COMMENT 'The actual count/number',
  `value_suppressed` DOUBLE COMMENT 'Suppressed version of the value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`, `ethnicity`),
  INDEX `idx_month_year` (`year`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Gender
-- Source worksheets: 'Gender by County', 'Gender by AHSD'
CREATE TABLE IF NOT EXISTS `data_act76_child_gender` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `month` INT COMMENT 'Month (1-12)',
  `year` INT COMMENT 'Year (e.g., 2023)',
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `gender` VARCHAR(100) COMMENT 'Category value (e.g., infant, white, hispanic)',
  `value` DOUBLE COMMENT 'The actual count/number',
  `value_suppressed` DOUBLE COMMENT 'Suppressed version of the value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`, `gender`),
  INDEX `idx_month_year` (`year`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Race
-- Source worksheets: 'Race by County', 'Race by AHSD'
CREATE TABLE IF NOT EXISTS `data_act76_child_race` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `month` INT COMMENT 'Month (1-12)',
  `year` INT COMMENT 'Year (e.g., 2023)',
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `race` VARCHAR(100) COMMENT 'Category value (e.g., infant, white, hispanic)',
  `value` DOUBLE COMMENT 'The actual count/number',
  `value_suppressed` DOUBLE COMMENT 'Suppressed version of the value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`, `race`),
  INDEX `idx_month_year` (`year`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

