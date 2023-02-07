drop table `upload_types`;

CREATE TABLE `upload_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(64) NOT NULL,
  `table` VARCHAR(45) NOT NULL,
  `index_columns` VARCHAR(4000) NULL,
  PRIMARY KEY (`id`));
ALTER TABLE `upload_types` ADD UNIQUE INDEX `type` (`type` ASC) VISIBLE;

ALTER TABLE `queries` ADD COLUMN `uploadType` VARCHAR(128) NULL AFTER `metadata`;
ALTER TABLE `queries` ADD CONSTRAINT `queries_upload_type`
  FOREIGN KEY (`uploadType`)
  REFERENCES `upload_types` (`type`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `data_bed` 
  ADD UNIQUE INDEX `DESC` (`year` ASC, `geo` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:bed', 'data_bed', 'year,geo');
update queries set uploadType='general:bed' where name='67';

ALTER TABLE `data_headstart` 
  ADD UNIQUE INDEX `DESC` (`year` ASC, `age` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:headstart', 'data_headstart', 'year,age');
update queries set uploadType='general:headstart' where name='69';

ALTER TABLE `data_individuals_served_pccn` 
  ADD UNIQUE INDEX `DESC` (`year` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:individuals_served_pccn', 'data_individuals_served_pccn', 'year');
update queries set uploadType='general:individuals_served_pccn' where name='68';

CREATE TABLE `data_ed` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `year` INT NOT NULL,
  `same_day` INT NOT NULL DEFAULT 0,
  `1_day` INT NOT NULL DEFAULT 0,
  `2_to_4_days` INT NOT NULL DEFAULT 0,
  `5+_days` INT NOT NULL DEFAULT 0,
  `grand_total` INT NOT NULL DEFAULT 0
  PRIMARY KEY (`id`),
  UNIQUE INDEX `year_UNIQUE` (`year` ASC) VISIBLE);

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:ed', 'data_ed', 'year');
insert into queries (name, sqlText, uploadType) value ('70', 'SELECT `id`, `year`, `same_day`, `1_day`, `2_to_4_days`, `5+_days`, `grand_total` FROM `data_ed` order by `year`', 'general:ed');
