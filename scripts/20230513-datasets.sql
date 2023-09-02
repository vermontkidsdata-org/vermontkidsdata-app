CREATE TABLE `data_families_no_05_care` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` VARCHAR(32) NOT NULL,
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
    'general:families_no_05_care',
    'data_families_no_05_care',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'families_no_05_care:table',
    'SELECT * FROM `data_families_no_05_care` order by `year`',
    'general:families_no_05_care',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'families_no_05_care:chart',
    'SELECT `category` as cat, `year` as label, `value`*100 as `value` FROM `data_families_no_05_care` where geo_type="State" and geography="Vermont" order by `year`',
    'general:families_no_05_care',
    '{"yAxis": {"type": "percent"}}'
  );
  
--    '{"yAxis": {"type": "number", "title": "", "labels": {"format": "{value:0.2f}"}}, "colors": ["#007155", "#3b886e", "#60a088", "#84b8a3", "#a7d0bf", "#cae9dc"], "tooltip": "'Percent <b>' + this.x +'</b>: <b>' + this.y + '</b>'", "plotOptions": {"series": {"dataLabels": {"format": "{point.y:0.2f}"}}}}'

CREATE TABLE `data_poverty_under_12` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `county` enum (
    'Addison',
    'Bennington',
    'Caledonia and Southern Essex',
    'Central Vermont',
    'Chittenden',
    'Franklin Grand Isle',
    'Lamoille Valley',
    'Northern Windsor and Orange',
    'Orleans and Northern Essex',
    'Rutland',
    'Southeast Vermont',
    'Springfield',
    'Vermont'
  ) NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
  `value` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC,
    `county` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:poverty_under_12',
    'data_poverty_under_12',
    'geo_type,geography,year,county'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'poverty_under_12:table',
    'SELECT * FROM `data_poverty_under_12` order by `year`',
    'general:poverty_under_12',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'poverty_under_12:chart',
    'SELECT `county` as cat, `year` as label, `percent`*100 as `value` FROM `data_poverty_under_12` where county="Vermont" order by `year`',
    'general:poverty_under_12',
    '{"yAxis": {"type": "percent"}}'
  );

-- households_30pct_housing

CREATE TABLE `data_households_30pct_housing` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Rent',
    'Mortage'
  ) NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:households_30pct_housing',
    'data_households_30pct_housing',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'households_30pct_housing:table',
    'SELECT * FROM `data_households_30pct_housing` order by `year`',
    'general:households_30pct_housing',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'households_30pct_housing:chart',
    'SELECT `year` as cat, `category` as label, `percent`*100 as `value` FROM `data_households_30pct_housing` order by `year`',
    'general:households_30pct_housing',
    '{"yAxis": {"type": "percent"}}'
  );

-- free_reduced_lunch

CREATE TABLE `data_free_reduced_lunch` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:free_reduced_lunch',
    'data_free_reduced_lunch',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'free_reduced_lunch:table',
    'SELECT * FROM `data_free_reduced_lunch` order by `year`',
    'general:free_reduced_lunch',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'free_reduced_lunch:chart',
    'SELECT `geography` as label, `year` as cat, `percent`*100 as value FROM `data_free_reduced_lunch` order by `year`',
    'general:free_reduced_lunch',
    '{"yAxis": {"type": "percent"}}'
  );

-- households_food_insecure

CREATE TABLE `data_households_food_insecure` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:households_food_insecure',
    'data_households_food_insecure',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'households_food_insecure:table',
    'SELECT * FROM `data_households_food_insecure` order by `year`',
    'general:households_food_insecure',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'households_food_insecure:chart',
    'SELECT `geography` as label, `year` as cat, `percent`*100 as value FROM `data_households_food_insecure` order by `year`',
    'general:households_food_insecure',
    '{"yAxis": {"type": "percent"}}'
  );

-- children_wic_snap
CREATE TABLE `data_children_wic_snap` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'WIC participants',
    'SNAP children served'
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
    'general:children_wic_snap',
    'data_children_wic_snap',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_wic_snap:chart_wic',
    'SELECT `year` as cat, "Vermont" as label, `value` as `value` FROM `data_children_wic_snap` where category="WIC participants" order by `year`',
    'general:children_wic_snap',
    '{"yAxis": {"type": "number"}}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_wic_snap:chart_snap',
    'SELECT `year` as cat, "Vermont" as label, `value` as `value` FROM `data_children_wic_snap` where category="SNAP children served" order by `year`',
    'general:children_wic_snap',
    '{"yAxis": {"type": "number"}}'
  );

-- children_designated_mental_agencies

CREATE TABLE `data_children_designated_mental_agencies` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
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
    'general:children_designated_mental_agencies',
    'data_children_designated_mental_agencies',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_designated_mental_agencies:chart',
    'SELECT `year` as cat, "Vermont" as label, `value` as `value` FROM `data_children_designated_mental_agencies` order by `year`',
    'general:children_designated_mental_agencies',
    '{"yAxis": {"type": "number"}}'
  );

-- children_crisis_services

CREATE TABLE `data_children_crisis_services` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
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
    'general:children_crisis_services',
    'data_children_crisis_services',
    'geo_type,geography,year'
  );



-- children_exclusionary_discipline

CREATE TABLE `data_children_exclusionary_discipline` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Overall',
    'Free and Reduced Lunch Eligible',
    'Children on an IEP',
    'Historically marginalized'
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
    'general:children_exclusionary_discipline',
    'data_children_exclusionary_discipline',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_exclusionary_discipline:chart',
    'SELECT `category` as cat, `year` as label, `value` as `value` FROM `data_children_exclusionary_discipline` where geo_type="State" and geography="Vermont" order by `year`',
    'general:children_exclusionary_discipline',
    '{"yAxis": {"type": "number"}}'
  );

-- intended_pregnancies

CREATE TABLE `data_intended_pregnancies` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:intended_pregnancies',
    'data_intended_pregnancies',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'intended_pregnancies:chart',
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_intended_pregnancies` where geo_type="State" and geography="Vermont" order by `year`',
    'general:intended_pregnancies',
    '{"yAxis": {"type": "percent"}}'
  );

