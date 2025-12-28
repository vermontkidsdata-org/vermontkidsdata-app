-- DDL for family-fy23-fy25.xlsx

-- DDL for % of FPL
-- Source worksheets: '% of FPL by County', '% of FPL by AHSD'
DROP TABLE IF EXISTS `data_act76_family_pct_of_fpl`;
CREATE TABLE `data_act76_family_pct_of_fpl` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `month` INT COMMENT 'Month (1-12)',
  `year` INT COMMENT 'Year (e.g., 2023)',
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `pct_of_fpl` VARCHAR(100) COMMENT 'Category value (e.g., infant, white, hispanic)',
  `value` DOUBLE COMMENT 'The actual count/number',
  `value_suppressed` DOUBLE COMMENT 'Suppressed version of the value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`, `pct_of_fpl`),
  INDEX `idx_month_year` (`year`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Service Need
-- Source worksheets: 'Service Need by County', 'Service Need by AHSD'
DROP TABLE IF EXISTS `data_act76_family_service_need`;
CREATE TABLE `data_act76_family_service_need` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `month` INT COMMENT 'Month (1-12)',
  `year` INT COMMENT 'Year (e.g., 2023)',
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `service_need` VARCHAR(100) COMMENT 'Category value (e.g., infant, white, hispanic)',
  `value` DOUBLE COMMENT 'The actual count/number',
  `value_suppressed` DOUBLE COMMENT 'Suppressed version of the value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`, `service_need`),
  INDEX `idx_month_year` (`year`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Total by <geography type>
-- Source worksheets: 'Total by County', 'Total by AHSD'
DROP TABLE IF EXISTS `data_act76_family_total`;
CREATE TABLE `data_act76_family_total` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `month` INT COMMENT 'Month (1-12)',
  `year` INT COMMENT 'Year (e.g., 2023)',
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `total` DOUBLE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`),
  INDEX `idx_month_year_geo` (`month`, `year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

