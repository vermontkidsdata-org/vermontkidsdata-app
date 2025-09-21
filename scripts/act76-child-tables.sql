-- DDL for Act 76 Child Demo Breakdown by County and AHS District SFY 23.xlsx

-- DDL for Age
CREATE TABLE IF NOT EXISTS `data_act76_child_age` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `value_infant` DOUBLE,
  `value_preschool` DOUBLE,
  `value_school` DOUBLE,
  `value_toddler` DOUBLE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Citizenship
CREATE TABLE IF NOT EXISTS `data_act76_child_citizenship` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `value_none_of_the_above` DOUBLE,
  `value_qualified_immigrant` DOUBLE,
  `value_us_citizen` DOUBLE,
  `value_unreported` DOUBLE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Ethnicity
CREATE TABLE IF NOT EXISTS `data_act76_child_ethnicity` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `value_hispanic` DOUBLE,
  `value_native_american` DOUBLE,
  `value_non_hispanic` DOUBLE,
  `value_unknown` DOUBLE,
  `value_unreported` DOUBLE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Gender
CREATE TABLE IF NOT EXISTS `data_act76_child_gender` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `value_female` DOUBLE,
  `value_male` DOUBLE,
  `value_non_binary` DOUBLE,
  `value_prefer_not_to_answer` DOUBLE,
  `value_prefer_to_self_describe` DOUBLE,
  `value_unknown` DOUBLE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DDL for Race
CREATE TABLE IF NOT EXISTS `data_act76_child_race` (
  `id` INT AUTO_INCREMENT,
  `month_year` VARCHAR(255),
  `geo_type` VARCHAR(50),
  `geography` VARCHAR(255),
  `value_american_indian_or_alaskan_native` DOUBLE,
  `value_asian` DOUBLE,
  `value_black_or_african_american` DOUBLE,
  `value_native_hawaiian_or_pacific_islander` DOUBLE,
  `value_prefer_not_to_answer` DOUBLE,
  `value_prefer_to_self_describe` DOUBLE,
  `value_two_or_more_races` DOUBLE,
  `value_unreported` DOUBLE,
  `value_white` DOUBLE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`month_year`, `geo_type`, `geography`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