-- women_no_leave

CREATE TABLE `data_women_no_leave` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` float DEFAULT NULL,
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
    'general:women_no_leave',
    'data_women_no_leave',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'women_no_leave:chart',
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_women_no_leave` where geo_type="State" and geography="Vermont" order by `year`',
    'general:women_no_leave',
    '{"yAxis": {"type": "percent"}}'
  );

-- children_improved_early_intervention

CREATE TABLE `data_children_improved_early_intervention` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:children_improved_early_intervention',
    'data_children_improved_early_intervention',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_improved_early_intervention:chart',
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_children_improved_early_intervention` where geo_type="State" and geography="Vermont" order by `year`',
    'general:children_improved_early_intervention',
    '{"yAxis": {"type": "percent"}}'
  );

-- families_early_intervention

CREATE TABLE `data_families_early_intervention` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:families_early_intervention',
    'data_families_early_intervention',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'families_early_intervention:chart',
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_families_early_intervention` where geo_type="State" and geography="Vermont" order by `year`',
    'general:families_early_intervention',
    '{"yAxis": {"type": "percent"}}'
  );

-- children_ccfap

CREATE TABLE `data_children_ccfap` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Total',
    'Under 5'
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
    'general:children_ccfap',
    'data_children_ccfap',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_ccfap:chart',
    'SELECT `category` as cat, `year` as label, `value` as `value` FROM `data_children_ccfap` where geo_type="State" and geography="Vermont" order by `year`',
    'general:children_ccfap',
    '{"yAxis": {"type": "number"}}'
  );
  
-- well_visits

CREATE TABLE `data_well_visits` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:well_visits',
    'data_well_visits',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'well_visits:chart',
    'SELECT `geography` as label, `year` as cat, `percent`*100 as value FROM `data_well_visits` where geo_type="State" and geography="Vermont" order by `year`',
    'general:well_visits',
    '{"yAxis": {"type": "percent"}}'
  );

-- preventative_dental

CREATE TABLE `data_preventative_dental` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `age` enum (
    '1-2',
    '3-5',
    '6-8'
  ) NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC,
    `age` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:preventative_dental',
    'data_preventative_dental',
    'geo_type,geography,year,age'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'preventative_dental:chart',
    'SELECT `age` as cat, `year` as label, `percent`*100 as `value` FROM `data_preventative_dental` where geo_type="State" and geography="Vermont" order by `year`',
    'general:preventative_dental',
    '{"yAxis": {"type": "percent"}}'
  );

-- immunizations
CREATE TABLE `data_immunizations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:immunizations',
    'data_immunizations',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'immunizations:chart',
    'SELECT `geography` as label, `year` as cat, `percent`*100 as value FROM `data_immunizations` where geo_type="State" and geography="Vermont" order by `year`',
    'general:immunizations',
    '{"yAxis": {"type": "percent"}}'
  );

-- health_insurance

CREATE TABLE `data_health_insurance` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:health_insurance',
    'data_health_insurance',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'health_insurance:chart',
    'SELECT `geography` as label, concat(`year`-1,"-",`year`) as cat, `percent`*100 as value FROM `data_health_insurance` where geo_type="State" and geography="Vermont" order by `year`',
    'general:health_insurance',
    '{"yAxis": {"type": "percent"}}'
  );

-- substance_use_pregnancy

CREATE TABLE `data_substance_use_pregnancy` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Cigarette smoking',
    'Alcohol',
    'MAT',
    'Marijuana'
  ) NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:substance_use_pregnancy',
    'data_substance_use_pregnancy',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'substance_use_pregnancy:chart',
    'SELECT `year` as cat, `category` as label, `percent`*100 as `value` FROM `data_substance_use_pregnancy` where geo_type="State" and geography="Vermont" order by `year`',
    'general:substance_use_pregnancy',
    '{"yAxis": {"type": "percent"}}'
  );

-- prenatal_visits

CREATE TABLE `data_prenatal_visits` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:prenatal_visits',
    'data_prenatal_visits',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'prenatal_visits:chart',
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_prenatal_visits` where geo_type="State" and geography="Vermont" order by `year`',
    'general:prenatal_visits',
    '{"yAxis": {"type": "percent"}}'
  );

-- breastfed_infants

CREATE TABLE `data_breastfed_infants` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Breastfeeding initiation',
    'Exclusively breastfeeding at 6 months',
    'Sustained breastfeeding through 12 months'
  ) NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:breastfed_infants',
    'data_breastfed_infants',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'breastfed_infants:chart',
    'SELECT `year` as cat, `category` as label, `percent`*100 as `value` FROM `data_breastfed_infants` where geo_type="State" and geography="Vermont" order by `year`',
    'general:breastfed_infants',
    '{"yAxis": {"type": "percent"}}'
  );