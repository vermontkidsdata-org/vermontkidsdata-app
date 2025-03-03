CREATE TABLE `data_fbc_cost_living` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` enum (
    'State',
    'County'
  ) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'pre-tax income hourly',
    'pre-tax income annually'
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
    'general:fbc_cost_living',
    'data_fbc_cost_living',
    'geo_type,geography,year,category'
  );

update upload_types 
set download_query = "SELECT id, geo_type, geography, year, category, value, concat('Maximum Reach Up Benefit') benchmark_type FROM data_reachup
union all
SELECT id, geo_type, geography, year, category, value, concat('Federal Poverty Level') benchmark_type FROM data_fpl
union all
SELECT id, geo_type, geography, year, category, value, concat('Minimum Wage') benchmark_type FROM data_minimumwage
union all
SELECT id, geo_type, geography, year, 'Family Median Wage' category, value, concat('Census Family Median Wage') benchmark_type FROM data_familymedianwage
union all
SELECT id, geo_type, geography, year, category, value, concat('Family Budget Calculator') benchmark_type FROM data_fbc_cost_living"
where `type`='query:wage_benchmarks:chart';

update queries
set sqlText="select '' as cat, benchmark_type as label, value  from (
SELECT id, geo_type, geography, year, category, value, concat('Maximum Reach Up Benefit (', year, ')') benchmark_type FROM data_reachup where category='Annual Maximum Benefit for a Family of Four' and year=(select max(year) from data_reachup)
union all
SELECT id, geo_type, geography, year, category, value, concat('Federal Poverty Level (', year, ')') benchmark_type FROM data_fpl where category='100% FPL' and year=(select max(year) from data_fpl)
union all
SELECT id, geo_type, geography, year, category, value, concat('Minimum Wage (', year, ')') benchmark_type FROM data_minimumwage where category='Annual Wage' and year=(select max(year) from data_minimumwage)
union all
SELECT id, geo_type, geography, year, 'Family Median Wage' category, value, concat('Census Family Median Wage (', year, ')') benchmark_type FROM data_familymedianwage where year=(select max(year) from data_familymedianwage)
union all
SELECT id, geo_type, geography, year, category, value, concat('Family Budget Calculator (', year, ')') benchmark_type FROM data_fbc_cost_living where category='pre-tax income annually' and geography='Vermont' and year=(select max(year) from data_fbc_cost_living)
) as v order by value"
where name='wage_benchmarks:chart';

update `upload_types` 
set `index_columns`='geo_type,geography,year'
where `type`='general:ece_workforce';
