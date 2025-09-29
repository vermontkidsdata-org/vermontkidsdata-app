INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`) 
VALUES (
  'act76_child_race:bar:unsuppressed',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_race
  WHERE geo_type = "county"
)
SELECT
  CASE 
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `race` as cat,
  SUM(`value`) as value
FROM data_act76_child_race, latest_date
WHERE 
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (
      (@month_filter = "-- All --" AND MONTH(`month_year`) = latest_date.latest_month) 
      OR MONTH(`month_year`) = @month_filter
  )
  AND (
      (@year_filter = "-- All --" AND YEAR(`month_year`) = latest_date.latest_year) 
      OR YEAR(`month_year`) = @year_filter
  )
  AND (@race_filter = "-- All --" OR `race` COLLATE utf8mb4_unicode_ci = @race_filter)
GROUP BY 
  CASE WHEN @county_filter = "-- All --" THEN `race` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `race` END
ORDER BY 
  CASE WHEN `race` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "race_filter", "title": "Race", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_race:line:unsuppressed" }]},
      {"key": "county_filter", "title": "County"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_race',
  '{
    "table": "data_act76_child_race",
    "filters": {
      "race_filter": {"column": "race"},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_race:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_race
  WHERE geo_type = "county"
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `race` as cat,
  SUM(`value_suppressed`) as value
FROM data_act76_child_race, latest_date
WHERE
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (
      (@month_filter = "-- All --" AND MONTH(`month_year`) = latest_date.latest_month)
      OR MONTH(`month_year`) = @month_filter
  )
  AND (
      (@year_filter = "-- All --" AND YEAR(`month_year`) = latest_date.latest_year)
      OR YEAR(`month_year`) = @year_filter
  )
  AND (@race_filter = "-- All --" OR `race` COLLATE utf8mb4_unicode_ci = @race_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `race` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `race` END
ORDER BY
  CASE WHEN `race` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "race_filter", "title": "Race", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_race:line" }]},
      {"key": "county_filter", "title": "County"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_race',
  '{
    "table": "data_act76_child_race",
    "filters": {
      "race_filter": {"column": "race"},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`) 
VALUES (
  'act76_child_race:line:unsuppressed',
  'SELECT 
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `race` as label,
  SUM(`value`) as value
FROM data_act76_child_race
WHERE 
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@race_filter = "-- All --" OR `race` COLLATE utf8mb4_unicode_ci = @race_filter)
GROUP BY 
  month_year, `race`
ORDER BY 
  month_year, `race`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "race_filter", "title": "Race"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_race',
  '{
    "table": "data_act76_child_race",
    "filters": {
      "race_filter": {"column": "race"},
      "county_filter": {"column": "geography"}
    }
  }'
);

INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`) 
VALUES (
  'act76_child_race:line',
  'SELECT 
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `race` as label,
  SUM(`value_suppressed`) as value
FROM data_act76_child_race
WHERE 
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@race_filter = "-- All --" OR `race` COLLATE utf8mb4_unicode_ci = @race_filter)
GROUP BY 
  month_year, `race`
ORDER BY 
  month_year, `race`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "race_filter", "title": "Race"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_race',
  '{
    "table": "data_act76_child_race",
    "filters": {
      "race_filter": {"column": "race"},
      "county_filter": {"column": "geography"}
    }
  }'
);
