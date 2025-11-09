-- Upload types for Act76 child data tables
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:child_race','data_act76_child_race','',0,'year,month,geo_type,geography,race',NULL,NULL,NULL,NULL);
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:child_age','data_act76_child_age','',0,'year,month,geo_type,geography,age',NULL,NULL,NULL,NULL);
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:child_citizenship','data_act76_child_citizenship','',0,'year,month,geo_type,geography,citizenship',NULL,NULL,NULL,NULL);
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:child_ethnicity','data_act76_child_ethnicity','',0,'year,month,geo_type,geography,ethnicity',NULL,NULL,NULL,NULL);
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:child_gender','data_act76_child_gender','',0,'year,month,geo_type,geography,gender',NULL,NULL,NULL,NULL);
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:child_total','data_act76_child_total','',0,'year,month,geo_type,geography',NULL,NULL,NULL,NULL);

-- Upload types for Act76 family data tables
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:family_pct_of_fpl','data_act76_family_pct_of_fpl','',0,'year,month,geo_type,geography,pct_of_fpl',NULL,NULL,NULL,NULL);
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:family_service_need','data_act76_family_service_need','',0,'year,month,geo_type,geography,service_need',NULL,NULL,NULL,NULL);
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:family_total','data_act76_family_total','',0,'year,month,geo_type,geography',NULL,NULL,NULL,NULL);




-- Upload types for Act76 child total data by geography type (filtered)
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:child_total_county','data_act76_child_total','SELECT * FROM data_act76_child_total WHERE geo_type = "county"',0,'year,month,geo_type,geography',NULL,NULL,NULL,NULL);
INSERT INTO `upload_types` (`type`,`table`,`download_query`,`read_only`,`index_columns`,`column_map`,`name`,`last_upload`,`filters`) VALUES ('act76:child_total_ahsd','data_act76_child_total','SELECT * FROM data_act76_child_total WHERE geo_type = "AHS district"',0,'year,month,geo_type,geography',NULL,NULL,NULL,NULL);
