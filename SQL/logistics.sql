-- Active: 1744998584825@@douyin.zsxfun.fun@3306@logistics
-- ----------------------------
-- Chat2DB export data , export time: 2025-07-07 02:55:11
-- ----------------------------
SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for table Commodity
-- ----------------------------
DROP TABLE IF EXISTS `Commodity`;
CREATE TABLE `Commodity` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `brand` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL,
  `total_inbound` int NOT NULL,
  `total_outbound` int NOT NULL,
  `supplier` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `last_update_time` datetime(6) NOT NULL,
  `storage_area` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 插入商品数据到 Commodity 表
INSERT INTO `Commodity` (`name`, `image`, `brand`, `description`, `status`, `price`, `stock`, `total_inbound`, `total_outbound`, `supplier`, `create_time`, `last_update_time`, `storage_area`) VALUES
('海尔冰箱', 'https://ts1.tc.mm.bing.net/th/id/OIP-C.CjbS9TqwMegLcwaTA7pCAgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3', 'Haier', '海尔冰箱，遥遥领先', '1', 3999.00, 0, 0, 0, '海尔集团公司', '2025-01-15 10:30:00', '2025-01-20 14:30:00', 'A区-L1层-01号'),
('海尔空调', 'https://imgservice.suning.cn/uimg1/b2c/image/ofgTnG1XQh9fdeaGhs0wnA.jpg_800w_800h_4e', 'Haier', '海尔空调，遥遥领先', '1', 2999.00, 0, 0, 0, '海尔集团公司', '2025-01-10 14:20:00', '2025-01-18 16:45:00', 'A区-L2层-03号'),
('海尔电视', 'https://imgservice.suning.cn/uimg1/b2c/image/TJqCFOY9MhPSXJab_76Ceg.jpg_800w_800h_4e', 'Haier', '海尔电视，遥遥领先', '2', 3999.00, 0, 0, 0, '海尔集团公司', '2025-01-08 09:15:00', '2025-01-19 11:20:00', 'B区-L1层-05号'),
('海尔洗衣机', 'https://imgservice.suning.cn/uimg1/b2c/image/2jOBNNCQdMN2C5VkFaPIjg.png_800w_800h_4e', 'Haier', '海尔洗衣机，遥遥领先', '3', 1999.00, 0, 0, 0, '海尔集团公司', '2025-02-01 16:45:00', '2025-02-05 09:30:00', 'B区-L2层-07号'),
('海尔热水器', 'https://ts1.tc.mm.bing.net/th/id/OIP-C.0E-HDX7AMbNspKcsWq9SPgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3', 'Haier', '海尔热水器，遥遥领先', '1', 999.00, 0, 0, 0, '海尔集团公司', '2025-01-20 11:30:00', '2025-01-22 13:15:00', 'C区-L1层-02号');

-- ----------------------------
-- Records of Commodity
-- ----------------------------
-- ----------------------------
-- Table structure for table Department
-- ----------------------------
DROP TABLE IF EXISTS `Department`;
CREATE TABLE `Department` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `is_enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 插入部门数据
INSERT INTO `Department` (`department_name`, `description`, `create_time`, `is_enabled`) VALUES
('总经办', '负责公司整体管理和决策', '2025-07-01 12:34:56', 1),
('人事管理部', '负责人事管理和员工招聘', '2025-07-01 12:34:56', 1),
('订单管理部', '负责订单管理和处理', '2025-07-01 12:34:56', 1),
('配送管理部', '负责配送管理和运输', '2025-07-01 12:34:56', 1),
('仓储管理部', '负责仓储资源管理', '2025-07-01 12:34:56', 1),
('采购管理部', '负责采购管理和供应商对接', '2025-07-01 12:34:56', 1),
('财务管理部', '负责财务管理和会计核算', '2025-07-01 12:34:56', 1),
('客服售后部', '负责客户服务和支持', '2025-07-01 12:34:56', 0),
('电商运营部', '负责电商平台运营', '2025-07-01 12:34:56', 0);

-- ----------------------------
-- Records of Department
-- ----------------------------
-- ----------------------------
-- Table structure for table ExpenditureRecord
-- ----------------------------
DROP TABLE IF EXISTS `ExpenditureRecord`;
CREATE TABLE `ExpenditureRecord` (
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
-- Records of ExpenditureRecord
-- ----------------------------
-- ----------------------------
-- Table structure for table Finance
-- ----------------------------
DROP TABLE IF EXISTS `Finance`;
CREATE TABLE `Finance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `balance` decimal(12,2) NOT NULL,
  `income` decimal(12,2) NOT NULL,
  `expenditure` decimal(12,2) NOT NULL,
  `net_profit` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 初始化财务数据
