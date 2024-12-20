alter table `queries` add column `filters` text;
alter table `upload_types` add column `filters` text;

CREATE TABLE `data_ccfap_stars` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Provider Name` varchar(255) DEFAULT NULL,
  `Provider Licence Number` varchar(32) DEFAULT NULL,
  `Provider Program Type` varchar(32) DEFAULT NULL,
  `Provider Town` varchar(64) DEFAULT NULL,
  `County` varchar(64) DEFAULT NULL,
  `AHS District` varchar(64) DEFAULT NULL,
  `Current Tier Level` varchar(16) DEFAULT NULL,
  `Paycycle: Paycycle Name` varchar(16) DEFAULT NULL,
  `VISION Payment Date` datetime DEFAULT NULL,
  `month` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8035 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`, `filters`)
VALUES
  (
    'general:ccfap_stars',
    'data_ccfap_stars',
    'Provider Name',
    '{"filters": {"year_filter": {"column": "Year"}, "month_filter": {"column": "month"}, "county_filter": {"column": "County"}, "program_filter": {"column": "Provider Program Type"}, "stars_filter": {"column": "Current Tier Level"}}}'
  );

insert into queries (name, sqlText, metadata, filters, uploadType)
values ('ccfap_filtered:chart', "
SELECT
 concat(
   case when trim(@county_filter)='Vermont' or @county_filter='-- All --' then 'Vermont' else `County` end
 ) as label,
 YEAR(`VISION Payment Date`) as cat,
 count(*) as value
 FROM data_ccfap_stars
 where YEAR(`VISION Payment Date`) > 0
 and `County`=(case when trim(@county_filter)='Vermont' or @county_filter='-- All --' then `County` else @county_filter end)
 and `Provider Program Type`=(case when @program_filter='-- All --' then `Provider Program Type` else @program_filter end)
 and (
   @stars_filter='-- All --' or
   @stars_filter='4 or 5 Star' and `Current Tier Level` in ('4 Star', '5 Star') or
   `Current Tier Level` = @stars_filter
 )
 group by label, cat", 
'{"yAxis": {"type": "number"}, "filters": [{"key": "county_filter", "title": "County"}, {"key": "program_filter", "title": "Program"}, {"key": "stars_filter", "title": "Tier Level"}]}',
'{"table": "data_ccfap_stars", "extra_filter_values": {"county_filter": ["  Vermont"], "program_filter": ["-- All --"], "stars_filter": ["-- All --", "4 or 5 Star"]}, "filters": {"county_filter": {"column": "County"}, "program_filter": {"column": "Provider Program Type"}, "stars_filter": {"column": "Current Tier Level"}}}',
'general:ccfap_stars'
);

insert into queries (name, sqlText, metadata, filters, uploadType)
values ('ccfap_filtered_byprog:chart', "
SELECT
 concat(
   case when @county_filter='Vermont' then 'Vermont' else `County` end
 ) as label,
 `Provider Program Type` as cat
 , count(*) as value
 FROM data_ccfap_stars
 where YEAR(`VISION Payment Date`) > 0
 and `County`=(case when @county_filter='Vermont' then `County` else @county_filter end)
 and `month`=(case when @month_filter='-- All --' then `month` else @month_filter end)
 and `year`=(case when @year_filter='-- All --' then `year` else @year_filter end)
 and (
   @stars_filter='-- All --' or
   @stars_filter='4 or 5 Star' and `Current Tier Level` in ('4 Star', '5 Star') or
   `Current Tier Level` = @stars_filter
 )
 group by label, cat
 ", 
'{"yAxis": {"type": "number"}, "filters": [{"key": "county_filter", "title": "County"}, {"key": "month_filter", "title": "Month"}, {"key": "year_filter", "title": "Year"}, {"key": "stars_filter", "title": "Tier Level"}]}',
'{"table": "data_ccfap_stars", "extra_filter_values": {"county_filter": ["Vermont"], "month_filter": ["-- All --"], "year_filter": ["-- All --"], "stars_filter": ["-- All --", "4 or 5 Star"]}, "filters": {"county_filter": {"column": "County"}, "month_filter": {"column": "month", "sort": "number"}, "year_filter": {"column": "year", "sort": "number"},  "stars_filter": {"column": "Current Tier Level"}}}',
'general:ccfap_stars'
);
