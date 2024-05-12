-- kids_3squares_vt
CREATE TABLE `data_kids_3squares_vt` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Children under 18'
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
    'general:kids_3squares_vt',
    'data_kids_3squares_vt',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'kids_3squares_vt:chart',
    'SELECT `year` as `cat`, geography as `label`, `value` FROM data_kids_3squares_vt where `geography`="Vermont" order by `year`',
    'general:kids_3squares_vt',
    '{"yAxis": {"type": "number"}}'
  );

-- avgbenefit_3squares_vt
CREATE TABLE `data_avgbenefit_3squares_vt` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Individual',
    'Household'
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
    'general:avgbenefit_3squares_vt',
    'data_avgbenefit_3squares_vt',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'avgbenefit_3squares_vt:chart',
    'SELECT `year` as `cat`, category as `label`, `value` FROM data_avgbenefit_3squares_vt where `geography`="Vermont" order by `year`',
    'general:avgbenefit_3squares_vt',
    '{"yAxis": {"type": "number"}}'
  );

-- number_babies
CREATE TABLE `data_number_babies` (
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
    'general:number_babies',
    'data_number_babies',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'number_babies:chart',
    'SELECT `year` as `cat`, geography as `label`, `value` FROM data_number_babies where `geography`="Vermont" order by `year`',
    'general:number_babies',
    '{"yAxis": {"type": "number"}}'
  );

-- kids_poverty_region
CREATE TABLE `data_kids_poverty_region` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
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
    'general:kids_poverty_region',
    'data_kids_poverty_region',
    'geo_type,geography,year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'kids_poverty_region:chart',
    'SELECT `year` as `cat`, geography as `label`, `percent`*100 as `value` FROM data_kids_poverty_region 
where `year`=(select max(`year`) from data_kids_poverty_region)
order by `percent` desc',
    'general:kids_poverty_region',
    '{"yAxis": {"type": "percent"}}'
  );

-- idea_bc
CREATE TABLE `data_idea_bc` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `category` enum (
    'IDEA C',
    'IDEA B'
  ) NOT NULL,
  `age` VARCHAR(32) NOT NULL,
  `school_year` INT NOT NULL,
  `value` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (
    `geo_type` ASC,
    `geography` ASC,
    `school_year` ASC,
    `category` ASC,
    `age` ASC
  ) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:idea_bc',
    'data_idea_bc',
    'geo_type,geography,category,age,school_year'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'idea_bc:chart_by_year',
    'SELECT `school_year` as `cat`, category as `label`, sum(`value`) as `value` FROM data_idea_bc where `geography`="Vermont" group by `geo_type`, `geography`, `category`, `school_year` order by `school_year`',
    'general:idea_bc',
    '{"yAxis": {"type": "number"}}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'idea_bc:chart_by_age',
    'SELECT `age` as `cat`, `category` as `label`, sum(`value`) as `value` FROM data_idea_bc where `geography`="Vermont" and `school_year`=(select max(`school_year`) from data_idea_bc) group by `age` order by `age`',
    'general:idea_bc',
    '{"yAxis": {"type": "number"}}'
  );

-- third_grade_vcap
CREATE TABLE `data_third_grade_vcap` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `category` enum (
    'English All Students',
    'English No Special Ed',
    'English Special Ed',
    'English ELL',
    'English Not ELL',
    'English FRL',
    'English Not FRL',
    'English Foster',
    'English Not Foster',
    'English Female',
    'English Male',
    'English Historically Marginalized',
    'English Not Historically Marginalized',
    'English McKinney Vento Eligible',
    'English Not McKinney Vento Eligible',
    'English Migrant',
    'English Not Migrant',
    'English Military',
    'English Not Military',
    'English American Indian or Alaskan Native',
    'English Asian',
    'English Black',
    'English Hispanic',
    'English Native Hawaiian or Pacific Islander',
    'English White',
    'Math All Students',
    'Math No Special Ed',
    'Math Special Ed',
    'Math ELL',
    'Math Not ELL',
    'Math FRL',
    'Math Not FRL',
    'Math Foster',
    'Math Not Foster',
    'Math Female',
    'Math Male',
    'Math Historically Marginalized',
    'Math Not Historically Marginalized',
    'Math McKinney Vento Eligible',
    'Math Not McKinney Vento Eligible',
    'Math Migrant',
    'Math Not Migrant',
    'Math Military',
    'Math Not Military',
    'Math American Indian or Alaskan Native',
    'Math Asian',
    'Math Black',
    'Math Hispanic',
    'Math Native Hawaiian or Pacific Islander',
    'Math White'
  ) NOT NULL,
  `year` INT NOT NULL,
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
    'general:third_grade_vcap',
    'data_third_grade_vcap',
    'geo_type,geography,category,year'
  );

