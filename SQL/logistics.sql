-- ----------------------------
-- Chat2DB export data , export time: 2025-07-04 12:52:27
-- ----------------------------
SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for table auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
-- ----------------------------
-- Table structure for table auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------
-- ----------------------------
-- Table structure for table auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('1','Can add log entry','1','add_logentry');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('2','Can change log entry','1','change_logentry');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('3','Can delete log entry','1','delete_logentry');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('4','Can view log entry','1','view_logentry');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('5','Can add permission','2','add_permission');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('6','Can change permission','2','change_permission');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('7','Can delete permission','2','delete_permission');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('8','Can view permission','2','view_permission');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('9','Can add group','3','add_group');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('10','Can change group','3','change_group');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('11','Can delete group','3','delete_group');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('12','Can view group','3','view_group');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('13','Can add content type','4','add_contenttype');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('14','Can change content type','4','change_contenttype');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('15','Can delete content type','4','delete_contenttype');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('16','Can view content type','4','view_contenttype');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('17','Can add session','5','add_session');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('18','Can change session','5','change_session');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('19','Can delete session','5','delete_session');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('20','Can view session','5','view_session');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('21','Can add 商品','6','add_commodity');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('22','Can change 商品','6','change_commodity');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('23','Can delete 商品','6','delete_commodity');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('24','Can view 商品','6','view_commodity');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('25','Can add 部门','7','add_department');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('26','Can change 部门','7','change_department');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('27','Can delete 部门','7','delete_department');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('28','Can view 部门','7','view_department');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('29','Can add 财务支出记录','8','add_expenditurerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('30','Can change 财务支出记录','8','change_expenditurerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('31','Can delete 财务支出记录','8','delete_expenditurerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('32','Can view 财务支出记录','8','view_expenditurerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('33','Can add 财务收入记录','9','add_incomerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('34','Can change 财务收入记录','9','change_incomerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('35','Can delete 财务收入记录','9','delete_incomerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('36','Can view 财务收入记录','9','view_incomerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('37','Can add 静态线路','10','add_staticroute');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('38','Can change 静态线路','10','change_staticroute');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('39','Can delete 静态线路','10','delete_staticroute');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('40','Can view 静态线路','10','view_staticroute');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('41','Can add 供应商','11','add_supplier');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('42','Can change 供应商','11','change_supplier');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('43','Can delete 供应商','11','delete_supplier');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('44','Can view 供应商','11','view_supplier');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('45','Can add 车辆','12','add_vehicle');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('46','Can change 车辆','12','change_vehicle');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('47','Can delete 车辆','12','delete_vehicle');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('48','Can view 车辆','12','view_vehicle');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('49','Can add 入库记录','13','add_inboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('50','Can change 入库记录','13','change_inboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('51','Can delete 入库记录','13','delete_inboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('52','Can view 入库记录','13','view_inboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('53','Can add 出库记录','14','add_outboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('54','Can change 出库记录','14','change_outboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('55','Can delete 出库记录','14','delete_outboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('56','Can view 出库记录','14','view_outboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('57','Can add 角色','15','add_role');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('58','Can change 角色','15','change_role');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('59','Can delete 角色','15','delete_role');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('60','Can view 角色','15','view_role');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('61','Can add 运单','16','add_shippingorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('62','Can change 运单','16','change_shippingorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('63','Can delete 运单','16','delete_shippingorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('64','Can view 运单','16','view_shippingorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('65','Can add 采购订单','17','add_purchaseorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('66','Can change 采购订单','17','change_purchaseorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('67','Can delete 采购订单','17','delete_purchaseorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('68','Can view 采购订单','17','view_purchaseorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('69','Can add 用户','18','add_user');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('70','Can change 用户','18','change_user');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('71','Can delete 用户','18','delete_user');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('72','Can view 用户','18','view_user');
-- ----------------------------
-- Table structure for table core_commodity
-- ----------------------------
DROP TABLE IF EXISTS `core_commodity`;
CREATE TABLE `core_commodity` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `brand` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL,
  `total_inbound` int NOT NULL,
  `total_outbound` int NOT NULL,
  `supplier` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `last_update_time` datetime(6) NOT NULL,
  `storage_area` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_commodity
-- ----------------------------
-- ----------------------------
-- Table structure for table core_department
-- ----------------------------
DROP TABLE IF EXISTS `core_department`;
CREATE TABLE `core_department` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `department_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `is_enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `department_code` (`department_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_department
-- ----------------------------
-- ----------------------------
-- Table structure for table core_expenditure_record
-- ----------------------------
DROP TABLE IF EXISTS `core_expenditure_record`;
CREATE TABLE `core_expenditure_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `amount` decimal(12,2) NOT NULL,
  `reason` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `related_order` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `expenditure_time` datetime(6) NOT NULL,
  `operator_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `operator_job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `remark` longtext COLLATE utf8mb4_general_ci,
  `create_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_expenditure_record
-- ----------------------------
-- ----------------------------
-- Table structure for table core_inbound_record
-- ----------------------------
DROP TABLE IF EXISTS `core_inbound_record`;
CREATE TABLE `core_inbound_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `reason` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `inbound_time` datetime(6) NOT NULL,
  `related_order` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `operator` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `commodity_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `core_inbound_record_commodity_id_5ce6ee9c_fk_core_commodity_id` (`commodity_id`),
  CONSTRAINT `core_inbound_record_commodity_id_5ce6ee9c_fk_core_commodity_id` FOREIGN KEY (`commodity_id`) REFERENCES `core_commodity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_inbound_record
-- ----------------------------
-- ----------------------------
-- Table structure for table core_income_record
-- ----------------------------
DROP TABLE IF EXISTS `core_income_record`;
CREATE TABLE `core_income_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `amount` decimal(12,2) NOT NULL,
  `reason` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `related_order` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `income_time` datetime(6) NOT NULL,
  `operator_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `operator_job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `remark` longtext COLLATE utf8mb4_general_ci,
  `create_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_income_record
-- ----------------------------
-- ----------------------------
-- Table structure for table core_outbound_record
-- ----------------------------
DROP TABLE IF EXISTS `core_outbound_record`;
CREATE TABLE `core_outbound_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `reason` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `outbound_time` datetime(6) NOT NULL,
  `related_order` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `operator` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `commodity_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `core_outbound_record_commodity_id_d2172a7f_fk_core_commodity_id` (`commodity_id`),
  CONSTRAINT `core_outbound_record_commodity_id_d2172a7f_fk_core_commodity_id` FOREIGN KEY (`commodity_id`) REFERENCES `core_commodity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_outbound_record
-- ----------------------------
-- ----------------------------
-- Table structure for table core_purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `core_purchase_order`;
CREATE TABLE `core_purchase_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `order_time` datetime(6) NOT NULL,
  `inbound_time` datetime(6) DEFAULT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `purchaser_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `purchaser_job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `warehouse_keeper_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `warehouse_keeper_job_number` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `commodity_id` bigint NOT NULL,
  `supplier_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `core_purchase_order_commodity_id_0ce66953_fk_core_commodity_id` (`commodity_id`),
  KEY `core_purchase_order_supplier_id_e24a2edb_fk_core_supplier_id` (`supplier_id`),
  CONSTRAINT `core_purchase_order_commodity_id_0ce66953_fk_core_commodity_id` FOREIGN KEY (`commodity_id`) REFERENCES `core_commodity` (`id`),
  CONSTRAINT `core_purchase_order_supplier_id_e24a2edb_fk_core_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `core_supplier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_purchase_order
-- ----------------------------
-- ----------------------------
-- Table structure for table core_role
-- ----------------------------
DROP TABLE IF EXISTS `core_role`;
CREATE TABLE `core_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `role_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `is_enabled` tinyint(1) NOT NULL,
  `department_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_code` (`role_code`),
  KEY `core_role_department_id_6f8926cb_fk_core_department_id` (`department_id`),
  CONSTRAINT `core_role_department_id_6f8926cb_fk_core_department_id` FOREIGN KEY (`department_id`) REFERENCES `core_department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_role
-- ----------------------------
-- ----------------------------
-- Table structure for table core_shipping_order
-- ----------------------------
DROP TABLE IF EXISTS `core_shipping_order`;
CREATE TABLE `core_shipping_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `quantity` int NOT NULL,
  `receiver_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `receiver_phone` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `receiver_address` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `complete_time` datetime(6) DEFAULT NULL,
  `creator_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `creator_job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `delivery_person_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `delivery_person_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tracking_info` longtext COLLATE utf8mb4_general_ci,
  `commodity_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `core_shipping_order_commodity_id_2cbfe083_fk_core_commodity_id` (`commodity_id`),
  CONSTRAINT `core_shipping_order_commodity_id_2cbfe083_fk_core_commodity_id` FOREIGN KEY (`commodity_id`) REFERENCES `core_commodity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_shipping_order
-- ----------------------------
-- ----------------------------
-- Table structure for table core_static_route
-- ----------------------------
DROP TABLE IF EXISTS `core_static_route`;
CREATE TABLE `core_static_route` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `departure` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `destination` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `total_distance` decimal(8,2) NOT NULL,
  `estimated_time` decimal(5,1) NOT NULL,
  `schedule_info` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_static_route
-- ----------------------------
-- ----------------------------
-- Table structure for table core_supplier
-- ----------------------------
DROP TABLE IF EXISTS `core_supplier`;
CREATE TABLE `core_supplier` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `supplier_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `address` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `contact_person` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `contact_phone` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `contact_email` varchar(254) COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_supplier
-- ----------------------------
-- ----------------------------
-- Table structure for table core_user
-- ----------------------------
DROP TABLE IF EXISTS `core_user`;
CREATE TABLE `core_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `gender` int NOT NULL,
  `mobile` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `dep` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `position` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `avatar` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `job_number` (`job_number`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_user
-- ----------------------------
INSERT INTO `core_user` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`gender`,`mobile`,`dep`,`status`,`job_number`,`position`,`avatar`)  VALUES ('1','pbkdf2_sha256$1000000$F1hXH0Dv54vAteTfFw0KqR$tuiUeiYSaPavZywnOTUOjQmDWPdJY0AtmGaVAyD22E0=',NULL,1,'SuperAdmin','','','123456789@qq.com',1,1,'2025-07-04 12:51:23.722373','1','','','1','','',NULL);
-- ----------------------------
-- Table structure for table core_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `core_user_groups`;
CREATE TABLE `core_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_user_groups_user_id_group_id_c82fcad1_uniq` (`user_id`,`group_id`),
  KEY `core_user_groups_group_id_fe8c697f_fk_auth_group_id` (`group_id`),
  CONSTRAINT `core_user_groups_group_id_fe8c697f_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `core_user_groups_user_id_70b4d9b8_fk_core_user_id` FOREIGN KEY (`user_id`) REFERENCES `core_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_user_groups
-- ----------------------------
-- ----------------------------
-- Table structure for table core_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `core_user_user_permissions`;
CREATE TABLE `core_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_user_user_permissions_user_id_permission_id_73ea0daa_uniq` (`user_id`,`permission_id`),
  KEY `core_user_user_permi_permission_id_35ccf601_fk_auth_perm` (`permission_id`),
  CONSTRAINT `core_user_user_permi_permission_id_35ccf601_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `core_user_user_permissions_user_id_085123d3_fk_core_user_id` FOREIGN KEY (`user_id`) REFERENCES `core_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_user_user_permissions
-- ----------------------------
-- ----------------------------
-- Table structure for table core_vehicle
-- ----------------------------
DROP TABLE IF EXISTS `core_vehicle`;
CREATE TABLE `core_vehicle` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vehicle_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `current_load` int NOT NULL,
  `max_load` int NOT NULL,
  `health_status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `plate_number` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `purchase_time` datetime(6) NOT NULL,
  `storage_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `current_route` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate_number` (`plate_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of core_vehicle
-- ----------------------------
-- ----------------------------
-- Table structure for table django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_general_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_core_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_core_user_id` FOREIGN KEY (`user_id`) REFERENCES `core_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
-- ----------------------------
-- Table structure for table django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('1','admin','logentry');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('3','auth','group');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('2','auth','permission');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('4','contenttypes','contenttype');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('6','Core','commodity');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('7','Core','department');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('8','Core','expenditurerecord');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('13','Core','inboundrecord');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('9','Core','incomerecord');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('14','Core','outboundrecord');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('17','Core','purchaseorder');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('15','Core','role');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('16','Core','shippingorder');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('10','Core','staticroute');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('11','Core','supplier');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('18','Core','user');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('12','Core','vehicle');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('5','sessions','session');
-- ----------------------------
-- Table structure for table django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('1','contenttypes','0001_initial','2025-07-04 12:49:12.762882');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('2','contenttypes','0002_remove_content_type_name','2025-07-04 12:49:12.851124');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('3','auth','0001_initial','2025-07-04 12:49:13.086116');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('4','auth','0002_alter_permission_name_max_length','2025-07-04 12:49:13.136176');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('5','auth','0003_alter_user_email_max_length','2025-07-04 12:49:13.146846');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('6','auth','0004_alter_user_username_opts','2025-07-04 12:49:13.157918');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('7','auth','0005_alter_user_last_login_null','2025-07-04 12:49:13.168903');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('8','auth','0006_require_contenttypes_0002','2025-07-04 12:49:13.177928');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('9','auth','0007_alter_validators_add_error_messages','2025-07-04 12:49:13.189873');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('10','auth','0008_alter_user_username_max_length','2025-07-04 12:49:13.200459');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('11','auth','0009_alter_user_last_name_max_length','2025-07-04 12:49:13.210188');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('12','auth','0010_alter_group_name_max_length','2025-07-04 12:49:13.235291');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('13','auth','0011_update_proxy_permissions','2025-07-04 12:49:13.266242');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('14','auth','0012_alter_user_first_name_max_length','2025-07-04 12:49:13.276562');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('15','Core','0001_initial','2025-07-04 12:49:14.112194');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('16','admin','0001_initial','2025-07-04 12:49:14.239213');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('17','admin','0002_logentry_remove_auto_add','2025-07-04 12:49:14.251119');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('18','admin','0003_logentry_add_action_flag_choices','2025-07-04 12:49:14.262956');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('19','sessions','0001_initial','2025-07-04 12:49:14.312588');
-- ----------------------------
-- Table structure for table django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of django_session
-- ----------------------------
SET FOREIGN_KEY_CHECKS=1;
