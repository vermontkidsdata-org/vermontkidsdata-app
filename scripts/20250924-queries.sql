INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`) 
VALUES (
  'act76_child_race:bar:unsuppressed',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_race
  WHERE geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
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
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
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
  AND `race` != "total"
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
      {"key": "county_filter", "title": "Geography"},
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
      "race_filter": {"column": "race", "exclude": ["total"]},
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
  WHERE geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  CONCAT(race, " (", DATE_FORMAT(month_year, "%b %Y"), ")") as cat,
  SUM(`value_suppressed`) as value
FROM data_act76_child_race, latest_date
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
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
  AND `race` != "total"
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
      {"key": "county_filter", "title": "Geography"},
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
      "race_filter": {"column": "race", "exclude": ["total"]},
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
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
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
      {"key": "county_filter", "title": "Geography"}
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
      "race_filter": {"column": "race", "exclude": ["total"]},
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
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
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
      {"key": "county_filter", "title": "Geography"}
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
      "race_filter": {"column": "race", "exclude": ["total"]},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for total families over time
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_family_total:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_total
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Total Families"
  END as label,
  SUM(total) as value
FROM data_act76_family_total
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "ahsd"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND geography != "Vermont"  -- Exclude Vermont total to avoid double counting
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Total Families"
  END
ORDER BY
  year, month',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "geography_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_total',
  '{
    "table": "data_act76_family_total",
    "filters": {
      "geography_filter": {"column": "geography"}
    }
  }'
);

-- Query for families by service need over time
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_family_service_need:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  service_need as label,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "ahsd"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND (@service_need_filter = "-- All --" OR service_need COLLATE utf8mb4_unicode_ci = @service_need_filter)
  AND geography != "Vermont"  -- Exclude Vermont total to avoid double counting
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month, service_need
ORDER BY
  year, month, service_need',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "geography_filter", "title": "Geography"},
      {"key": "service_need_filter", "title": "Service Need"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "geography_filter": {"column": "geography"},
      "service_need_filter": {"column": "service_need"}
    }
  }'
);

-- Query for families by % of FPL over time
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_family_pct_of_fpl:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_pct_of_fpl
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  pct_of_fpl as label,
  SUM(value_suppressed) as value
FROM data_act76_family_pct_of_fpl
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "ahsd"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND (@pct_of_fpl_filter = "-- All --" OR pct_of_fpl COLLATE utf8mb4_unicode_ci = @pct_of_fpl_filter)
  AND geography != "Vermont"  -- Exclude Vermont total to avoid double counting
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month, pct_of_fpl
ORDER BY
  year, month, pct_of_fpl',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "geography_filter", "title": "Geography"},
      {"key": "pct_of_fpl_filter", "title": "% of FPL"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_pct_of_fpl',
  '{
    "table": "data_act76_family_pct_of_fpl",
    "filters": {
      "geography_filter": {"column": "geography"},
      "pct_of_fpl_filter": {"column": "pct_of_fpl", "xf": "fpl-decimal-to-percent", "exclude": ["total"]}
    }
  }'
);

-- Query for child age data (unsuppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_age:bar:unsuppressed',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_age
  WHERE geo_type = "county"
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `age` as cat,
  SUM(`value`) as value
FROM data_act76_child_age, latest_date
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
  AND (@age_filter = "-- All --" OR `age` COLLATE utf8mb4_unicode_ci = @age_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `age` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `age` END
ORDER BY
  CASE WHEN `age` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "age_filter", "title": "Age", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_age:line:unsuppressed" }]},
      {"key": "county_filter", "title": "County"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_age',
  '{
    "table": "data_act76_child_age",
    "filters": {
      "age_filter": {"column": "age"},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child age data (suppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_age:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_age
  WHERE geo_type = "county"
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `age` as cat,
  SUM(`value_suppressed`) as value
FROM data_act76_child_age, latest_date
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
  AND (@age_filter = "-- All --" OR `age` COLLATE utf8mb4_unicode_ci = @age_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `age` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `age` END
ORDER BY
  CASE WHEN `age` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "age_filter", "title": "Age", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_age:line" }]},
      {"key": "county_filter", "title": "County"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_age',
  '{
    "table": "data_act76_child_age",
    "filters": {
      "age_filter": {"column": "age"},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child age line chart (unsuppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_age:line:unsuppressed',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `age` as label,
  SUM(`value`) as value
FROM data_act76_child_age
WHERE
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@age_filter = "-- All --" OR `age` COLLATE utf8mb4_unicode_ci = @age_filter)
GROUP BY
  month_year, `age`
ORDER BY
  month_year, `age`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "age_filter", "title": "Age"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_age',
  '{
    "table": "data_act76_child_age",
    "filters": {
      "age_filter": {"column": "age"},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for child citizenship data (unsuppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_citizenship:bar:unsuppressed',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_citizenship
  WHERE geo_type = "county"
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `citizenship` as cat,
  SUM(`value`) as value
FROM data_act76_child_citizenship, latest_date
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
  AND (@citizenship_filter = "-- All --" OR `citizenship` COLLATE utf8mb4_unicode_ci = @citizenship_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `citizenship` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `citizenship` END
ORDER BY
  CASE WHEN `citizenship` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "citizenship_filter", "title": "Citizenship", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_citizenship:line:unsuppressed" }]},
      {"key": "county_filter", "title": "County"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_citizenship',
  '{
    "table": "data_act76_child_citizenship",
    "filters": {
      "citizenship_filter": {"column": "citizenship"},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child citizenship data (suppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_citizenship:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_citizenship
  WHERE geo_type = "county"
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `citizenship` as cat,
  SUM(`value_suppressed`) as value
FROM data_act76_child_citizenship, latest_date
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
  AND (@citizenship_filter = "-- All --" OR `citizenship` COLLATE utf8mb4_unicode_ci = @citizenship_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `citizenship` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `citizenship` END
ORDER BY
  CASE WHEN `citizenship` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "citizenship_filter", "title": "Citizenship", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_citizenship:line" }]},
      {"key": "county_filter", "title": "County"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_citizenship',
  '{
    "table": "data_act76_child_citizenship",
    "filters": {
      "citizenship_filter": {"column": "citizenship"},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child citizenship line chart (unsuppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_citizenship:line:unsuppressed',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `citizenship` as label,
  SUM(`value`) as value
FROM data_act76_child_citizenship
WHERE
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@citizenship_filter = "-- All --" OR `citizenship` COLLATE utf8mb4_unicode_ci = @citizenship_filter)
GROUP BY
  month_year, `citizenship`
ORDER BY
  month_year, `citizenship`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "citizenship_filter", "title": "Citizenship"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_citizenship',
  '{
    "table": "data_act76_child_citizenship",
    "filters": {
      "citizenship_filter": {"column": "citizenship"},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for child citizenship line chart (suppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_citizenship:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `citizenship` as label,
  SUM(`value_suppressed`) as value
FROM data_act76_child_citizenship
WHERE
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@citizenship_filter = "-- All --" OR `citizenship` COLLATE utf8mb4_unicode_ci = @citizenship_filter)
GROUP BY
  month_year, `citizenship`
ORDER BY
  month_year, `citizenship`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "citizenship_filter", "title": "Citizenship"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_citizenship',
  '{
    "table": "data_act76_child_citizenship",
    "filters": {
      "citizenship_filter": {"column": "citizenship"},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for child ethnicity data (unsuppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ethnicity:bar:unsuppressed',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_ethnicity
  WHERE geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `ethnicity` as cat,
  SUM(`value`) as value
FROM data_act76_child_ethnicity, latest_date
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (
      (@month_filter = "-- All --" AND MONTH(`month_year`) = latest_date.latest_month)
      OR MONTH(`month_year`) = @month_filter
  )
  AND (
      (@year_filter = "-- All --" AND YEAR(`month_year`) = latest_date.latest_year)
      OR YEAR(`month_year`) = @year_filter
  )
  AND (@ethnicity_filter = "-- All --" OR `ethnicity` COLLATE utf8mb4_unicode_ci = @ethnicity_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `ethnicity` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `ethnicity` END
ORDER BY
  CASE WHEN `ethnicity` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "ethnicity_filter", "title": "Ethnicity", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_ethnicity:line:unsuppressed" }]},
      {"key": "county_filter", "title": "Geography"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_ethnicity',
  '{
    "table": "data_act76_child_ethnicity",
    "filters": {
      "ethnicity_filter": {"column": "ethnicity", "exclude": ["total"]},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child ethnicity data (suppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ethnicity:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_ethnicity
  WHERE geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `ethnicity` as cat,
  SUM(`value_suppressed`) as value
FROM data_act76_child_ethnicity, latest_date
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (
      (@month_filter = "-- All --" AND MONTH(`month_year`) = latest_date.latest_month)
      OR MONTH(`month_year`) = @month_filter
  )
  AND (
      (@year_filter = "-- All --" AND YEAR(`month_year`) = latest_date.latest_year)
      OR YEAR(`month_year`) = @year_filter
  )
  AND (@ethnicity_filter = "-- All --" OR `ethnicity` COLLATE utf8mb4_unicode_ci = @ethnicity_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `ethnicity` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `ethnicity` END
ORDER BY
  CASE WHEN `ethnicity` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "ethnicity_filter", "title": "Ethnicity", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_ethnicity:line" }]},
      {"key": "county_filter", "title": "Geography"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_ethnicity',
  '{
    "table": "data_act76_child_ethnicity",
    "filters": {
      "ethnicity_filter": {"column": "ethnicity", "exclude": ["total"]},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child ethnicity line chart (unsuppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ethnicity:line:unsuppressed',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `ethnicity` as label,
  SUM(`value`) as value
FROM data_act76_child_ethnicity
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@ethnicity_filter = "-- All --" OR `ethnicity` COLLATE utf8mb4_unicode_ci = @ethnicity_filter)
GROUP BY
  month_year, `ethnicity`
ORDER BY
  month_year, `ethnicity`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "ethnicity_filter", "title": "Ethnicity"},
      {"key": "county_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_ethnicity',
  '{
    "table": "data_act76_child_ethnicity",
    "filters": {
      "ethnicity_filter": {"column": "ethnicity", "exclude": ["total"]},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for child ethnicity line chart (suppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ethnicity:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `ethnicity` as label,
  SUM(`value_suppressed`) as value
FROM data_act76_child_ethnicity
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@ethnicity_filter = "-- All --" OR `ethnicity` COLLATE utf8mb4_unicode_ci = @ethnicity_filter)
GROUP BY
  month_year, `ethnicity`
ORDER BY
  month_year, `ethnicity`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "ethnicity_filter", "title": "Ethnicity"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_ethnicity',
  '{
    "table": "data_act76_child_ethnicity",
    "filters": {
      "ethnicity_filter": {"column": "ethnicity", "exclude": ["total"]},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for child gender data (unsuppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_gender:bar:unsuppressed',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_gender
  WHERE geo_type = "county"
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `gender` as cat,
  SUM(`value`) as value
FROM data_act76_child_gender, latest_date
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
  AND (@gender_filter = "-- All --" OR `gender` COLLATE utf8mb4_unicode_ci = @gender_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `gender` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `gender` END
ORDER BY
  CASE WHEN `gender` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "gender_filter", "title": "Gender", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_gender:line:unsuppressed" }]},
      {"key": "county_filter", "title": "County"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_gender',
  '{
    "table": "data_act76_child_gender",
    "filters": {
      "gender_filter": {"column": "gender"},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child gender data (suppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_gender:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_gender
  WHERE geo_type = "county"
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  `gender` as cat,
  SUM(`value_suppressed`) as value
FROM data_act76_child_gender, latest_date
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
  AND (@gender_filter = "-- All --" OR `gender` COLLATE utf8mb4_unicode_ci = @gender_filter)
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `gender` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `gender` END
ORDER BY
  CASE WHEN `gender` = "total" THEN 1 ELSE 0 END,
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "gender_filter", "title": "Gender", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_gender:line" }]},
      {"key": "county_filter", "title": "County"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_gender',
  '{
    "table": "data_act76_child_gender",
    "filters": {
      "gender_filter": {"column": "gender"},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child gender line chart (unsuppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_gender:line:unsuppressed',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `gender` as label,
  SUM(`value`) as value
FROM data_act76_child_gender
WHERE
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@gender_filter = "-- All --" OR `gender` COLLATE utf8mb4_unicode_ci = @gender_filter)
GROUP BY
  month_year, `gender`
ORDER BY
  month_year, `gender`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "gender_filter", "title": "Gender"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_gender',
  '{
    "table": "data_act76_child_gender",
    "filters": {
      "gender_filter": {"column": "gender"},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for child gender line chart (suppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_gender:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `gender` as label,
  SUM(`value_suppressed`) as value
FROM data_act76_child_gender
WHERE
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@gender_filter = "-- All --" OR `gender` COLLATE utf8mb4_unicode_ci = @gender_filter)
GROUP BY
  month_year, `gender`
ORDER BY
  month_year, `gender`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "gender_filter", "title": "Gender"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_gender',
  '{
    "table": "data_act76_child_gender",
    "filters": {
      "gender_filter": {"column": "gender"},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for child age line chart (suppressed)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_age:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `age` as label,
  SUM(`value_suppressed`) as value
FROM data_act76_child_age
WHERE
  geo_type = "county"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@age_filter = "-- All --" OR `age` COLLATE utf8mb4_unicode_ci = @age_filter)
GROUP BY
  month_year, `age`
ORDER BY
  month_year, `age`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "age_filter", "title": "Age"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_age',
  '{
    "table": "data_act76_child_age",
    "filters": {
      "age_filter": {"column": "age"},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query 1: CCFAP Families by County and Service Need (most recent data)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_ccfap_family_county_service_need:bar',
  'WITH latest_date AS (
  SELECT MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
  WHERE geo_type = "county"
)
SELECT
  geography as label,
  CASE
    WHEN @service_need_filter = "-- All --" THEN CONCAT("Total (", DATE_FORMAT(latest_date.max_date, "%b %Y"), ")")
    ELSE CONCAT(service_need, " (", DATE_FORMAT(latest_date.max_date, "%b %Y"), ")")
  END as cat,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN latest_date
WHERE
  geo_type = "county"
  AND geography != "Vermont"
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') = latest_date.max_date
  AND (@service_need_filter = "-- All --" OR service_need COLLATE utf8mb4_unicode_ci = @service_need_filter)
GROUP BY
  geography,
  CASE
    WHEN @service_need_filter = "-- All --" THEN "Total"
    ELSE service_need
  END
ORDER BY
  geography',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Families Receiving CCFAP by County",
    "subtitle": "By Service Need",
    "filters": [
      {"key": "service_need_filter", "title": "Service Need"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "service_need_filter": {"column": "service_need"}
    }
  }'
);

-- Query 2: CCFAP Families by County and % of FPL (most recent data)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_ccfap_family_county_pct_fpl:bar',
  'WITH latest_date AS (
  SELECT MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_pct_of_fpl
  WHERE geo_type = "county"
)
SELECT
  geography as label,
  CASE
    WHEN @pct_of_fpl_filter = "-- All --" THEN CONCAT("Total (", DATE_FORMAT(latest_date.max_date, "%b %Y"), ")")
    ELSE CONCAT(pct_of_fpl, " (", DATE_FORMAT(latest_date.max_date, "%b %Y"), ")")
  END as cat,
  SUM(value_suppressed) as value
FROM data_act76_family_pct_of_fpl
CROSS JOIN latest_date
WHERE
  geo_type = "county"
  AND geography != "Vermont"
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') = latest_date.max_date
  AND (@pct_of_fpl_filter = "-- All --" OR pct_of_fpl COLLATE utf8mb4_unicode_ci = @pct_of_fpl_filter)
GROUP BY
  geography,
  CASE
    WHEN @pct_of_fpl_filter = "-- All --" THEN "Total"
    ELSE pct_of_fpl
  END
ORDER BY
  geography',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Families Receiving CCFAP by County",
    "subtitle": "By % of FPL",
    "filters": [
      {"key": "pct_of_fpl_filter", "title": "% of FPL"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar"]
    }
  }',
  'act76:family_pct_of_fpl',
  '{
    "table": "data_act76_family_pct_of_fpl",
    "filters": {
      "pct_of_fpl_filter": {"column": "pct_of_fpl"}
    }
  }'
);

-- Query 3: CCFAP Families by AHS District and Service Need (most recent data)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_ccfap_family_ahsd_service_need:bar',
  'WITH latest_date AS (
  SELECT MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
  WHERE geo_type IN ("ahsd", "AHS district")
)
SELECT
  geography as label,
  CASE
    WHEN @service_need_filter = "-- All --" THEN CONCAT("Total (", DATE_FORMAT(latest_date.max_date, "%b %Y"), ")")
    ELSE CONCAT(service_need, " (", DATE_FORMAT(latest_date.max_date, "%b %Y"), ")")
  END as cat,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN latest_date
WHERE
  geo_type IN ("ahsd", "AHS district")
  AND geography != "Vermont"
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') = latest_date.max_date
  AND (@service_need_filter = "-- All --" OR service_need COLLATE utf8mb4_unicode_ci = @service_need_filter)
GROUP BY
  geography,
  CASE
    WHEN @service_need_filter = "-- All --" THEN "Total"
    ELSE service_need
  END
ORDER BY
  geography',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Families Receiving CCFAP by AHS District",
    "subtitle": "By Service Need",
    "filters": [
      {"key": "service_need_filter", "title": "Service Need"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "service_need_filter": {"column": "service_need"}
    }
  }'
);

-- Query 4: CCFAP Families by AHS District and % of FPL (most recent data)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_ccfap_family_ahsd_pct_fpl:bar',
  'WITH latest_date AS (
  SELECT MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_pct_of_fpl
  WHERE geo_type IN ("ahsd", "AHS district")
)
SELECT
  geography as label,
  CASE
    WHEN @pct_of_fpl_filter = "-- All --" THEN CONCAT("Total (", DATE_FORMAT(latest_date.max_date, "%b %Y"), ")")
    ELSE CONCAT(pct_of_fpl, " (", DATE_FORMAT(latest_date.max_date, "%b %Y"), ")")
  END as cat,
  SUM(value_suppressed) as value
FROM data_act76_family_pct_of_fpl
CROSS JOIN latest_date
WHERE
  geo_type IN ("ahsd", "AHS district")
  AND geography != "Vermont"
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') = latest_date.max_date
  AND (@pct_of_fpl_filter = "-- All --" OR pct_of_fpl COLLATE utf8mb4_unicode_ci = @pct_of_fpl_filter)
GROUP BY
  geography,
  CASE
    WHEN @pct_of_fpl_filter = "-- All --" THEN "Total"
    ELSE pct_of_fpl
  END
ORDER BY
  geography',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Families Receiving CCFAP by AHS District",
    "subtitle": "By % of FPL",
    "filters": [
      {"key": "pct_of_fpl_filter", "title": "% of FPL"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar"]
    }
  }',
  'act76:family_pct_of_fpl',
  '{
    "table": "data_act76_family_pct_of_fpl",
    "filters": {
      "pct_of_fpl_filter": {"column": "pct_of_fpl"}
    }
  }'
);

-- Query 5: CCFAP Families Over Time - Total
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_ccfap_family_total:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_total
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Total Families"
  END as label,
  SUM(total) as value
FROM data_act76_family_total
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "ahsd"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND geography != "Vermont"
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Total Families"
  END
ORDER BY
  year, month',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Families Receiving CCFAP Over Time",
    "filters": [
      {"key": "geography_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_total',
  '{
    "table": "data_act76_family_total",
    "filters": {
      "geography_filter": {"column": "geography"}
    }
  }'
);

-- Query 6: CCFAP Families Over Time - By Service Need
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_ccfap_family_service_need:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  CASE
    WHEN @service_need_filter != "-- All --" THEN service_need
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Total Families"
  END as label,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "ahsd"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND (@service_need_filter = "-- All --" OR service_need COLLATE utf8mb4_unicode_ci = @service_need_filter)
  AND geography != "Vermont"
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month,
  CASE
    WHEN @service_need_filter != "-- All --" THEN service_need
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Total Families"
  END
ORDER BY
  year, month',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Families Receiving CCFAP Over Time",
    "subtitle": "By Service Need",
    "filters": [
      {"key": "geography_filter", "title": "Geography"},
      {"key": "service_need_filter", "title": "Service Need"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "geography_filter": {"column": "geography"},
      "service_need_filter": {"column": "service_need"}
    }
  }'
);

-- Query 7: CCFAP Families Over Time - By % of FPL
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_ccfap_family_pct_of_fpl:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_pct_of_fpl
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  CASE
    WHEN @pct_of_fpl_filter != "-- All --" THEN pct_of_fpl
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Total Families"
  END as label,
  SUM(value_suppressed) as value
FROM data_act76_family_pct_of_fpl
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "ahsd"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND (@pct_of_fpl_filter = "-- All --" OR pct_of_fpl COLLATE utf8mb4_unicode_ci = @pct_of_fpl_filter)
  AND geography != "Vermont"
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month,
  CASE
    WHEN @pct_of_fpl_filter != "-- All --" THEN pct_of_fpl
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Total Families"
  END
ORDER BY
  year, month',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Families Receiving CCFAP Over Time",
    "subtitle": "By % of FPL",
    "filters": [
      {"key": "geography_filter", "title": "Geography"},
      {"key": "pct_of_fpl_filter", "title": "% of FPL"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_pct_of_fpl',
  '{
    "table": "data_act76_family_pct_of_fpl",
    "filters": {
      "geography_filter": {"column": "geography"},
      "pct_of_fpl_filter": {"column": "pct_of_fpl"}
    }
  }'
);

-- -- Query for Children Receiving CCFAP by Ethnicity Over Time
-- INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
-- VALUES (
--   'act76_child_ethnicity_ccfap:line',
--   'WITH last_18_months AS (
--   SELECT
--     MAX(month_year) as max_date
--   FROM data_act76_child_ethnicity
--   WHERE geo_type = "county"
-- )
-- SELECT
--   CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
--   `ethnicity` as label,
--   SUM(`value_suppressed`) as value
-- FROM data_act76_child_ethnicity
-- CROSS JOIN last_18_months
-- WHERE
--   geo_type = "county"
--   AND `ethnicity` != "total"
--   AND (@ethnicity_filter = "-- All --" OR `ethnicity` COLLATE utf8mb4_unicode_ci = @ethnicity_filter)
--   AND month_year >= DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
-- GROUP BY
--   month_year, `ethnicity`
-- ORDER BY
--   month_year, `ethnicity`',
--   NULL,
--   '{
--     "yAxis": {"type": "number"},
--     "title": "Children Receiving CCFAP by Ethnicity Over Time",
--     "subtitle": "Count of children statewide over time for the last 18 months by ethnicity",
--     "filters": [
--       {"key": "ethnicity_filter", "title": "Ethnicity"}
--     ],
--     "chartTypes": {
--       "default": "line",
--       "allowed": ["line"]
--     }
--   }',
--   'act76:child_ethnicity',
--   '{
--     "table": "data_act76_child_ethnicity",
--     "filters": {
--       "ethnicity_filter": {"column": "ethnicity"}
--     }
--   }'
-- );

-- Query for Children Receiving CCFAP by Citizenship Over Time
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_citizenship_ccfap:line',
  'WITH last_18_months AS (
  SELECT
    MAX(month_year) as max_date
  FROM data_act76_child_citizenship
  WHERE geo_type = "county"
)
SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `citizenship` as label,
  SUM(`value_suppressed`) as value
FROM data_act76_child_citizenship
CROSS JOIN last_18_months
WHERE
  geo_type = "county"
  AND (@citizenship_filter = "-- All --" OR `citizenship` COLLATE utf8mb4_unicode_ci = @citizenship_filter)
  AND month_year >= DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  month_year, `citizenship`
ORDER BY
  month_year, `citizenship`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Children Receiving CCFAP by Citizenship Over Time",
    "subtitle": "Count of children statewide over time for the last 18 months by citizenship",
    "filters": [
      {"key": "citizenship_filter", "title": "Citizenship"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_citizenship',
  '{
    "table": "data_act76_child_citizenship",
    "filters": {
      "citizenship_filter": {"column": "citizenship"}
    }
  }'
);

-- Query for child ethnicity CCFAP data (bar chart)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ethnicity_ccfap:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_ethnicity
  WHERE geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  CONCAT(ethnicity, " (", DATE_FORMAT(month_year, "%b %Y"), ")") as cat,
  SUM(`value_suppressed`) as value
FROM data_act76_child_ethnicity, latest_date
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (
      (@month_filter = "-- All --" AND MONTH(`month_year`) = latest_date.latest_month)
      OR MONTH(`month_year`) = @month_filter
  )
  AND (
      (@year_filter = "-- All --" AND YEAR(`month_year`) = latest_date.latest_year)
      OR YEAR(`month_year`) = @year_filter
  )
  AND (@ethnicity_filter = "-- All --" OR `ethnicity` COLLATE utf8mb4_unicode_ci = @ethnicity_filter)
  AND `ethnicity` != "total"
  AND `ethnicity` != "Native American"
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `ethnicity` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `ethnicity` END
ORDER BY
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "ethnicity_filter", "title": "Ethnicity", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_ethnicity_ccfap:line" }]},
      {"key": "county_filter", "title": "Geography"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_ethnicity',
  '{
    "table": "data_act76_child_ethnicity",
    "filters": {
      "ethnicity_filter": {"column": "ethnicity", "exclude": ["total"]},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child ethnicity CCFAP data (line chart)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ethnicity_ccfap:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `ethnicity` as label,
  SUM(`value_suppressed`) as value
FROM data_act76_child_ethnicity
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@ethnicity_filter = "-- All --" OR `ethnicity` COLLATE utf8mb4_unicode_ci = @ethnicity_filter)
  AND `ethnicity` != "Native American"
GROUP BY
  month_year, `ethnicity`
ORDER BY
  month_year, `ethnicity`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "ethnicity_filter", "title": "Ethnicity"},
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_ethnicity',
  '{
    "table": "data_act76_child_ethnicity",
    "filters": {
      "ethnicity_filter": {"column": "ethnicity", "exclude": ["total"]},
      "county_filter": {"column": "geography"}
    }
  }'
);


-- Query for child age CCFAP data (bar chart - switches to line when age selected)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_age_ccfap:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_age
  WHERE geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  CONCAT(age, " (", DATE_FORMAT(month_year, "%b %Y"), ")") as cat,
  SUM(`value_suppressed`) as value
FROM data_act76_child_age, latest_date
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (
      (@month_filter = "-- All --" AND MONTH(`month_year`) = latest_date.latest_month)
      OR MONTH(`month_year`) = @month_filter
  )
  AND (
      (@year_filter = "-- All --" AND YEAR(`month_year`) = latest_date.latest_year)
      OR YEAR(`month_year`) = @year_filter
  )
  AND (@age_filter = "-- All --" OR `age` COLLATE utf8mb4_unicode_ci = @age_filter)
  AND `age` != "total"
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN `age` ELSE `geography` END,
  CASE WHEN @county_filter = "-- All --" THEN 1 ELSE `age` END
ORDER BY
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "age_filter", "title": "Age", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_age_ccfap:line" }]},
      {"key": "county_filter", "title": "Geography"},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_age',
  '{
    "table": "data_act76_child_age",
    "filters": {
      "age_filter": {"column": "age", "exclude": ["total"]},
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for child age CCFAP data (line chart)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_age_ccfap:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  `age` as label,
  SUM(`value_suppressed`) as value
FROM data_act76_child_age
WHERE
  geo_type = CASE
    WHEN @county_filter = "-- All --" THEN "county"
    WHEN @county_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                           "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                           "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (@age_filter = "-- All --" OR `age` COLLATE utf8mb4_unicode_ci = @age_filter)
GROUP BY
  month_year, `age`
ORDER BY
  month_year, `age`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "age_filter", "title": "Age"},
      {"key": "county_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_age',
  '{
    "table": "data_act76_child_age",
    "filters": {
      "age_filter": {"column": "age", "exclude": ["total"]},
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for Children Receiving CCFAP by County (bar chart)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ccfap_total:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_total
  WHERE geo_type = "county"
)
SELECT
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont"
    ELSE `geography`
  END as label,
  CONCAT("Total (", DATE_FORMAT(month_year, "%b %Y"), ")") as cat,
  SUM(`total`) as value
FROM data_act76_child_total, latest_date
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
GROUP BY
  CASE WHEN @county_filter = "-- All --" THEN "Total" ELSE `geography` END
ORDER BY
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Children Receiving CCFAP by County",
    "filters": [
      {"key": "county_filter", "title": "Geography", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_ccfap_total:line" }]},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_total',
  '{
    "table": "data_act76_child_total",
    "filters": {
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for Children Receiving CCFAP by County (line chart)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ccfap_total:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont Total"
    ELSE `geography`
  END as label,
  SUM(`total`) as value
FROM data_act76_child_total
WHERE
  (geo_type = "county" OR geo_type = "AHS district")
  AND geography != "Vermont"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
GROUP BY
  month_year,
  CASE WHEN @county_filter = "-- All --" THEN "Vermont Total" ELSE `geography` END
ORDER BY
  month_year, `geography`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Children Receiving CCFAP Over Time",
    "filters": [
      {"key": "county_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_total',
  '{
    "table": "(SELECT * FROM data_act76_child_total WHERE (geo_type = \\\"county\\\" OR geo_type = \\\"AHS district\\\") AND geography != \\\"Vermont\\\") filtered_total",
    "filters": {
      "county_filter": {"column": "geography"}
    }
  }'
);


-- Query for Children Receiving CCFAP by County (bar chart - switches to line when county selected)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ccfap_county:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_total
  WHERE geo_type = "county"
)
SELECT
  `geography` as label,
  CONCAT("Total (", DATE_FORMAT(month_year, "%b %Y"), ")") as cat,
  SUM(`total`) as value
FROM data_act76_child_total, latest_date
WHERE
  geo_type = "county"
  AND geography != "Vermont"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
  AND (
      (@month_filter = "-- All --" AND MONTH(`month_year`) = latest_date.latest_month)
      OR MONTH(`month_year`) = @month_filter
  )
  AND (
      (@year_filter = "-- All --" AND YEAR(`month_year`) = latest_date.latest_year)
      OR YEAR(`month_year`) = @year_filter
  )
GROUP BY
  `geography`
ORDER BY
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Children Receiving CCFAP by County",
    "filters": [
      {"key": "county_filter", "title": "County", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_ccfap_county:line" }]},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_total_county',
  '{
    "table": "(SELECT * FROM data_act76_child_total WHERE geo_type = \\\"county\\\" AND geography != \\\"Vermont\\\") filtered_total",
    "filters": {
      "county_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for Children Receiving CCFAP by County (line chart)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ccfap_county:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  CASE
    WHEN @county_filter = "-- All --" THEN "Vermont Total"
    ELSE `geography`
  END as label,
  SUM(`total`) as value
FROM data_act76_child_total
WHERE
  geo_type = "county"
  AND geography != "Vermont"
  AND (@county_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @county_filter)
GROUP BY
  month_year,
  CASE WHEN @county_filter = "-- All --" THEN "Vermont Total" ELSE `geography` END
ORDER BY
  month_year, `geography`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Children Receiving CCFAP Over Time",
    "filters": [
      {"key": "county_filter", "title": "County"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_total_county',
  '{
    "table": "(SELECT * FROM data_act76_child_total WHERE geo_type = \\\"county\\\" AND geography != \\\"Vermont\\\") filtered_total",
    "filters": {
      "county_filter": {"column": "geography"}
    }
  }'
);

-- Query for Children Receiving CCFAP by AHS District (bar chart - switches to line when district selected)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ccfap_ahsd:bar',
  'WITH latest_date AS (
  SELECT MAX(month_year) as max_date,
         MONTH(MAX(month_year)) as latest_month,
         YEAR(MAX(month_year)) as latest_year
  FROM data_act76_child_total
  WHERE geo_type = "AHS district"
)
SELECT
  `geography` as label,
  CONCAT("Total (", DATE_FORMAT(month_year, "%b %Y"), ")") as cat,
  SUM(`total`) as value
FROM data_act76_child_total, latest_date
WHERE
  geo_type = "AHS district"
  AND geography != "Vermont"
  AND (@ahsd_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @ahsd_filter)
  AND (
      (@month_filter = "-- All --" AND MONTH(`month_year`) = latest_date.latest_month)
      OR MONTH(`month_year`) = @month_filter
  )
  AND (
      (@year_filter = "-- All --" AND YEAR(`month_year`) = latest_date.latest_year)
      OR YEAR(`month_year`) = @year_filter
  )
GROUP BY
  `geography`
ORDER BY
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Children Receiving CCFAP by AHS District",
    "filters": [
      {"key": "ahsd_filter", "title": "AHS District", "ifSelected": [{"disable": ["month_filter", "year_filter"] }, {"query": "act76_child_ccfap_ahsd:line" }]},
      {"key": "month_filter", "title": "Month"},
      {"key": "year_filter", "title": "Year"}
    ],
    "chartTypes": {
      "default": "bar",
      "allowed": ["bar", "line"]
    }
  }',
  'act76:child_total_ahsd',
  '{
    "table": "(SELECT * FROM data_act76_child_total WHERE geo_type = \\\"AHS district\\\" AND geography != \\\"Vermont\\\") filtered_total",
    "filters": {
      "ahsd_filter": {"column": "geography"},
      "month_filter": {"column": "month", "sort": "number"},
      "year_filter": {"column": "year", "sort": "number"}
    }
  }'
);

-- Query for Children Receiving CCFAP by AHS District (line chart)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'act76_child_ccfap_ahsd:line',
  'SELECT
  CONCAT(MONTHNAME(month_year), '' '', YEAR(month_year)) as cat,
  CASE
    WHEN @ahsd_filter = "-- All --" THEN "Vermont Total"
    ELSE `geography`
  END as label,
  SUM(`total`) as value
FROM data_act76_child_total
WHERE
  geo_type = "AHS district"
  AND geography != "Vermont"
  AND (@ahsd_filter = "-- All --" OR `geography` COLLATE utf8mb4_unicode_ci = @ahsd_filter)
GROUP BY
  month_year,
  CASE WHEN @ahsd_filter = "-- All --" THEN "Vermont Total" ELSE `geography` END
ORDER BY
  month_year, `geography`',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "title": "Children Receiving CCFAP Over Time",
    "filters": [
      {"key": "ahsd_filter", "title": "AHS District"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:child_total_ahsd',
  '{
    "table": "(SELECT * FROM data_act76_child_total WHERE geo_type = \\\"AHS district\\\" AND geography != \\\"Vermont\\\") filtered_total",
    "filters": {
      "ahsd_filter": {"column": "geography"}
    }
  }'
);


-- Query for families receiving CCFAP by service need over time (column chart)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'ccfap_families_service_need:column',
  'WITH latest_date AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
)
SELECT
  service_need as label,
  CONCAT(
    CASE
      WHEN @geography_filter != "-- All --" THEN geography
      ELSE "Vermont"
    END,
    " (",
    MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')),
    " ",
    year,
    ")"
  ) as cat,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN latest_date
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND service_need != "total"  -- Exclude total to show individual categories
  AND geography != "Vermont"  -- Exclude Vermont total to avoid double counting when aggregating
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') = latest_date.max_date
GROUP BY
  service_need,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END
ORDER BY
  value DESC',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "geography_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "column",
      "allowed": ["column", "bar"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "geography_filter": {"column": "geography"}
    }
  }'
);


-- Query for families receiving CCFAP by service need: Working (line chart over time)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'ccfap_families_working:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END as label,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND service_need = "Working"  -- Filter specifically for Working service need
  AND geography != "Vermont"  -- Exclude Vermont total to avoid double counting when aggregating
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END
ORDER BY
  year, month',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "geography_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "geography_filter": {"column": "geography"}
    }
  }'
);


-- Query for families receiving CCFAP by service need: Self-Employed (line chart over time)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'ccfap_families_self_employed:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END as label,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND service_need = "Self employed"  -- Filter specifically for Self employed service need
  AND geography != "Vermont"  -- Exclude Vermont total to avoid double counting when aggregating
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END
ORDER BY
  year, month',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "geography_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "geography_filter": {"column": "geography"}
    }
  }'
);


-- Query for families receiving CCFAP by service need: Family Support (line chart over time)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'ccfap_families_family_support:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END as label,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND service_need = "Family Support"  -- Filter specifically for Family Support service need
  AND geography != "Vermont"  -- Exclude Vermont total to avoid double counting when aggregating
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END
ORDER BY
  year, month',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "geography_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "geography_filter": {"column": "geography"}
    }
  }'
);

-- Query for families receiving CCFAP by service need: Reach Up (line chart over time)
INSERT INTO `queries` (`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`)
VALUES (
  'ccfap_families_reach_up:line',
  'WITH last_18_months AS (
  SELECT
    MAX(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')) as max_date
  FROM data_act76_family_service_need
)
SELECT
  CONCAT(MONTHNAME(STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'')), '' '', year) as cat,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END as label,
  SUM(value_suppressed) as value
FROM data_act76_family_service_need
CROSS JOIN last_18_months
WHERE
  geo_type = CASE
    WHEN @geography_filter = "-- All --" THEN "county"
    WHEN @geography_filter IN ("Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
                               "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
                               "Windham", "Windsor") THEN "county"
    ELSE "AHS district"
  END
  AND (@geography_filter = "-- All --" OR geography COLLATE utf8mb4_unicode_ci = @geography_filter)
  AND service_need = "Reach up"  -- Filter specifically for Reach up service need
  AND geography != "Vermont"  -- Exclude Vermont total to avoid double counting when aggregating
  AND STR_TO_DATE(CONCAT(year, ''-'', LPAD(month, 2, ''0''), ''-01''), ''%Y-%m-%d'') >=
      DATE_SUB(last_18_months.max_date, INTERVAL 18 MONTH)
GROUP BY
  year, month,
  CASE
    WHEN @geography_filter != "-- All --" THEN geography
    ELSE "Vermont"
  END
ORDER BY
  year, month',
  NULL,
  '{
    "yAxis": {"type": "number"},
    "filters": [
      {"key": "geography_filter", "title": "Geography"}
    ],
    "chartTypes": {
      "default": "line",
      "allowed": ["line"]
    }
  }',
  'act76:family_service_need',
  '{
    "table": "data_act76_family_service_need",
    "filters": {
      "geography_filter": {"column": "geography"}
    }
  }'
);
