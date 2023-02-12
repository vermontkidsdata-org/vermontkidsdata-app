drop table `upload_types`;

CREATE TABLE `upload_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(64) NOT NULL,
  `table` VARCHAR(45) NOT NULL,
  `index_columns` VARCHAR(4000) NULL,
  PRIMARY KEY (`id`));
ALTER TABLE `upload_types` ADD UNIQUE INDEX `type` (`type` ASC) VISIBLE;

ALTER TABLE `queries` ADD COLUMN `uploadType` VARCHAR(128) NULL AFTER `metadata`;

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
  `grand_total` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `year_UNIQUE` (`year` ASC) VISIBLE);

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:ed', 'data_ed', 'year');
insert into queries (name, sqlText, uploadType) value ('ed:table', 'SELECT `id`, `year`, `same_day`, `1_day`, `2_to_4_days`, `5+_days`, `grand_total` FROM `data_ed` order by `year`', 'general:ed');
update queries set uploadType='general:ed' where sqlText like '%data_ed%';

ALTER TABLE `data_ccenrollment` 
  ADD UNIQUE INDEX `DESC` (`year` ASC, `type` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:ccenrollment', 'data_ccenrollment', 'year,type');
update queries set uploadType='general:ccenrollment' where sqlText like '%data_ccenrollment%';

ALTER TABLE `data_adequatehealth` 
  ADD UNIQUE INDEX `DESC` (`year` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:adequatehealth', 'data_adequatehealth', 'year');
update queries set uploadType='general:adequatehealth' where sqlText like '%data_adequatehealth%';

ALTER TABLE `data_developmentalscreening` 
  ADD UNIQUE INDEX `DESC` (`hospital_service` ASC, `year` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:developmentalscreening', 'data_developmentalscreening', 'hospital_service,year');
update queries set uploadType='general:developmentalscreening' where sqlText like '%data_developmentalscreening%';

ALTER TABLE `data_ahs_population` 
  ADD UNIQUE INDEX `DESC` (`year` ASC, `AGE` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:ahs_population', 'data_ahs_population', 'Year,AGE');
update queries set uploadType='general:ahs_population' where sqlText like '%data_ahs_population%';

ALTER TABLE `data_access_to_education` 
  ADD UNIQUE INDEX `DESC` (`year` ASC, `age` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:access_to_education', 'data_access_to_education', 'year,age');
update queries set uploadType='general:access_to_education' where sqlText like '%data_access_to_education%';

ALTER TABLE `data_elevated_blood_lead` 
  ADD UNIQUE INDEX `DESC` (`year` ASC, `geography` asc, `age` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:elevated_blood_lead', 'data_elevated_blood_lead', 'year,geography,age');
update queries set uploadType='general:elevated_blood_lead' where sqlText like '%data_elevated_blood_lead%';

ALTER TABLE `data_student_support_services` 
  ADD UNIQUE INDEX `DESC` (`age` ASC) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:student_support_services', 'data_student_support_services', 'age');
update queries set uploadType='general:student_support_services' where sqlText like '%data_student_support_services%';

INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:assessments', 'data_assessments', 'sy,org_id,test_name,indicator_label,assess_group,assess_label');
update queries set uploadType='general:assessments' where sqlText like '%data_assessments%';

ALTER TABLE `data_capacity` 
  ADD UNIQUE INDEX `DESC` (`year`, `program_type`, `capacity_type`) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:capacity', 'data_capacity', 'year,program_type,capacity_type');
update queries set uploadType='general:capacity' where sqlText like '%data_capacity%';

ALTER TABLE `data_upk_enrollment` 
  ADD UNIQUE INDEX `DESC` (`year`) VISIBLE;
INSERT INTO `upload_types` (`type`, `table`, `index_columns`) VALUES ('general:upk_enrollment', 'data_upk_enrollment', 'year');
update queries set uploadType='general:upk_enrollment' where sqlText like '%data_upk_enrollment%';

ALTER TABLE `queries` ADD CONSTRAINT `queries_upload_type`
  FOREIGN KEY (`uploadType`)
  REFERENCES `upload_types` (`type`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
