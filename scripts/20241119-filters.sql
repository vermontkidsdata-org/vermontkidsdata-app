alter table `queries` add column `filters` text;

insert into queries (name, sqlText, metadata, filters)
values ('ccfap_filtered:chart', "SELECT
concat(
  case when {{county_filter}}='all' then 'Vermont' else `County` end
) as label,
YEAR(`VISION Payment Date`) as cat,
count(*) as value
FROM data_ccfap_stars
where YEAR(`VISION Payment Date`) > 0
-- In order: county, program type, star rating
-- 'Chittenden'='all' and 'CBCCPP'='all' and '4 and 5 Star'='all'
and `County`=(case when {{county_filter}}='all' then `County` else {{county_filter}} end)
and `Provider Program Type`=(case when {{program_filter}}='all' then `Provider Program Type` else {{program_filter}} end)
and (
  {{stars_filter}}='all' or
  {{stars_filter}}='4 or 5 Star' and `Current Tier Level` in ('4 Star', '5 Star') or
  `Current Tier Level` = {{stars_filter}}
)
group by  label, cat", '{"yAxis": {"type": "number"}, "params": ["county_filter", "program_filter", "stars_filter"]}',
'{"table": "data_ccfap_stars", "extra_filter_values": {"stars_filter": ["4 or 5 Star"]}, "filters": {"county_filter": {"column": "County"}, "program_filter": {"column": "Provider Program Type"}, "stars_filter": {"column": "Current Tier Level"}}}');
