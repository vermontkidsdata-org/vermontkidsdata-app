ALTER TABLE `dashboard_indicators` 
CHANGE COLUMN `BN Cost of living` `BN:Cost of living` INT NULL DEFAULT NULL ,
CHANGE COLUMN `BN Housing` `BN:Housing` INT NULL DEFAULT NULL ,
CHANGE COLUMN `BN Food security and nutrition` `BN:Food security and nutrition` INT NULL DEFAULT NULL ,
CHANGE COLUMN `BN Financial assistance` `BN:Financial assistance` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Housing Housing` `Housing:Housing` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Demographic living arrangements` `Demographics:Living arrangements` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Demographics population` `Demographics:Population` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Econ Cost of living` `Econ:Cost of living` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Econ Financial assistance` `Econ:Financial assistance` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Econ Economic impact` `Econ:Economic impact` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Child Care Access` `Child Care:Access` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Child development Service access and utilization` `Child development:Service access and utilization` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Child development Standardized tests and screening` `Child development:Standardized tests and screening` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Education Standardized tests` `Education:Standardized tests` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Education Student characteristics` `Education:Student characteristics` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Mental health Access` `Mental health:Access` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Mental health Prevalence` `Mental health:Prevalence` INT NULL DEFAULT NULL ,
CHANGE COLUMN `PH Mental health` `PH:Mental health` INT NULL DEFAULT NULL ,
CHANGE COLUMN `PH Access and utilization` `PH:Access and utilization` INT NULL DEFAULT NULL ,
CHANGE COLUMN `PH Food security and nutrition` `PH:Food security and nutrition` INT NULL DEFAULT NULL ,
CHANGE COLUMN `PH Perinatal health` `PH:Perinatal health` INT NULL DEFAULT NULL ,
CHANGE COLUMN `R Food security and nutrition` `R:Food security and nutrition` INT NULL DEFAULT NULL ,
CHANGE COLUMN `R Housing` `R:Housing` INT NULL DEFAULT NULL ,
CHANGE COLUMN `R Cost of living` `R:Cost of living` INT NULL DEFAULT NULL ,
CHANGE COLUMN `R Mental health` `R:Mental health` INT NULL DEFAULT NULL ,
CHANGE COLUMN `R Other environmental factors` `R:Other environmental factors` INT NULL DEFAULT NULL ,
CHANGE COLUMN `R Social and emotional` `R:Social and emotional` INT NULL DEFAULT NULL ,
CHANGE COLUMN `UPK Access and utilization` `UPK:Access and utilization` INT NULL DEFAULT NULL ,
CHANGE COLUMN `UPK Standardized tests` `UPK:Standardized tests` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Workforce Paid Leave` `Workforce:Paid Leave` INT NULL DEFAULT NULL ;

-- update `queries`
--   set `metadata`='{"server": {"transforms":{"Category": [{"op": "striptag"}]}}}'
--   where `name`='dashboard:subcategories:table';

update `queries`
  set `metadata`=null
  where `name`='dashboard:subcategories:table';
