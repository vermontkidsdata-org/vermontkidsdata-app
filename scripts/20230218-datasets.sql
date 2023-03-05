CREATE TABLE `data_mckinney_vento_u9` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `school_year` INT NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `school_year` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:mckinney_vento_u9',
    'data_mckinney_vento_u9',
    'geo_type,geography,school_year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'mckinney_vento_u9:table',
    'SELECT * FROM `data_mckinney_vento_u9` order by `year`',
    'general:mckinney_vento_u9',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'mckinney_vento_u9:chart',
    'SELECT school_year as label, geography as cat, value FROM `data_mckinney_vento_u9` order by school_year',
    'general:mckinney_vento_u9',
    '{"yAxis": {"type": "number", "labels": {"format": "{value:.0f}"}, "decimals": "0"}, "plotOptions": {"series": {"dataLabels": {"format": "{point.y:,.0f}"}}}}'
  );

CREATE TABLE `data_fsh` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` VARCHAR(32) NOT NULL,
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
    'general:fsh',
    'data_fsh',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'fsh:table',
    'SELECT * FROM `data_fsh` order by `year`',
    'general:fsh',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'fsh:chart',
    'SELECT `category` as cat, `year` as label, `value` FROM `data_fsh` where geo_type="State" and geography="Vermont" order by `year`',
    'general:fsh',
    '{"yAxis": {"type": "number"}, "plotOptions": {"series": {"dataLabels": {"format": "{point.y:,.0f}"}}}}'
  );

CREATE TABLE `data_dcf` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `federal_fiscal_year` INT NOT NULL,
  `category` VARCHAR(32) NOT NULL,
  `indicator` VARCHAR(32) NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `federal_fiscal_year` ASC,
    `category` ASC,
    `indicator` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:dcf',
    'data_dcf',
    'geo_type,geography,federal_fiscal_year,category,indicator'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'dcf:table',
    'SELECT `geo_type`, `geography`, `federal_fiscal_year`, `category`, `indicator`, `value` FROM `data_dcf` order by `geo_type` ASC, `geography` ASC, `federal_fiscal_year` ASC, `category` ASC, `indicator` ASC',
    'general:dcf',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'dcf:chart',
    'SELECT concat(`category`,":",`indicator`) as label, `federal_fiscal_year` as cat, `value` FROM `data_dcf` where geo_type="State" and geography="Vermont" and category="Caseload by Type" order by `federal_fiscal_year`',
    'general:dcf',
    '{"yAxis": {"type": "number"}}'
  );

-- Out of Home Custody by Region and State 2012-2022 (ooh_custody)
CREATE TABLE `data_ooh_custody` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `age_range` VARCHAR(32) NOT NULL,
  `year` int NOT NULL,
  `count` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `age_range` ASC,
    `year` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:ooh_custody',
    'data_ooh_custody',
    'geo_type,geography,age_range,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'ooh_custody:table',
    'SELECT `id`, `geo_type`, `geography`, `age_range`, `year`, `count` FROM `data_ooh_custody` order by `geo_type` ASC, `geography` ASC, `age_range` ASC, `year` ASC',
    'general:ooh_custody',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'ooh_custody:chart',
    'SELECT `age_range` as label, `year` as cat, `count` as `value` FROM `data_ooh_custody` where geo_type="State" and geography="Vermont" and `year`>2012 and `age_range`<>"Under 9" order by `year`, age_range',
    'general:ooh_custody',
    '{"yAxis": {"type": "number"}, "plotOptions": {"series": {"dataLabels": {"format": "{point.y:,.0f}"}}}}'
  );

-- devscreen
CREATE TABLE `data_devscreen` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` int NOT NULL,
  `percent` DOUBLE NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (`geo_type` ASC, `geography` ASC, `year` ASC) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:devscreen',
    'data_devscreen',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'devscreen:table',
    concat(
      'SELECT `id`, `geo_type`, `geography`, `year`, `percent` FROM `data_devscreen`',
      ' order by `geo_type` ASC, `geography` ASC, `year` ASC'
    ),
    'general:devscreen',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'devscreen:chart',
    'SELECT geography as label, `year` as cat, `percent`*100 as value FROM `data_devscreen` where geo_type="State" and geography="Vermont" order by `year`',
    'general:devscreen',
    '{"yAxis": {"type": "percent"}}'
  );

