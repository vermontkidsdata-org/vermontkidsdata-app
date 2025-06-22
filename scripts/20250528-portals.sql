CREATE TABLE `portals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `portal_topics` (
  `id_topic` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `portal_id` int DEFAULT NULL,
  PRIMARY KEY (`id_topic`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `portal_categories` (
  `id_category` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `portal` int DEFAULT NULL,
  PRIMARY KEY (`id_category`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `portal_subcategories` (
  `id_subcategory` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `portal` int DEFAULT NULL,
  PRIMARY KEY (`id_subcategory`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `portal_category_topic_map` (
  `id` int NOT NULL AUTO_INCREMENT,
  `topic` int DEFAULT NULL,
  `category` int DEFAULT NULL,
  `portal` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `portal_indicators` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chart_url` text,
  `link` text,
  `title` text,
  `portal` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `portal_indicator_map` (
  `id` int NOT NULL AUTO_INCREMENT,
  `portal` int DEFAULT NULL,
  `topic` int DEFAULT NULL,
  `category` int DEFAULT NULL,
  `subcategory` int DEFAULT NULL,
  `indicator` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `portal_subcategory_category_map` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` int DEFAULT NULL,
  `subcategory` int DEFAULT NULL,
  `portal` int DEFAULT NULL,
  `topic` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `portals` (`id`,`name`) VALUES (1,'Vermont’s Early Childhood Data Portal');
INSERT INTO `portals` (`id`,`name`) VALUES (2,'Act 76 Metrics');
INSERT INTO `portal_topics` (`id_topic`,`name`,`portal_id`) VALUES (1,'CCFAP',2);
INSERT INTO `portal_topics` (`id_topic`,`name`,`portal_id`) VALUES (10,'Geography',1);
INSERT INTO `portal_topics` (`id_topic`,`name`,`portal_id`) VALUES (11,'Goals',1);
INSERT INTO `portal_topics` (`id_topic`,`name`,`portal_id`) VALUES (12,'Topics',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (1,'Programs ',NULL);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (3,'New Category',2);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (4,'Second Category',2);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (8,'AHS District; BBF Region; Health Services District',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (9,'Hospital Service Area',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (10,'School District/Supervisory Union',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (11,'County',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (12,'Goal 1: Children Have a Healthy Start',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (13,'Goal 2: Families and Communities Play A Leading Role',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (14,'Goal 3: Access to High-Quality Opportunities',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (15,'Goal 4: Integrated Well-Resourced and Data-Informed System',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (16,'Basic Needs',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (17,'Challenging Childhood Experiences',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (18,'Child Care',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (19,'Child Development',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (20,'Demographics',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (21,'Economics',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (22,'Education',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (23,'Housing',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (24,'Mental Health',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (25,'Physical Health',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (26,'Universal Prekindergarten Education',1);
INSERT INTO `portal_categories` (`id_category`,`name`,`portal`) VALUES (27,'Workforce',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (2,'Act 76 Subcategory 2',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (3,'Act 76 Subcategory 3',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (4,'Act 76 Subcategory 4',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (5,'Act 76 Subcategory 5',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (6,'Act 76 Subcategory 6',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (7,'New Subcategory',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (8,'Second Subcategory',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (9,'Third Subcat',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (11,'New Subcat',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (12,'Cost of Living',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (13,'Financial Assistance',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (14,'Food Security and Nutrition',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (15,'Homelessness',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (16,'Housing',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (17,'Domestic Violence',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (18,'Protective Custody',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (19,'Child Care',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (20,'Early Care and Education Workforce',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (21,'Educational Assessments',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (22,'Living Arrangements',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (23,'Population',1);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (25,'Over Time',2);
INSERT INTO `portal_subcategories` (`id_subcategory`,`name`,`portal`) VALUES (26,'By Type',2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (1,1,1,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (2,1,2,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (3,2,1,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (5,3,3,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (6,4,4,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (7,4,2,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (8,1,5,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (9,4,6,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (10,3,7,2);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (11,10,8,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (12,10,9,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (13,10,10,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (14,10,11,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (15,11,12,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (16,11,13,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (17,11,14,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (18,11,15,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (19,12,16,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (20,12,17,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (21,12,18,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (22,12,19,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (23,12,20,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (24,12,21,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (25,12,22,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (26,12,23,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (27,12,24,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (28,12,25,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (29,12,26,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (30,12,27,1);
INSERT INTO `portal_category_topic_map` (`id`,`topic`,`category`,`portal`) VALUES (31,1,28,2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (32,'/linechart/adverse_experiences_under_18:chart','https://vermontkidsdata.org/aces/','Percent of children under 9 with 2 or fewer Adverse Childhood Experiences (ACEs)',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (33,'/columnchart/breastfed_infants:chart','https://vermontkidsdata.org/breastfeeding-duration-exclusivity/','Breastfeeding duration and exclusivity',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (34,'/columnchart/families_no_05_care:chart','https://vermontkidsdata.org/access-to-0-5-early-care-and-education/','Child care access: families without access to 0-5 early care and education',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (35,'/columnchart/children_ccfap:chart','https://vermontkidsdata.org/families-receiving-ccfap/','Families participating in the Child Care Financial Assistance Program (CCFAP)',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (36,'/linechart/dcf:chart','https://vermontkidsdata.org/child-protection-case-type/','Child protection cases by type of DCF involvement',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (37,'/columnchart/poverty_under_12:chart','https://vermontkidsdata.org/children-in-poverty/','Children in poverty: Households with children under 6 living at or below 185% of the Federal Poverty Level',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (38,'/columnchart/69','https://vermontkidsdata.org/children-served-by-head-start/','Individuals served by Head Start and Early Head Start Programs',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (39,'/columnchart/health_insurance:chart','https://vermontkidsdata.org/health-insurance-coverage/','Children with current and adequate insurance',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (40,'/columnchart/devscreen:chart','https://vermontkidsdata.org/developmental-screening/','Children with a developmental screening',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (41,'/linechart/elevated_blood_lead_levels_by_cat:chart','https://vermontkidsdata.org/elevated-blood-lead-levels/','Children with elevated blood lead levels',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (42,'/columnchart/fsh:chart','https://vermontkidsdata.org/family-supportive-housing/','Families served by Family Supportive Housing (FSH)',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (43,'/columnchart/flourishing_children:chart','https://vermontkidsdata.org/flourishing-children/','Children who are flourishing',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (44,'/linechart/free_reduced_lunch:chart','https://vermontkidsdata.org/free-reduced-lunch/','Children eligible for Free and Reduced Lunch',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (45,'/columnchart/households_30pct_housing:chart','https://vermontkidsdata.org/households-cost-burdened-by-housing/','Households with children spending 30% or more of their income on housing',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (46,'/linechart/children_improved_early_intervention:chart','https://vermontkidsdata.org/improved-social-and-emotional-skills-from-cis-ei/','Improved social and emotional skills from Early Intervention',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (47,'/linechart/intended_pregnancies:chart','https://vermontkidsdata.org/intended-pregnancies/','Intended pregnancies',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (48,'/linechart/children_crisis_services:chart','https://vermontkidsdata.org/mental-health-crisis-services/','Children receiving crisis services from Designated Mental Health Agencies',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (49,'/columnchart/women_no_leave:chart','https://vermontkidsdata.org/no-parental-leave/','Birthing parents without paid parental leave',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (50,'/stackedcolumnchart/ooh_custody:chart','https://vermontkidsdata.org/out-of-home-custody/','Children age 0-9 in out of home protective custody',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (51,'/linechart/families_early_intervention:chart','https://vermontkidsdata.org/parental-competence-cis-ei/','Increased parental competance from Early Intervention',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (52,'/columnchart/preventative_dental:chart','https://vermontkidsdata.org/preventive-dental-visit/','Children under 11 with a preventive dental visit in the past year',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (53,'/linechart/r4k:chart','https://vermontkidsdata.org/ready-for-k/','Children ready for Kindergarten (R4K!S)',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (54,'/linechart/children_designated_mental_agencies:chart','https://vermontkidsdata.org/routine-mental-health-services/','Children receiving routine mental health services from Designated Mental Health Agencies',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (55,'/columnchart/substance_use_pregnancy:chart','https://vermontkidsdata.org/substance-use-during-pregnancy/','Substance use during pregnancy',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (56,'/linechart/third_grade_sbac:all-vermont:chart','https://vermontkidsdata.org/third-grade-assessments/','Third grade reading proficiency',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (57,'/columnchart/mckinney_vento_u9:chart','https://vermontkidsdata.org/unhoused-children/','Children experiencing homelessness (McKinney Vento)',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (58,'/linechart/72','https://vermontkidsdata.org/upk-enrollment/','Children enrolled in Universal Prekindergarten Education',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (59,'/linechart/immunizations:chart','https://vermontkidsdata.org/vaccination-coverage/','Children fully vaccinated by age 2',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (60,'/linechart/wic_participation:chart','https://vermontkidsdata.org/children-served-by-wic/','Children served by the Women, Infants, and Children (WIC) program',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (61,'/linechart/ed:columnchart','https://vermontkidsdata.org/youth-boarding-emergency-departments/','Emergency Department Placement Wait Times for Children with a Primary Mental Health Diagnosis',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (62,'/columnchart/wage_benchmarks:chart','https://vermontkidsdata.org/wage-benchmarks/','Wage Benchmarks',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (63,'/columnchart/pitc_homelessness:chart','https://vermontkidsdata.org/homelessness-point-in-time/','Persons Experiencing Homelessness (PIT)',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (64,'/columnchart/wellcarevisits:chart','https://vermontkidsdata.org/well-care-visits/','Children with a Well Care Visit',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (65,'/linechart/households_food_insecure:chart','https://vermontkidsdata.org/food-insecure-households/','Food Insecure Households with Children Under 18',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (66,'/linechart/children_wic_snap:chart_snap','https://vermontkidsdata.org/children-served-by-snap/','Children Receiving Benefits from the Supplemental Nutrition Assistance Program (SNAP)',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (67,'/linechart/prenatal_visits:chart','https://vermontkidsdata.org/adequate-prenatal-care/','Birthing parents with adequate prenatal care',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (68,'/columnchart/residentialcare:chart','https://vermontkidsdata.org/residential-care/','Children in Residential Care',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (69,'/linechart/iep:chart','https://vermontkidsdata.org/iep/','Children ages 3-8 on an Individualized Education Plan',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (70,'/linechart/child_population_u10:chart','https://vermontkidsdata.org/number-of-children/','Number of Children Under 10',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (71,'/columnchart/ece_workforce:chart','https://vermontkidsdata.org/individuals-in-the-ece-workforce/','Individuals in the ECE Workforce',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (72,'/columnchart/rental_vacancy_rate:chart','https://vermontkidsdata.org/vacancy-rates/','Rental and Homeowner Vacancy Rates',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (73,'/columnchart/race_ethnicity_u10:chart','https://vermontkidsdata.org/population-by-race_and_ethnicity/','Vermont Children Under 10 by Race and Ethnicity',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (74,'/columnchart/pmads:chart','https://vermontkidsdata.org/pmads/','Perinatal Mood and Anxiety Disorders Prevalence',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (75,'/columnchart/coordinated_entry_services:chart','https://vermontkidsdata.org/coordinated-entry/','Coordinated Entry',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (76,'/columnchart/67','https://vermontkidsdata.org/mental-health-condition/','Children with a behavioral, emotional, or mental health condition',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (77,'/linechart/licensed_foster_custody:chart','https://vermontkidsdata.org/foster-homes-and-children-in-custody/','Licensed Foster Homes and Children in Custody',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (80,'/linechart/reachup_caseload:chart','https://vermontkidsdata.org/reach-up/','Reach Up Caseload',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (81,'/columnchart/da_ssa_turnover:chart','https://vermontkidsdata.org/da-ssa-workforce/','Designated Mental Health Agency and Specialized Service Agency Workforce - Turnover Rate',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (82,'/linechart/children_kinship_care:chart','https://vermontkidsdata.org/kinship-care/','Children Living in Kinship Care',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (83,'/columnchart/children_abuse_services:chart','https://vermontkidsdata.org/domestic-and-sexual-violence/','Sexual Abuse Cases',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (84,'/linechart/reachup_max_benefit:chart','https://vermontkidsdata.org/broadband-access/','Broadband Access',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (93,'/columnchartfiltered/ccfap_filtered:chart','','Programs receiving CCFAP payments over time',2);
INSERT INTO `portal_indicators` (`id`,`chart_url`,`link`,`title`,`portal`) VALUES (94,'/columnchartfiltered/ccfap_filtered_byprog:chart','','Programs receiving CCFAP payments by program type',2);

INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (1,2,1,1,1,79);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (2,2,2,1,2,78);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (3,2,1,-1,-1,86);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (4,2,1,1,-1,86);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (5,2,2,-1,-1,79);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (6,2,3,-1,-1,78);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (7,2,1,1,-1,79);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (8,2,4,-1,-1,78);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (9,2,4,-1,-1,86);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (10,2,1,1,-1,78);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (11,2,1,1,1,87);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (12,2,1,1,-1,88);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (13,2,1,-1,1,87);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (14,2,1,-1,1,78);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (15,2,2,1,2,87);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (16,2,1,1,10,88);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (17,2,1,1,24,89);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (18,2,1,1,24,90);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (19,2,1,1,24,0);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (20,2,1,-1,-1,91);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (21,2,1,1,-1,92);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (22,2,1,1,25,92);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (23,2,1,1,25,93);
INSERT INTO `portal_indicator_map` (`id`,`portal`,`topic`,`category`,`subcategory`,`indicator`) VALUES (24,2,1,1,26,94);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (1,1,1,2,1);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (2,1,2,2,2);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (3,2,5,2,1);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (5,3,7,2,3);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (6,4,8,2,4);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (7,4,1,2,4);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (8,4,9,2,4);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (9,1,10,2,1);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (10,2,11,2,4);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (11,16,12,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (12,16,13,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (13,16,14,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (14,16,15,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (15,16,16,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (16,17,17,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (17,17,18,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (18,17,15,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (19,18,19,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (20,18,20,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (21,19,21,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (22,20,22,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (23,20,23,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (24,21,12,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (25,21,13,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (26,21,14,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (27,21,16,1,12);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (28,1,24,2,1);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (29,1,25,2,1);
INSERT INTO `portal_subcategory_category_map` (`id`,`category`,`subcategory`,`portal`,`topic`) VALUES (30,1,26,2,1);
