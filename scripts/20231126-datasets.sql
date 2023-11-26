-- regulatedchildcare
CREATE TABLE `data_regulatedchildcare` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `geo_type` VARCHAR(16) NOT NULL,
  `geography` VARCHAR(32) NOT NULL,
  `year` INT NOT NULL,
  `category` enum (
    'Infants in center',
    'Infants in licensed',
    'Infants in registered',
    'Toddlers in center',
    'Toddlers in licensed',
    'Toddlers in registered',
    'Preschoolers in center',
    'Preschoolers in licensed',
    'Preschoolers in registered'
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
    'general:regulatedchildcare',
    'data_regulatedchildcare',
    'geo_type,geography,year,category'
  );

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'regulatedchildcare:chart',
    'SELECT concat(`year`,"-",`year`+1) as `cat`, SUBSTRING_INDEX(category, " ", 1) as `label`, sum(value) as `value` FROM data_regulatedchildcare group by geo_type, geography, `year`, label order by `year`, FIELD(`label`,"Infants","Toddlers","Preschoolers")',
    'general:regulatedchildcare',
    '{"yAxis": {"type": "number"}}'
  );