INSERT INTO `Finance` (`balance`, `income`, `expenditure`, `net_profit`) VALUES
(0.00, 0.00, 0.00, 0.00);

-- ----------------------------
-- Records of Finance
-- ----------------------------
-- ----------------------------
-- Table structure for table InboundRecord
-- ----------------------------
DROP TABLE IF EXISTS `InboundRecord`;
CREATE TABLE `InboundRecord` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `reason` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `inbound_time` datetime(6) NOT NULL,
  `related_order` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `inbound_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `inbound_job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `commodity_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `InboundRecord_commodity_id_857bbdc1_fk_Commodity_id` (`commodity_id`),
  CONSTRAINT `InboundRecord_commodity_id_857bbdc1_fk_Commodity_id` FOREIGN KEY (`commodity_id`) REFERENCES `Commodity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of InboundRecord
-- ----------------------------
-- ----------------------------
-- Table structure for table IncomeRecord
-- ----------------------------
DROP TABLE IF EXISTS `IncomeRecord`;
CREATE TABLE `IncomeRecord` (
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
-- Records of IncomeRecord
-- ----------------------------
-- ----------------------------
-- Table structure for table OutboundRecord
-- ----------------------------
DROP TABLE IF EXISTS `OutboundRecord`;
CREATE TABLE `OutboundRecord` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `reason` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `outbound_time` datetime(6) NOT NULL,
  `related_order` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `outbound_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `outbound_job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `commodity_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `OutboundRecord_commodity_id_5308ec71_fk_Commodity_id` (`commodity_id`),
  CONSTRAINT `OutboundRecord_commodity_id_5308ec71_fk_Commodity_id` FOREIGN KEY (`commodity_id`) REFERENCES `Commodity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of OutboundRecord
-- ----------------------------
-- ----------------------------
-- Table structure for table PurchaseOrder
-- ----------------------------
DROP TABLE IF EXISTS `PurchaseOrder`;
CREATE TABLE `PurchaseOrder` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `purchase_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `purchase_job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `order_time` datetime(6) NOT NULL,
  `check_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `check_job_number` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `check_time` datetime(6) DEFAULT NULL,
  `check_reason` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `inbound_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `inbound_job_number` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `inbound_time` datetime(6) DEFAULT NULL,
  `commodity_id` bigint NOT NULL,
  `supplier_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `PurchaseOrder_commodity_id_87f4d919_fk_Commodity_id` (`commodity_id`),
  KEY `PurchaseOrder_supplier_id_7bd6a9d5_fk_Supplier_id` (`supplier_id`),
  CONSTRAINT `PurchaseOrder_commodity_id_87f4d919_fk_Commodity_id` FOREIGN KEY (`commodity_id`) REFERENCES `Commodity` (`id`),
  CONSTRAINT `PurchaseOrder_supplier_id_7bd6a9d5_fk_Supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `Supplier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 插入采购订单数据到 PurchaseOrder 表
INSERT INTO `PurchaseOrder` (
    `order_number`, 
    `unit_price`, 
    `quantity`, 
    `total_amount`, 
    `status`, 
    `purchase_name`, 
    `purchase_job_number`, 
    `order_time`, 
    `check_name`, 
    `check_job_number`, 
    `check_time`, 
    `check_reason`, 
    `inbound_name`, 
    `inbound_job_number`, 
    `inbound_time`, 
    `commodity_id`, 
    `supplier_id`
) VALUES
('PO202501150001', 8999.00, 50, 449950.00, '2', 'Isabella Moore', 'EMP011', '2025-01-15 09:30:00', NULL, NULL, NULL, NULL, 'Mia Clark', 'EMP009', '2025-01-16 14:20:00', 1, 1),
('PO202501160002', 15999.00, 20, 319980.00, '1', 'Isabella Moore', 'EMP011', '2025-01-16 10:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 1),
('PO202501170003', 1899.00, 100, 189900.00, '2', 'Isabella Moore', 'EMP011', '2025-01-17 14:30:00', NULL, NULL, NULL, NULL, 'Mia Clark', 'EMP009', '2025-01-18 11:45:00', 3, 1),
('PO202501180004', 5999.00, 30, 179970.00, '3', 'Isabella Moore', 'EMP011', '2025-01-18 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 3),
('PO202501190005', 7999.00, 15, 119985.00, '2', 'Isabella Moore', 'EMP011', '2025-01-19 09:45:00', NULL, NULL, NULL, NULL, 'Mia Clark', 'EMP009', '2025-01-20 15:30:00', 5, 4);

-- ----------------------------
-- Records of PurchaseOrder
-- ----------------------------
-- ----------------------------
-- Table structure for table Role
-- ----------------------------
DROP TABLE IF EXISTS `Role`;
CREATE TABLE `Role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `role_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `is_enabled` tinyint(1) NOT NULL,
  `department_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_code` (`role_code`),
  KEY `Role_department_id_41170d3a_fk_Department_id` (`department_id`),
  CONSTRAINT `Role_department_id_41170d3a_fk_Department_id` FOREIGN KEY (`department_id`) REFERENCES `Department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 插入职务数据
INSERT INTO `Role` (`role_name`, `role_code`, `description`, `create_time`, `is_enabled`, `department_id`) VALUES
('总经理', 'R_SUPER', '拥有系统最高权限', '2025-07-01 12:34:56', 1, 1),
('人事管理员', 'R_USER_INFO', '管理用户信息相关权限', '2025-07-01 12:34:56', 1, 2),
('运单管理员', 'R_ORDER', '管理运单相关权限', '2025-07-01 12:34:56', 1, 3),
('运输管理员', 'R_DELIVERY', '管理配送运输相关权限', '2025-07-01 12:34:56', 1, 4),
('仓储管理员', 'R_STORAGE', '管理仓储作业权限', '2025-07-01 12:34:56', 1, 5),
('采购管理员', 'R_PURCHASE', '管理采购与供应商相关权限', '2025-07-01 12:34:56', 1, 6),
('财务管理员', 'R_FINANCE', '管理财务相关权限', '2025-07-01 12:34:56', 1, 7),
('人事员', 'E_USER_INFO', '拥有系统普通权限', '2025-07-01 12:34:56', 1, 2),
('运单员', 'E_ORDER', '负责运单的创建和录入', '2025-07-01 12:34:56', 1, 3),
('配送员', 'E_DELIVERY', '负责将货物运输到目的地', '2025-07-01 12:34:56', 1, 4),
('仓储员', 'E_STORAGE', '负责清点库存和货物搬运', '2025-07-01 12:34:56', 1, 5),
('采购员', 'E_PURCHASE', '负责采购订单的处理和商品的采购', '2025-07-01 12:34:56', 1, 6),
('财务员', 'E_FINANCE', '负责财务相关工作', '2025-07-01 12:34:56', 1, 7);

-- ----------------------------
-- Records of Role
-- ----------------------------
-- ----------------------------
-- Table structure for table ShippingOrder
-- ----------------------------
DROP TABLE IF EXISTS `ShippingOrder`;
CREATE TABLE `ShippingOrder` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `quantity` int NOT NULL,
  `receiver_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `receiver_phone` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `receiver_address` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `complete_time` datetime(6) DEFAULT NULL,
  `creator_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `creator_job_number` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `check_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `check_job_number` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `check_time` datetime(6) DEFAULT NULL,
  `check_reason` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `delivery_time` datetime(6) DEFAULT NULL,
  `delivery_job_number` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `delivery_person_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `delivery_person_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `delivery_car_number` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `commodity_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `ShippingOrder_commodity_id_1f46ad54_fk_Commodity_id` (`commodity_id`),
  CONSTRAINT `ShippingOrder_commodity_id_1f46ad54_fk_Commodity_id` FOREIGN KEY (`commodity_id`) REFERENCES `Commodity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ShippingOrder
-- ----------------------------
-- ----------------------------
-- Table structure for table StaticRoute
-- ----------------------------
DROP TABLE IF EXISTS `StaticRoute`;
CREATE TABLE `StaticRoute` (
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
-- Records of StaticRoute
-- ----------------------------
-- ----------------------------
-- Table structure for table Supplier
-- ----------------------------
DROP TABLE IF EXISTS `Supplier`;
CREATE TABLE `Supplier` (
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

-- 让数据库自动生成ID的版本
INSERT INTO `Supplier` (`name`, `supplier_type`, `address`, `contact_person`, `contact_phone`, `contact_email`, `create_time`, `status`) VALUES
('海尔集团公司', '企业', '北京市朝阳区中关村科技园区', '张经理', '010-85123456', 'zhang@Haier.com', '2025-01-15 10:30:00', '1'),
('海尔集团上海分公司', '企业', '上海市浦东新区张江高科技园区', '李总监', '010-56781234', 'li.director@haier.com', '2025-02-20 14:20:00', '1'),
('海尔集团江苏分公司', '企业', '江苏省南京市玄武区玄武大道123号', '王部长', '021-58901234', 'wang.minister@Haier.cn', '2025-03-10 09:15:00', '1'),
('海尔集团浙江分公司', '企业', '浙江省杭州市西湖区西湖大道123号', '刘经理', '021-38123456', 'liu.manager@Haier.com.cn', '2025-04-05 16:45:00', '1');

-- ----------------------------
-- Records of Supplier
-- ----------------------------
-- ----------------------------
-- Table structure for table User
-- ----------------------------
DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
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
  `job_number` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `gender` int NOT NULL,
  `mobile` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `position` int NOT NULL,
  `status` int NOT NULL,
  `avatar` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户';

-- ----------------------------
-- Records of User
-- ----------------------------
-- ----------------------------
-- Table structure for table User_groups
-- ----------------------------
DROP TABLE IF EXISTS `User_groups`;
CREATE TABLE `User_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_groups_user_id_group_id_d63e199e_uniq` (`user_id`,`group_id`),
  KEY `User_groups_group_id_328392a3_fk_auth_group_id` (`group_id`),
  CONSTRAINT `User_groups_group_id_328392a3_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `User_groups_user_id_8f675f72_fk_User_id` FOREIGN KEY (`user_id`) REFERENCES `User` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of User_groups
-- ----------------------------
-- ----------------------------
-- Table structure for table User_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `User_user_permissions`;
CREATE TABLE `User_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_user_permissions_user_id_permission_id_af0f54ec_uniq` (`user_id`,`permission_id`),
  KEY `User_user_permission_permission_id_8e998ba4_fk_auth_perm` (`permission_id`),
  CONSTRAINT `User_user_permission_permission_id_8e998ba4_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `User_user_permissions_user_id_2c6da4d4_fk_User_id` FOREIGN KEY (`user_id`) REFERENCES `User` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of User_user_permissions
-- ----------------------------
-- ----------------------------
-- Table structure for table Vehicle
-- ----------------------------
DROP TABLE IF EXISTS `Vehicle`;
CREATE TABLE `Vehicle` (
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
  `driver_job_number` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate_number` (`plate_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of Vehicle
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('33','Can add 财务总览','9','add_finance');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('34','Can change 财务总览','9','change_finance');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('35','Can delete 财务总览','9','delete_finance');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('36','Can view 财务总览','9','view_finance');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('37','Can add 财务收入记录','10','add_incomerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('38','Can change 财务收入记录','10','change_incomerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('39','Can delete 财务收入记录','10','delete_incomerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('40','Can view 财务收入记录','10','view_incomerecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('41','Can add 固定线路','11','add_staticroute');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('42','Can change 固定线路','11','change_staticroute');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('43','Can delete 固定线路','11','delete_staticroute');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('44','Can view 固定线路','11','view_staticroute');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('45','Can add 供应商','12','add_supplier');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('46','Can change 供应商','12','change_supplier');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('47','Can delete 供应商','12','delete_supplier');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('48','Can view 供应商','12','view_supplier');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('49','Can add 车辆','13','add_vehicle');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('50','Can change 车辆','13','change_vehicle');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('51','Can delete 车辆','13','delete_vehicle');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('52','Can view 车辆','13','view_vehicle');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('53','Can add 入库记录','14','add_inboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('54','Can change 入库记录','14','change_inboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('55','Can delete 入库记录','14','delete_inboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('56','Can view 入库记录','14','view_inboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('57','Can add 出库记录','15','add_outboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('58','Can change 出库记录','15','change_outboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('59','Can delete 出库记录','15','delete_outboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('60','Can view 出库记录','15','view_outboundrecord');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('61','Can add 职务','16','add_role');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('62','Can change 职务','16','change_role');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('63','Can delete 职务','16','delete_role');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('64','Can view 职务','16','view_role');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('65','Can add 运单','17','add_shippingorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('66','Can change 运单','17','change_shippingorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('67','Can delete 运单','17','delete_shippingorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('68','Can view 运单','17','view_shippingorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('69','Can add 采购订单','18','add_purchaseorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('70','Can change 采购订单','18','change_purchaseorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('71','Can delete 采购订单','18','delete_purchaseorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('72','Can view 采购订单','18','view_purchaseorder');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('73','Can add user','19','add_user');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('74','Can change user','19','change_user');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('75','Can delete user','19','delete_user');
INSERT INTO `auth_permission` (`id`,`name`,`content_type_id`,`codename`)  VALUES ('76','Can view user','19','view_user');
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
  KEY `django_admin_log_user_id_c564eba6_fk_User_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_User_id` FOREIGN KEY (`user_id`) REFERENCES `User` (`id`),
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('9','Core','finance');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('14','Core','inboundrecord');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('10','Core','incomerecord');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('15','Core','outboundrecord');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('18','Core','purchaseorder');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('16','Core','role');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('17','Core','shippingorder');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('11','Core','staticroute');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('12','Core','supplier');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('19','Core','user');
INSERT INTO `django_content_type` (`id`,`app_label`,`model`)  VALUES ('13','Core','vehicle');
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
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('1','contenttypes','0001_initial','2025-07-07 02:51:10.457039');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('2','contenttypes','0002_remove_content_type_name','2025-07-07 02:52:28.697050');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('3','auth','0001_initial','2025-07-07 02:52:28.953089');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('4','auth','0002_alter_permission_name_max_length','2025-07-07 02:52:29.004444');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('5','auth','0003_alter_user_email_max_length','2025-07-07 02:52:29.015666');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('6','auth','0004_alter_user_username_opts','2025-07-07 02:52:29.027120');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('7','auth','0005_alter_user_last_login_null','2025-07-07 02:52:29.039197');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('8','auth','0006_require_contenttypes_0002','2025-07-07 02:52:29.047973');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('9','auth','0007_alter_validators_add_error_messages','2025-07-07 02:52:29.058736');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('10','auth','0008_alter_user_username_max_length','2025-07-07 02:52:29.069388');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('11','auth','0009_alter_user_last_name_max_length','2025-07-07 02:52:29.082035');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('12','auth','0010_alter_group_name_max_length','2025-07-07 02:52:29.107537');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('13','auth','0011_update_proxy_permissions','2025-07-07 02:52:29.139085');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('14','auth','0012_alter_user_first_name_max_length','2025-07-07 02:52:29.150818');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('15','Core','0001_initial','2025-07-07 02:52:30.024438');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('16','admin','0001_initial','2025-07-07 02:53:33.692968');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('17','admin','0002_logentry_remove_auto_add','2025-07-07 02:53:33.714235');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('18','admin','0003_logentry_add_action_flag_choices','2025-07-07 02:53:33.733117');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('19','sessions','0001_initial','2025-07-07 02:53:33.794780');
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
