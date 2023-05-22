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
    '{"yAxis": {"type": "percent"}, "tooltip": "'Percent <b>' + this.x +'</b>: <b>' + (this.y).toFixed(0) + '</b>'"}'
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

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_crisis_services:chart',
    'SELECT `year` as cat, "Vermont" as label, `value` as `value` FROM `data_children_crisis_services` order by `year`',
    'general:children_crisis_services',
    '{"yAxis": {"type": "number"}}'
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
    'SELECT `category` as cat, `year` as label, `value` as `value` FROM `data_children_exclusionary_discipline` order by `year`',
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
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_intended_pregnancies` order by `year`',
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
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_women_no_leave` order by `year`',
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
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_children_improved_early_intervention` order by `year`',
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
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_families_early_intervention` order by `year`',
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
    'SELECT `category` as cat, `year` as label, `value` as `value` FROM `data_children_ccfap` order by `year`',
    'general:children_ccfap',
    '{"yAxis": {"type": "number"}}'
  );
  
