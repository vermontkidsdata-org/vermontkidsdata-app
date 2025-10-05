-- INSERT statements for Act 76 Child Demo Breakdown by County and AHS District SFY 25 Q2.xlsx and child-fy25q2.xlsx
-- Generated on 2025-09-24 19:07:10

INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Addison', 'Infant', 96, 96.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Preschool', 276, 276.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'School', 206, 206),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Toddler', 87, 87),
('2024-12-01', 12, 2024, 'county', 'Addison', 'total', 665.0, 665.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Infant', 150, 150.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Preschool', 338, 338.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'School', 181, 181),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Toddler', 106, 106),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'total', 775.0, 775.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Infant', 121, 121.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Preschool', 280, 280.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'School', 271, 271),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Toddler', 96, 96),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'total', 768.0, 768.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Infant', 423, 423.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Preschool', 894, 894.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'School', 733, 733),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Toddler', 318, 318),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'total', 2368.0, 2368.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Essex', 'Infant', 21, 21.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Preschool', 49, 49.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'School', 25, 25),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Toddler', 13, 13),
('2024-12-01', 12, 2024, 'county', 'Essex', 'total', 108.0, 108.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Infant', 147, 147.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Preschool', 323, 323.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'School', 235, 235),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Toddler', 121, 121),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'total', 826.0, 826.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Infant', 18, 18.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Preschool', 41, 41.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'School', 36, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Toddler', 7, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'total', 102.0, 59.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Infant', 87, 87.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Preschool', 204, 204.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'School', 125, 125),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Toddler', 64, 64),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'total', 480.0, 480.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orange', 'Infant', 73, 73.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Preschool', 152, 152.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'School', 92, 92),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Toddler', 70, 70),
('2024-12-01', 12, 2024, 'county', 'Orange', 'total', 387.0, 387.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Infant', 90, 90.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Preschool', 189, 189.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'School', 151, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Toddler', 62, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'total', 492.0, 279.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Infant', 192, 192.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Preschool', 429, 429.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'School', 345, 345),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Toddler', 150, 150),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'total', 1116.0, 1116.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Washington', 'Infant', 112, 112.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Preschool', 264, 264.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'School', 146, 146),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Toddler', 88, 88),
('2024-12-01', 12, 2024, 'county', 'Washington', 'total', 610.0, 610.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windham', 'Infant', 138, 138.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Preschool', 299, 299.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'School', 125, 125),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Toddler', 117, 117),
('2024-12-01', 12, 2024, 'county', 'Windham', 'total', 679.0, 679.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Infant', 118, 118.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Preschool', 279, 279.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'School', 272, 272),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Toddler', 109, 109),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'total', 778.0, 778.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Addison', 'Infant', 106, 106.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Preschool', 282, 282.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'School', 209, 209),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Toddler', 82, 82),
('2024-11-01', 11, 2024, 'county', 'Addison', 'total', 679.0, 679.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Infant', 149, 149.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Preschool', 323, 323.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'School', 179, 179),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Toddler', 111, 111),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'total', 762.0, 762.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Infant', 124, 124.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Preschool', 281, 281.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'School', 268, 268),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Toddler', 97, 97),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'total', 770.0, 770.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Infant', 430, 430.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Preschool', 874, 874.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'School', 716, 716),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Toddler', 309, 309),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'total', 2329.0, 2329.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Essex', 'Infant', 22, 22.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Preschool', 49, 49.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'School', 26, 26),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Toddler', 13, 13),
('2024-11-01', 11, 2024, 'county', 'Essex', 'total', 110.0, 110.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Infant', 140, 140.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Preschool', 318, 318.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'School', 235, 235),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Toddler', 116, 116),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'total', 809.0, 809.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Infant', 15, 15.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Preschool', 40, 40.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'School', 33, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Toddler', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'total', 94.0, 55.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Infant', 94, 94.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Preschool', 208, 208.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'School', 121, 121),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Toddler', 64, 64),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'total', 487.0, 487.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orange', 'Infant', 76, 76.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Preschool', 149, 149.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'School', 87, 87),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Toddler', 71, 71),
('2024-11-01', 11, 2024, 'county', 'Orange', 'total', 383.0, 383.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Infant', 87, 87.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Preschool', 188, 188.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'School', 148, 148),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Toddler', 68, 68),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'total', 491.0, 491.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Infant', 186, 186.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Preschool', 437, 437.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'School', 361, 361),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Toddler', 147, 147),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'total', 1131.0, 1131.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Washington', 'Infant', 113, 113.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Preschool', 270, 270.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'School', 144, 144),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Toddler', 78, 78),
('2024-11-01', 11, 2024, 'county', 'Washington', 'total', 605.0, 605.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windham', 'Infant', 145, 145.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Preschool', 297, 297.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'School', 121, 121),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Toddler', 111, 111),
('2024-11-01', 11, 2024, 'county', 'Windham', 'total', 674.0, 674.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Infant', 123, 123.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Preschool', 281, 281.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'School', 274, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Toddler', 111, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'total', 789.0, 404.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Addison', 'Infant', 140, 140.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Preschool', 275, 275.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'School', 196, 196),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Toddler', 103, 103),
('2024-10-01', 10, 2024, 'county', 'Addison', 'total', 714.0, 714.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Infant', 137, 137.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Preschool', 310, 310.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'School', 206, 206),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Toddler', 117, 117),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'total', 770.0, 770.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Infant', 154, 154.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Preschool', 337, 337.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'School', 255, 255),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Toddler', 116, 116),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'total', 862.0, 862.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Infant', 438, 438.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Preschool', 847, 847.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'School', 649, 649),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Toddler', 317, 317),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'total', 2251.0, 2251.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Essex', 'Infant', 24, 24.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Preschool', 59, 59.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'School', 39, 39),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Toddler', 20, 20),
('2024-10-01', 10, 2024, 'county', 'Essex', 'total', 142.0, 142.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Infant', 144, 144.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Preschool', 313, 313.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'School', 241, 241),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Toddler', 118, 118),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'total', 816.0, 816.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Infant', 14, 14.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Preschool', 32, 32.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'School', 29, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Toddler', 9, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'total', 84.0, 46.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Infant', 88, 88.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Preschool', 248, 248.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'School', 165, 165),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Toddler', 71, 71),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'total', 572.0, 572.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orange', 'Infant', 71, 71.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Preschool', 142, 142.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'School', 100, 100),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Toddler', 50, 50),
('2024-10-01', 10, 2024, 'county', 'Orange', 'total', 363.0, 363.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Infant', 78, 78.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Preschool', 174, 174.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'School', 121, 121),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Toddler', 54, 54),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'total', 427.0, 427.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Infant', 174, 174.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Preschool', 411, 411.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'School', 316, 316),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Toddler', 161, 161),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'total', 1062.0, 1062.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Washington', 'Infant', 82, 82.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Preschool', 181, 181.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'School', 142, 142),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Toddler', 63, 63),
('2024-10-01', 10, 2024, 'county', 'Washington', 'total', 468.0, 468.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windham', 'Infant', 91, 91.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Preschool', 227, 227.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'School', 189, 189),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Toddler', 82, 82),
('2024-10-01', 10, 2024, 'county', 'Windham', 'total', 589.0, 589.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Infant', 133, 133.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Preschool', 299, 299.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'School', 209, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Toddler', 75, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'total', 716.0, 432.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Infant', 122, 122.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Preschool', 284, 284.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'School', 156, 156.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Toddler', 98, 98.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'total', 660.0, 660.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Infant', 150, 150.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Preschool', 338, 338.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'School', 181, 181.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Toddler', 106, 106.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'total', 775.0, 775.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Infant', 112, 112.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Preschool', 242, 242.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'School', 107, 107.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Toddler', 99, 99.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'total', 560.0, 560.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Infant', 423, 423.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Preschool', 894, 894.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'School', 733, 733.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Toddler', 318, 318.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'total', 2368.0, 2368.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Infant', 112, 112.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Preschool', 193, 193.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'School', 162, 162.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Toddler', 100, 100.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'total', 567.0, 567.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Infant', 96, 96.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Preschool', 276, 276.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'School', 206, 206.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Toddler', 87, 87.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'total', 665.0, 665.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Infant', 101, 101.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Preschool', 240, 240.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'School', 139, 139.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Toddler', 88, 88.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'total', 568.0, 568.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Infant', 87, 87.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Preschool', 191, 191.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'School', 154, 154.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Toddler', 54, 54.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'total', 486.0, 486.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Infant', 192, 192.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Preschool', 429, 429.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'School', 345, 345.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Toddler', 150, 150.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'total', 1116.0, 1116.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Infant', 88, 88.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Preschool', 254, 254.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'School', 198, 198.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Toddler', 78, 78.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'total', 618.0, 618.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Infant', 165, 165.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Preschool', 364, 364.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'School', 271, 271.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Toddler', 128, 128.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'total', 928.0, 928.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Infant', 138, 138.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Preschool', 312, 312.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'School', 291, 291.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Toddler', 102, 102.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 843.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Infant', 123, 123.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Preschool', 293, 293.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'School', 156, 156.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Toddler', 86, 86.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'total', 658.0, 658.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Infant', 149, 149.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Preschool', 323, 323.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'School', 179, 179.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Toddler', 111, 111.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'total', 762.0, 762.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Infant', 117, 117.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Preschool', 237, 237.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'School', 105, 105.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Toddler', 96, 96.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'total', 555.0, 555.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Infant', 430, 430.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Preschool', 874, 874.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'School', 716, 716.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Toddler', 309, 309.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'total', 2329.0, 2329.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Infant', 122, 122.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Preschool', 189, 189.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'School', 156, 156.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Toddler', 97, 97.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'total', 564.0, 564.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Infant', 106, 106.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Preschool', 282, 282.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'School', 209, 209.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Toddler', 82, 82.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'total', 679.0, 679.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Infant', 111, 111.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Preschool', 241, 241.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'School', 135, 135.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Toddler', 86, 86.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'total', 573.0, 573.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Infant', 82, 82.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Preschool', 192, 192.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'School', 152, 152.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Toddler', 61, 61.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'total', 487.0, 487.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Infant', 186, 186.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Preschool', 437, 437.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'School', 361, 361.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Toddler', 147, 147.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'total', 1131.0, 1131.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Infant', 88, 88.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Preschool', 261, 261.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'School', 199, 199.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Toddler', 81, 81.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'total', 629.0, 629.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Infant', 155, 155.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Preschool', 358, 358.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'School', 268, 268.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Toddler', 122, 122.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'total', 903.0, 903.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Infant', 141, 141.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Preschool', 310, 310.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'School', 286, 286.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Toddler', 106, 106.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 843.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Infant', 90, 90.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Preschool', 197, 197.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'School', 150, 150.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Toddler', 68, 68.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'total', 505.0, 505.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Infant', 137, 137.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Preschool', 310, 310.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'School', 206, 206.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Toddler', 117, 117.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'total', 770.0, 770.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Infant', 71, 71.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Preschool', 176, 176.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'School', 149, 149.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Toddler', 61, 61.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'total', 457.0, 457.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Infant', 438, 438.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Preschool', 847, 847.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'School', 649, 649.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Toddler', 317, 317.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'total', 2251.0, 2251.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Infant', 111, 111.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Preschool', 218, 218.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'School', 160, 160.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Toddler', 74, 74.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'total', 563.0, 563.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Infant', 140, 140.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Preschool', 275, 275.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'School', 196, 196.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Toddler', 103, 103.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'total', 714.0, 714.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Infant', 96, 96.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Preschool', 267, 267.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'School', 187, 187.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Toddler', 81, 81.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'total', 631.0, 631.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Infant', 79, 79.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Preschool', 174, 174.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'School', 117, 117.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Toddler', 52, 52.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'total', 422.0, 422.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Infant', 174, 174.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Preschool', 411, 411.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'School', 316, 316.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Toddler', 161, 161.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'total', 1062.0, 1062.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Infant', 97, 97.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Preschool', 243, 243.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'School', 169, 169.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Toddler', 61, 61.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'total', 570.0, 570.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Infant', 158, 158.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Preschool', 345, 345.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'School', 270, 270.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Toddler', 127, 127.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'total', 900.0, 900.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Infant', 177, 177.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Preschool', 392, 392.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'School', 288, 288.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Toddler', 134, 134.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'total', 991.0, 991.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Addison', 'None of the above', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Qualified Immigrant', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'US Citizen', 630, 630.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Unreported', 34, 34),
('2024-12-01', 12, 2024, 'county', 'Addison', 'total', 665.0, 664.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Bennington', 'None of the above', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Qualified Immigrant', 8, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'US Citizen', 684, 684.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Unreported', 82, 82),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'total', 775.0, 766.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'US Citizen', 732, 732.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Unreported', 35, 35),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'total', 768.0, 767.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'None of the above', 11, 11),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Qualified Immigrant', 51, 51),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'US Citizen', 2192, 2192.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Unreported', 114, 114),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'total', 2368.0, 2368.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Essex', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Qualified Immigrant', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'US Citizen', 101, 101.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Unreported', 7, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'total', 108.0, 101.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Franklin', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Qualified Immigrant', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'US Citizen', 764, 764.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Unreported', 62, 62),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'total', 826.0, 826.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Qualified Immigrant', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'US Citizen', 94, 94.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Unreported', 8, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'total', 102.0, 94.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'None of the above', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'US Citizen', 458, 458.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Unreported', 19, 19),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'total', 480.0, 477.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orange', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'US Citizen', 368, 368.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Unreported', 18, 18),
('2024-12-01', 12, 2024, 'county', 'Orange', 'total', 387.0, 386.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orleans', 'None of the above', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'US Citizen', 467, 467.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Unreported', 23, 23),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'total', 492.0, 490.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Rutland', 'None of the above', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Qualified Immigrant', 18, 18),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'US Citizen', 1019, 1019.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Unreported', 78, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'total', 1116.0, 1037.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Washington', 'None of the above', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Qualified Immigrant', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'US Citizen', 567, 567.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Unreported', 36, 36),
('2024-12-01', 12, 2024, 'county', 'Washington', 'total', 610.0, 603.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windham', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Qualified Immigrant', 6, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'US Citizen', 636, 636.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Unreported', 37, 37),
('2024-12-01', 12, 2024, 'county', 'Windham', 'total', 679.0, 673.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windsor', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'US Citizen', 746, 746.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Unreported', 31, 31),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'total', 778.0, 777.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Addison', 'None of the above', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Qualified Immigrant', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'US Citizen', 643, 643.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Unreported', 35, 35),
('2024-11-01', 11, 2024, 'county', 'Addison', 'total', 679.0, 678.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Bennington', 'None of the above', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Qualified Immigrant', 8, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'US Citizen', 675, 675.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Unreported', 78, 78),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'total', 762.0, 753.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'US Citizen', 735, 735.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Unreported', 34, 34),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'total', 770.0, 769.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'None of the above', 10, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Qualified Immigrant', 51, 51),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'US Citizen', 2154, 2154.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Unreported', 114, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'total', 2329.0, 2205.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Essex', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Qualified Immigrant', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'US Citizen', 103, 103.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Unreported', 7, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'total', 110.0, 103.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Franklin', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Qualified Immigrant', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'US Citizen', 745, 745.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Unreported', 64, 64),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'total', 809.0, 809.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Qualified Immigrant', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'US Citizen', 86, 86.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Unreported', 8, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'total', 94.0, 86.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'None of the above', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'US Citizen', 463, 463.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Unreported', 21, 21),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'total', 487.0, 484.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orange', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'US Citizen', 364, 364.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Unreported', 18, 18),
('2024-11-01', 11, 2024, 'county', 'Orange', 'total', 383.0, 382.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orleans', 'None of the above', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'US Citizen', 466, 466.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Unreported', 23, 23),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'total', 491.0, 489.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Rutland', 'None of the above', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Qualified Immigrant', 27, 27),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'US Citizen', 1024, 1024.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Unreported', 79, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'total', 1131.0, 1051.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Washington', 'None of the above', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Qualified Immigrant', 4, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'US Citizen', 562, 562.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Unreported', 36, 36),
('2024-11-01', 11, 2024, 'county', 'Washington', 'total', 605.0, 598.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windham', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Qualified Immigrant', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'US Citizen', 632, 632.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Unreported', 36, 36),
('2024-11-01', 11, 2024, 'county', 'Windham', 'total', 674.0, 668.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windsor', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'US Citizen', 756, 756.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Unreported', 32, 32),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'total', 789.0, 788.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Addison', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Qualified Immigrant', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'US Citizen', 660, 660.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Unreported', 50, 50),
('2024-10-01', 10, 2024, 'county', 'Addison', 'total', 714.0, 710.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Bennington', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Qualified Immigrant', 8, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'US Citizen', 708, 708.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Unreported', 53, 53),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'total', 770.0, 761.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Qualified Immigrant', 11, 11),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'US Citizen', 799, 799.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Unreported', 51, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'total', 862.0, 810.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'None of the above', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Qualified Immigrant', 21, 21),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'US Citizen', 2086, 2086.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Unreported', 138, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'total', 2251.0, 2107.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Essex', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Qualified Immigrant', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'US Citizen', 134, 134.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Unreported', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'total', 142.0, 134.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Franklin', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Qualified Immigrant', 10, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'US Citizen', 753, 753.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Unreported', 52, 52),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'total', 816.0, 805.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Qualified Immigrant', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'US Citizen', 80, 80.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Unreported', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'total', 84.0, 80.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Qualified Immigrant', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'US Citizen', 538, 538.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Unreported', 29, 29),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'total', 572.0, 567.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orange', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Qualified Immigrant', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'US Citizen', 332, 332.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Unreported', 25, 25),
('2024-10-01', 10, 2024, 'county', 'Orange', 'total', 363.0, 357.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orleans', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Qualified Immigrant', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'US Citizen', 398, 398.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Unreported', 25, 25),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'total', 427.0, 423.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Rutland', 'None of the above', 7, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Qualified Immigrant', 10, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'US Citizen', 980, 980.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Unreported', 65, 65),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'total', 1062.0, 1045.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Washington', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Qualified Immigrant', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'US Citizen', 437, 437.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Unreported', 28, 28),
('2024-10-01', 10, 2024, 'county', 'Washington', 'total', 468.0, 465.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windham', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Qualified Immigrant', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'US Citizen', 548, 548.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Unreported', 35, 35),
('2024-10-01', 10, 2024, 'county', 'Windham', 'total', 589.0, 583.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windsor', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Qualified Immigrant', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'US Citizen', 666, 666.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Unreported', 44, 44),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'total', 716.0, 710.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'None of the above', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Qualified Immigrant', 4, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'US Citizen', 614, 614.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Unreported', 39, 39.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'total', 660.0, 653.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'None of the above', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Qualified Immigrant', 8, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'US Citizen', 684, 684.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Unreported', 82, 82.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'total', 775.0, 766.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Qualified Immigrant', 5, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'US Citizen', 525, 525.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 30, 30.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'total', 560.0, 555.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'None of the above', 11, 11),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Qualified Immigrant', 51, 51),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'US Citizen', 2192, 2192.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Unreported', 114, 114.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'total', 2368.0, 2368.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Qualified Immigrant', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'US Citizen', 540, 540.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Unreported', 25, 25.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'total', 567.0, 565.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'None of the above', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Qualified Immigrant', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'US Citizen', 630, 630.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Unreported', 34, 34.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'total', 665.0, 664.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'None of the above', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'US Citizen', 541, 541.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Unreported', 24, 24.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'total', 568.0, 565.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'None of the above', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'US Citizen', 459, 459.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Unreported', 25, 25.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'total', 486.0, 484.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'None of the above', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Qualified Immigrant', 18, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'US Citizen', 1019, 1019.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Unreported', 78, 78.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'total', 1116.0, 1097.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'US Citizen', 590, 590.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Unreported', 27, 27.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'total', 618.0, 617.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Qualified Immigrant', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'US Citizen', 858, 858.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Unreported', 70, 70.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'total', 928.0, 928.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'None of the above', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Qualified Immigrant', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'US Citizen', 806, 806.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 36, 36.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 842.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'None of the above', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Qualified Immigrant', 4, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'US Citizen', 614, 614.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Unreported', 39, 39.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'total', 660.0, 653.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'None of the above', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Qualified Immigrant', 8, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'US Citizen', 684, 684.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Unreported', 82, 82.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'total', 775.0, 766.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Qualified Immigrant', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'US Citizen', 525, 525.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 30, 30.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'total', 560.0, 555.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'None of the above', 11, 11),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Qualified Immigrant', 51, 51),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'US Citizen', 2192, 2192.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Unreported', 114, 114.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'total', 2368.0, 2368.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Qualified Immigrant', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'US Citizen', 540, 540.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Unreported', 25, 25.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'total', 567.0, 565.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'None of the above', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Qualified Immigrant', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'US Citizen', 630, 630.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Unreported', 34, 34.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'total', 665.0, 664.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'None of the above', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'US Citizen', 541, 541.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Unreported', 24, 24.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'total', 568.0, 565.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'None of the above', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'US Citizen', 459, 459.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Unreported', 25, 25.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'total', 486.0, 484.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'None of the above', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Qualified Immigrant', 18, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'US Citizen', 1019, 1019.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Unreported', 78, 78.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'total', 1116.0, 1097.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'US Citizen', 590, 590.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Unreported', 27, 27.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'total', 618.0, 617.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Qualified Immigrant', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'US Citizen', 858, 858.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Unreported', 70, 70.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'total', 928.0, 928.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'None of the above', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Qualified Immigrant', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'US Citizen', 806, 806.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 36, 36.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 842.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Qualified Immigrant', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'US Citizen', 469, 469.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Unreported', 32, 32.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'total', 505.0, 501.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Qualified Immigrant', 8, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'US Citizen', 708, 708.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Unreported', 53, 53.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'total', 770.0, 761.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Qualified Immigrant', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'US Citizen', 426, 426.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 26, 26.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'total', 457.0, 452.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'None of the above', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Qualified Immigrant', 21, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'US Citizen', 2086, 2086.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Unreported', 138, 138.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'total', 2251.0, 2224.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Qualified Immigrant', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'US Citizen', 519, 519.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Unreported', 38, 38.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'total', 563.0, 557.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Qualified Immigrant', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'US Citizen', 660, 660.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Unreported', 50, 50.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'total', 714.0, 710.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Qualified Immigrant', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'US Citizen', 595, 595.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Unreported', 31, 31.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'total', 631.0, 626.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Qualified Immigrant', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'US Citizen', 392, 392.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Unreported', 26, 26.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'total', 422.0, 418.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'None of the above', 7, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Qualified Immigrant', 10, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'US Citizen', 980, 980.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Unreported', 65, 65.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'total', 1062.0, 1045.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'None of the above', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Qualified Immigrant', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'US Citizen', 533, 533.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Unreported', 32, 32.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'total', 570.0, 565.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Qualified Immigrant', 10, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'US Citizen', 833, 833.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Unreported', 56, 56.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'total', 900.0, 889.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'None of the above', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Qualified Immigrant', 14, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'US Citizen', 918, 918.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 58, 58.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'total', 991.0, 976.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Addison', 'Hispanic', 11, 11),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Non Hispanic', 291, 291.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Unknown', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Unreported', 361, 361.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'total', 665.0, 663.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Hispanic', 33, 33),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Non Hispanic', 672, 672.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Unknown', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Unreported', 67, 67.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'total', 775.0, 772.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Hispanic', 17, 17),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Non Hispanic', 616, 616.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Unknown', 5, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Unreported', 130, 130.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'total', 768.0, 763.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Hispanic', 64, 64),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Non Hispanic', 1971, 1971.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Unknown', 26, -1),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Unreported', 307, 307.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'total', 2368.0, 2342.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Essex', 'Hispanic', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Non Hispanic', 85, 85.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Unknown', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Unreported', 22, 22.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'total', 108.0, 107.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Hispanic', 24, 24),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Non Hispanic', 697, 697.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Unknown', 8, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Unreported', 97, 97.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'total', 826.0, 818.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Hispanic', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Non Hispanic', 87, 87.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Unreported', 13, 13.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'total', 102.0, 100.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Hispanic', 11, 11),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Non Hispanic', 435, 435.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Unknown', 6, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Unreported', 28, 28.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'total', 480.0, 474.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orange', 'Hispanic', 13, 13),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Non Hispanic', 336, 336.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Unknown', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Unreported', 34, 34.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'total', 387.0, 383.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Hispanic', 9, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Non Hispanic', 426, 426.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Unknown', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Unreported', 56, 56.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'total', 492.0, 482.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Hispanic', 38, 38),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Non Hispanic', 948, 948.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Unknown', 18, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Unreported', 112, 112.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'total', 1116.0, 1098.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Washington', 'Hispanic', 21, 21),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Non Hispanic', 513, 513.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Unknown', 9, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Unreported', 67, 67.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'total', 610.0, 601.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windham', 'Hispanic', 51, 51),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Non Hispanic', 526, 526.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Unknown', 8, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Unreported', 94, 94.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'total', 679.0, 671.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Hispanic', 46, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Non Hispanic', 645, 645.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Unknown', 13, 13),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Unreported', 74, 74.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'total', 778.0, 732.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Addison', 'Hispanic', 11, 11),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Non Hispanic', 297, 297.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Unknown', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Unreported', 368, 368.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'total', 679.0, 676.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Hispanic', 38, 38),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Non Hispanic', 661, 661.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Unknown', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Unreported', 61, 61.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'total', 762.0, 760.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Hispanic', 15, 15),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Non Hispanic', 622, 622.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Unknown', 5, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Unreported', 128, 128.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'total', 770.0, 765.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Hispanic', 63, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Non Hispanic', 1946, 1946.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Unknown', 26, 26),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Unreported', 294, 294.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'total', 2329.0, 2266.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Essex', 'Hispanic', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Non Hispanic', 87, 87.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Unknown', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Unreported', 22, 22.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'total', 110.0, 109.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Hispanic', 24, 24),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Non Hispanic', 680, 680.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Unknown', 7, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Unreported', 98, 98.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'total', 809.0, 802.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Hispanic', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Non Hispanic', 81, 81.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Unreported', 11, 11.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'total', 94.0, 92.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Hispanic', 11, 11),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Non Hispanic', 445, 445.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Unknown', 4, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Unreported', 27, 27.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'total', 487.0, 483.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orange', 'Hispanic', 10, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Non Hispanic', 334, 334.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Unknown', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Unreported', 33, 33.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'total', 383.0, 367.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Hispanic', 7, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Non Hispanic', 425, 425.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Unknown', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Unreported', 57, 57.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'total', 491.0, 482.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Hispanic', 40, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Non Hispanic', 962, 962.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Unknown', 21, 21),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Unreported', 108, 108.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'total', 1131.0, 1091.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Washington', 'Hispanic', 19, 19),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Non Hispanic', 516, 516.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Unknown', 7, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Unreported', 63, 63.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'total', 605.0, 598.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windham', 'Hispanic', 49, 49),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Non Hispanic', 525, 525.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Unknown', 8, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Unreported', 92, 92.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'total', 674.0, 666.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Hispanic', 46, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Non Hispanic', 655, 655.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Unknown', 14, 14),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Unreported', 74, 74.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'total', 789.0, 743.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Addison', 'Hispanic', 30, 30),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Non Hispanic', 584, 584.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Unknown', 7, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Unreported', 93, 93.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'total', 714.0, 707.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Hispanic', 22, 22),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Non Hispanic', 642, 642.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Unknown', 7, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Unreported', 99, 99.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'total', 770.0, 763.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Hispanic', 27, 27),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Non Hispanic', 706, 706.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Unknown', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Unreported', 123, 123.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'total', 862.0, 856.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Hispanic', 75, 75),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Non Hispanic', 1821, 1821.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Unknown', 28, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Unreported', 327, 327.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'total', 2251.0, 2223.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Essex', 'Hispanic', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Non Hispanic', 116, 116.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Unknown', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Unreported', 22, 22.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'total', 142.0, 138.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Hispanic', 35, 35),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Non Hispanic', 647, 647.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Unknown', 14, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Unreported', 120, 120.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'total', 816.0, 802.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Hispanic', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Non Hispanic', 69, 69.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Unknown', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Unreported', 11, 11.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'total', 84.0, 80.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Hispanic', 23, 23),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Non Hispanic', 460, 460.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Unknown', 8, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Unreported', 81, 81.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'total', 572.0, 564.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orange', 'Hispanic', 10, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Non Hispanic', 300, 300.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Unknown', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Unreported', 50, 50.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'total', 363.0, 350.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Hispanic', 17, 17),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Non Hispanic', 344, 344.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Unknown', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Unreported', 62, 62.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'total', 427.0, 423.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Hispanic', 39, 39),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Non Hispanic', 867, 867.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Unknown', 10, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Unreported', 146, 146.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'total', 1062.0, 1052.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Washington', 'Hispanic', 15, 15),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Non Hispanic', 382, 382.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Unknown', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Unreported', 66, 66.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'total', 468.0, 463.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windham', 'Hispanic', 18, 18),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Non Hispanic', 479, 479.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Unknown', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Unreported', 86, 86.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'total', 589.0, 583.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Hispanic', 19, 19),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Non Hispanic', 587, 587.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Unknown', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Unreported', 104, 104.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'total', 716.0, 710.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Hispanic', 22, 22),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Non Hispanic', 560, 560.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Unknown', 10, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Unreported', 68, 68.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'total', 660.0, 650.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Hispanic', 33, 33),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Non Hispanic', 672, 672.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Unknown', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Unreported', 67, 67.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'total', 775.0, 772.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Hispanic', 43, 43),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Non Hispanic', 429, 429.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 7, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 81, 81.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'total', 560.0, 553.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Hispanic', 64, 64),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Non Hispanic', 1971, 1971.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Unknown', 26, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Unreported', 307, 307.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'total', 2368.0, 2342.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Hispanic', 29, 29),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Non Hispanic', 481, 481.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Unknown', 6, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Unreported', 51, 51.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'total', 567.0, 561.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Hispanic', 11, 11),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Non Hispanic', 291, 291.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Unknown', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Unreported', 361, 361.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'total', 665.0, 663.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Hispanic', 15, 15),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Non Hispanic', 514, 514.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Unknown', 7, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Unreported', 32, 32.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'total', 568.0, 561.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Hispanic', 6, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Non Hispanic', 417, 417.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Unknown', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Unreported', 61, 61.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'total', 486.0, 478.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Hispanic', 38, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Non Hispanic', 948, 948.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Unknown', 18, 18),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Unreported', 112, 112.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'total', 1116.0, 1078.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Hispanic', 37, 37),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Non Hispanic', 510, 510.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Unknown', 10, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Unreported', 61, 61.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'total', 618.0, 608.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Hispanic', 26, 26),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Non Hispanic', 784, 784.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Unknown', 8, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Unreported', 110, 110.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'total', 928.0, 920.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Hispanic', 16, 16),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Native American', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Non Hispanic', 671, 671.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 5, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 151, 151.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 838.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Hispanic', 20, 20),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Non Hispanic', 566, 566.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Unknown', 8, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Unreported', 64, 64.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'total', 658.0, 650.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Hispanic', 38, 38),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Non Hispanic', 661, 661.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Unknown', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Unreported', 61, 61.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'total', 762.0, 760.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Hispanic', 42, 42),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Non Hispanic', 427, 427.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 7, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 79, 79.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'total', 555.0, 548.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Hispanic', 63, 63),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Non Hispanic', 1946, 1946.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Unknown', 26, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Unreported', 294, 294.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'total', 2329.0, 2303.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Hispanic', 25, 25),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Non Hispanic', 478, 478.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Unknown', 9, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Unreported', 52, 52.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'total', 564.0, 555.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Hispanic', 11, 11),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Non Hispanic', 297, 297.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Unknown', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Unreported', 368, 368.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'total', 679.0, 676.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Hispanic', 14, 14),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Non Hispanic', 522, 522.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Unknown', 6, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Unreported', 31, 31.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'total', 573.0, 567.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Hispanic', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Non Hispanic', 418, 418.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Unknown', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Unreported', 62, 62.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'total', 487.0, 480.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Hispanic', 40, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Non Hispanic', 962, 962.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Unknown', 21, 21),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Unreported', 108, 108.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'total', 1131.0, 1091.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Hispanic', 37, 37),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Non Hispanic', 523, 523.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Unknown', 10, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Unreported', 59, 59.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'total', 629.0, 619.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Hispanic', 26, 26),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Non Hispanic', 761, 761.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Unknown', 7, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Unreported', 109, 109.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'total', 903.0, 896.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Hispanic', 14, 14),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Native American', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Non Hispanic', 675, 675.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 149, 149.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 838.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Hispanic', 16, 16),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Non Hispanic', 415, 415.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Unknown', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Unreported', 69, 69.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'total', 505.0, 500.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Hispanic', 22, 22),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Non Hispanic', 642, 642.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Unknown', 7, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Unreported', 99, 99.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'total', 770.0, 763.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Hispanic', 14, 14),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Non Hispanic', 368, 368.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 70, 70.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'total', 457.0, 452.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Hispanic', 75, 75),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Non Hispanic', 1821, 1821.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Unknown', 28, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Unreported', 327, 327.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'total', 2251.0, 2223.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Hispanic', 16, 16),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Non Hispanic', 467, 467.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Unknown', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Unreported', 74, 74.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'total', 563.0, 557.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Hispanic', 30, 30),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Non Hispanic', 584, 584.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Unknown', 7, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Unreported', 93, 93.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'total', 714.0, 707.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Hispanic', 24, 24),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Non Hispanic', 507, 507.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Unknown', 8, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Unreported', 92, 92.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'total', 631.0, 623.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Hispanic', 16, 16),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Non Hispanic', 340, 340.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Unknown', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Unreported', 60, 60.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'total', 422.0, 416.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Hispanic', 39, 39),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Non Hispanic', 867, 867.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Unknown', 10, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Unreported', 146, 146.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'total', 1062.0, 1052.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Hispanic', 14, 14),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Non Hispanic', 471, 471.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Unknown', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Unreported', 81, 81.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'total', 570.0, 566.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Hispanic', 37, 37),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Non Hispanic', 716, 716.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Unknown', 16, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Unreported', 131, 131.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'total', 900.0, 884.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Hispanic', 31, 31),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Native American', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Non Hispanic', 806, 806.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 148, 148.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'total', 991.0, 985.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Addison', 'Female', 333, 333.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Male', 331, 331.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Prefer not to answer', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'total', 665.0, 664.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Female', 361, 361.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Male', 411, 411.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Prefer not to answer', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'total', 775.0, 772.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Female', 415, 415.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Male', 350, 350.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Unknown', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'total', 768.0, 765.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Female', 1171, 1171.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Male', 1179, 1179.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Non-binary', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Prefer not to answer', 16, 16),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'total', 2368.0, 2366.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Essex', 'Female', 56, 56.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Male', 52, 52.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'total', 108.0, 108.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Female', 422, 422.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Male', 404, 404.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'total', 826.0, 826.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Female', 50, 50.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Male', 52, 52.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'total', 102.0, 102.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Female', 226, 226.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Male', 251, 251.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Non-binary', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'total', 480.0, 477.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orange', 'Female', 195, 195.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Male', 191, 191.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Prefer not to answer', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'total', 387.0, 386.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Female', 219, 219.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Male', 273, 273.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'total', 492.0, 492.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Female', 571, 571.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Male', 543, 543.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'total', 1116.0, 1114.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Washington', 'Female', 267, 267.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Male', 335, 335.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Prefer not to answer', 7, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'total', 610.0, 602.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windham', 'Female', 319, 319.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Male', 353, 353.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Prefer not to answer', 5, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Prefer to self-describe', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'total', 679.0, 672.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Female', 398, 398.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Male', 380, 380.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'total', 778.0, 778.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Addison', 'Female', 338, 338.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Male', 340, 340.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Prefer not to answer', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'total', 679.0, 678.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Female', 353, 353.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Male', 406, 406.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Prefer not to answer', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'total', 762.0, 759.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Female', 419, 419.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Male', 349, 349.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Prefer not to answer', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Unknown', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'total', 770.0, 768.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Female', 1159, 1159.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Male', 1154, 1154.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Non-binary', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Prefer not to answer', 13, 13),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'total', 2329.0, 2326.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Essex', 'Female', 57, 57.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Male', 53, 53.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'total', 110.0, 110.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Female', 414, 414.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Male', 395, 395.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'total', 809.0, 809.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Female', 44, 44.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Male', 50, 50.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'total', 94.0, 94.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Female', 231, 231.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Male', 253, 253.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Non-binary', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'total', 487.0, 484.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orange', 'Female', 189, 189.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Male', 193, 193.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Prefer not to answer', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'total', 383.0, 382.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Female', 220, 220.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Male', 271, 271.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'total', 491.0, 491.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Female', 580, 580.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Male', 549, 549.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Prefer not to answer', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'total', 1131.0, 1129.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Washington', 'Female', 266, 266.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Male', 331, 331.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Prefer not to answer', 7, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'total', 605.0, 597.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windham', 'Female', 320, 320.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Male', 347, 347.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Prefer not to answer', 5, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Prefer to self-describe', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'total', 674.0, 667.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Female', 407, 407.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Male', 381, 381.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Non-binary', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'total', 789.0, 788.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Addison', 'Female', 355, 355.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Male', 356, 356.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'total', 714.0, 711.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Female', 386, 386.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Male', 381, 381.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'total', 770.0, 767.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Female', 425, 425.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Male', 433, 433.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Prefer not to answer', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'total', 862.0, 858.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Female', 1136, 1136.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Male', 1106, 1106.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Non-binary', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Prefer not to answer', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Unknown', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'total', 2251.0, 2242.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Essex', 'Female', 71, 71.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Male', 71, 71.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'total', 142.0, 142.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Female', 382, 382.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Male', 432, 432.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'total', 816.0, 814.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Female', 43, 43.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Male', 41, 41.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'total', 84.0, 84.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Female', 278, 278.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Male', 291, 291.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'total', 572.0, 569.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orange', 'Female', 180, 180.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Male', 181, 181.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'total', 363.0, 361.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Female', 216, 216.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Male', 209, 209.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'total', 427.0, 425.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Female', 516, 516.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Male', 543, 543.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Non-binary', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'total', 1062.0, 1059.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Washington', 'Female', 219, 219.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Male', 248, 248.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Prefer not to answer', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'total', 468.0, 467.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windham', 'Female', 276, 276.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Male', 313, 313.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Prefer not to answer', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'total', 589.0, 589.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Female', 356, 356.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Male', 356, 356.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Prefer to self-describe', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'total', 716.0, 712.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Female', 296, 296.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Male', 356, 356.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 7, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'total', 660.0, 652.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Female', 361, 361.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Male', 411, 411.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'total', 775.0, 772.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Female', 269, 269.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Male', 284, 284.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 5, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'total', 560.0, 553.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Female', 1171, 1171.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Male', 1179, 1179.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Non-binary', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 16, 16),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'total', 2368.0, 2366.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Female', 287, 287.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Male', 279, 279.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'total', 567.0, 566.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Female', 333, 333.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Male', 331, 331.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'total', 665.0, 664.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Female', 272, 272.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Male', 293, 293.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Non-binary', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'total', 568.0, 565.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Female', 216, 216.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Male', 270, 270.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'total', 486.0, 486.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Female', 571, 571.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Male', 543, 543.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'total', 1116.0, 1114.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Female', 303, 303.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Male', 315, 315.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'total', 618.0, 618.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Female', 472, 472.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Male', 456, 456.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Unknown', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'total', 928.0, 928.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Female', 452, 452.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Male', 388, 388.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Non-binary', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 840.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Female', 296, 296.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Male', 356, 356.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 7, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'total', 660.0, 652.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Female', 361, 361.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Male', 411, 411.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'total', 775.0, 772.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Female', 269, 269.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Male', 284, 284.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'total', 560.0, 553.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Female', 1171, 1171.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Male', 1179, 1179.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Non-binary', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 16, 16),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'total', 2368.0, 2366.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Female', 287, 287.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Male', 279, 279.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'total', 567.0, 566.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Female', 333, 333.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Male', 331, 331.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'total', 665.0, 664.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Female', 272, 272.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Male', 293, 293.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Non-binary', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'total', 568.0, 565.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Female', 216, 216.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Male', 270, 270.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'total', 486.0, 486.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Female', 571, 571.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Male', 543, 543.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'total', 1116.0, 1114.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Female', 303, 303.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Male', 315, 315.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'total', 618.0, 618.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Female', 472, 472.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Male', 456, 456.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Unknown', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'total', 928.0, 928.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Female', 452, 452.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Male', 388, 388.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Non-binary', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 840.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Female', 236, 236.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Male', 267, 267.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'total', 505.0, 503.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Female', 386, 386.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Male', 381, 381.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'total', 770.0, 767.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Female', 211, 211.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Male', 246, 246.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'total', 457.0, 457.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Female', 1136, 1136.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Male', 1106, 1106.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Non-binary', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Unknown', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'total', 2251.0, 2242.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Female', 291, 291.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Male', 271, 271.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'total', 563.0, 562.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Female', 355, 355.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Male', 356, 356.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'total', 714.0, 711.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Female', 300, 300.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Male', 327, 327.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'total', 631.0, 627.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Female', 219, 219.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Male', 201, 201.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'total', 422.0, 420.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Female', 516, 516.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Male', 543, 543.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Non-binary', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'total', 1062.0, 1059.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Female', 272, 272.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Male', 295, 295.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'total', 570.0, 567.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Female', 425, 425.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Male', 473, 473.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'total', 900.0, 898.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Female', 492, 492.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Male', 495, 495.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Non-binary', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'total', 991.0, 987.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Addison', 'American Indian or Alaskan Native', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Asian', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Black or African American', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Prefer not to answer', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Prefer to self-describe', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'White', 166, 166.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Two or More Races', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Addison', 'Unreported', 487, 487.0),
('2024-12-01', 12, 2024, 'county', 'Addison', 'total', 665.0, 653.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Bennington', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Asian', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Black or African American', 18, 18),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Prefer not to answer', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Prefer to self-describe', 11, 11),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'White', 652, 652.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Two or More Races', 30, 30),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'Unreported', 56, 56.0),
('2024-12-01', 12, 2024, 'county', 'Bennington', 'total', 775.0, 767.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Asian', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Black or African American', 5, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Native Hawaiian or Pacific Islander', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'White', 300, 300.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Two or More Races', 14, 14),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'Unreported', 442, 442.0),
('2024-12-01', 12, 2024, 'county', 'Caledonia', 'total', 768.0, 756.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'American Indian or Alaskan Native', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Asian', 47, 47),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Black or African American', 255, 255),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Prefer not to answer', 30, 30),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 30, 30),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'White', 1345, 1345.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Two or More Races', 138, 138),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'Unreported', 519, 519.0),
('2024-12-01', 12, 2024, 'county', 'Chittenden', 'total', 2368.0, 2364.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Essex', 'American Indian or Alaskan Native', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Asian', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Black or African American', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'White', 49, 49.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Two or More Races', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Essex', 'Unreported', 57, 57.0),
('2024-12-01', 12, 2024, 'county', 'Essex', 'total', 108.0, 106.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Franklin', 'American Indian or Alaskan Native', 9, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Asian', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Black or African American', 12, 12),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Prefer not to answer', 6, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Prefer to self-describe', 7, -1),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'White', 626, 626.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Two or More Races', 28, 28),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'Unreported', 136, 136.0),
('2024-12-01', 12, 2024, 'county', 'Franklin', 'total', 826.0, 802.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'American Indian or Alaskan Native', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Asian', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Black or African American', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'White', 79, 79.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Two or More Races', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'Unreported', 15, 15.0),
('2024-12-01', 12, 2024, 'county', 'Grand Isle', 'total', 102.0, 94.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'American Indian or Alaskan Native', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Asian', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Black or African American', 6, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'White', 380, 380.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Two or More Races', 25, 25),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'Unreported', 60, 60.0),
('2024-12-01', 12, 2024, 'county', 'Lamoille', 'total', 480.0, 465.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orange', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Asian', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Black or African American', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Prefer to self-describe', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'White', 320, 320.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Two or More Races', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Orange', 'Unreported', 55, 55.0),
('2024-12-01', 12, 2024, 'county', 'Orange', 'total', 387.0, 375.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Orleans', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Asian', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Black or African American', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Prefer not to answer', 6, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'White', 400, 400.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Two or More Races', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'Unreported', 79, 79.0),
('2024-12-01', 12, 2024, 'county', 'Orleans', 'total', 492.0, 479.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Rutland', 'American Indian or Alaskan Native', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Asian', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Black or African American', 38, 38),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Prefer not to answer', 6, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Prefer to self-describe', 7, -1),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'White', 900, 900.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Two or More Races', 27, 27),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'Unreported', 136, 136.0),
('2024-12-01', 12, 2024, 'county', 'Rutland', 'total', 1116.0, 1101.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Washington', 'American Indian or Alaskan Native', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Asian', 5, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Black or African American', 6, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Native Hawaiian or Pacific Islander', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Prefer not to answer', 12, 12),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Prefer to self-describe', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Washington', 'White', 485, 485.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Two or More Races', 16, 16),
('2024-12-01', 12, 2024, 'county', 'Washington', 'Unreported', 76, 76.0),
('2024-12-01', 12, 2024, 'county', 'Washington', 'total', 610.0, 589.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windham', 'American Indian or Alaskan Native', 2, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Asian', 3, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Black or African American', 15, 15),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Prefer not to answer', 12, 12),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Prefer to self-describe', 11, 11),
('2024-12-01', 12, 2024, 'county', 'Windham', 'White', 502, 502.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Two or More Races', 31, 31),
('2024-12-01', 12, 2024, 'county', 'Windham', 'Unreported', 103, 103.0),
('2024-12-01', 12, 2024, 'county', 'Windham', 'total', 679.0, 674.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'county', 'Windsor', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Asian', 4, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Black or African American', 13, 13),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Prefer not to answer', 6, -1),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Prefer to self-describe', 11, 11),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'White', 636, 636.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Two or More Races', 24, 24),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'Unreported', 83, 83.0),
('2024-12-01', 12, 2024, 'county', 'Windsor', 'total', 778.0, 767.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Addison', 'American Indian or Alaskan Native', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Asian', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Black or African American', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Prefer not to answer', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Prefer to self-describe', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'White', 168, 168.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Two or More Races', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Addison', 'Unreported', 500, 500.0),
('2024-11-01', 11, 2024, 'county', 'Addison', 'total', 679.0, 668.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Bennington', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Asian', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Black or African American', 19, 19),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Prefer not to answer', 4, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Prefer to self-describe', 10, -1),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'White', 647, 647.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Two or More Races', 30, 30),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'Unreported', 48, 48.0),
('2024-11-01', 11, 2024, 'county', 'Bennington', 'total', 762.0, 744.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Asian', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Black or African American', 5, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Native Hawaiian or Pacific Islander', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'White', 296, 296.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Two or More Races', 16, 16),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'Unreported', 446, 446.0),
('2024-11-01', 11, 2024, 'county', 'Caledonia', 'total', 770.0, 758.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'American Indian or Alaskan Native', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Asian', 48, 48),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Black or African American', 253, 253),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Prefer not to answer', 29, 29),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 29, 29),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'White', 1328, 1328.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Two or More Races', 135, 135),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'Unreported', 503, 503.0),
('2024-11-01', 11, 2024, 'county', 'Chittenden', 'total', 2329.0, 2325.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Essex', 'American Indian or Alaskan Native', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Asian', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Black or African American', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'White', 50, 50.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Two or More Races', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Essex', 'Unreported', 58, 58.0),
('2024-11-01', 11, 2024, 'county', 'Essex', 'total', 110.0, 108.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Franklin', 'American Indian or Alaskan Native', 8, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Asian', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Black or African American', 12, 12),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Prefer not to answer', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Prefer to self-describe', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'White', 618, 618.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Two or More Races', 27, 27),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'Unreported', 130, 130.0),
('2024-11-01', 11, 2024, 'county', 'Franklin', 'total', 809.0, 787.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'American Indian or Alaskan Native', 4, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Asian', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Black or African American', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'White', 73, 73.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Two or More Races', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'Unreported', 12, 12.0),
('2024-11-01', 11, 2024, 'county', 'Grand Isle', 'total', 94.0, 85.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'American Indian or Alaskan Native', 5, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Asian', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Black or African American', 7, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'White', 389, 389.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Two or More Races', 25, 25),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'Unreported', 56, 56.0),
('2024-11-01', 11, 2024, 'county', 'Lamoille', 'total', 487.0, 470.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orange', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Asian', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Black or African American', 4, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Prefer not to answer', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Prefer to self-describe', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'White', 319, 319.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Two or More Races', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Orange', 'Unreported', 51, 51.0),
('2024-11-01', 11, 2024, 'county', 'Orange', 'total', 383.0, 370.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Orleans', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Asian', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Black or African American', 4, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Prefer not to answer', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'White', 396, 396.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Two or More Races', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'Unreported', 82, 82.0),
('2024-11-01', 11, 2024, 'county', 'Orleans', 'total', 491.0, 478.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Rutland', 'American Indian or Alaskan Native', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Asian', 2, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Black or African American', 37, 37),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Prefer not to answer', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Prefer to self-describe', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'White', 930, 930.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Two or More Races', 28, 28),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'Unreported', 122, 122.0),
('2024-11-01', 11, 2024, 'county', 'Rutland', 'total', 1131.0, 1117.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Washington', 'American Indian or Alaskan Native', 4, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Asian', 5, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Black or African American', 8, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Prefer not to answer', 10, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Prefer to self-describe', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Washington', 'White', 491, 491.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Two or More Races', 16, 16),
('2024-11-01', 11, 2024, 'county', 'Washington', 'Unreported', 68, 68.0),
('2024-11-01', 11, 2024, 'county', 'Washington', 'total', 605.0, 575.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windham', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Asian', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Black or African American', 15, 15),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Prefer not to answer', 13, 13),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Prefer to self-describe', 11, 11),
('2024-11-01', 11, 2024, 'county', 'Windham', 'White', 500, 500.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Two or More Races', 35, 35),
('2024-11-01', 11, 2024, 'county', 'Windham', 'Unreported', 96, 96.0),
('2024-11-01', 11, 2024, 'county', 'Windham', 'total', 674.0, 670.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'county', 'Windsor', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Asian', 3, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Black or African American', 14, 14),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Prefer not to answer', 6, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Prefer to self-describe', 10, -1),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'White', 650, 650.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Two or More Races', 26, 26),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'Unreported', 78, 78.0),
('2024-11-01', 11, 2024, 'county', 'Windsor', 'total', 789.0, 768.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Addison', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Asian', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Black or African American', 26, 26),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Native Hawaiian or Pacific Islander', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Prefer not to answer', 9, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Prefer to self-describe', 8, -1),
('2024-10-01', 10, 2024, 'county', 'Addison', 'White', 489, 489.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Two or More Races', 22, 22),
('2024-10-01', 10, 2024, 'county', 'Addison', 'Unreported', 153, 153.0),
('2024-10-01', 10, 2024, 'county', 'Addison', 'total', 714.0, 690.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Bennington', 'American Indian or Alaskan Native', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Asian', 7, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Black or African American', 36, 36),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Prefer to self-describe', 7, -1),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'White', 530, 530.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Two or More Races', 33, 33),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'Unreported', 152, 152.0),
('2024-10-01', 10, 2024, 'county', 'Bennington', 'total', 770.0, 751.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'American Indian or Alaskan Native', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Asian', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Black or African American', 28, 28),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Prefer not to answer', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 7, -1),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'White', 590, 590.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Two or More Races', 30, 30),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'Unreported', 197, 197.0),
('2024-10-01', 10, 2024, 'county', 'Caledonia', 'total', 862.0, 845.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'American Indian or Alaskan Native', 10, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Asian', 18, 18),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Black or African American', 88, 88),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Prefer not to answer', 15, 15),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 21, 21),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'White', 1517, 1517.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Two or More Races', 80, 80),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'Unreported', 502, 502.0),
('2024-10-01', 10, 2024, 'county', 'Chittenden', 'total', 2251.0, 2241.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Essex', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Asian', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Black or African American', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Prefer not to answer', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Prefer to self-describe', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'White', 91, 91.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Two or More Races', 9, -1),
('2024-10-01', 10, 2024, 'county', 'Essex', 'Unreported', 35, 35.0),
('2024-10-01', 10, 2024, 'county', 'Essex', 'total', 142.0, 126.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Franklin', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Asian', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Black or African American', 28, 28),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Prefer not to answer', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Prefer to self-describe', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'White', 563, 563.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Two or More Races', 27, 27),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'Unreported', 185, 185.0),
('2024-10-01', 10, 2024, 'county', 'Franklin', 'total', 816.0, 803.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Asian', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Black or African American', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'White', 60, 60.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Two or More Races', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'Unreported', 16, 16.0),
('2024-10-01', 10, 2024, 'county', 'Grand Isle', 'total', 84.0, 76.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'American Indian or Alaskan Native', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Asian', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Black or African American', 19, 19),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Prefer not to answer', 15, 15),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'White', 372, 372.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Two or More Races', 16, 16),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'Unreported', 132, 132.0),
('2024-10-01', 10, 2024, 'county', 'Lamoille', 'total', 572.0, 554.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orange', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Asian', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Black or African American', 16, 16),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Prefer not to answer', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Prefer to self-describe', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Orange', 'White', 253, 253.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Two or More Races', 11, 11),
('2024-10-01', 10, 2024, 'county', 'Orange', 'Unreported', 78, 78.0),
('2024-10-01', 10, 2024, 'county', 'Orange', 'total', 363.0, 358.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Orleans', 'American Indian or Alaskan Native', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Asian', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Black or African American', 15, 15),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Prefer to self-describe', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'White', 290, 290.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Two or More Races', 8, -1),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'Unreported', 104, 104.0),
('2024-10-01', 10, 2024, 'county', 'Orleans', 'total', 427.0, 409.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Rutland', 'American Indian or Alaskan Native', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Asian', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Black or African American', 46, 46),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Prefer not to answer', 11, 11),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Prefer to self-describe', 12, 12),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'White', 723, 723.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Two or More Races', 30, 30),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'Unreported', 234, 234.0),
('2024-10-01', 10, 2024, 'county', 'Rutland', 'total', 1062.0, 1056.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Washington', 'American Indian or Alaskan Native', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Asian', 5, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Black or African American', 18, 18),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Prefer not to answer', 7, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Washington', 'White', 315, 315.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Two or More Races', 11, 11),
('2024-10-01', 10, 2024, 'county', 'Washington', 'Unreported', 108, 108.0),
('2024-10-01', 10, 2024, 'county', 'Washington', 'total', 468.0, 452.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windham', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Asian', 2, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Black or African American', 28, 28),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Prefer to self-describe', 6, -1),
('2024-10-01', 10, 2024, 'county', 'Windham', 'White', 382, 382.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Two or More Races', 33, 33),
('2024-10-01', 10, 2024, 'county', 'Windham', 'Unreported', 135, 135.0),
('2024-10-01', 10, 2024, 'county', 'Windham', 'total', 589.0, 578.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'county', 'Windsor', 'American Indian or Alaskan Native', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Asian', 9, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Black or African American', 23, 23),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Prefer not to answer', 8, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Prefer to self-describe', 4, -1),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'White', 499, 499.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Two or More Races', 20, 20),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'Unreported', 151, 151.0),
('2024-10-01', 10, 2024, 'county', 'Windsor', 'total', 716.0, 693.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'American Indian or Alaskan Native', 4, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Asian', 5, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Black or African American', 6, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Native Hawaiian or Pacific Islander', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 13, 13),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 6, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'White', 527, 527.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Two or More Races', 16, 16),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'Unreported', 81, 81.0),
('2024-12-01', 12, 2024, 'AHS district', 'Barre District', 'total', 660.0, 637.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Asian', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Black or African American', 18, 18),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 4, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 11, 11),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'White', 652, 652.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Two or More Races', 30, 30),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'Unreported', 56, 56.0),
('2024-12-01', 12, 2024, 'AHS district', 'Bennington District', 'total', 775.0, 767.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Asian', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Black or African American', 12, 12),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 12, 12),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 9, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'White', 408, 408.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Two or More Races', 27, 27),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 88, 88.0),
('2024-12-01', 12, 2024, 'AHS district', 'Brattleboro District', 'total', 560.0, 547.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'American Indian or Alaskan Native', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Asian', 47, 47),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Black or African American', 255, 255),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 30, 30),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 30, 30),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'White', 1345, 1345.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Two or More Races', 138, 138),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'Unreported', 519, 519.0),
('2024-12-01', 12, 2024, 'AHS district', 'Burlington District', 'total', 2368.0, 2364.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Asian', 4, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Black or African American', 12, 12),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 4, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'White', 488, 488.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Two or More Races', 9, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'Unreported', 46, 46.0),
('2024-12-01', 12, 2024, 'AHS district', 'Hartford District', 'total', 567.0, 546.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'American Indian or Alaskan Native', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Asian', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Black or African American', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'White', 166, 166.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Two or More Races', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'Unreported', 487, 487.0),
('2024-12-01', 12, 2024, 'AHS district', 'Middlebury District', 'total', 665.0, 653.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'American Indian or Alaskan Native', 5, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Asian', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Black or African American', 6, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'White', 460, 460.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Two or More Races', 28, 28),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'Unreported', 64, 64.0),
('2024-12-01', 12, 2024, 'AHS district', 'Morrisville District', 'total', 568.0, 552.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'American Indian or Alaskan Native', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Asian', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Black or African American', 5, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 6, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'White', 391, 391.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Two or More Races', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'Unreported', 80, 80.0),
('2024-12-01', 12, 2024, 'AHS district', 'Newport District', 'total', 486.0, 471.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'American Indian or Alaskan Native', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Asian', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Black or African American', 38, 38),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 6, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 7, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'White', 900, 900.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Two or More Races', 27, 27),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'Unreported', 136, 136.0),
('2024-12-01', 12, 2024, 'AHS district', 'Rutland District', 'total', 1116.0, 1101.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'American Indian or Alaskan Native', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Asian', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Black or African American', 8, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 10, -1),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'White', 499, 499.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Two or More Races', 21, 21),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'Unreported', 74, 74.0),
('2024-12-01', 12, 2024, 'AHS district', 'Springfield District', 'total', 618.0, 594.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'American Indian or Alaskan Native', 13, 13),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Asian', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Black or African American', 12, 12),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 6, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 8, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'White', 705, 705.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Two or More Races', 31, 31),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'Unreported', 151, 151.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Albans District', 'total', 928.0, 912.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'American Indian or Alaskan Native', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Asian', 3, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Black or African American', 5, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Native Hawaiian or Pacific Islander', 2, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 0, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 1, -1),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'White', 299, 299.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Two or More Races', 11, 11),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 522, 522.0),
('2024-12-01', 12, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 832.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'American Indian or Alaskan Native', 4, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Asian', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Black or African American', 8, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 11, 11),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'White', 537, 537.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Two or More Races', 16, 16),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'Unreported', 72, 72.0),
('2024-11-01', 11, 2024, 'AHS district', 'Barre District', 'total', 658.0, 636.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Asian', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Black or African American', 19, 19),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 4, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 10, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'White', 647, 647.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Two or More Races', 30, 30),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'Unreported', 48, 48.0),
('2024-11-01', 11, 2024, 'AHS district', 'Bennington District', 'total', 762.0, 744.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Asian', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Black or African American', 13, 13),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 13, 13),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 9, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'White', 401, 401.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Two or More Races', 31, 31),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 84, 84.0),
('2024-11-01', 11, 2024, 'AHS district', 'Brattleboro District', 'total', 555.0, 542.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'American Indian or Alaskan Native', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Asian', 48, 48),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Black or African American', 253, 253),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 29, 29),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 29, 29),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'White', 1328, 1328.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Two or More Races', 135, 135),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'Unreported', 503, 503.0),
('2024-11-01', 11, 2024, 'AHS district', 'Burlington District', 'total', 2329.0, 2325.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Asian', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Black or African American', 12, 12),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 4, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'White', 483, 483.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Two or More Races', 9, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'Unreported', 47, 47.0),
('2024-11-01', 11, 2024, 'AHS district', 'Hartford District', 'total', 564.0, 542.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'American Indian or Alaskan Native', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Asian', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Black or African American', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'White', 168, 168.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Two or More Races', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'Unreported', 500, 500.0),
('2024-11-01', 11, 2024, 'AHS district', 'Middlebury District', 'total', 679.0, 668.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'American Indian or Alaskan Native', 6, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Asian', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Black or African American', 7, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'White', 468, 468.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Two or More Races', 28, 28),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'Unreported', 59, 59.0),
('2024-11-01', 11, 2024, 'AHS district', 'Morrisville District', 'total', 573.0, 555.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Asian', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Black or African American', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 6, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'White', 389, 389.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Two or More Races', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'Unreported', 83, 83.0),
('2024-11-01', 11, 2024, 'AHS district', 'Newport District', 'total', 487.0, 472.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'American Indian or Alaskan Native', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Asian', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Black or African American', 37, 37),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 6, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 6, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'White', 930, 930.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Two or More Races', 28, 28),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'Unreported', 122, 122.0),
('2024-11-01', 11, 2024, 'AHS district', 'Rutland District', 'total', 1131.0, 1117.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'American Indian or Alaskan Native', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Asian', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Black or African American', 8, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 10, -1),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'White', 520, 520.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Two or More Races', 22, 22),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'Unreported', 64, 64.0),
('2024-11-01', 11, 2024, 'AHS district', 'Springfield District', 'total', 629.0, 606.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'American Indian or Alaskan Native', 12, 12),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Asian', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Black or African American', 13, 13),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 6, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 7, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'White', 691, 691.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Two or More Races', 30, 30),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'Unreported', 142, 142.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Albans District', 'total', 903.0, 888.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'American Indian or Alaskan Native', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Asian', 3, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Black or African American', 5, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Native Hawaiian or Pacific Islander', 2, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 0, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 1, -1),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'White', 293, 293.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Two or More Races', 13, 13),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 526, 526.0),
('2024-11-01', 11, 2024, 'AHS district', 'St. Johnsbury District', 'total', 843.0, 832.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'American Indian or Alaskan Native', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Asian', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Black or African American', 22, 22),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 7, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'White', 341, 341.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Two or More Races', 11, 11),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'Unreported', 114, 114.0),
('2024-10-01', 10, 2024, 'AHS district', 'Barre District', 'total', 505.0, 488.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'American Indian or Alaskan Native', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Asian', 7, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Black or African American', 36, 36),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 7, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'White', 530, 530.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Two or More Races', 33, 33),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'Unreported', 152, 152.0),
('2024-10-01', 10, 2024, 'AHS district', 'Bennington District', 'total', 770.0, 751.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Asian', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Black or African American', 22, 22),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'White', 292, 292.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Two or More Races', 22, 22),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 112, 112.0),
('2024-10-01', 10, 2024, 'AHS district', 'Brattleboro District', 'total', 457.0, 448.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'American Indian or Alaskan Native', 10, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Asian', 18, 18),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Black or African American', 88, 88),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 15, 15),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 21, 21),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'White', 1517, 1517.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Two or More Races', 80, 80),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'Unreported', 502, 502.0),
('2024-10-01', 10, 2024, 'AHS district', 'Burlington District', 'total', 2251.0, 2241.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'American Indian or Alaskan Native', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Asian', 7, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Black or African American', 21, 21),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'White', 398, 398.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Two or More Races', 18, 18),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'Unreported', 109, 109.0),
('2024-10-01', 10, 2024, 'AHS district', 'Hartford District', 'total', 563.0, 546.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Asian', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Black or African American', 26, 26),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Native Hawaiian or Pacific Islander', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 9, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 8, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'White', 489, 489.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Two or More Races', 22, 22),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'Unreported', 153, 153.0),
('2024-10-01', 10, 2024, 'AHS district', 'Middlebury District', 'total', 714.0, 690.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'American Indian or Alaskan Native', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Asian', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Black or African American', 20, 20),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 15, 15),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'White', 410, 410.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Two or More Races', 16, 16),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'Unreported', 152, 152.0),
('2024-10-01', 10, 2024, 'AHS district', 'Morrisville District', 'total', 631.0, 613.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'American Indian or Alaskan Native', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Asian', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Black or African American', 16, 16),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'White', 287, 287.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Two or More Races', 9, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'Unreported', 99, 99.0),
('2024-10-01', 10, 2024, 'AHS district', 'Newport District', 'total', 422.0, 402.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'American Indian or Alaskan Native', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Asian', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Black or African American', 46, 46),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 11, 11),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 12, 12),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'White', 723, 723.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Two or More Races', 30, 30),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'Unreported', 234, 234.0),
('2024-10-01', 10, 2024, 'AHS district', 'Rutland District', 'total', 1062.0, 1056.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Asian', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Black or African American', 20, 20),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 3, -1),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'White', 393, 393.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Two or More Races', 22, 22),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'Unreported', 124, 124.0),
('2024-10-01', 10, 2024, 'AHS district', 'Springfield District', 'total', 570.0, 559.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'American Indian or Alaskan Native', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Asian', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Black or African American', 32, 32),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 5, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'White', 623, 623.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Two or More Races', 30, 30),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'Unreported', 201, 201.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Albans District', 'total', 900.0, 886.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'American Indian or Alaskan Native', 2, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Asian', 4, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Black or African American', 31, 31),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 6, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 7, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'White', 671, 671.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Two or More Races', 40, -1),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 230, 230.0),
('2024-10-01', 10, 2024, 'AHS district', 'St. Johnsbury District', 'total', 991.0, 932.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
