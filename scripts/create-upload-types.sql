drop table `upload_types`;

CREATE TABLE `upload_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(64) NOT NULL,
  `table` VARCHAR(45) NOT NULL,
  `index_columns` VARCHAR(4000) NULL,
  PRIMARY KEY (`id`));
ALTER TABLE `upload_types` 
ADD UNIQUE INDEX `type` (`type` ASC) VISIBLE;

ALTER TABLE `data_bed` 
  ADD UNIQUE INDEX `DESC` (`year` ASC, `geo` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:bed', 'data_bed', 'year,geo');

ALTER TABLE `data_headstart` 
  ADD UNIQUE INDEX `DESC` (`year` ASC, `age` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:headstart', 'data_headstart', 'year,age');

ALTER TABLE `data_individuals_served_pccn` 
  ADD UNIQUE INDEX `DESC` (`year` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:individuals_served_pccn', 'data_individuals_served_pccn', 'year');