-- headstart
ALTER TABLE
  `data_headstart`
ADD
  COLUMN `geo_type` VARCHAR(16) NOT NULL DEFAULT 'State'
AFTER
  `id`,
ADD
  COLUMN `geography` VARCHAR(32) NOT NULL DEFAULT 'Vermont'
AFTER
  `geo_type`,
  CHANGE COLUMN `year` `year` VARCHAR(45) NOT NULL,
  CHANGE COLUMN `age` `age` VARCHAR(45) NOT NULL;

update
  `queries`
set
  sqlText = "select age as label, year as cat, value from data_headstart where geo_type='State' and geography='Vermont'"
where
  name = '69';

-- r4k
CREATE TABLE `data_r4k` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` int NOT NULL,
  `category` enum (
    '1-Not yet ready',
    '2-Approaching ready',
    '3-Ready and practicing',
    '4-Ready and performing independently',
    'Total of all students statewide identified as ready',
    'All Students Surveyed',
    'Boys',
    'Girls',
    'Free and Reduced Lunch Eligible',
    'Not Free and Reduced Lunch Eligible',
    'Attended Publicly Funded PreK',
    'Did Not Attend Publicly Funded PreK'
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
    'general:r4k',
    'data_r4k',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'r4k:table',
    concat(
      'SELECT `id`, `geo_type`, `geography`, `year`, `percent` FROM `data_r4k`',
      ' order by `geo_type` ASC, `geography` ASC, `year` ASC, `category`'
    ),
    'general:r4k',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'r4k:chart',
    'SELECT `category` as label, `year` as cat, `percent`*100 as value FROM `data_r4k` where geo_type="State" and geography="Vermont" and `category`="Total of all students statewide identified as ready" order by `year`, `category`',
    'general:r4k',
    '{"yAxis": {"type": "percent"}}'
  );

-- adverse_experiences
CREATE TABLE `data_adverse_experiences` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geography` VARCHAR(32) NOT NULL,
  `year` int NOT NULL,
  `age` enum ('0 to 5', '6 to 11', '0 to 12') not null,
  `category` enum ('0', '1', '2 or more') NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geography` ASC,
    `year` ASC,
    `age` ASC,
    `category` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:adverse_experiences',
    'data_adverse_experiences',
    'geography,year,age,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'adverse_experiences:table',
    concat(
      'SELECT `id`, `geography`, `year`, `age`, `category`, `percent` FROM `data_adverse_experiences`',
      ' order by `geography` ASC, `year` ASC, `age` ASC, `category`'
    ),
    'general:adverse_experiences',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'adverse_experiences:chart',
    'SELECT `geography` as label, `year` as cat, `percent`*100 as value FROM `data_adverse_experiences` where `age`="0 to 12" and `category`="2 or more" order by `year`, `category`, `geography`',
    'general:adverse_experiences',
    '{"yAxis": {"type": "percent"}}'
  );

-- flourishing_children 6mo-5y
CREATE TABLE `data_flourishing_children` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geography` VARCHAR(32) NOT NULL,
  `year` int NOT NULL,
  `category` enum ('Meets 0-2', 'Meets 3', 'Meets 4') NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (`year`, `category`, `geography`) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:flourishing_children',
    'data_flourishing_children',
    'geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'flourishing_children:table',
    concat(
      'SELECT `id`, `geography`, `year`, `category`, `percent` FROM `data_flourishing_children`',
      ' order by `year`, `category`, `geography`'
    ),
    'general:flourishing_children',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'flourishing_children:chart',
    'SELECT `geography` as label, `year` as cat, `percent`*100 as value FROM `data_flourishing_children` where `category`="Meets 4" order by `year`, `category`, `geography`',
    'general:flourishing_children',
    '{"yAxis": {"type": "percent"}}'
  );