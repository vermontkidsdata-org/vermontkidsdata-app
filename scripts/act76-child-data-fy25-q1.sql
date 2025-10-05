-- INSERT statements for Act 76 Child Demo Breakdown by County and AHS District SFY 25 Q1.xlsx and child-fy25q1.xlsx
-- Generated on 2025-09-24 19:06:47

INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Addison', 'Infant', 93, 93),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Preschool', 246, 246.0),
('2024-09-01', 9, 2024, 'county', 'Addison', 'School', 193, 193.0),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Toddler', 65, 65),
('2024-09-01', 9, 2024, 'county', 'Addison', 'total', 597.0, 597.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Infant', 133, 133),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Preschool', 313, 313.0),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'School', 171, 171.0),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Toddler', 109, 109),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'total', 726.0, 726.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Infant', 121, 121),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Preschool', 284, 284.0),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'School', 267, 267.0),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Toddler', 90, 90),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'total', 762.0, 762.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Infant', 306, 306),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Preschool', 705, 705.0),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'School', 622, 622.0),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Toddler', 232, 232),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'total', 1865.0, 1865.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Essex', 'Infant', 21, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Preschool', 46, 46.0),
('2024-09-01', 9, 2024, 'county', 'Essex', 'School', 26, 26.0),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Toddler', 10, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'total', 103.0, 72.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Infant', 104, 104),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Preschool', 293, 293.0),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'School', 219, 219.0),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Toddler', 90, 90),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'total', 706.0, 706.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Infant', 9, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Preschool', 34, 34.0),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'School', 30, 30.0),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Toddler', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'total', 78.0, 64.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Infant', 84, 84),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Preschool', 172, 172.0),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'School', 118, 118.0),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Toddler', 62, 62),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'total', 436.0, 436.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orange', 'Infant', 62, 62),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Preschool', 135, 135.0),
('2024-09-01', 9, 2024, 'county', 'Orange', 'School', 74, 74.0),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Toddler', 58, 58),
('2024-09-01', 9, 2024, 'county', 'Orange', 'total', 329.0, 329.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Infant', 72, 72),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Preschool', 193, 193.0),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'School', 149, 149.0),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Toddler', 59, 59),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'total', 473.0, 473.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Infant', 163, 163),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Preschool', 375, 375.0),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'School', 336, 336.0),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Toddler', 143, 143),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'total', 1017.0, 1017.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Washington', 'Infant', 86, 86),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Preschool', 218, 218.0),
('2024-09-01', 9, 2024, 'county', 'Washington', 'School', 127, 127.0),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Toddler', 59, 59),
('2024-09-01', 9, 2024, 'county', 'Washington', 'total', 490.0, 490.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windham', 'Infant', 137, 137),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Preschool', 287, 287.0),
('2024-09-01', 9, 2024, 'county', 'Windham', 'School', 116, 116.0),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Toddler', 98, 98),
('2024-09-01', 9, 2024, 'county', 'Windham', 'total', 638.0, 638.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Infant', 108, 108),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Preschool', 282, 282.0),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'School', 273, 273.0),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Toddler', 100, 100),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'total', 763.0, 763.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Addison', 'Infant', 89, 89),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Preschool', 259, 259.0),
('2024-08-01', 8, 2024, 'county', 'Addison', 'School', 265, 265.0),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Toddler', 63, 63),
('2024-08-01', 8, 2024, 'county', 'Addison', 'total', 676.0, 676.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Infant', 124, 124),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Preschool', 347, 347.0),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'School', 196, 196.0),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Toddler', 101, 101),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'total', 768.0, 768.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Infant', 121, 121),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Preschool', 289, 289.0),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'School', 271, 271.0),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Toddler', 82, 82),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'total', 763.0, 763.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Infant', 287, 287),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Preschool', 738, 738.0),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'School', 831, 831.0),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Toddler', 210, 210),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'total', 2066.0, 2066.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Essex', 'Infant', 21, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Preschool', 40, 40.0),
('2024-08-01', 8, 2024, 'county', 'Essex', 'School', 29, 29.0),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Toddler', 10, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'total', 100.0, 69.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Infant', 99, 99),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Preschool', 288, 288.0),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'School', 237, 237.0),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Toddler', 78, 78),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'total', 702.0, 702.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Infant', 10, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Preschool', 34, 34.0),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'School', 36, 36.0),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Toddler', 5, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'total', 85.0, 70.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Infant', 78, 78),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Preschool', 181, 181.0),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'School', 136, 136.0),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Toddler', 64, 64),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'total', 459.0, 459.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orange', 'Infant', 59, 59),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Preschool', 128, 128.0),
('2024-08-01', 8, 2024, 'county', 'Orange', 'School', 87, 87.0),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Toddler', 49, 49),
('2024-08-01', 8, 2024, 'county', 'Orange', 'total', 323.0, 323.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Infant', 66, 66),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Preschool', 199, 199.0),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'School', 155, 155.0),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Toddler', 53, 53),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'total', 473.0, 473.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Infant', 161, 161),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Preschool', 393, 393.0),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'School', 434, 434.0),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Toddler', 132, 132),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'total', 1120.0, 1120.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Washington', 'Infant', 76, 76),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Preschool', 222, 222.0),
('2024-08-01', 8, 2024, 'county', 'Washington', 'School', 194, 194.0),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Toddler', 51, 51),
('2024-08-01', 8, 2024, 'county', 'Washington', 'total', 543.0, 543.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windham', 'Infant', 115, 115),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Preschool', 304, 304.0),
('2024-08-01', 8, 2024, 'county', 'Windham', 'School', 149, 149.0),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Toddler', 91, 91),
('2024-08-01', 8, 2024, 'county', 'Windham', 'total', 659.0, 659.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Infant', 96, 96),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Preschool', 272, 272.0),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'School', 335, 335.0),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Toddler', 91, 91),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'total', 794.0, 794.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Addison', 'Infant', 73, 73),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Preschool', 209, 209.0),
('2024-07-01', 7, 2024, 'county', 'Addison', 'School', 249, 249.0),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Toddler', 56, 56),
('2024-07-01', 7, 2024, 'county', 'Addison', 'total', 587.0, 587.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Infant', 121, 121),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Preschool', 342, 342.0),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'School', 187, 187.0),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Toddler', 98, 98),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'total', 748.0, 748.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Infant', 115, 115),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Preschool', 274, 274.0),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'School', 258, 258.0),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Toddler', 80, 80),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'total', 727.0, 727.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Infant', 256, 256),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Preschool', 694, 694.0),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'School', 740, 740.0),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Toddler', 209, 209),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'total', 1899.0, 1899.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Essex', 'Infant', 21, 21),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Preschool', 40, 40.0),
('2024-07-01', 7, 2024, 'county', 'Essex', 'School', 25, 25.0),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Toddler', 11, 11),
('2024-07-01', 7, 2024, 'county', 'Essex', 'total', 97.0, 97.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Infant', 97, 97),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Preschool', 276, 276.0),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'School', 241, 241.0),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Toddler', 78, 78),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'total', 692.0, 692.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Infant', 9, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Preschool', 28, 28.0),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'School', 33, 33.0),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Toddler', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'total', 72.0, 61.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Infant', 72, 72),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Preschool', 165, 165.0),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'School', 109, 109.0),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Toddler', 51, 51),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'total', 397.0, 397.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orange', 'Infant', 52, 52),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Preschool', 119, 119.0),
('2024-07-01', 7, 2024, 'county', 'Orange', 'School', 81, 81.0),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Toddler', 46, 46),
('2024-07-01', 7, 2024, 'county', 'Orange', 'total', 298.0, 298.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Infant', 62, 62),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Preschool', 197, 197.0),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'School', 147, 147.0),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Toddler', 44, 44),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'total', 450.0, 450.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Infant', 146, 146),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Preschool', 379, 379.0),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'School', 423, 423.0),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Toddler', 133, 133),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'total', 1081.0, 1081.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Washington', 'Infant', 67, 67),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Preschool', 193, 193.0),
('2024-07-01', 7, 2024, 'county', 'Washington', 'School', 183, 183.0),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Toddler', 53, 53),
('2024-07-01', 7, 2024, 'county', 'Washington', 'total', 496.0, 496.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windham', 'Infant', 96, 96),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Preschool', 273, 273.0),
('2024-07-01', 7, 2024, 'county', 'Windham', 'School', 119, 119.0),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Toddler', 91, 91),
('2024-07-01', 7, 2024, 'county', 'Windham', 'total', 579.0, 579.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Infant', 96, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Preschool', 259, 259.0),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'School', 310, 310.0),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Toddler', 82, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'total', 747.0, 569.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Infant', 94, 94.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Preschool', 239, 239.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'School', 137, 137.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Toddler', 63, 63.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'total', 533.0, 533.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Infant', 133, 133.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Preschool', 313, 313.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'School', 171, 171.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Toddler', 109, 109.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'total', 726.0, 726.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Infant', 112, 112.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Preschool', 225, 225.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'School', 97, 97.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Toddler', 86, 86.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'total', 520.0, 520.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Infant', 306, 306.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Preschool', 705, 705.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'School', 622, 622.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Toddler', 232, 232.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'total', 1865.0, 1865.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Infant', 97, 97.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Preschool', 168, 168.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'School', 129, 129.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Toddler', 84, 84.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'total', 478.0, 478.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Infant', 93, 93.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Preschool', 246, 246.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'School', 193, 193.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Toddler', 65, 65.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'total', 597.0, 597.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Infant', 101, 101.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Preschool', 200, 200.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'School', 132, 132.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Toddler', 83, 83.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'total', 516.0, 516.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Infant', 68, 68.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Preschool', 196, 196.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'School', 153, 153.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Toddler', 54, 54.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'total', 471.0, 471.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Infant', 163, 163.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Preschool', 375, 375.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'School', 336, 336.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Toddler', 143, 143.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'total', 1017.0, 1017.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Infant', 84, 84.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Preschool', 271, 271.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'School', 218, 218.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Toddler', 73, 73.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'total', 646.0, 646.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Infant', 113, 113.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Preschool', 327, 327.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'School', 249, 249.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Toddler', 95, 95.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'total', 784.0, 784.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Infant', 135, 135.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Preschool', 318, 318.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'School', 284, 284.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Toddler', 93, 93.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'total', 830.0, 830.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Infant', 85, 85.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Preschool', 248, 248.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'School', 208, 208.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Toddler', 55, 55.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'total', 596.0, 596.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Infant', 124, 124.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Preschool', 347, 347.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'School', 196, 196.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Toddler', 101, 101.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'total', 768.0, 768.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Infant', 96, 96.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Preschool', 246, 246.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'School', 123, 123.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Toddler', 77, 77.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'total', 542.0, 542.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Infant', 287, 287.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Preschool', 738, 738.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'School', 831, 831.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Toddler', 210, 210.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'total', 2066.0, 2066.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Infant', 84, 84.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Preschool', 155, 155.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'School', 156, 156.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Toddler', 74, 74.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'total', 469.0, 469.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Infant', 89, 89.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Preschool', 259, 259.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'School', 265, 265.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Toddler', 63, 63.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'total', 676.0, 676.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Infant', 97, 97.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Preschool', 215, 215.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'School', 153, 153.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Toddler', 79, 79.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'total', 544.0, 544.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Infant', 62, 62.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Preschool', 197, 197.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'School', 159, 159.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Toddler', 49, 49.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'total', 467.0, 467.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Infant', 161, 161.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Preschool', 393, 393.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'School', 434, 434.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Toddler', 132, 132.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'total', 1120.0, 1120.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Infant', 74, 74.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Preschool', 257, 257.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'School', 267, 267.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Toddler', 70, 70.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'total', 668.0, 668.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Infant', 109, 109.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Preschool', 322, 322.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'School', 273, 273.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Toddler', 83, 83.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'total', 787.0, 787.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Infant', 134, 134.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Preschool', 316, 316.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'School', 290, 290.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Toddler', 87, 87.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'total', 827.0, 827.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Infant', 76, 76.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Preschool', 219, 219.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'School', 196, 196.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Toddler', 58, 58.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'total', 549.0, 549.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Infant', 121, 121.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Preschool', 342, 342.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'School', 187, 187.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Toddler', 98, 98.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'total', 748.0, 748.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Infant', 81, 81.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Preschool', 220, 220.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'School', 93, 93.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Toddler', 77, 77.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'total', 471.0, 471.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Infant', 256, 256.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Preschool', 694, 694.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'School', 740, 740.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Toddler', 209, 209.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'total', 1899.0, 1899.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Infant', 78, 78.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Preschool', 144, 144.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'School', 139, 139.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Toddler', 67, 67.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'total', 428.0, 428.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Infant', 73, 73.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Preschool', 209, 209.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'School', 249, 249.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Toddler', 56, 56.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'total', 587.0, 587.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Infant', 89, 89.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Preschool', 197, 197.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'School', 121, 121.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Toddler', 59, 59.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'total', 466.0, 466.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Infant', 59, 59.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Preschool', 194, 194.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'School', 153, 153.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Toddler', 45, 45.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'total', 451.0, 451.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Infant', 146, 146.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Preschool', 379, 379.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'School', 423, 423.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Toddler', 133, 133.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'total', 1081.0, 1081.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Infant', 71, 71.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Preschool', 243, 243.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'School', 256, 256.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Toddler', 63, 63.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'total', 633.0, 633.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Infant', 106, 106.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Preschool', 304, 304.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'School', 274, 274.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Toddler', 80, 80.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'total', 764.0, 764.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_age` (`month_year`, `month`, `year`, `geo_type`, `geography`, `age`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Infant', 127, 127.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Preschool', 303, 303.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'School', 274, 274.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Toddler', 89, 89.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'total', 793.0, 793.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Addison', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Qualified Immigrant', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'US Citizen', 559, 559.0),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Unreported', 38, 38),
('2024-09-01', 9, 2024, 'county', 'Addison', 'total', 597.0, 597.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Bennington', 'None of the above', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Qualified Immigrant', 7, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'US Citizen', 638, 638.0),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Unreported', 80, 80),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'total', 726.0, 718.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Qualified Immigrant', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'US Citizen', 726, 726.0),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Unreported', 35, 35),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'total', 762.0, 761.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'None of the above', 9, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Qualified Immigrant', 38, 38),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'US Citizen', 1700, 1700.0),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Unreported', 118, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'total', 1865.0, 1738.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Essex', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Qualified Immigrant', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'US Citizen', 95, 95.0),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Unreported', 8, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'total', 103.0, 95.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Franklin', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Qualified Immigrant', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'US Citizen', 639, 639.0),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Unreported', 67, 67),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'total', 706.0, 706.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Qualified Immigrant', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'US Citizen', 72, 72.0),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Unreported', 6, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'total', 78.0, 72.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'None of the above', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Qualified Immigrant', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'US Citizen', 410, 410.0),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Unreported', 23, 23),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'total', 436.0, 433.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orange', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Qualified Immigrant', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'US Citizen', 312, 312.0),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Unreported', 17, 17),
('2024-09-01', 9, 2024, 'county', 'Orange', 'total', 329.0, 329.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orleans', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Qualified Immigrant', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'US Citizen', 445, 445.0),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Unreported', 26, 26),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'total', 473.0, 471.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Rutland', 'None of the above', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Qualified Immigrant', 26, 26),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'US Citizen', 917, 917.0),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Unreported', 73, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'total', 1017.0, 943.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Washington', 'None of the above', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Qualified Immigrant', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'US Citizen', 447, 447.0),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Unreported', 40, 40),
('2024-09-01', 9, 2024, 'county', 'Washington', 'total', 490.0, 487.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windham', 'None of the above', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Qualified Immigrant', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'US Citizen', 597, 597.0),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Unreported', 35, 35),
('2024-09-01', 9, 2024, 'county', 'Windham', 'total', 638.0, 632.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windsor', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Qualified Immigrant', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'US Citizen', 726, 726.0),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Unreported', 36, 36),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'total', 763.0, 762.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Addison', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Qualified Immigrant', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'US Citizen', 642, 642.0),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Unreported', 33, 33),
('2024-08-01', 8, 2024, 'county', 'Addison', 'total', 676.0, 675.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Bennington', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Qualified Immigrant', 6, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'US Citizen', 679, 679.0),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Unreported', 83, 83),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'total', 768.0, 762.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Qualified Immigrant', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'US Citizen', 721, 721.0),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Unreported', 40, 40),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'total', 763.0, 761.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'None of the above', 7, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Qualified Immigrant', 37, 37),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'US Citizen', 1891, 1891.0),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Unreported', 131, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'total', 2066.0, 1928.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Essex', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Qualified Immigrant', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'US Citizen', 92, 92.0),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Unreported', 8, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'total', 100.0, 92.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Franklin', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Qualified Immigrant', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'US Citizen', 639, 639.0),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Unreported', 63, 63),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'total', 702.0, 702.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Qualified Immigrant', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'US Citizen', 78, 78.0),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Unreported', 7, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'total', 85.0, 78.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'None of the above', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Qualified Immigrant', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'US Citizen', 428, 428.0),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Unreported', 29, 29),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'total', 459.0, 457.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orange', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Qualified Immigrant', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'US Citizen', 306, 306.0),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Unreported', 17, 17),
('2024-08-01', 8, 2024, 'county', 'Orange', 'total', 323.0, 323.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orleans', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Qualified Immigrant', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'US Citizen', 441, 441.0),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Unreported', 30, 30),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'total', 473.0, 471.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Rutland', 'None of the above', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Qualified Immigrant', 29, 29),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'US Citizen', 1011, 1011.0),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Unreported', 79, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'total', 1120.0, 1040.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Washington', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Qualified Immigrant', 12, 12),
('2024-08-01', 8, 2024, 'county', 'Washington', 'US Citizen', 487, 487.0),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Unreported', 44, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'total', 543.0, 499.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windham', 'None of the above', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Qualified Immigrant', 8, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'US Citizen', 612, 612.0),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Unreported', 38, 38),
('2024-08-01', 8, 2024, 'county', 'Windham', 'total', 659.0, 650.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windsor', 'None of the above', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Qualified Immigrant', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'US Citizen', 755, 755.0),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Unreported', 37, 37),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'total', 794.0, 792.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Addison', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Qualified Immigrant', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'US Citizen', 555, 555.0),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Unreported', 31, 31),
('2024-07-01', 7, 2024, 'county', 'Addison', 'total', 587.0, 586.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Bennington', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Qualified Immigrant', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'US Citizen', 662, 662.0),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Unreported', 81, 81),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'total', 748.0, 743.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Qualified Immigrant', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'US Citizen', 681, 681.0),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Unreported', 44, 44),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'total', 727.0, 725.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'None of the above', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Qualified Immigrant', 30, 30),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'US Citizen', 1741, 1741.0),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Unreported', 127, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'total', 1899.0, 1771.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Essex', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Qualified Immigrant', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'US Citizen', 89, 89.0),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Unreported', 8, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'total', 97.0, 89.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Franklin', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Qualified Immigrant', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'US Citizen', 626, 626.0),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Unreported', 66, 66),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'total', 692.0, 692.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Qualified Immigrant', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'US Citizen', 67, 67.0),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Unreported', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'total', 72.0, 67.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'None of the above', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Qualified Immigrant', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'US Citizen', 369, 369.0),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Unreported', 26, 26),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'total', 397.0, 395.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orange', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Qualified Immigrant', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'US Citizen', 281, 281.0),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Unreported', 17, 17),
('2024-07-01', 7, 2024, 'county', 'Orange', 'total', 298.0, 298.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orleans', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Qualified Immigrant', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'US Citizen', 410, 410.0),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Unreported', 38, 38),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'total', 450.0, 448.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Rutland', 'None of the above', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Qualified Immigrant', 23, 23),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'US Citizen', 988, 988.0),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Unreported', 69, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'total', 1081.0, 1011.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Washington', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Qualified Immigrant', 12, 12),
('2024-07-01', 7, 2024, 'county', 'Washington', 'US Citizen', 442, 442.0),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Unreported', 42, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'total', 496.0, 454.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windham', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Qualified Immigrant', 8, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'US Citizen', 535, 535.0),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Unreported', 36, 36),
('2024-07-01', 7, 2024, 'county', 'Windham', 'total', 579.0, 571.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windsor', 'None of the above', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Qualified Immigrant', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'US Citizen', 708, 708.0),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Unreported', 37, 37),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'total', 747.0, 745.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'None of the above', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Qualified Immigrant', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'US Citizen', 486, 486.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Unreported', 44, 44.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'total', 533.0, 530.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'None of the above', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Qualified Immigrant', 7, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'US Citizen', 638, 638.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Unreported', 80, 80.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'total', 726.0, 718.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'None of the above', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Qualified Immigrant', 4, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'US Citizen', 486, 486.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 29, 29.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'total', 520.0, 515.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'None of the above', 9, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Qualified Immigrant', 38, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'US Citizen', 1700, 1700.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Unreported', 118, 118.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'total', 1865.0, 1818.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Qualified Immigrant', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'US Citizen', 451, 451.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Unreported', 27, 27.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'total', 478.0, 478.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Qualified Immigrant', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'US Citizen', 559, 559.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Unreported', 38, 38.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'total', 597.0, 597.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'None of the above', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Qualified Immigrant', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'US Citizen', 485, 485.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Unreported', 28, 28.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'total', 516.0, 513.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Qualified Immigrant', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'US Citizen', 441, 441.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Unreported', 28, 28.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'total', 471.0, 469.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'None of the above', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Qualified Immigrant', 26, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'US Citizen', 917, 917.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Unreported', 73, 73.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'total', 1017.0, 990.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Qualified Immigrant', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'US Citizen', 617, 617.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Unreported', 27, 27.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'total', 646.0, 644.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Qualified Immigrant', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'US Citizen', 711, 711.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Unreported', 73, 73.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'total', 784.0, 784.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'None of the above', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Qualified Immigrant', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'US Citizen', 792, 792.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 37, 37.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'total', 830.0, 829.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Qualified Immigrant', 12, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'US Citizen', 535, 535.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Unreported', 49, 49.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'total', 596.0, 584.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Qualified Immigrant', 6, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'US Citizen', 679, 679.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Unreported', 83, 83.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'total', 768.0, 762.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'None of the above', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Qualified Immigrant', 7, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'US Citizen', 502, 502.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 32, 32.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'total', 542.0, 534.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'None of the above', 7, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Qualified Immigrant', 37, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'US Citizen', 1891, 1891.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Unreported', 131, 131.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'total', 2066.0, 2022.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'None of the above', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Qualified Immigrant', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'US Citizen', 442, 442.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Unreported', 26, 26.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'total', 469.0, 468.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Qualified Immigrant', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'US Citizen', 642, 642.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Unreported', 33, 33.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'total', 676.0, 675.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'None of the above', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Qualified Immigrant', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'US Citizen', 507, 507.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Unreported', 35, 35.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'total', 544.0, 542.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Qualified Immigrant', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'US Citizen', 434, 434.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Unreported', 31, 31.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'total', 467.0, 465.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'None of the above', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Qualified Immigrant', 29, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'US Citizen', 1011, 1011.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Unreported', 79, 79.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'total', 1120.0, 1090.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Qualified Immigrant', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'US Citizen', 639, 639.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Unreported', 27, 27.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'total', 668.0, 666.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Qualified Immigrant', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'US Citizen', 717, 717.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Unreported', 70, 70.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'total', 787.0, 787.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'None of the above', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Qualified Immigrant', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'US Citizen', 783, 783.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 42, 42.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'total', 827.0, 825.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Qualified Immigrant', 12, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'US Citizen', 489, 489.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Unreported', 48, 48.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'total', 549.0, 537.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Qualified Immigrant', 5, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'US Citizen', 662, 662.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Unreported', 81, 81.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'total', 748.0, 743.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Qualified Immigrant', 7, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'US Citizen', 433, 433.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 31, 31.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'total', 471.0, 464.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'None of the above', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Qualified Immigrant', 30, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'US Citizen', 1741, 1741.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Unreported', 127, 127.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'total', 1899.0, 1868.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'None of the above', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Qualified Immigrant', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'US Citizen', 402, 402.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Unreported', 25, 25.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'total', 428.0, 427.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Qualified Immigrant', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'US Citizen', 555, 555.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Unreported', 31, 31.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'total', 587.0, 586.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'None of the above', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Qualified Immigrant', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'US Citizen', 434, 434.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Unreported', 30, 30.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'total', 466.0, 464.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Qualified Immigrant', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'US Citizen', 411, 411.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Unreported', 38, 38.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'total', 451.0, 449.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'None of the above', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Qualified Immigrant', 23, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'US Citizen', 988, 988.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Unreported', 69, 69.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'total', 1081.0, 1057.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Qualified Immigrant', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'US Citizen', 604, 604.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Unreported', 27, 27.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'total', 633.0, 631.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Qualified Immigrant', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'US Citizen', 693, 693.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Unreported', 71, 71.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'total', 764.0, 764.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_citizenship` (`month_year`, `month`, `year`, `geo_type`, `geography`, `citizenship`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'None of the above', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Qualified Immigrant', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'US Citizen', 742, 742.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 49, 49.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'total', 793.0, 791.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Addison', 'Hispanic', 11, 11),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Non Hispanic', 270, 270.0),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Unknown', 3, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Unreported', 313, 313),
('2024-09-01', 9, 2024, 'county', 'Addison', 'total', 597.0, 594.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Hispanic', 35, 35),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Non Hispanic', 613, 613.0),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Unknown', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Unreported', 76, 76),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'total', 726.0, 724.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Hispanic', 15, 15),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Non Hispanic', 615, 615.0),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Unknown', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Unreported', 127, 127),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'total', 762.0, 757.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Hispanic', 54, 54),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Non Hispanic', 1564, 1564.0),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Unknown', 18, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Unreported', 229, 229),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'total', 1865.0, 1847.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Essex', 'Hispanic', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Non Hispanic', 80, 80.0),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Unknown', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Unreported', 22, 22),
('2024-09-01', 9, 2024, 'county', 'Essex', 'total', 103.0, 102.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Hispanic', 19, 19),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Non Hispanic', 601, 601.0),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Unknown', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Unreported', 81, 81),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'total', 706.0, 701.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Hispanic', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Non Hispanic', 71, 71.0),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Unreported', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'total', 78.0, 71.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Hispanic', 10, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Non Hispanic', 407, 407.0),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Unknown', 4, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Unreported', 15, 15),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'total', 436.0, 422.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orange', 'Hispanic', 9, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Non Hispanic', 285, 285.0),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Unknown', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Unreported', 30, 30),
('2024-09-01', 9, 2024, 'county', 'Orange', 'total', 329.0, 315.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Hispanic', 7, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Non Hispanic', 409, 409.0),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Unknown', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Unreported', 55, 55),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'total', 473.0, 464.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Hispanic', 39, 39),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Non Hispanic', 858, 858.0),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Unknown', 20, 20),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Unreported', 100, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'total', 1017.0, 917.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Washington', 'Hispanic', 19, 19),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Non Hispanic', 427, 427.0),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Unknown', 7, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Unreported', 37, 37),
('2024-09-01', 9, 2024, 'county', 'Washington', 'total', 490.0, 483.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windham', 'Hispanic', 50, 50),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Non Hispanic', 489, 489.0),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Unknown', 10, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Unreported', 89, 89),
('2024-09-01', 9, 2024, 'county', 'Windham', 'total', 638.0, 628.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Hispanic', 47, 47),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Non Hispanic', 626, 626.0),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Unknown', 15, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Unreported', 75, 75),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'total', 763.0, 748.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Addison', 'Hispanic', 10, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Non Hispanic', 337, 337.0),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Unknown', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Unreported', 326, 326),
('2024-08-01', 8, 2024, 'county', 'Addison', 'total', 676.0, 663.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Hispanic', 31, 31),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Non Hispanic', 641, 641.0),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Unknown', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Unreported', 94, 94),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'total', 768.0, 766.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Hispanic', 16, 16),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Non Hispanic', 619, 619.0),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Unknown', 6, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Unreported', 122, 122),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'total', 763.0, 757.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Hispanic', 54, 54),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Non Hispanic', 1721, 1721.0),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Unknown', 17, 17),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Unreported', 274, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'total', 2066.0, 1792.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Essex', 'Hispanic', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Non Hispanic', 77, 77.0),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Unknown', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Unreported', 22, 22),
('2024-08-01', 8, 2024, 'county', 'Essex', 'total', 100.0, 99.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Hispanic', 20, 20),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Non Hispanic', 602, 602.0),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Unknown', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Unreported', 76, 76),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'total', 702.0, 698.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Hispanic', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Non Hispanic', 75, 75.0),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Unreported', 7, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'total', 85.0, 75.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Hispanic', 12, 12),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Non Hispanic', 430, 430.0),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Unknown', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Unreported', 13, 13),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'total', 459.0, 455.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orange', 'Hispanic', 6, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Non Hispanic', 283, 283.0),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Unknown', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Unreported', 32, 32),
('2024-08-01', 8, 2024, 'county', 'Orange', 'total', 323.0, 315.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Hispanic', 7, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Non Hispanic', 413, 413.0),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Unknown', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Unreported', 51, 51),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'total', 473.0, 464.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Hispanic', 43, 43),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Non Hispanic', 963, 963.0),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Unknown', 14, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Unreported', 100, 100),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'total', 1120.0, 1106.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Washington', 'Hispanic', 18, 18),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Non Hispanic', 465, 465.0),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Unknown', 8, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Unreported', 52, 52),
('2024-08-01', 8, 2024, 'county', 'Washington', 'total', 543.0, 535.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windham', 'Hispanic', 49, 49),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Non Hispanic', 510, 510.0),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Unknown', 8, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Unreported', 92, 92),
('2024-08-01', 8, 2024, 'county', 'Windham', 'total', 659.0, 651.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Hispanic', 51, 51),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Non Hispanic', 651, 651.0),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Unknown', 15, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Unreported', 77, 77),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'total', 794.0, 779.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Addison', 'Hispanic', 11, 11),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Non Hispanic', 303, 303.0),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Unknown', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Unreported', 270, 270),
('2024-07-01', 7, 2024, 'county', 'Addison', 'total', 587.0, 584.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Hispanic', 30, 30),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Non Hispanic', 610, 610.0),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Unknown', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Unreported', 106, 106),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'total', 748.0, 746.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Hispanic', 16, 16),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Non Hispanic', 591, 591.0),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Unknown', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Unreported', 115, 115),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'total', 727.0, 722.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Hispanic', 46, 46),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Non Hispanic', 1588, 1588.0),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Unknown', 18, 18),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Unreported', 247, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'total', 1899.0, 1652.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Essex', 'Hispanic', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Non Hispanic', 76, 76.0),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Unknown', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Unreported', 19, 19),
('2024-07-01', 7, 2024, 'county', 'Essex', 'total', 97.0, 95.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Hispanic', 21, 21),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Non Hispanic', 584, 584.0),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Unknown', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Unreported', 82, 82),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'total', 692.0, 687.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Hispanic', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Non Hispanic', 63, 63.0),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Unreported', 6, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'total', 72.0, 63.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Hispanic', 7, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Non Hispanic', 373, 373.0),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Unknown', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Unreported', 13, 13),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'total', 397.0, 386.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orange', 'Hispanic', 7, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Non Hispanic', 264, 264.0),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Unknown', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Unreported', 26, 26),
('2024-07-01', 7, 2024, 'county', 'Orange', 'total', 298.0, 290.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Hispanic', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Non Hispanic', 394, 394.0),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Unreported', 51, 51),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'total', 450.0, 445.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Hispanic', 39, 39),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Non Hispanic', 938, 938.0),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Unknown', 13, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Unreported', 91, 91),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'total', 1081.0, 1068.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Washington', 'Hispanic', 17, 17),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Non Hispanic', 426, 426.0),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Unknown', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Unreported', 48, 48),
('2024-07-01', 7, 2024, 'county', 'Washington', 'total', 496.0, 491.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windham', 'Hispanic', 39, 39),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Non Hispanic', 450, 450.0),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Unknown', 9, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Unreported', 81, 81),
('2024-07-01', 7, 2024, 'county', 'Windham', 'total', 579.0, 570.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Hispanic', 48, 48),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Non Hispanic', 610, 610.0),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Unknown', 15, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Unreported', 74, 74),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'total', 747.0, 732.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Hispanic', 20, 20),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Non Hispanic', 470, 470.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Unknown', 7, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Unreported', 36, 36.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'total', 533.0, 526.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Hispanic', 35, 35),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Non Hispanic', 613, 613.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Unknown', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Unreported', 76, 76.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'total', 726.0, 724.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Hispanic', 43, 43),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Non Hispanic', 392, 392.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 7, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 78, 78.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'total', 520.0, 513.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Hispanic', 54, 54),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Non Hispanic', 1564, 1564.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Unknown', 18, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Unreported', 229, 229.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'total', 1865.0, 1847.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Hispanic', 20, 20),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Non Hispanic', 397, 397.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Unknown', 9, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Unreported', 52, 52.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'total', 478.0, 469.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Hispanic', 11, 11),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Non Hispanic', 270, 270.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Unknown', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Unreported', 313, 313.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'total', 597.0, 594.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Hispanic', 13, 13),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Non Hispanic', 479, 479.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Unknown', 6, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Unreported', 18, 18.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'total', 516.0, 510.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Hispanic', 5, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Non Hispanic', 404, 404.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Unknown', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Unreported', 60, 60.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'total', 471.0, 464.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Hispanic', 39, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Non Hispanic', 858, 858.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Unknown', 20, 20),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Unreported', 100, 100.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'total', 1017.0, 978.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Hispanic', 42, 42),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Non Hispanic', 534, 534.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Unknown', 13, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Unreported', 57, 57.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'total', 646.0, 633.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Hispanic', 21, 21),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Non Hispanic', 672, 672.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Unknown', 5, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Unreported', 86, 86.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'total', 784.0, 779.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Hispanic', 14, 14),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Native American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Non Hispanic', 662, 662.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 5, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 149, 149.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'total', 830.0, 825.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Hispanic', 20, 20),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Non Hispanic', 517, 517.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Unknown', 8, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Unreported', 51, 51.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'total', 596.0, 588.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Hispanic', 31, 31),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Non Hispanic', 641, 641.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Unknown', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Unreported', 94, 94.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'total', 768.0, 766.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Hispanic', 42, 42),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Non Hispanic', 413, 413.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 5, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 82, 82.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'total', 542.0, 537.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Hispanic', 54, 54),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Non Hispanic', 1721, 1721.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Unknown', 17, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Unreported', 274, 274.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'total', 2066.0, 2049.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Hispanic', 16, 16),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Non Hispanic', 391, 391.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Unknown', 7, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Unreported', 55, 55.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'total', 469.0, 462.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Hispanic', 10, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Non Hispanic', 337, 337.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Unknown', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Unreported', 326, 326.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'total', 676.0, 663.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Hispanic', 14, 14),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Non Hispanic', 506, 506.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Unknown', 8, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Unreported', 16, 16.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'total', 544.0, 536.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Hispanic', 5, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Non Hispanic', 404, 404.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Unknown', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Unreported', 56, 56.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'total', 467.0, 460.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Hispanic', 43, 43),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Non Hispanic', 963, 963.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Unknown', 14, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Unreported', 100, 100.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'total', 1120.0, 1106.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Hispanic', 46, 46),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Non Hispanic', 551, 551.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Unknown', 13, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Unreported', 58, 58.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'total', 668.0, 655.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Hispanic', 23, 23),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Non Hispanic', 677, 677.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Unknown', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Unreported', 83, 83.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'total', 787.0, 783.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Hispanic', 16, 16),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Native American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Non Hispanic', 665, 665.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 143, 143.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'total', 827.0, 824.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Hispanic', 19, 19),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Non Hispanic', 476, 476.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Unknown', 5, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Unreported', 49, 49.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'total', 549.0, 544.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Hispanic', 30, 30),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Non Hispanic', 610, 610.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Unknown', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Unreported', 106, 106.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'total', 748.0, 746.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Hispanic', 32, 32),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Non Hispanic', 359, 359.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 6, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 74, 74.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'total', 471.0, 465.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Hispanic', 46, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Non Hispanic', 1588, 1588.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Unknown', 18, 18),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Unreported', 247, 247.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'total', 1899.0, 1853.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Hispanic', 15, 15),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Non Hispanic', 359, 359.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Unknown', 5, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Unreported', 49, 49.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'total', 428.0, 423.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Hispanic', 11, 11),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Non Hispanic', 303, 303.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Unknown', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Unreported', 270, 270.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'total', 587.0, 584.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Hispanic', 7, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Non Hispanic', 439, 439.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Unknown', 6, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Unreported', 14, 14.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'total', 466.0, 453.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Hispanic', 5, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Non Hispanic', 388, 388.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Unknown', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Unreported', 56, 56.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'total', 451.0, 444.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Hispanic', 39, 39),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Non Hispanic', 938, 938.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Unknown', 13, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Unreported', 91, 91.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'total', 1081.0, 1068.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Hispanic', 45, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Non Hispanic', 522, 522.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Unknown', 14, 14),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Unreported', 52, 52.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'total', 633.0, 588.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Hispanic', 24, 24),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Non Hispanic', 647, 647.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Unknown', 5, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Unreported', 88, 88.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'total', 764.0, 759.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_ethnicity` (`month_year`, `month`, `year`, `geo_type`, `geography`, `ethnicity`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Hispanic', 16, 16),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Native American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Non Hispanic', 641, 641.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 133, 133.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'total', 793.0, 790.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Addison', 'Female', 293, 293.0),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Male', 303, 303.0),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Prefer not to answer', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'total', 597.0, 596.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Female', 332, 332.0),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Male', 391, 391.0),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Prefer not to answer', 3, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'total', 726.0, 723.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Female', 415, 415.0),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Male', 346, 346.0),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Unknown', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'total', 762.0, 761.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Female', 940, 940.0),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Male', 922, 922.0),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Non-binary', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Prefer not to answer', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'total', 1865.0, 1862.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Essex', 'Female', 52, 52.0),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Male', 51, 51.0),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'total', 103.0, 103.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Female', 355, 355.0),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Male', 351, 351.0),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'total', 706.0, 706.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Female', 38, 38.0),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Male', 40, 40.0),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'total', 78.0, 78.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Female', 210, 210.0),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Male', 223, 223.0),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Non-binary', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'total', 436.0, 433.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orange', 'Female', 163, 163.0),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Male', 165, 165.0),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Prefer not to answer', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'total', 329.0, 328.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Female', 206, 206.0),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Male', 266, 266.0),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Prefer not to answer', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'total', 473.0, 472.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Female', 513, 513.0),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Male', 500, 500.0),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Prefer not to answer', 4, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'total', 1017.0, 1013.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Washington', 'Female', 216, 216.0),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Male', 269, 269.0),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Prefer not to answer', 4, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'total', 490.0, 485.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windham', 'Female', 304, 304.0),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Male', 328, 328.0),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Prefer not to answer', 4, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Prefer to self-describe', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'total', 638.0, 632.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Female', 397, 397.0),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Male', 365, 365.0),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Non-binary', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'total', 763.0, 762.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Addison', 'Female', 326, 326.0),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Male', 349, 349.0),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Prefer not to answer', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'total', 676.0, 675.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Female', 366, 366.0),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Male', 399, 399.0),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Prefer not to answer', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'total', 768.0, 765.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Female', 420, 420.0),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Male', 340, 340.0),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Prefer not to answer', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Unknown', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'total', 763.0, 760.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Female', 1063, 1063.0),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Male', 1000, 1000.0),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Non-binary', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Prefer not to answer', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'total', 2066.0, 2063.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Essex', 'Female', 52, 52.0),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Male', 48, 48.0),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'total', 100.0, 100.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Female', 351, 351.0),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Male', 351, 351.0),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'total', 702.0, 702.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Female', 39, 39.0),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Male', 46, 46.0),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'total', 85.0, 85.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Female', 220, 220.0),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Male', 236, 236.0),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Non-binary', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'total', 459.0, 456.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orange', 'Female', 158, 158.0),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Male', 164, 164.0),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Prefer not to answer', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'total', 323.0, 322.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Female', 209, 209.0),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Male', 263, 263.0),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Prefer not to answer', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'total', 473.0, 472.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Female', 553, 553.0),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Male', 563, 563.0),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Prefer not to answer', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'total', 1120.0, 1116.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Washington', 'Female', 246, 246.0),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Male', 292, 292.0),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Prefer not to answer', 5, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'total', 543.0, 538.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windham', 'Female', 318, 318.0),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Male', 334, 334.0),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Non-binary', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Prefer not to answer', 5, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'total', 659.0, 652.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Female', 408, 408.0),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Male', 384, 384.0),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Non-binary', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Prefer not to answer', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'total', 794.0, 792.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Addison', 'Female', 293, 293.0),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Male', 303, 303.0),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'total', 597.0, 596.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Female', 332, 332.0),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Male', 391, 391.0),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Prefer not to answer', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'total', 726.0, 723.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Female', 415, 415.0),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Male', 346, 346.0),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Unknown', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'total', 762.0, 761.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Female', 940, 940.0),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Male', 922, 922.0),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Non-binary', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'total', 1865.0, 1862.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Essex', 'Female', 52, 52.0),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Male', 51, 51.0),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'total', 103.0, 103.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Female', 355, 355.0),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Male', 351, 351.0),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'total', 706.0, 706.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Female', 38, 38.0),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Male', 40, 40.0),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'total', 78.0, 78.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Female', 210, 210.0),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Male', 223, 223.0),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Non-binary', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'total', 436.0, 433.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orange', 'Female', 163, 163.0),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Male', 165, 165.0),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'total', 329.0, 328.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Female', 206, 206.0),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Male', 266, 266.0),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'total', 473.0, 472.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Female', 513, 513.0),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Male', 500, 500.0),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'total', 1017.0, 1013.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Washington', 'Female', 216, 216.0),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Male', 269, 269.0),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'total', 490.0, 485.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windham', 'Female', 304, 304.0),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Male', 328, 328.0),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Prefer to self-describe', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'total', 638.0, 632.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Female', 397, 397.0),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Male', 365, 365.0),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Non-binary', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'total', 763.0, 762.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Female', 240, 240.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Male', 288, 288.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 4, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'total', 533.0, 528.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Female', 332, 332.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Male', 391, 391.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'total', 726.0, 723.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Female', 255, 255.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Male', 259, 259.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 4, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'total', 520.0, 514.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Female', 940, 940.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Male', 922, 922.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Non-binary', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'total', 1865.0, 1862.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Female', 244, 244.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Male', 232, 232.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Non-binary', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'total', 478.0, 476.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Female', 293, 293.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Male', 303, 303.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'total', 597.0, 596.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Female', 249, 249.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Male', 264, 264.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Non-binary', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'total', 516.0, 513.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Female', 205, 205.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Male', 265, 265.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'total', 471.0, 470.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Female', 513, 513.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Male', 500, 500.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 4, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'total', 1017.0, 1013.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Female', 318, 318.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Male', 328, 328.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'total', 646.0, 646.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Female', 393, 393.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Male', 391, 391.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Unknown', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'total', 784.0, 784.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Female', 452, 452.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Male', 377, 377.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Non-binary', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'total', 830.0, 829.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Female', 274, 274.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Male', 317, 317.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 5, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'total', 596.0, 591.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Female', 366, 366.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Male', 399, 399.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'total', 768.0, 765.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Female', 264, 264.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Male', 271, 271.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Non-binary', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 5, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'total', 542.0, 535.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Female', 1063, 1063.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Male', 1000, 1000.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Non-binary', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'total', 2066.0, 2063.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Female', 241, 241.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Male', 225, 225.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Non-binary', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'total', 469.0, 466.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Female', 326, 326.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Male', 349, 349.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'total', 676.0, 675.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Female', 260, 260.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Male', 279, 279.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Non-binary', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'total', 544.0, 539.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Female', 208, 208.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Male', 258, 258.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'total', 467.0, 466.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Female', 553, 553.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Male', 563, 563.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'total', 1120.0, 1116.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Female', 328, 328.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Male', 340, 340.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'total', 668.0, 668.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Female', 390, 390.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Male', 397, 397.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Unknown', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'total', 787.0, 787.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Female', 455, 455.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Male', 371, 371.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Non-binary', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'total', 827.0, 826.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Female', 255, 255.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Male', 290, 290.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'total', 549.0, 545.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Female', 354, 354.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Male', 391, 391.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'total', 748.0, 745.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Female', 224, 224.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Male', 239, 239.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Non-binary', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 5, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'total', 471.0, 463.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Female', 993, 993.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Male', 903, 903.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Non-binary', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'total', 1899.0, 1896.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Female', 212, 212.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Male', 214, 214.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Non-binary', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'total', 428.0, 426.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Female', 294, 294.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Male', 292, 292.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'total', 587.0, 586.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Female', 223, 223.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Male', 240, 240.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'total', 466.0, 463.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Female', 203, 203.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Male', 247, 247.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'total', 451.0, 450.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Female', 532, 532.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Male', 545, 545.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'total', 1081.0, 1077.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Female', 305, 305.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Male', 328, 328.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'total', 633.0, 633.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Female', 385, 385.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Male', 379, 379.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Unknown', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'total', 764.0, 764.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_gender` (`month_year`, `month`, `year`, `geo_type`, `geography`, `gender`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Female', 438, 438.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Male', 354, 354.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Non-binary', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Unknown', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'total', 793.0, 792.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Addison', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Asian', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Black or African American', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Prefer to self-describe', 3, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'White', 122, 122.0),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Two or More Races', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Addison', 'Unreported', 471, 471),
('2024-09-01', 9, 2024, 'county', 'Addison', 'total', 597.0, 593.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Bennington', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Asian', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Black or African American', 16, 16),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Prefer not to answer', 4, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Prefer to self-describe', 8, -1),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'White', 610, 610.0),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Two or More Races', 30, 30),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'Unreported', 56, 56),
('2024-09-01', 9, 2024, 'county', 'Bennington', 'total', 726.0, 712.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Asian', 3, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Black or African American', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'White', 290, 290.0),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Two or More Races', 16, 16),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'Unreported', 448, 448),
('2024-09-01', 9, 2024, 'county', 'Caledonia', 'total', 762.0, 754.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Asian', 48, 48),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Black or African American', 242, 242),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Prefer not to answer', 18, 18),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 23, 23),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'White', 1012, 1012.0),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Two or More Races', 108, 108),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'Unreported', 413, 413),
('2024-09-01', 9, 2024, 'county', 'Chittenden', 'total', 1865.0, 1864.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Essex', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Asian', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Black or African American', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'White', 44, 44.0),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Two or More Races', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Essex', 'Unreported', 57, 57),
('2024-09-01', 9, 2024, 'county', 'Essex', 'total', 103.0, 101.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Franklin', 'American Indian or Alaskan Native', 8, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Asian', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Black or African American', 13, 13),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Prefer not to answer', 7, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Prefer to self-describe', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'White', 560, 560.0),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Two or More Races', 16, 16),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'Unreported', 96, 96),
('2024-09-01', 9, 2024, 'county', 'Franklin', 'total', 706.0, 685.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'American Indian or Alaskan Native', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Asian', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Black or African American', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'White', 65, 65.0),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Two or More Races', 4, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'Unreported', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Grand Isle', 'total', 78.0, 65.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'American Indian or Alaskan Native', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Asian', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Black or African American', 8, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'White', 363, 363.0),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Two or More Races', 23, 23),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'Unreported', 32, 32),
('2024-09-01', 9, 2024, 'county', 'Lamoille', 'total', 436.0, 418.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orange', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Asian', 3, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Black or African American', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Prefer not to answer', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Prefer to self-describe', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'White', 270, 270.0),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Two or More Races', 3, -1),
('2024-09-01', 9, 2024, 'county', 'Orange', 'Unreported', 47, 47),
('2024-09-01', 9, 2024, 'county', 'Orange', 'total', 329.0, 317.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Orleans', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Asian', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Black or African American', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Prefer not to answer', 7, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'White', 367, 367.0),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Two or More Races', 3, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'Unreported', 91, -1),
('2024-09-01', 9, 2024, 'county', 'Orleans', 'total', 473.0, 367.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Rutland', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Asian', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Black or African American', 36, 36),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Prefer not to answer', 6, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Prefer to self-describe', 6, -1),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'White', 834, 834.0),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Two or More Races', 24, 24),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'Unreported', 108, 108),
('2024-09-01', 9, 2024, 'county', 'Rutland', 'total', 1017.0, 1002.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Washington', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Asian', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Black or African American', 9, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Prefer not to answer', 10, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Washington', 'White', 418, 418.0),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Two or More Races', 17, 17),
('2024-09-01', 9, 2024, 'county', 'Washington', 'Unreported', 33, 33),
('2024-09-01', 9, 2024, 'county', 'Washington', 'total', 490.0, 468.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windham', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Asian', 3, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Black or African American', 17, 17),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Prefer not to answer', 12, 12),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Prefer to self-describe', 10, -1),
('2024-09-01', 9, 2024, 'county', 'Windham', 'White', 466, 466.0),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Two or More Races', 33, 33),
('2024-09-01', 9, 2024, 'county', 'Windham', 'Unreported', 96, 96),
('2024-09-01', 9, 2024, 'county', 'Windham', 'total', 638.0, 624.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'county', 'Windsor', 'American Indian or Alaskan Native', 2, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Asian', 4, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Black or African American', 14, 14),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Prefer not to answer', 5, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Prefer to self-describe', 10, -1),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'White', 620, 620.0),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Two or More Races', 25, 25),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'Unreported', 82, 82),
('2024-09-01', 9, 2024, 'county', 'Windsor', 'total', 763.0, 741.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Addison', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Black or African American', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Prefer to self-describe', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'White', 124, 124.0),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Two or More Races', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Addison', 'Unreported', 550, 550),
('2024-08-01', 8, 2024, 'county', 'Addison', 'total', 676.0, 674.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Bennington', 'American Indian or Alaskan Native', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Asian', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Black or African American', 16, 16),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Prefer not to answer', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Prefer to self-describe', 7, -1),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'White', 643, 643.0),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Two or More Races', 35, 35),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'Unreported', 60, 60),
('2024-08-01', 8, 2024, 'county', 'Bennington', 'total', 768.0, 754.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Asian', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Black or African American', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'White', 285, 285.0),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Two or More Races', 17, 17),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'Unreported', 453, 453),
('2024-08-01', 8, 2024, 'county', 'Caledonia', 'total', 763.0, 755.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'American Indian or Alaskan Native', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Asian', 56, 56),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Black or African American', 243, 243),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Prefer not to answer', 21, 21),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 18, 18),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'White', 1091, 1091.0),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Two or More Races', 105, 105),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'Unreported', 531, 531),
('2024-08-01', 8, 2024, 'county', 'Chittenden', 'total', 2066.0, 2065.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Essex', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Black or African American', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'White', 44, 44.0),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Two or More Races', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Essex', 'Unreported', 54, 54),
('2024-08-01', 8, 2024, 'county', 'Essex', 'total', 100.0, 98.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Franklin', 'American Indian or Alaskan Native', 5, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Black or African American', 12, 12),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Prefer not to answer', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Prefer to self-describe', 5, -1),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'White', 568, 568.0),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Two or More Races', 18, 18),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'Unreported', 89, 89),
('2024-08-01', 8, 2024, 'county', 'Franklin', 'total', 702.0, 687.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'American Indian or Alaskan Native', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Black or African American', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'White', 69, 69.0),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Two or More Races', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'Unreported', 7, -1),
('2024-08-01', 8, 2024, 'county', 'Grand Isle', 'total', 85.0, 69.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'American Indian or Alaskan Native', 6, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Black or African American', 10, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Prefer not to answer', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'White', 381, 381.0),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Two or More Races', 29, 29),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'Unreported', 27, 27),
('2024-08-01', 8, 2024, 'county', 'Lamoille', 'total', 459.0, 437.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orange', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Asian', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Black or African American', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Prefer not to answer', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Prefer to self-describe', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'White', 259, 259.0),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Two or More Races', 5, -1),
('2024-08-01', 8, 2024, 'county', 'Orange', 'Unreported', 49, 49),
('2024-08-01', 8, 2024, 'county', 'Orange', 'total', 323.0, 308.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Orleans', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Black or African American', 5, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Prefer not to answer', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'White', 360, 360.0),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Two or More Races', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'Unreported', 101, 101),
('2024-08-01', 8, 2024, 'county', 'Orleans', 'total', 473.0, 461.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Rutland', 'American Indian or Alaskan Native', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Asian', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Black or African American', 39, 39),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Prefer not to answer', 13, 13),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Prefer to self-describe', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'White', 933, 933.0),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Two or More Races', 29, 29),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'Unreported', 101, 101),
('2024-08-01', 8, 2024, 'county', 'Rutland', 'total', 1120.0, 1115.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Washington', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Asian', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Black or African American', 12, 12),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Prefer not to answer', 11, 11),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Prefer to self-describe', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Washington', 'White', 458, 458.0),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Two or More Races', 18, 18),
('2024-08-01', 8, 2024, 'county', 'Washington', 'Unreported', 38, 38),
('2024-08-01', 8, 2024, 'county', 'Washington', 'total', 543.0, 537.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windham', 'American Indian or Alaskan Native', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Asian', 3, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Black or African American', 16, 16),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Prefer not to answer', 12, 12),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Prefer to self-describe', 12, 12),
('2024-08-01', 8, 2024, 'county', 'Windham', 'White', 488, 488.0),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Two or More Races', 36, 36),
('2024-08-01', 8, 2024, 'county', 'Windham', 'Unreported', 90, 90),
('2024-08-01', 8, 2024, 'county', 'Windham', 'total', 659.0, 654.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'county', 'Windsor', 'American Indian or Alaskan Native', 2, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Asian', 4, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Black or African American', 12, 12),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Prefer not to answer', 6, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Prefer to self-describe', 11, 11),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'White', 646, 646.0),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Two or More Races', 29, 29),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'Unreported', 83, -1),
('2024-08-01', 8, 2024, 'county', 'Windsor', 'total', 794.0, 698.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Addison', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Asian', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Black or African American', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Prefer to self-describe', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'White', 98, 98.0),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Two or More Races', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Addison', 'Unreported', 487, 487),
('2024-07-01', 7, 2024, 'county', 'Addison', 'total', 587.0, 585.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Bennington', 'American Indian or Alaskan Native', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Black or African American', 16, 16),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Prefer not to answer', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Prefer to self-describe', 7, -1),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'White', 623, 623.0),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Two or More Races', 36, 36),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'Unreported', 60, 60),
('2024-07-01', 7, 2024, 'county', 'Bennington', 'total', 748.0, 735.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Black or African American', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'White', 272, 272.0),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Two or More Races', 17, 17),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'Unreported', 431, 431),
('2024-07-01', 7, 2024, 'county', 'Caledonia', 'total', 727.0, 720.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'American Indian or Alaskan Native', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Asian', 44, 44),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Black or African American', 218, 218),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Prefer not to answer', 20, 20),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Prefer to self-describe', 14, 14),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'White', 995, 995.0),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Two or More Races', 92, 92),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'Unreported', 514, 514),
('2024-07-01', 7, 2024, 'county', 'Chittenden', 'total', 1899.0, 1897.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Essex', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Asian', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Black or African American', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'White', 43, 43.0),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Two or More Races', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Essex', 'Unreported', 52, 52),
('2024-07-01', 7, 2024, 'county', 'Essex', 'total', 97.0, 95.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Franklin', 'American Indian or Alaskan Native', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Asian', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Black or African American', 11, 11),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Prefer to self-describe', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'White', 562, 562.0),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Two or More Races', 20, 20),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'Unreported', 85, 85),
('2024-07-01', 7, 2024, 'county', 'Franklin', 'total', 692.0, 678.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'American Indian or Alaskan Native', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Black or African American', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'White', 53, 53.0),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Two or More Races', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'Unreported', 7, -1),
('2024-07-01', 7, 2024, 'county', 'Grand Isle', 'total', 72.0, 53.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'American Indian or Alaskan Native', 6, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Asian', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Black or African American', 8, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Prefer not to answer', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'White', 328, 328.0),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Two or More Races', 26, 26),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'Unreported', 25, 25),
('2024-07-01', 7, 2024, 'county', 'Lamoille', 'total', 397.0, 379.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orange', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Black or African American', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Prefer not to answer', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Prefer to self-describe', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'White', 239, 239.0),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Two or More Races', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Orange', 'Unreported', 44, 44),
('2024-07-01', 7, 2024, 'county', 'Orange', 'total', 298.0, 283.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Orleans', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Asian', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Black or African American', 5, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'White', 324, 324.0),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Two or More Races', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'Unreported', 114, 114),
('2024-07-01', 7, 2024, 'county', 'Orleans', 'total', 450.0, 438.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Rutland', 'American Indian or Alaskan Native', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Asian', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Black or African American', 40, 40),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Prefer not to answer', 13, 13),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'White', 899, 899.0),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Two or More Races', 30, 30),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'Unreported', 95, 95),
('2024-07-01', 7, 2024, 'county', 'Rutland', 'total', 1081.0, 1077.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Washington', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Black or African American', 12, 12),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Prefer not to answer', 6, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Washington', 'White', 419, 419.0),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Two or More Races', 17, 17),
('2024-07-01', 7, 2024, 'county', 'Washington', 'Unreported', 38, 38),
('2024-07-01', 7, 2024, 'county', 'Washington', 'total', 496.0, 486.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windham', 'American Indian or Alaskan Native', 2, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Black or African American', 13, 13),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Prefer not to answer', 9, -1),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Prefer to self-describe', 15, 15),
('2024-07-01', 7, 2024, 'county', 'Windham', 'White', 432, 432.0),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Two or More Races', 28, 28),
('2024-07-01', 7, 2024, 'county', 'Windham', 'Unreported', 77, 77),
('2024-07-01', 7, 2024, 'county', 'Windham', 'total', 579.0, 565.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'county', 'Windsor', 'American Indian or Alaskan Native', 3, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Asian', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Black or African American', 10, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Prefer to self-describe', 11, 11),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'White', 604, 604.0),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Two or More Races', 30, 30),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'Unreported', 80, -1),
('2024-07-01', 7, 2024, 'county', 'Windsor', 'total', 747.0, 645.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Asian', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Black or African American', 9, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 11, 11),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'White', 456, 456.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Two or More Races', 17, 17),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'Unreported', 35, 35.0),
('2024-09-01', 9, 2024, 'AHS district', 'Barre District', 'total', 533.0, 519.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Asian', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Black or African American', 16, 16),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 4, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 8, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'White', 610, 610.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Two or More Races', 30, 30),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'Unreported', 56, 56.0),
('2024-09-01', 9, 2024, 'AHS district', 'Bennington District', 'total', 726.0, 712.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Asian', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Black or African American', 14, 14),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 12, 12),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 8, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'White', 369, 369.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Two or More Races', 28, 28),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 85, 85.0),
('2024-09-01', 9, 2024, 'AHS district', 'Brattleboro District', 'total', 520.0, 508.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Asian', 48, 48),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Black or African American', 242, 242),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 18, 18),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 23, 23),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'White', 1012, 1012.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Two or More Races', 108, 108),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'Unreported', 413, 413.0),
('2024-09-01', 9, 2024, 'AHS district', 'Burlington District', 'total', 1865.0, 1864.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Asian', 5, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Black or African American', 9, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'White', 399, 399.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Two or More Races', 12, 12),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'Unreported', 47, 47.0),
('2024-09-01', 9, 2024, 'AHS district', 'Hartford District', 'total', 478.0, 458.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Asian', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Black or African American', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'White', 122, 122.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Two or More Races', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'Unreported', 471, 471.0),
('2024-09-01', 9, 2024, 'AHS district', 'Middlebury District', 'total', 597.0, 593.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'American Indian or Alaskan Native', 5, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Asian', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Black or African American', 8, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'White', 439, 439.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Two or More Races', 25, 25),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'Unreported', 34, 34.0),
('2024-09-01', 9, 2024, 'AHS district', 'Morrisville District', 'total', 516.0, 498.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Asian', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Black or African American', 6, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 7, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'White', 361, 361.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Two or More Races', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'Unreported', 93, 93.0),
('2024-09-01', 9, 2024, 'AHS district', 'Newport District', 'total', 471.0, 454.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Asian', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Black or African American', 36, 36),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 6, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 6, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'White', 834, 834.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Two or More Races', 24, 24),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'Unreported', 108, 108.0),
('2024-09-01', 9, 2024, 'AHS district', 'Rutland District', 'total', 1017.0, 1002.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'American Indian or Alaskan Native', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Asian', 2, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Black or African American', 10, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 11, 11),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'White', 534, 534.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Two or More Races', 21, 21),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'Unreported', 64, 64.0),
('2024-09-01', 9, 2024, 'AHS district', 'Springfield District', 'total', 646.0, 630.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'American Indian or Alaskan Native', 10, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Asian', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Black or African American', 14, 14),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 7, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 6, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'White', 625, 625.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Two or More Races', 20, 20),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'Unreported', 101, 101.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Albans District', 'total', 784.0, 760.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'American Indian or Alaskan Native', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Asian', 3, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Black or African American', 5, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 0, -1),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'White', 280, 280.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Two or More Races', 14, 14),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 528, 528.0),
('2024-09-01', 9, 2024, 'AHS district', 'St. Johnsbury District', 'total', 830.0, 822.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Asian', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Black or African American', 12, 12),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 13, 13),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'White', 504, 504.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Two or More Races', 19, 19),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'Unreported', 40, 40.0),
('2024-08-01', 8, 2024, 'AHS district', 'Barre District', 'total', 596.0, 588.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'American Indian or Alaskan Native', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Asian', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Black or African American', 16, 16),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 7, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'White', 643, 643.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Two or More Races', 35, 35),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'Unreported', 60, 60.0),
('2024-08-01', 8, 2024, 'AHS district', 'Bennington District', 'total', 768.0, 754.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'American Indian or Alaskan Native', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Asian', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Black or African American', 14, 14),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 12, 12),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 10, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'White', 389, 389.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Two or More Races', 31, 31),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 81, 81.0),
('2024-08-01', 8, 2024, 'AHS district', 'Brattleboro District', 'total', 542.0, 527.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'American Indian or Alaskan Native', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Asian', 56, 56),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Black or African American', 243, 243),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 21, 21),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 18, 18),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'White', 1091, 1091.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Two or More Races', 105, 105),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'Unreported', 531, 531.0),
('2024-08-01', 8, 2024, 'AHS district', 'Burlington District', 'total', 2066.0, 2065.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'American Indian or Alaskan Native', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Asian', 5, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Black or African American', 8, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'White', 382, 382.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Two or More Races', 15, 15),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'Unreported', 52, 52.0),
('2024-08-01', 8, 2024, 'AHS district', 'Hartford District', 'total', 469.0, 449.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Black or African American', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'White', 124, 124.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Two or More Races', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'Unreported', 550, 550.0),
('2024-08-01', 8, 2024, 'AHS district', 'Middlebury District', 'total', 676.0, 674.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'American Indian or Alaskan Native', 6, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Black or African American', 10, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'White', 461, 461.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Two or More Races', 32, 32),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'Unreported', 29, 29.0),
('2024-08-01', 8, 2024, 'AHS district', 'Morrisville District', 'total', 544.0, 522.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Black or African American', 6, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'White', 350, 350.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Two or More Races', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'Unreported', 103, 103.0),
('2024-08-01', 8, 2024, 'AHS district', 'Newport District', 'total', 467.0, 453.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'American Indian or Alaskan Native', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Asian', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Black or African American', 39, 39),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 13, 13),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'White', 933, 933.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Two or More Races', 29, 29),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'Unreported', 101, 101.0),
('2024-08-01', 8, 2024, 'AHS district', 'Rutland District', 'total', 1120.0, 1115.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'American Indian or Alaskan Native', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Asian', 2, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Black or African American', 8, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 12, 12),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'White', 557, 557.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Two or More Races', 23, 23),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'Unreported', 62, 62.0),
('2024-08-01', 8, 2024, 'AHS district', 'Springfield District', 'total', 668.0, 654.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'American Indian or Alaskan Native', 8, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Asian', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Black or African American', 13, 13),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 6, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'White', 637, 637.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Two or More Races', 22, 22),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'Unreported', 96, 96.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Albans District', 'total', 787.0, 768.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'American Indian or Alaskan Native', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Asian', 3, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Black or African American', 4, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 0, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 1, -1),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'White', 277, 277.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Two or More Races', 14, 14),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 528, 528.0),
('2024-08-01', 8, 2024, 'AHS district', 'St. Johnsbury District', 'total', 827.0, 819.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Black or African American', 12, 12),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Prefer not to answer', 8, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Prefer to self-describe', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'White', 464, 464.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Two or More Races', 18, 18),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'Unreported', 41, 41.0),
('2024-07-01', 7, 2024, 'AHS district', 'Barre District', 'total', 549.0, 535.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'American Indian or Alaskan Native', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Black or African American', 16, 16),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Prefer not to answer', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Prefer to self-describe', 7, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'White', 623, 623.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Two or More Races', 36, 36),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'Unreported', 60, 60.0),
('2024-07-01', 7, 2024, 'AHS district', 'Bennington District', 'total', 748.0, 735.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'American Indian or Alaskan Native', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Black or African American', 11, 11),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Prefer not to answer', 9, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Prefer to self-describe', 13, 13),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'White', 340, 340.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Two or More Races', 23, 23),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'Unreported', 70, 70.0),
('2024-07-01', 7, 2024, 'AHS district', 'Brattleboro District', 'total', 471.0, 457.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'American Indian or Alaskan Native', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Asian', 44, 44),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Black or African American', 218, 218),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Prefer not to answer', 20, 20),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Prefer to self-describe', 14, 14),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'White', 995, 995.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Two or More Races', 92, 92),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'Unreported', 514, 514.0),
('2024-07-01', 7, 2024, 'AHS district', 'Burlington District', 'total', 1899.0, 1897.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'American Indian or Alaskan Native', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Asian', 5, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Black or African American', 8, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Prefer to self-describe', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'White', 346, 346.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Two or More Races', 16, 16),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'Unreported', 46, 46.0),
('2024-07-01', 7, 2024, 'AHS district', 'Hartford District', 'total', 428.0, 408.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Asian', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Black or African American', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Prefer to self-describe', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'White', 98, 98.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Two or More Races', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'Unreported', 487, 487.0),
('2024-07-01', 7, 2024, 'AHS district', 'Middlebury District', 'total', 587.0, 585.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'American Indian or Alaskan Native', 6, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Asian', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Black or African American', 8, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Prefer not to answer', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'White', 394, 394.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Two or More Races', 29, 29),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'Unreported', 25, 25.0),
('2024-07-01', 7, 2024, 'AHS district', 'Morrisville District', 'total', 466.0, 448.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Asian', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Black or African American', 6, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'White', 319, 319.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Two or More Races', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'Unreported', 118, 118.0),
('2024-07-01', 7, 2024, 'AHS district', 'Newport District', 'total', 451.0, 437.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'American Indian or Alaskan Native', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Asian', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Black or African American', 40, 40),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Prefer not to answer', 13, 13),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'White', 899, 899.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Two or More Races', 30, 30),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'Unreported', 95, 95.0),
('2024-07-01', 7, 2024, 'AHS district', 'Rutland District', 'total', 1081.0, 1077.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'American Indian or Alaskan Native', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Asian', 2, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Black or African American', 6, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Prefer not to answer', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Prefer to self-describe', 13, 13),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'White', 529, 529.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Two or More Races', 23, 23),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'Unreported', 58, 58.0),
('2024-07-01', 7, 2024, 'AHS district', 'Springfield District', 'total', 633.0, 623.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'American Indian or Alaskan Native', 8, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Black or African American', 12, 12),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Native Hawaiian or Pacific Islander', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Prefer not to answer', 4, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Prefer to self-describe', 5, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'White', 615, 615.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Two or More Races', 24, 24),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'Unreported', 92, 92.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Albans District', 'total', 764.0, 743.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
INSERT INTO `data_act76_child_race` (`month_year`, `month`, `year`, `geo_type`, `geography`, `race`, `value`, `value_suppressed`)
VALUES
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'American Indian or Alaskan Native', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Asian', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Black or African American', 3, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Native Hawaiian or Pacific Islander', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer not to answer', 0, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Prefer to self-describe', 1, -1),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'White', 269, 269.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Two or More Races', 14, 14),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'Unreported', 503, 503.0),
('2024-07-01', 7, 2024, 'AHS district', 'St. Johnsbury District', 'total', 793.0, 786.0) AS new_data
ON DUPLICATE KEY UPDATE `month` = new_data.`month`, `year` = new_data.`year`, `value` = new_data.`value`, `value_suppressed` = new_data.`value_suppressed`;
