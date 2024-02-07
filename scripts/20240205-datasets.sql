-- child_population_u10
CREATE TABLE `data_child_population_u10` (
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
    'general:child_population_u10',
    'data_child_population_u10',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'child_population_u10:chart',
    'SELECT `year` as `cat`, geography as `label`, `value` FROM data_child_population_u10 where `geography`="Vermont" order by `year`',
    'general:child_population_u10',
    '{"yAxis": {"type": "number"}}'
  );

-- race_ethnicity_u10
CREATE TABLE `data_race_ethnicity_u10` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `age` enum ('10 and under', 'All ages') NOT NULL,
  `category` enum (
    'American Indian and Alaska Native',
    'Asian',
    'Black or African American',
    'Hispanic/Latino/a/x',
    'Native Hawaiian and Other Pacific Islander',
    'Total population',
    'Two or More Races',
    'White'
  ) NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
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
    'general:race_ethnicity_u10',
    'data_race_ethnicity_u10',
    'geo_type,geography,year,age,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'race_ethnicity_u10:chart',
    'SELECT `category` as `cat`, geography as `label`, `value` FROM data_race_ethnicity_u10 where year=(select max(year) from data_race_ethnicity_u10) order by `year`',
    'general:race_ethnicity_u10',
    '{"yAxis": {"type": "number"}}'
  );

-- ece_workforce
CREATE TABLE `data_ece_workforce` (
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
    'general:ece_workforce',
    'data_ece_workforce',
    'geo_type,geography,year,age,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'ece_workforce:chart',
    'SELECT `year` as `cat`, geography as `label`, `value` FROM data_ece_workforce where `geography`="Vermont" order by `year`',
    'general:ece_workforce',
    '{"yAxis": {"type": "number"}}'
  );

-- substance use enum fix
ALTER TABLE
  `data_substance_use_pregnancy`
MODIFY
    `category` enum (
      'Cigarette smoking',
      'Alcohol',
      'MAT',
      'Marijuana',
      'Other Substances'
    ) NOT NULL
;

delete from
  queries
where
  name = 'substance_use_pregnancy:chart';

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'substance_use_pregnancy:chart',
    'SELECT `year` as cat, `category` as label, `percent`*100 as `value` FROM `data_substance_use_pregnancy` where geo_type="State" and geography="Vermont" and `category`<>"MAT" and `year`>(select max(year)-5 from data_substance_use_pregnancy) order by `year`',
    'general:substance_use_pregnancy',
    '{"yAxis": {"type": "percent"}}'
  );

-- pmads
CREATE TABLE `data_pmads` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum ('prevalence', 'screening') NOT NULL,
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
    'general:pmads',
    'data_pmads',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'pmads:chart',
    'SELECT `category` as `cat`, geography as `label`, `value`*100 as `value` FROM data_pmads order by `year`',
    'general:pmads',
    '{"yAxis": {"type": "percent"}}'
  );

-- coordinated_entry_services
CREATE TABLE `data_coordinated_entry_services` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `age` enum ('Under 5', '5-12', 'Under 18', '13-17') NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC,
    `age` ASC
  ) VISIBLE
);

insert into
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:coordinated_entry_services',
    'data_coordinated_entry_services',
    'geo_type,geography,year,age'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'coordinated_entry_services:chart',
    'SELECT `age` as `cat`, geography as `label`, `value` FROM data_coordinated_entry_services where geography="Vermont" order by `year`',
    'general:coordinated_entry_services',
    '{"yAxis": {"type": "number"}}'
  );

-- rental_vacancy_rate
CREATE TABLE `data_rental_vacancy_rate` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum ('homeowner', 'rental') NOT NULL,
  `value` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC,
    `category` ASC
  ) VISIBLE
);

insert into
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:rental_vacancy_rate',
    'data_rental_vacancy_rate',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'rental_vacancy_rate:chart',
    'SELECT `year` as `cat`, category as `label`, `value`*100 as `value` FROM data_rental_vacancy_rate order by `year`',
    'general:rental_vacancy_rate',
    '{"yAxis": {"type": "percent"}}'
  );

-- fsh:chart modified:
-- Existing chart - The maximum caseload is no longer being reported regularly. Can we remove that category from the visualization? 
-- Maybe this is something that I should be able to do, but I'm not sure how. 
-- Also, if you are in there, can you group by year rather than category? 
delete from 
  queries
    where name='fsh:chart';

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'fsh:chart',
    'SELECT `year` as cat, `category` as label, `value` FROM `data_fsh` where geo_type="State" and geography="Vermont" and Category<>"Maximum Family Caseload" order by `year`',
    'general:fsh',
    '{"yAxis": {"type": "number"}, "plotOptions": {"series": {"dataLabels": {"format": "{point.y:,.0f}"}}}}'
  );

-- licensed_foster_custody
CREATE TABLE `data_licensed_foster_custody` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum ('Licensed Foster Homes','Children in Custody') NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `year` ASC,
    `category` ASC
  ) VISIBLE
);

insert into
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:licensed_foster_custody',
    'data_licensed_foster_custody',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'licensed_foster_custody:chart',
    'SELECT `year` as `cat`, category as `label`, `value` FROM data_licensed_foster_custody where `geography`="Vermont" order by `year`',
    'general:licensed_foster_custody',
    '{"yAxis": {"type": "number"}}'
  );

-- Upload scripts
node scripts\upload-csv.js child_population_u10 prod -d data
node scripts\upload-csv.js race_ethnicity_u10 prod -d data
node scripts\upload-csv.js ece_workforce prod -d data
node scripts\upload-csv.js substance_use_pregnancy prod -d data
node scripts\upload-csv.js pmads prod -d data
node scripts\upload-csv.js coordinated_entry_services prod -d data
node scripts\upload-csv.js rental_vacancy_rate prod -d data
node scripts\upload-csv.js licensed_foster_custody prod -d data
