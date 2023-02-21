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
insert into queries (name, sqlText, uploadType, metadata) value ('mckinney_vento_u9:chart',
 'SELECT school_year as label, geography as cat, value FROM `data_mckinney_vento_u9` order by school_year',
  'general:mckinney_vento_u9',
  '{"title": "Students under 9 eligible for McKinney-Vento homelessness assistance", "yAxis": {"type": "number", "labels": {"format": "{value:.0f}"}, "decimals": "0"}, "plotOptions": {"series": {"dataLabels": {"format": "{point.y:,.0f}"}}}}'
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

insert into queries (name, sqlText, uploadType, metadata) value ('fsh:chart',
 'SELECT `category` as cat, `year` as label, `value` FROM `data_fsh` where geo_type="State" and geography="Vermont" order by `year`',
  'general:fsh',
  '{"title": "Family Supportive Housing", "yAxis": {"type": "number"}, "plotOptions": {"series": {"dataLabels": {"format": "{point.y:,.0f}"}}}}'
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
insert into queries (name, sqlText, uploadType, metadata) value ('dcf:chart',
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
  UNIQUE INDEX `UPDATE_UNIQUE` (`geo_type` ASC, `geography` ASC, `age_range` ASC, `year` ASC) VISIBLE);

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:ooh_custody', 'data_ooh_custody', 'geo_type,geography,age_range,year');
insert into queries (name, sqlText, uploadType, metadata) value ('ooh_custody:table',
 'SELECT `id`, `geo_type`, `geography`, `age_range`, `year`, `count` FROM `data_ooh_custody` order by `geo_type` ASC, `geography` ASC, `age_range` ASC, `year` ASC',
  'general:ooh_custody',
  '{"title": "Out of Home Custody by Region and State"}'
);
insert into queries (name, sqlText, uploadType, metadata) value ('ooh_custody:chart',
 'SELECT concat(`category`,":",`indicator`) as label, `federal_fiscal_year` as cat, `value` FROM `data_dcf` where geo_type="State" and geography="Vermont" order by `federal_fiscal_year`',
  'general:ooh_custody',
  '{"yAxis": {"type": "number"}}'
);

-- devscreen
CREATE TABLE `data_devscreen` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` int NOT NULL,
  `percent` DOUBLE NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (`geo_type` ASC, `geography` ASC, `year` ASC) VISIBLE);

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:devscreen', 'data_devscreen', 'geo_type,geography,year');
insert into queries (name, sqlText, uploadType, metadata) value ('devscreen:table',
 concat('SELECT `id`, `geo_type`, `geography`, `year`, `percent` FROM `data_devscreen`',
 ' order by `geo_type` ASC, `geography` ASC, `year` ASC'),
  'general:devscreen',
  '{"title": "Developmental Screening"}'
);
insert into queries (name, sqlText, uploadType, metadata) value ('devscreen:chart',
 'SELECT geography as label, `year` as cat, `percent`*100 as value FROM `data_devscreen` where geo_type="State" and geography="Vermont" order by `year`',
  'general:devscreen',
  '{"title": "Developmental Screening", "yAxis": {"type": "percent"}}'
);

-- headstart
ALTER TABLE `data_headstart` 
ADD COLUMN `geo_type` VARCHAR(16) NOT NULL DEFAULT 'State' AFTER `id`,
ADD COLUMN `geography` VARCHAR(32) NOT NULL DEFAULT 'Vermont' AFTER `geo_type`,
CHANGE COLUMN `year` `year` VARCHAR(45) NOT NULL ,
CHANGE COLUMN `age` `age` VARCHAR(45) NOT NULL ;

update `queries` set sqlText="select age as label, year as cat, value from data_headstart where geo_type='State' and geography='Vermont'"
where name='69';