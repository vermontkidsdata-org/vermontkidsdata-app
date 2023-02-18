CREATE TABLE `data_mckinney_vento_u9` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `school_year` INT NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (`geo_type` ASC, `geography` ASC, `school_year` ASC) VISIBLE);

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:mckinney_vento_u9', 'data_mckinney_vento_u9', 'geo_type,geography,school_year');
insert into queries (name, sqlText, uploadType, metadata) value ('mckinney_vento_u9:table',
 'SELECT * FROM `data_mckinney_vento_u9` order by `year`',
  'general:mckinney_vento_u9',
  '{"title": "Students under 9 eligible for McKinney-Vento homelessness assistance"}'
);

CREATE TABLE `data_fsh` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` VARCHAR(32) NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (`geo_type` ASC, `geography` ASC, `year` ASC, `category` ASC) VISIBLE);

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:fsh', 'data_fsh', 'geo_type,geography,year,category');
insert into queries (name, sqlText, uploadType, metadata) value ('fsh:table',
 'SELECT * FROM `data_fsh` order by `year`',
  'general:fsh',
  '{"title": "Family Supportive Housing"}'
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
  UNIQUE INDEX `UPDATE_UNIQUE` (`geo_type` ASC, `geography` ASC, `federal_fiscal_year` ASC, `category` ASC, `indicator` ASC) VISIBLE);

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:dcf', 'data_dcf', 'geo_type,geography,federal_fiscal_year,category,indicator');
insert into queries (name, sqlText, uploadType, metadata) value ('dcf:table',
 'SELECT `geo_type`, `geography`, `federal_fiscal_year`, `category`, `indicator`, `value` FROM `data_dcf` order by `geo_type` ASC, `geography` ASC, `federal_fiscal_year` ASC, `category` ASC, `indicator` ASC',
  'general:dcf',
  '{"title": "Children in DCF Custody Trends"}'
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
  UNIQUE INDEX `UPDATE_UNIQUE` (`geo_type` ASC, `geography` ASC, `age_range` ASC, `year` ASC) VISIBLE);

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:ooh_custody', 'data_ooh_custody', 'geo_type,geography,age_range,year');
insert into queries (name, sqlText, uploadType, metadata) value ('ooh_custody:table',
 'SELECT `id`, `geo_type`, `geography`, `age_range`, `year`, `count` FROM `data_ooh_custody` order by `geo_type` ASC, `geography` ASC, `age_range` ASC, `year` ASC',
  'general:ooh_custody',
  '{"title": "Out of Home Custody by Region and State"}'
);
