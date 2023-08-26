CREATE TABLE `dashboard_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Category` varchar(256) NOT NULL,
  `Topics` int DEFAULT NULL,
  `Goals` int DEFAULT NULL,
  `Geographies` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Category_UNIQUE` (`Category`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

CREATE TABLE `dashboard_indicators` (
  `id` int NOT NULL AUTO_INCREMENT,
  `wp_id` int NOT NULL,
  `slug` varchar(256) NOT NULL,
  `Chart_url` varchar(256) DEFAULT NULL,
  `link` varchar(256) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  `BN Cost of living` int DEFAULT NULL,
  `BN Housing` int DEFAULT NULL,
  `BN Food security and nutrition` int DEFAULT NULL,
  `BN Financial assistance` int DEFAULT NULL,
  `Housing Housing` int DEFAULT NULL,
  `Demographic living arrangements` int DEFAULT NULL,
  `Demographics population` int DEFAULT NULL,
  `Econ Cost of living` int DEFAULT NULL,
  `Econ Financial assistance` int DEFAULT NULL,
  `Econ Economic impact` int DEFAULT NULL,
  `Child Care Access` int DEFAULT NULL,
  `Child development Service access and utilization` int DEFAULT NULL,
  `Child development Standardized tests and screening` int DEFAULT NULL,
  `Education Standardized tests` int DEFAULT NULL,
  `Education Student characteristics` int DEFAULT NULL,
  `Mental health Access` int DEFAULT NULL,
  `Mental health Prevalence` int DEFAULT NULL,
  `PH Mental health` int DEFAULT NULL,
  `PH Access and utilization` int DEFAULT NULL,
  `PH Food security and nutrition` int DEFAULT NULL,
  `PH Perinatal health` int DEFAULT NULL,
  `R Food security and nutrition` int DEFAULT NULL,
  `R Housing` int DEFAULT NULL,
  `R Cost of living` int DEFAULT NULL,
  `R Mental health` int DEFAULT NULL,
  `R Other environmental factors` int DEFAULT NULL,
  `R Social and emotional` int DEFAULT NULL,
  `UPK Access and utilization` int DEFAULT NULL,
  `UPK Standardized tests` int DEFAULT NULL,
  `Workforce Paid Leave` int DEFAULT NULL,
  `Geo_state` int DEFAULT NULL,
  `Geo_AHS_District` int DEFAULT NULL,
  `Geo_County` int DEFAULT NULL,
  `Geo_SU_SD` int DEFAULT NULL,
  `Geo_HSA` int DEFAULT NULL,
  `Goal 1 (healthy start)` int DEFAULT NULL,
  `Goal 2 (families and comm)` int DEFAULT NULL,
  `Goal 3 (opportunties)` int DEFAULT NULL,
  `Goal 4 (integrated/resource/data-drive)` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug_UNIQUE` (`slug`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

CREATE TABLE `dashboard_subcategories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Category` varchar(256) NOT NULL,
  `Basic Needs` int DEFAULT NULL,
  `Child Care` int DEFAULT NULL,
  `Child Development` int DEFAULT NULL,
  `Demographics` int DEFAULT NULL,
  `Economics` int DEFAULT NULL,
  `Education` int DEFAULT NULL,
  `Housing` int DEFAULT NULL,
  `Mental Health` int DEFAULT NULL,
  `Physical Health` int DEFAULT NULL,
  `Resilience` int DEFAULT NULL,
  `UPK` int DEFAULT NULL,
  `Workforce` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Category_UNIQUE` (`Category`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

CREATE TABLE `dashboard_topics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

INSERT INTO `upload_types` (`type`,`table`,`index_columns`,`column_map`) VALUES ('dashboard:indicators','dashboard_indicators','slug',NULL);
INSERT INTO `upload_types` (`type`,`table`,`index_columns`,`column_map`) VALUES ('dashboard:categories','dashboard_categories','Category',NULL);
INSERT INTO `upload_types` (`type`,`table`,`index_columns`,`column_map`) VALUES ('dashboard:subcategories','dashboard_subcategories','Category',NULL);
INSERT INTO `upload_types` (`type`,`table`,`index_columns`,`column_map`) VALUES ('dashboard:topics','dashboard_topics','name',NULL);

INSERT INTO `queries`
  (`name`, `sqlText`, `columnMap`, `metadata`, `uploadType`)
VALUES
  ('dashboard:indicators:table', 'select * from dashboard_indicators', null, null, 'dashboard:indicators');

INSERT INTO `queries`
  (`name`, `sqlText`, `columnMap`, `metadata`, `uploadType`)
VALUES
  ('dashboard:categories:table', 'select * from dashboard_categories', null, null, 'dashboard:categories');

INSERT INTO `queries`
  (`name`, `sqlText`, `columnMap`, `metadata`, `uploadType`)
VALUES
  ('dashboard:subcategories:table', 'select * from dashboard_subcategories', null, null, 'dashboard:subcategories');

INSERT INTO `queries`
  (`name`, `sqlText`, `columnMap`, `metadata`, `uploadType`)
VALUES
  ('dashboard:topics:table', 'select * from dashboard_topics', null, null, 'dashboard:topics');

