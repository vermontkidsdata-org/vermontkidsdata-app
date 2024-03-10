CREATE TABLE `dashboard_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Category` varchar(256) NOT NULL,
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug_UNIQUE` (`slug`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

CREATE TABLE `dashboard_subcategories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Category` varchar(256) NOT NULL,
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

