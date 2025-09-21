-- DDL for Act 76 Family Demo Breakdown by County and AHS District SFY 23.xlsx

-- DDL for Family Size
-- Source worksheets: 'Family Size by County', 'Family Size by AHSD'
CREATE TABLE IF NOT EXISTS `data_act76_family_family_size` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `value_five` DOUBLE COMMENT 'Five',
  `value_four` DOUBLE COMMENT 'Four',
  `value_six_or_more` DOUBLE COMMENT 'Six or More',
  `value_three_or_less` DOUBLE COMMENT 'Three or Less',
  `value_total` DOUBLE COMMENT 'Optional total column',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for % of FPL
-- Source worksheets: '% of FPL by County', '% of FPL by AHSD'
CREATE TABLE IF NOT EXISTS `data_act76_family_pct_of_fpl` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `value_1_5` DOUBLE COMMENT '1.5',
  `value_1_75` DOUBLE COMMENT '1.75',
  `value_2` DOUBLE COMMENT '2',
  `value_2_25` DOUBLE COMMENT '2.25',
  `value_2_5` DOUBLE COMMENT '2.5',
  `value_2_75` DOUBLE COMMENT '2.75',
  `value_3` DOUBLE COMMENT '3',
  `value_3_25` DOUBLE COMMENT '3.25',
  `value_3_5` DOUBLE COMMENT '3.5',
  `value_income_exempt_exceeding_guidelines` DOUBLE COMMENT 'Income-Exempt Exceeding Guidelines',
  `value_total` DOUBLE COMMENT 'Optional total column',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Service Need
-- Source worksheets: 'Service Need by County', 'Service Need by AHSD'
CREATE TABLE IF NOT EXISTS `data_act76_family_service_need` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `value_attending_school_or_training` DOUBLE COMMENT 'Attending school or training',
  `value_child_with_special_health_needs` DOUBLE COMMENT 'Child with special health needs',
  `value_family_support` DOUBLE COMMENT 'Family Support',
  `value_looking_for_work` DOUBLE COMMENT 'Looking for work',
  `value_medically_unable` DOUBLE COMMENT 'Medically unable',
  `value_reach_up` DOUBLE COMMENT 'Reach up',
  `value_self_employed` DOUBLE COMMENT 'Self employed',
  `value_working` DOUBLE COMMENT 'Working',
  `value_total` DOUBLE COMMENT 'Optional total column',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

