-- Geo Type |	Geography	| Year	| Category
CREATE TABLE `data_pitc_homelessness` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Persons in Households with at least One Adult & One Child',
    'Persons in households with Adults only',
    'Persons in Households with Children Only'
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
    'general:pitc_homelessness',
    'data_pitc_homelessness',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'pitc_homelessness:chart',
    'SELECT `year` as cat, "Vermont" as label, `value` as `value` FROM `data_pitc_homelessness` where category="Persons in Households with at least One Adult & One Child" order by `year`',
    'general:pitc_homelessness',
    '{"yAxis": {"type": "number"}}'
  );

-- Geo Type |	Geography	| Year	| Category
CREATE TABLE `data_reachup` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Caseload',
    'Monthly Maximum Benefits for a Family of 4',
    'Annual Maximum Benefit for a Family of Four'
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
    'general:reachup',
    'data_reachup',
    'geo_type,geography,year,category'
  );

-- Geo Type |	Geography	| Year	| Category
CREATE TABLE `data_fpl` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    '100% FPL',
    '185% FPL'
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
    'general:fpl',
    'data_fpl',
    'geo_type,geography,year,category'
  );

-- minimumwage
-- Geo Type |	Geography	| Year	| Category
CREATE TABLE `data_minimumwage` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Hourly Rate',
    'Annual Wage',
    'Two Working Adults'
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
    'general:minimumwage',
    'data_minimumwage',
    'geo_type,geography,year,category'
  );

-- familymedianwage
CREATE TABLE `data_familymedianwage` (
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
    'general:familymedianwage',
    'data_familymedianwage',
    'geo_type,geography,year'
  );

-- mitlivingwage
-- Geo Type |	Geography	| Year	| Category
CREATE TABLE `data_mitlivingwage` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'pre tax income',
    'pre tax income hourly',
    'annual food expenses',
    'transporation cost',
    'child care costs',
    'health cost'
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
    'general:mitlivingwage',
    'data_mitlivingwage',
    'geo_type,geography,year,category'
  );

alter table upload_types add column `download_query` varchar(4000) not null default '' after `table`;
ALTER TABLE `upload_types` 
  ADD COLUMN `read_only` TINYINT NOT NULL DEFAULT 0 AFTER `download_query`;

insert into upload_types (`type`, `table`, `index_columns`, `download_query`, `read_only`) 
values (
  'query:wage_benchmarks:chart', 
  '',
  'cat,label,value', 
"SELECT id, geo_type, geography, year, category, value, concat('Maximum Reach Up Benefit') benchmark_type FROM data_reachup
union all
SELECT id, geo_type, geography, year, category, value, concat('Federal Poverty Level') benchmark_type FROM data_fpl
union all
SELECT id, geo_type, geography, year, category, value, concat('Minimum Wage') benchmark_type FROM data_minimumwage
union all
SELECT id, geo_type, geography, year, 'Family Median Wage' category, value, concat('Census Family Median Wage') benchmark_type FROM data_familymedianwage
union all
SELECT id, geo_type, geography, year, category, value, concat('MIT Living Wage') benchmark_type FROM data_mitlivingwage",
  1
);

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'wage_benchmarks:chart',
    "select '' as cat, benchmark_type as label, value  from (
SELECT id, geo_type, geography, year, category, value, concat('Maximum Reach Up Benefit (', year, ')') benchmark_type FROM data_reachup where category='Annual Maximum Benefit for a Family of Four' and year=(select max(year) from data_reachup)
union all
SELECT id, geo_type, geography, year, category, value, concat('Federal Poverty Level (', year, ')') benchmark_type FROM data_fpl where category='100% FPL' and year=(select max(year) from data_fpl)
union all
SELECT id, geo_type, geography, year, category, value, concat('Minimum Wage (', year, ')') benchmark_type FROM data_minimumwage where category='Annual Wage' and year=(select max(year) from data_minimumwage)
union all
SELECT id, geo_type, geography, year, 'Family Median Wage' category, value, concat('Census Family Median Wage (', year, ')') benchmark_type FROM data_familymedianwage where year=(select max(year) from data_familymedianwage)
union all
SELECT id, geo_type, geography, year, category, value, concat('MIT Living Wage (', year, ')') benchmark_type FROM data_mitlivingwage where category='pre tax income' and geography='Vermont' and year=(select max(year) from data_mitlivingwage)
) as v order by value",
    'query:wage_benchmarks:chart',
    '{"yAxis": {"type": "number"}}'
  );

-- wellcarevisits
CREATE TABLE `data_wellcarevisits` (
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
    'general:wellcarevisits',
    'data_wellcarevisits',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'wellcarevisits:chart',
    'SELECT `year` as cat, "Vermont" as label, `value`*100 as `value` FROM `data_wellcarevisits` where geography="Vermont" order by `year`',
    'general:wellcarevisits',
    '{"yAxis": {"type": "percent"}}'
  );

-- residentialcare
CREATE TABLE `data_residentialcare` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'under 9',
    'between 10-21',
    'under 21'
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
    'general:residentialcare',
    'data_residentialcare',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'residentialcare:chart',
    'SELECT `year` as cat, category as label, `value` as `value` FROM `data_residentialcare` order by `year`',
    'general:residentialcare',
    '{"yAxis": {"type": "number"}}'
  );

-- Datasets to upload
-- node scripts\upload-csv.js familymedianwage 1 prod -d data
-- node scripts\upload-csv.js minimumwage 1 prod -d data
-- node scripts\upload-csv.js mitlivingwage 1 prod -d data
-- node scripts\upload-csv.js pitc_homelessness 1 prod -d data
-- node scripts\upload-csv.js reachup 1 prod -d data
-- node scripts\upload-csv.js residentialcare 1 prod -d data
-- node scripts\upload-csv.js wellcarevisits 1 prod -d data

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:upload_types',
    'upload_types',
    'type'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'upload_types',
    'SELECT * FROM `upload_types` order by `type`',
    'general:upload_types',
    '{}'
  );
