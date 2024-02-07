-- iep
CREATE TABLE `data_iep` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year_type` enum (
    'School Year'
  ) NOT NULL,
  `year` INT NOT NULL,
  `age` VARCHAR(32) NOT NULL,
  `category` enum (
    'IEP'
  ) NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year_type` ASC,
    `year` ASC,
    `age` ASC,
    `category` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:iep',
    'data_iep',
    'geo_type,geography,year_type,year,age,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'regulatedchildcare:chart',
    'SELECT concat(`year`,"-",`year`+1) as `cat`, SUBSTRING_INDEX(category, " ", 1) as `label`, sum(value) as `value` FROM data_regulatedchildcare group by geo_type, geography, `year`, label order by `year`, FIELD(`label`,"Infants","Toddlers","Preschoolers")',
    'general:regulatedchildcare',
    '{"yAxis": {"type": "number"}}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'iep:chart',
    'SELECT concat(`year`,"-",`year`+1) as `cat`, SUBSTRING_INDEX(category, " ", 1) as `label`, `value` FROM data_iep where age="3 to 8" group by geo_type, geography, year_type, `year`, label order by `year`',
    'general:iep',
    '{"yAxis": {"type": "number"}}'
  );

-- adverse_experiences_under_18
CREATE TABLE `data_adverse_experiences_under_18` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` VARCHAR(32) NOT NULL,
  `category` enum (
    '0 ACEs',
    '1 ACE',
    '2 or more ACEs'
  ) NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC,
    `category` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:adverse_experiences_under_18',
    'data_adverse_experiences_under_18',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'adverse_experiences_under_18:chart',
    'SELECT `geography` as label, `year` as cat, `value`*100 as value FROM `data_adverse_experiences_under_18` where `category`="2 or more ACEs" order by `year`, `category`, `geography`',
    'general:adverse_experiences_under_18',
    '{"yAxis": {"type": "percent"}}'
  );

-- elevated_blood_lead_levels_by_cat
CREATE TABLE `data_elevated_blood_lead_levels_by_cat` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    '1 year olds screened', 
    '1 year olds with undetectable levels', 
    '1 year olds with elevated blood lead levels', 
    '1 year olds with <5µg/dl', -- pre-2022
    '2 year olds screened', 
    '2 year olds with undetectable levels', 
    '2 year olds with elevated blood lead levels',
    '2 year olds with <5µg/dl' -- pre-2022
  ) NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC,
    `category` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:elevated_blood_lead_levels_by_cat',
    'data_elevated_blood_lead_levels_by_cat',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'elevated_blood_lead_levels_by_cat:chart',
    'SELECT case when `category`="1 year olds with <5µg/dl" then "1 year olds with undetectable levels" when `category`="2 year olds with <5µg/dl" then "2 year olds with undetectable levels" else `category` end as label, `year` as cat, `value`*100 as value FROM `data_elevated_blood_lead_levels_by_cat` where `category` in ("1 year olds with elevated blood lead levels", "2 year olds with elevated blood lead levels") order by `year`, `category`, `geography`',
    'general:elevated_blood_lead_levels_by_cat',
    '{"yAxis": {"type": "percent"}}'
  );

-- children_in_poverty_under_12
CREATE TABLE `data_children_in_poverty_under_12` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:children_in_poverty_under_12',
    'data_children_in_poverty_under_12',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_in_poverty_under_12:chart',
    'SELECT `geography` as label, `year` as cat, `percent`*100 as value FROM `data_children_in_poverty_under_12` where `geo_type`="State" order by `year`, `geography`',
    'general:children_in_poverty_under_12',
    '{"yAxis": {"type": "percent"}}'
  );

-- third_grade_sbac
CREATE TABLE `data_third_grade_sbac` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `category` enum (
    'English All Students',
    'English Historically Advantaged',
    'English Historically Marginalized',
    'English Total Proficient and Above',
    'Math All Students',
    'Math Historically Advantaged',
    'Math Historically Marginalized',
    'Math Total Proficient and Above'
  ) NOT NULL,
  `year` INT NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC,
    `category` ASC
  ) VISIBLE
);
