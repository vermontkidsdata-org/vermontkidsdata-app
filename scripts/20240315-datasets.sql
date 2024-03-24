-- child_sexual_abuse
CREATE TABLE `data_child_sexual_abuse` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
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
    'general:child_sexual_abuse',
    'data_child_sexual_abuse',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'child_sexual_abuse:chart',
    'SELECT `year` as `cat`, geography as `label`, `value` FROM data_child_sexual_abuse where `geography`="Vermont" order by `year`',
    'general:child_sexual_abuse',
    '{"yAxis": {"type": "number"}}'
  );

-- children_abuse_services
CREATE TABLE `data_children_abuse_services` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
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
    'general:children_abuse_services',
    'data_children_abuse_services',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_abuse_services:chart',
    'SELECT `year` as `cat`, geography as `label`, `value` FROM data_children_abuse_services where `geography`="Vermont" order by `year`',
    'general:children_abuse_services',
    '{"yAxis": {"type": "number"}}'
  );

-- da_ssa_turnover
CREATE TABLE `data_da_ssa_turnover` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'DA/SSA (all programs)',
    'MH program staff',
    'MH/SU staff',
    'Emergency Services'
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
    'general:da_ssa_turnover',
    'data_da_ssa_turnover',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'da_ssa_turnover:chart',
    'SELECT `category` as `cat`, geography as `label`, `value`*100 as `value` FROM data_da_ssa_turnover order by `year`',
    'general:da_ssa_turnover',
    '{"yAxis": {"type": "percent"}}'
  );

-- preventative_dental
delete FROM data_preventative_dental;

ALTER TABLE `data_preventative_dental` 
CHANGE COLUMN `age` `age` ENUM('1-2', '3-5', '6-8', '1-5', '6-11', '1-11') NOT NULL ;

delete from queries where name = 'preventative_dental:chart';

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'preventative_dental:chart',
    'SELECT `year` as cat, `age` as label, `percent`*100 as `value` FROM `data_preventative_dental` where geo_type="State" and geography="Vermont" and `age` in ("1-5", "6-11") order by `year`',
    'general:preventative_dental',
    '{"yAxis": {"type": "percent"}}'
  );

-- children_kinship_care
CREATE TABLE `data_children_kinship_care` (
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
    'general:children_kinship_care',
    'data_children_kinship_care',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'children_kinship_care:chart',
    'SELECT `year` as `cat`, geography as `label`, `value`*100 as `value` FROM data_children_kinship_care where `geography`="Vermont" order by `year`',
    'general:children_kinship_care',
    '{"yAxis": {"type": "percent"}}'
  );

-- Annual Maximum Benefit for a Family of Four
insert into
  queries (name, sqlText, uploadType, metadata) value (
    'reachup_max_benefit:chart',
    'SELECT `year` as `cat`, `geography` as `label`, `value` FROM data_reachup where `geography`="Vermont" and `category`="Annual Maximum Benefit for a Family of Four" order by `year`',
    'general:children_kinship_care',
    '{"yAxis": {"type": "number"}}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'reachup_caseload:chart',
    'SELECT `year` as `cat`, `geography` as `label`, `value` FROM data_reachup where `geography`="Vermont" and `category`="Caseload" order by `year`',
    'general:children_kinship_care',
    '{"yAxis": {"type": "number"}}'
  );

-- building_broadband_access
CREATE TABLE `data_building_broadband_access` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    '25/3',
    '100/100'
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
    'general:building_broadband_access',
    'data_building_broadband_access',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'building_broadband_access:chart',
    'SELECT `year` as `cat`, `category` as `label`, `value`*100 as `value` FROM data_building_broadband_access order by `year`',
    'general:building_broadband_access',
    '{"yAxis": {"type": "percent"}}'
  );

-- wic_participation
CREATE TABLE `data_wic_participation` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` VARCHAR(16) NOT NULL,
  `category` enum (
    'Women',
    'Infants',
    'Children'
  ) NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
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
    'general:wic_participation',
    'data_wic_participation',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'wic_participation:chart',
    'SELECT `year` as `cat`, `category` as `label`, `value` FROM data_wic_participation order by `year`',
    'general:wic_participation',
    '{"yAxis": {"type": "number"}}'
  );