create or replace view `third_grade_vcap_vermont` as 
SELECT `id`, `category`, `year`,
case 
  when category like 'English Not %' then 'English'
  when category like 'English No %' then 'English' 
  when category like 'English %' then 'English' 
  when category like 'Math Not %' then 'Math' 
  when category like 'Math No %' then 'Math' 
  when category like 'Math %' then 'Math' 
  else '??' end as `subject`,
case 
  when category like 'English Not %' then substring(category, 13)
  when category like 'English No %' then substring(category, 12)
  when category like 'English %' then substring(category, 9)
  when category like 'Math Not %' then substring(category, 10)
  when category like 'Math No %' then substring(category, 9)
  when category like 'Math %' then substring(category, 6)
  else '??' end as `group`,
case
  when category like 'English Not %' then 'No'
  when category like 'English No %' then 'No' 
  when category like 'English %' then 'Yes' 
  when category like 'Math Not %' then 'No' 
  when category like 'Math No %' then 'No' 
  when category like 'Math %' then 'Yes' 
  else '??' end as `included`,
  `value`
  FROM data_third_grade_vcap where geo_type='State'
;

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'third_grade_vcap:chart_english_elig',
    "select `group` as `cat`, `included` as `label`, `value`*100 as `value` from third_grade_vcap_vermont
  where 
  subject='English'
  and `group` in ('All Students', 'FRL', 'Special Ed', 'McKinney Vento Eligible', 'Historically Marginalized')
  and `year`=(select max(year) from third_grade_vcap_vermont)
  order by `cat`",
    'general:third_grade_vcap',
    '{"yAxis": {"type": "percent"}}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'third_grade_vcap:chart_english_race',
    "select `year` as `cat`, `group` as `label`, `value`*100 as `value` from third_grade_vcap_vermont
  where 
  subject='English'
  and `included`='Yes' and `group` in ('All Students', 'American Indian or Alaskan Native','Asian','Black','Hispanic','Native Hawaiian or Pacific Islander','White')
  and `year`=(select max(year) from third_grade_vcap_vermont)
  order by `cat`",
    'general:third_grade_vcap',
    '{"yAxis": {"type": "percent"}}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'third_grade_vcap:chart_math_elig',
    "select `group` as `cat`, `included` as `label`, `value`*100 as `value` from third_grade_vcap_vermont
  where 
  subject='Math'
  and `group` in ('All Students', 'FRL', 'Special Ed', 'McKinney Vento Eligible', 'Historically Marginalized')
  and `year`=(select max(year) from third_grade_vcap_vermont)
  order by `cat`",
    'general:third_grade_vcap',
    '{"yAxis": {"type": "percent"}}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'third_grade_vcap:chart_math_race',
    "select `year` as `cat`, `group` as `label`, `value`*100 as `value` from third_grade_vcap_vermont
  where 
  subject='Math'
  and `included`='Yes' and `group` in ('All Students', 'American Indian or Alaskan Native','Asian','Black','Hispanic','Native Hawaiian or Pacific Islander','White')
  and `year`=(select max(year) from third_grade_vcap_vermont)
  order by `cat`",
    'general:third_grade_vcap',
    '{"yAxis": {"type": "percent"}}'
  );
