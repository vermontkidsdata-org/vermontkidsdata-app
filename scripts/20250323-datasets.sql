CREATE TABLE `data_tsgold` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` enum (
    'State',
    'Supervisory Union/School District'
  ) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `age` INT NOT NULL,
  `category` enum (
    'Literacy',
    'Math',
    'Social Emotional'
  ) NOT NULL,
  `year` INT NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `age` ASC,
    `category` ASC,
    `year` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:tsgold',
    'data_tsgold',
    'geo_type,geography,age,category,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'tsgold:chart',
    'SELECT `year` as `cat`, category as `label`, geography, `value`*100 as `value` FROM data_tsgold where `geography`="Vermont" and `age`=4 order by `year`',
    'general:tsgold',
    '{"yAxis": {"type": "percent"}}'
  );

-- child_victimization
CREATE TABLE `data_child_victimization` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` enum (
    'State',
    'Country'
  ) NOT NULL,
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
    'general:child_victimization',
    'data_child_victimization',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'child_victimization:chart',
    'SELECT `year` as `cat`, geography as `label`, `value`*100 as `value` FROM data_child_victimization order by `year`',
    'general:child_victimization',
    '{"yAxis": {"type": "percent"}}'
  );

-- intake_rate
CREATE TABLE `data_intake_rate` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` enum (
    'State',
    'Country'
  ) NOT NULL,
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
    'general:intake_rate',
    'data_intake_rate',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'intake_rate:chart',
    'SELECT `year` as `cat`, geography as `label`, `value` FROM data_intake_rate order by `year`',
    'general:intake_rate',
    '{"yAxis": {"type": "number"}}'
  );

-- num_children_medicaid
CREATE TABLE `data_num_children_medicaid` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` enum (
    'State',
    'Country'
  ) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` VARCHAR(12) NOT NULL,
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
    'general:num_children_medicaid',
    'data_num_children_medicaid',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'num_children_medicaid:chart',
    'SELECT `year` as `cat`, geography as `label`, `value` FROM data_num_children_medicaid order by `year`',
    'general:num_children_medicaid',
    '{"yAxis": {"type": "number"}}'
  );

-- kinship_care
CREATE TABLE `data_kinship_care` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` enum (
    'State',
    'Country'
  ) NOT NULL,
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
    'general:kinship_care',
    'data_kinship_care',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'kinship_care:chart',
    'SELECT `year` as `cat`, geography as `label`, `value`*100 as `value` FROM data_kinship_care order by `year`',
    'general:kinship_care',
    '{"yAxis": {"type": "percent"}}'
  );

-- blood_lead
CREATE TABLE `data_blood_lead` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` enum (
    'State',
    'Country'
  ) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    '1 year olds screened',
    '1 year olds with undetectable levels',
    '1 year olds with elevated blood lead levels',
    '2 year olds screened',
    '2 year olds with undetectable levels',
    '2 year olds with elevated blood lead levels'
  ) NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `category` ASC,
    `year` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:blood_lead',
    'data_blood_lead',
    'geo_type,geography,category,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'blood_lead:chart',
    'SELECT `year` as `cat`, category as `label`, `value`*100 as `value` FROM data_blood_lead order by `year`',
    'general:blood_lead',
    '{"yAxis": {"type": "percent"}}'
  );

-- cacfp
CREATE TABLE `data_cacfp` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` enum (
    'State',
    'Country'
  ) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
  `count` INT NOT NULL DEFAULT 0,
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
    'general:cacfp',
    'data_cacfp',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'cacfp:chart',
    'SELECT `year` as `cat`, geography as `label`, `percent`*100 as `value`, concat("Count: ",`count`) as `hover` FROM data_cacfp order by `year`',
    'general:cacfp',
    '{"yAxis": {"type": "percent"}}'
  );