-- flourishing_children 6-11y
CREATE TABLE `data_flourishing_children_6_11` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `year` int NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `category` enum ('Meets 0-1', 'Meets 2', 'Meets 3') NOT NULL,
  `percent` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UPDATE_UNIQUE` (`year`, `geography`, `category`) VISIBLE
);

INSERT INTO
  `upload_types` (`type`, `table`, `index_columns`)
VALUES
  (
    'general:flourishing_children_6_11',
    'data_flourishing_children_6_11',
    'year,geography,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'flourishing_children_6_11:table',
    concat(
      'SELECT * FROM `data_flourishing_children_6_11`',
      ' order by `year`, `geography`, `category`'
    ),
    'general:flourishing_children_6_11',
    '{}'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'flourishing_children_6_11:chart',
    'SELECT `geography` as label, `year` as cat, `percent`*100 as value FROM `data_flourishing_children_6_11` where `category`="Meets 3" order by `year`, `geography`, `category`',
    'general:flourishing_children_6_11',
    '{"yAxis": {"type": "percent"}}'
  );

-- updated assessments
-- index sy, org_id, test_name, indicator_label, assess_group, assess_label

ALTER TABLE `upload_types` 
  ADD COLUMN `column_map` VARCHAR(256) NULL AFTER `index_columns`;

update upload_types set column_map='{"value_w": "School Value", "value_w_st":"State Value", "value_w_susd":"Supervisory Union Value"}'
  where `type`='general:assessments';

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'assessments-grade3-langarts:chart',
    '',
    'general:assessments',
    '{"yAxis": {"type": "number"}}'
  );
