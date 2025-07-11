-- ----------------------------
-- Chat2DB export data , export time: 2025-07-11 11:51:45
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of Commodity
-- ----------------------------
INSERT INTO `Commodity` (`id`,`name`,`image`,`brand`,`description`,`status`,`price`,`stock`,`total_inbound`,`total_outbound`,`supplier`,`create_time`,`last_update_time`,`storage_area`)  VALUES ('1','海尔冰箱','https://ts1.tc.mm.bing.net/th/id/OIP-C.CjbS9TqwMegLcwaTA7pCAgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3','Haier','海尔冰箱，遥遥领先','1',3999.00,'0','10','10','海尔集团江苏分公司','2025-01-15 10:30:00','2025-07-10 09:45:27.921026','A区-L1层-01号');
INSERT INTO `Commodity` (`id`,`name`,`image`,`brand`,`description`,`status`,`price`,`stock`,`total_inbound`,`total_outbound`,`supplier`,`create_time`,`last_update_time`,`storage_area`)  VALUES ('2','海尔空调','https://imgservice.suning.cn/uimg1/b2c/image/ofgTnG1XQh9fdeaGhs0wnA.jpg_800w_800h_4e','Haier','海尔空调，遥遥领先','3',2999.00,'0','0','0','海尔集团浙江分公司','2025-01-10 14:20:00','2025-07-08 05:08:43.032016','A区-L2层-03号');
INSERT INTO `Commodity` (`id`,`name`,`image`,`brand`,`description`,`status`,`price`,`stock`,`total_inbound`,`total_outbound`,`supplier`,`create_time`,`last_update_time`,`storage_area`)  VALUES ('3','海尔电视','https://imgservice.suning.cn/uimg1/b2c/image/TJqCFOY9MhPSXJab_76Ceg.jpg_800w_800h_4e','Haier','海尔电视，遥遥领先','2',3999.00,'10','10','0','Test','2025-01-08 09:15:00','2025-07-10 07:59:13.419523','B区-L1层-05号');
INSERT INTO `Commodity` (`id`,`name`,`image`,`brand`,`description`,`status`,`price`,`stock`,`total_inbound`,`total_outbound`,`supplier`,`create_time`,`last_update_time`,`storage_area`)  VALUES ('4','海尔洗衣机','https://imgservice.suning.cn/uimg1/b2c/image/2jOBNNCQdMN2C5VkFaPIjg.png_800w_800h_4e','Haier','海尔洗衣机，遥遥领先','1',1999.00,'1','6','5','海尔集团总公司','2025-02-01 16:45:00','2025-07-10 11:15:24.569286','B区-L2层-07号');
INSERT INTO `Commodity` (`id`,`name`,`image`,`brand`,`description`,`status`,`price`,`stock`,`total_inbound`,`total_outbound`,`supplier`,`create_time`,`last_update_time`,`storage_area`)  VALUES ('5','海尔热水器','https://ts1.tc.mm.bing.net/th/id/OIP-C.0E-HDX7AMbNspKcsWq9SPgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3','Haier','海尔热水器，遥遥领先','1',999.00,'0','3','3','海尔集团上海分公司','2025-01-20 11:30:00','2025-07-10 07:16:40.544452','C区-L1层-02号');
INSERT INTO `Commodity` (`id`,`name`,`image`,`brand`,`description`,`status`,`price`,`stock`,`total_inbound`,`total_outbound`,`supplier`,`create_time`,`last_update_time`,`storage_area`)  VALUES ('7','洗衣机','http://img.alicdn.com/img/i2/2200717059844/O1CN01s95wJf2Mabqv7Htaq_!!2200717059844-0-alimamacc.jpg','海尔','yjoufuyb','1',90.00,'5','5','0','海尔集团浙江分公司','2025-07-10 11:07:56.829366','2025-07-10 11:15:45.850514','A区-L2层-01号');
INSERT INTO `Commodity` (`id`,`name`,`image`,`brand`,`description`,`status`,`price`,`stock`,`total_inbound`,`total_outbound`,`supplier`,`create_time`,`last_update_time`,`storage_area`)  VALUES ('8','洗衣机1','http://img.alicdn.com/img/i2/2200717059844/O1CN01s95wJf2Mabqv7Htaq_!!2200717059844-0-alimamacc.jpg','海尔','1234567','1',178.00,'5','6','1','海尔集团江苏分公司','2025-07-10 11:09:55.968256','2025-07-10 11:18:42.137569','A区-L1层-02号');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of Department
-- ----------------------------
INSERT INTO `Department` (`id`,`department_name`,`description`,`create_time`,`is_enabled`)  VALUES ('1','总经办','负责公司整体管理和决策','2025-07-01 12:34:56',1);
INSERT INTO `Department` (`id`,`department_name`,`description`,`create_time`,`is_enabled`)  VALUES ('2','人事管理部','负责人事管理和员工招聘','2025-07-01 12:34:56',1);
INSERT INTO `Department` (`id`,`department_name`,`description`,`create_time`,`is_enabled`)  VALUES ('3','运单管理部','负责订单管理和处理','2025-07-01 12:34:56',1);
INSERT INTO `Department` (`id`,`department_name`,`description`,`create_time`,`is_enabled`)  VALUES ('4','配送管理部','负责配送管理和运输','2025-07-01 12:34:56',1);
INSERT INTO `Department` (`id`,`department_name`,`description`,`create_time`,`is_enabled`)  VALUES ('5','仓储管理部','负责仓储资源管理','2025-07-01 12:34:56',1);
INSERT INTO `Department` (`id`,`department_name`,`description`,`create_time`,`is_enabled`)  VALUES ('6','采购管理部','负责采购管理和供应商对接','2025-07-01 12:34:56',1);
INSERT INTO `Department` (`id`,`department_name`,`description`,`create_time`,`is_enabled`)  VALUES ('7','财务管理部','负责财务管理和会计核算','2025-07-01 12:34:56',1);
INSERT INTO `Department` (`id`,`department_name`,`description`,`create_time`,`is_enabled`)  VALUES ('8','客服售后部','负责客户服务和支持','2025-07-01 12:34:56',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ExpenditureRecord
-- ----------------------------
INSERT INTO `ExpenditureRecord` (`id`,`amount`,`reason`,`related_order`,`expenditure_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('1',39990.00,'采购支出','P202507080001','2025-07-08 22:00:51.579460','CEO','100001','采购订单审核通过自动创建 - 商品：海尔冰箱，供应商：海尔集团江苏分公司','2025-07-08 22:00:51.579482');
INSERT INTO `ExpenditureRecord` (`id`,`amount`,`reason`,`related_order`,`expenditure_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('2',2999.00,'采购支出','P202507090002','2025-07-09 15:26:24.019456','CEO','100001','采购订单审核通过自动创建 - 商品：海尔空调，供应商：海尔集团浙江分公司','2025-07-09 15:26:24.019475');
INSERT INTO `ExpenditureRecord` (`id`,`amount`,`reason`,`related_order`,`expenditure_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('3',199900.00,'采购支出','P202507090003','2025-07-09 20:23:08.756270','CEO','100001','采购订单审核通过自动创建 - 商品：海尔洗衣机，供应商：海尔集团总公司','2025-07-09 20:23:08.756286');
INSERT INTO `ExpenditureRecord` (`id`,`amount`,`reason`,`related_order`,`expenditure_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('4',1246.00,'采购支出','P202507100001','2025-07-10 11:11:56.750816','CEO','100001','采购订单审核通过自动创建 - 商品：洗衣机1，供应商：海尔集团江苏分公司','2025-07-10 11:11:56.750838');
INSERT INTO `ExpenditureRecord` (`id`,`amount`,`reason`,`related_order`,`expenditure_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('5',450.00,'采购支出','P202507100001','2025-07-10 11:21:02.529329','CEO','100001','','2025-07-10 11:21:02.529374');
INSERT INTO `ExpenditureRecord` (`id`,`amount`,`reason`,`related_order`,`expenditure_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('6',29990.00,'采购支出','P202507090002','2025-07-10 11:24:34.913075','CEO','100001','采购订单审核通过自动创建 - 商品：海尔空调，供应商：海尔集团浙江分公司','2025-07-10 11:24:34.913091');
INSERT INTO `ExpenditureRecord` (`id`,`amount`,`reason`,`related_order`,`expenditure_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('7',39990.00,'采购支出','P202507090001','2025-07-10 11:25:01.787339','CEO','100001','采购订单审核通过自动创建 - 商品：海尔冰箱，供应商：海尔集团江苏分公司','2025-07-10 11:25:01.787360');
INSERT INTO `ExpenditureRecord` (`id`,`amount`,`reason`,`related_order`,`expenditure_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('8',14995.00,'采购支出','P202507100002','2025-07-10 12:37:06.326601','CEO','100001','采购订单审核通过自动创建 - 商品：海尔空调，供应商：海尔集团浙江分公司','2025-07-10 12:37:06.326633');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of Finance
-- ----------------------------
INSERT INTO `Finance` (`id`,`balance`,`income`,`expenditure`,`net_profit`)  VALUES ('1',19610429.00,19899999.00,289570.00,19610429.00);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of InboundRecord
-- ----------------------------
INSERT INTO `InboundRecord` (`id`,`quantity`,`reason`,`inbound_time`,`related_order`,`inbound_name`,`inbound_job_number`,`commodity_id`)  VALUES ('1','10','123','2025-07-09 00:52:01.990734','','CEO','100001','1');
INSERT INTO `InboundRecord` (`id`,`quantity`,`reason`,`inbound_time`,`related_order`,`inbound_name`,`inbound_job_number`,`commodity_id`)  VALUES ('2','6','111111
','2025-07-09 15:11:54.429382','','CEO','100001','4');
INSERT INTO `InboundRecord` (`id`,`quantity`,`reason`,`inbound_time`,`related_order`,`inbound_name`,`inbound_job_number`,`commodity_id`)  VALUES ('3','3','好！','2025-07-09 15:12:41.094845','','CEO','100001','5');
INSERT INTO `InboundRecord` (`id`,`quantity`,`reason`,`inbound_time`,`related_order`,`inbound_name`,`inbound_job_number`,`commodity_id`)  VALUES ('4','10','111','2025-07-10 07:59:13.412162','','CEO','100001','3');
INSERT INTO `InboundRecord` (`id`,`quantity`,`reason`,`inbound_time`,`related_order`,`inbound_name`,`inbound_job_number`,`commodity_id`)  VALUES ('5','5','1','2025-07-10 11:15:45.842607','','CEO','100001','7');
INSERT INTO `InboundRecord` (`id`,`quantity`,`reason`,`inbound_time`,`related_order`,`inbound_name`,`inbound_job_number`,`commodity_id`)  VALUES ('6','1','无','2025-07-10 11:16:31.503319','','CEO','100001','8');
INSERT INTO `InboundRecord` (`id`,`quantity`,`reason`,`inbound_time`,`related_order`,`inbound_name`,`inbound_job_number`,`commodity_id`)  VALUES ('7','5','1','2025-07-10 11:18:42.105055','','CEO','100001','8');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of IncomeRecord
-- ----------------------------
INSERT INTO `IncomeRecord` (`id`,`amount`,`reason`,`related_order`,`income_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('1',1000000.00,'总公司拨款','','2025-07-09 00:08:01.588924','CEO','100001','总公司拨款','2025-07-09 00:08:01.588943');
INSERT INTO `IncomeRecord` (`id`,`amount`,`reason`,`related_order`,`income_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('2',8900000.00,'业务收入','','2025-07-09 15:16:12.335149','CEO','100001','','2025-07-09 15:16:12.335167');
INSERT INTO `IncomeRecord` (`id`,`amount`,`reason`,`related_order`,`income_time`,`operator_name`,`operator_job_number`,`remark`,`create_time`)  VALUES ('3',9999999.00,'其他','','2025-07-09 20:08:20.678649','CEO','100001','捡到钱了','2025-07-09 20:08:20.678665');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of OutboundRecord
-- ----------------------------
INSERT INTO `OutboundRecord` (`id`,`quantity`,`reason`,`outbound_time`,`related_order`,`outbound_name`,`outbound_job_number`,`commodity_id`)  VALUES ('1','3','补发货','2025-07-09 21:18:48.431118','','CEO','100001','1');
INSERT INTO `OutboundRecord` (`id`,`quantity`,`reason`,`outbound_time`,`related_order`,`outbound_name`,`outbound_job_number`,`commodity_id`)  VALUES ('2','1','无','2025-07-10 11:16:51.428504','','CEO','100001','8');
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of PurchaseOrder
-- ----------------------------
INSERT INTO `PurchaseOrder` (`id`,`order_number`,`unit_price`,`quantity`,`total_amount`,`status`,`purchase_name`,`purchase_job_number`,`order_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`inbound_name`,`inbound_job_number`,`inbound_time`,`commodity_id`,`supplier_id`)  VALUES ('24','P202507090001',3999.00,'10',39990.00,'3','CEO','100001','2025-07-09 20:21:04.700987',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1','3');
INSERT INTO `PurchaseOrder` (`id`,`order_number`,`unit_price`,`quantity`,`total_amount`,`status`,`purchase_name`,`purchase_job_number`,`order_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`inbound_name`,`inbound_job_number`,`inbound_time`,`commodity_id`,`supplier_id`)  VALUES ('25','P202507090002',2999.00,'10',29990.00,'3','CEO','100001','2025-07-09 20:21:13.787941',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2','4');
INSERT INTO `PurchaseOrder` (`id`,`order_number`,`unit_price`,`quantity`,`total_amount`,`status`,`purchase_name`,`purchase_job_number`,`order_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`inbound_name`,`inbound_job_number`,`inbound_time`,`commodity_id`,`supplier_id`)  VALUES ('26','P202507090003',1999.00,'100',199900.00,'3','CEO','100001','2025-07-09 20:21:28.009463',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'4','1');
INSERT INTO `PurchaseOrder` (`id`,`order_number`,`unit_price`,`quantity`,`total_amount`,`status`,`purchase_name`,`purchase_job_number`,`order_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`inbound_name`,`inbound_job_number`,`inbound_time`,`commodity_id`,`supplier_id`)  VALUES ('27','P202507100001',178.00,'7',1246.00,'3','CEO','100001','2025-07-10 11:11:44.659522',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'8','3');
INSERT INTO `PurchaseOrder` (`id`,`order_number`,`unit_price`,`quantity`,`total_amount`,`status`,`purchase_name`,`purchase_job_number`,`order_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`inbound_name`,`inbound_job_number`,`inbound_time`,`commodity_id`,`supplier_id`)  VALUES ('28','P202507100002',2999.00,'5',14995.00,'3','CEO','100001','2025-07-10 12:36:57.810417',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2','4');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of Role
-- ----------------------------
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('1','总经理','R_SUPER','拥有系统最高权限','2025-07-01 12:34:56',1,'1');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('2','人事管理员','R_USER_INFO','管理用户信息相关权限','2025-07-01 12:34:56',1,'2');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('3','运单管理员','R_ORDER','管理运单相关权限','2025-07-01 12:34:56',1,'3');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('4','运输管理员','R_DELIVERY','管理配送运输相关权限','2025-07-01 12:34:56',1,'4');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('5','仓储管理员','R_STORAGE','管理仓储作业权限','2025-07-01 12:34:56',1,'5');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('6','采购管理员','R_PURCHASE','管理采购与供应商相关权限','2025-07-01 12:34:56',1,'6');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('7','财务管理员','R_FINANCE','管理财务相关权限','2025-07-01 12:34:56',1,'7');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('8','人事员','E_USER_INFO','拥有系统普通权限','2025-07-01 12:34:56',1,'2');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('9','运单员','E_ORDER','负责运单的创建和录入','2025-07-01 12:34:56',1,'3');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('10','配送员','E_DELIVERY','负责将货物运输到目的地','2025-07-01 12:34:56',1,'4');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('11','仓储员','E_STORAGE','负责清点库存和货物搬运','2025-07-01 12:34:56',1,'5');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('12','采购员','E_PURCHASE','负责采购订单的处理和商品的采购','2025-07-01 12:34:56',1,'6');
INSERT INTO `Role` (`id`,`role_name`,`role_code`,`description`,`create_time`,`is_enabled`,`department_id`)  VALUES ('13','财务员','E_FINANCE','负责财务相关工作','2025-07-01 12:34:56',1,'7');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ShippingOrder
-- ----------------------------
INSERT INTO `ShippingOrder` (`id`,`order_number`,`quantity`,`receiver_name`,`receiver_phone`,`receiver_address`,`status`,`complete_time`,`creator_name`,`creator_job_number`,`create_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`delivery_time`,`delivery_job_number`,`delivery_person_name`,`delivery_person_phone`,`delivery_car_number`,`commodity_id`)  VALUES ('1','D202507090001','1','李四','13966668888','上海市浦东新区南汇新城镇上海海事大学','9',NULL,'CEO','100001','2025-07-09 01:02:10.954128',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1');
INSERT INTO `ShippingOrder` (`id`,`order_number`,`quantity`,`receiver_name`,`receiver_phone`,`receiver_address`,`status`,`complete_time`,`creator_name`,`creator_job_number`,`create_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`delivery_time`,`delivery_job_number`,`delivery_person_name`,`delivery_person_phone`,`delivery_car_number`,`commodity_id`)  VALUES ('2','D202507090002','1','李四','18888888888','上海市浦东新区上海海洋大学','4',NULL,'CEO','100001','2025-07-09 01:51:58.714333','CEO','100001','2025-07-10 01:43:23.437314','可以','2025-07-10 06:48:42.343594','100006','赵师傅','18888888888','沪A12345','1');
INSERT INTO `ShippingOrder` (`id`,`order_number`,`quantity`,`receiver_name`,`receiver_phone`,`receiver_address`,`status`,`complete_time`,`creator_name`,`creator_job_number`,`create_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`delivery_time`,`delivery_job_number`,`delivery_person_name`,`delivery_person_phone`,`delivery_car_number`,`commodity_id`)  VALUES ('3','D202507090003','4','刘蒂姆','13255217960','上海海事大学','3',NULL,'CEO','100001','2025-07-09 14:54:29.296468','CEO','100001','2025-07-10 01:52:14.579747','',NULL,NULL,NULL,NULL,NULL,'1');
INSERT INTO `ShippingOrder` (`id`,`order_number`,`quantity`,`receiver_name`,`receiver_phone`,`receiver_address`,`status`,`complete_time`,`creator_name`,`creator_job_number`,`create_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`delivery_time`,`delivery_job_number`,`delivery_person_name`,`delivery_person_phone`,`delivery_car_number`,`commodity_id`)  VALUES ('4','D202507090004','3','赵六','18888888888','上海海事大学','5','2025-07-10 07:27:44.180698','CEO','100001','2025-07-09 19:59:01.273931','CEO','100001','2025-07-10 02:27:44.180698','','2025-07-10 06:48:34.388084','100006','赵师傅','18888888888','沪A12345','4');
INSERT INTO `ShippingOrder` (`id`,`order_number`,`quantity`,`receiver_name`,`receiver_phone`,`receiver_address`,`status`,`complete_time`,`creator_name`,`creator_job_number`,`create_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`delivery_time`,`delivery_job_number`,`delivery_person_name`,`delivery_person_phone`,`delivery_car_number`,`commodity_id`)  VALUES ('5','D202507100001','3','刘亦菲','15555555555','北京市海淀区颐和园路北京大学','1',NULL,'CEO','100001','2025-07-10 07:16:40.530136','CEO','100001','2025-07-10 07:16:58.792306','',NULL,NULL,NULL,NULL,NULL,'5');
INSERT INTO `ShippingOrder` (`id`,`order_number`,`quantity`,`receiver_name`,`receiver_phone`,`receiver_address`,`status`,`complete_time`,`creator_name`,`creator_job_number`,`create_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`delivery_time`,`delivery_job_number`,`delivery_person_name`,`delivery_person_phone`,`delivery_car_number`,`commodity_id`)  VALUES ('6','D202507100002','1','吴亦凡','17891265381','青浦青东农场监狱片区','1',NULL,'CEO','100001','2025-07-10 09:41:36.028010',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'4');
INSERT INTO `ShippingOrder` (`id`,`order_number`,`quantity`,`receiver_name`,`receiver_phone`,`receiver_address`,`status`,`complete_time`,`creator_name`,`creator_job_number`,`create_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`delivery_time`,`delivery_job_number`,`delivery_person_name`,`delivery_person_phone`,`delivery_car_number`,`commodity_id`)  VALUES ('7','D202507100003','1','a','18926317821','青浦青东农场监狱片区','4',NULL,'CEO','100001','2025-07-10 09:45:27.914446','CEO','100001','2025-07-10 09:46:55.733763','','2025-07-10 09:47:45.997426','100008','孙师傅','18888888888','沪B67890','1');
INSERT INTO `ShippingOrder` (`id`,`order_number`,`quantity`,`receiver_name`,`receiver_phone`,`receiver_address`,`status`,`complete_time`,`creator_name`,`creator_job_number`,`create_time`,`check_name`,`check_job_number`,`check_time`,`check_reason`,`delivery_time`,`delivery_job_number`,`delivery_person_name`,`delivery_person_phone`,`delivery_car_number`,`commodity_id`)  VALUES ('8','D202507100004','1','啦啦啦啦啦','19987653545','上海话','4',NULL,'CEO','100001','2025-07-10 11:15:24.559398','CEO','100001','2025-07-10 11:16:03.531919','','2025-07-10 11:16:40.148579','100010','周师傅','19999999999','沪G66687','4');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of StaticRoute
-- ----------------------------
INSERT INTO `StaticRoute` (`id`,`departure`,`destination`,`total_distance`,`estimated_time`,`schedule_info`,`is_active`,`create_time`)  VALUES ('2','上海市浦东新区总部','广东省广州市天河区分部',1456.00,16.0,'每日发车：09:00, 15:00',1,'2025-02-20 14:20:00');
INSERT INTO `StaticRoute` (`id`,`departure`,`destination`,`total_distance`,`estimated_time`,`schedule_info`,`is_active`,`create_time`)  VALUES ('3','上海市浦东新区总部','广东省深圳市南山区分部',1478.00,17.0,'每日发车：10:00, 16:00, 22:00',1,'2025-03-10 11:15:00');
INSERT INTO `StaticRoute` (`id`,`departure`,`destination`,`total_distance`,`estimated_time`,`schedule_info`,`is_active`,`create_time`)  VALUES ('4','上海市浦东新区总部','浙江省杭州市西湖区分部',175.00,2.0,'每小时发车：07:00-19:00',1,'2025-04-08 16:45:00');
INSERT INTO `StaticRoute` (`id`,`departure`,`destination`,`total_distance`,`estimated_time`,`schedule_info`,`is_active`,`create_time`)  VALUES ('5','上海市浦东新区总部','江苏省南京市鼓楼区分部',295.00,4.0,'每日发车：08:30, 13:30, 18:30',0,'2025-05-25 10:30:00');
INSERT INTO `StaticRoute` (`id`,`departure`,`destination`,`total_distance`,`estimated_time`,`schedule_info`,`is_active`,`create_time`)  VALUES ('6','上海市浦东新区总部','江苏省苏州市姑苏区分部',102.00,1.5,'每30分钟发车：06:00-22:00',1,'2025-06-12 13:20:00');
INSERT INTO `StaticRoute` (`id`,`departure`,`destination`,`total_distance`,`estimated_time`,`schedule_info`,`is_active`,`create_time`)  VALUES ('7','上海市浦东新区总部','湖北省武汉市江汉区分部',695.00,8.0,'每日发车：07:00, 19:00',1,'2025-07-18 15:10:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of Supplier
-- ----------------------------
INSERT INTO `Supplier` (`id`,`name`,`supplier_type`,`address`,`contact_person`,`contact_phone`,`contact_email`,`create_time`,`status`)  VALUES ('1','海尔集团总公司','企业','北京市朝阳区中关村科技园区','张经理','010-85123456','zhang@Haier.com','2025-01-15 10:30:00','1');
INSERT INTO `Supplier` (`id`,`name`,`supplier_type`,`address`,`contact_person`,`contact_phone`,`contact_email`,`create_time`,`status`)  VALUES ('2','海尔集团上海分公司','企业','上海市浦东新区张江高科技园区','李总监','010-56781234','li.director@haier.com','2025-02-20 14:20:00','1');
INSERT INTO `Supplier` (`id`,`name`,`supplier_type`,`address`,`contact_person`,`contact_phone`,`contact_email`,`create_time`,`status`)  VALUES ('3','海尔集团江苏分公司','企业','江苏省南京市玄武区玄武大道123号','王部长','021-58901234','wang.minister@Haier.cn','2025-03-10 09:15:00','1');
INSERT INTO `Supplier` (`id`,`name`,`supplier_type`,`address`,`contact_person`,`contact_phone`,`contact_email`,`create_time`,`status`)  VALUES ('4','海尔集团浙江分公司','企业','浙江省杭州市西湖区西湖大道123号','刘经理','021-38123456','liu.manager@Haier.com.cn','2025-04-05 16:45:00','2');
INSERT INTO `Supplier` (`id`,`name`,`supplier_type`,`address`,`contact_person`,`contact_phone`,`contact_email`,`create_time`,`status`)  VALUES ('5','Test','政府部门','TestTestTest','Test','13800000000','Test@Test.com','2025-07-08 04:55:08.109334','3');
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户';

-- ----------------------------
-- Records of User
-- ----------------------------
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('1','pbkdf2_sha256$1000000$U8BKWEOv9u4HSrl9o8Y3r7$UylyS/6B2cdxM9AdOlQODKuvkThX7YraxVc3K4LYabA=',NULL,1,'CEO','','','123456789@qq.com',1,1,'2025-07-07 03:02:31.934674','100001','0','13800006666','1','1','https://wordspk-1321304971.cos.ap-shanghai.myqcloud.com/User/87e9c006fd76b40c3d7d14ea9dc20eb7d0ebdb48460e6440ecc79dc08d346893.jpg');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('2','pbkdf2_sha256$1000000$LhNjcjiHB3j23J44sskCxO$FlL44fmXnhQ4rSwzgc1Ken49W82BQeUhUc+mY2yuMj0=',NULL,0,'张三','','','666666@qq.com',0,1,'2025-07-07 21:15:42.346090','100002','1','13812345678','3','1','https://tse2-mm.cn.bing.net/th/id/OIP-C.y1zvENK0EldIdSTEqJWPxwAAAA?w=215&h=215&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('3','pbkdf2_sha256$1000000$By5vaWxBE6pAupWvngkXm9$n9qb53rN+2QpnTKwJcR2PSR/RzOnl856VSrWV6WtW/Q=',NULL,0,'暴脾气','','','2452935291@qq.com',0,1,'2025-07-08 02:27:37.127927','100003','0','16698769080','2','1','https://tse1-mm.cn.bing.net/th/id/OIP-C.a_AYxsjB5myiX6AXQSN-rQAAAA?w=177&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('9','pbkdf2_sha256$1000000$ipcxecVcwhLcoLQvrYajzW$rBcZELiUWaQUbOX7rwDfuJVemwNnwog2y8+AylSmMGk=',NULL,0,'王师傅','','','666@qq.com',0,1,'2025-07-10 04:11:44.682893','100004','1','16666666666','10','1','https://tse4-mm.cn.bing.net/th/id/OIP-C.sdXsJDq4Q-UoglC2xrnWtwAAAA?w=180&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('10','pbkdf2_sha256$1000000$lc365ItBcmkSCwzm8V1eVD$eVjEooDvUsLxWpUAw3tSwsZbe6Cy5H5sdJAJ643GnjI=',NULL,0,'吴师傅','','','777@qq.com',0,1,'2025-07-10 05:16:38.187328','100005','1','17777777777','10','1','https://tse4-mm.cn.bing.net/th/id/OIP-C.sdXsJDq4Q-UoglC2xrnWtwAAAA?w=180&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('11','pbkdf2_sha256$1000000$lc365ItBcmkSCwzm8V1eVD$eVjEooDvUsLxWpUAw3tSwsZbe6Cy5H5sdJAJ643GnjI=',NULL,0,'赵师傅','','','TestDelivery@qq.com',0,1,'2025-07-10 05:16:38.187328','100006','1','18888888888','10','1','https://tse4-mm.cn.bing.net/th/id/OIP-C.sdXsJDq4Q-UoglC2xrnWtwAAAA?w=180&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('12','pbkdf2_sha256$1000000$lc365ItBcmkSCwzm8V1eVD$eVjEooDvUsLxWpUAw3tSwsZbe6Cy5H5sdJAJ643GnjI=',NULL,0,'钱师傅','','','TestDelivery@qq.com',0,1,'2025-07-10 05:16:38.187328','100007','1','18888888888','10','1','https://tse4-mm.cn.bing.net/th/id/OIP-C.sdXsJDq4Q-UoglC2xrnWtwAAAA?w=180&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('13','pbkdf2_sha256$1000000$lc365ItBcmkSCwzm8V1eVD$eVjEooDvUsLxWpUAw3tSwsZbe6Cy5H5sdJAJ643GnjI=',NULL,0,'孙师傅','','','TestDelivery@qq.com',0,1,'2025-07-10 05:16:38.187328','100008','1','18888888888','10','1','https://tse4-mm.cn.bing.net/th/id/OIP-C.sdXsJDq4Q-UoglC2xrnWtwAAAA?w=180&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('14','pbkdf2_sha256$1000000$lc365ItBcmkSCwzm8V1eVD$eVjEooDvUsLxWpUAw3tSwsZbe6Cy5H5sdJAJ643GnjI=',NULL,0,'李师傅','','','TestDelivery@qq.com',0,1,'2025-07-10 05:16:38.187328','100009','1','18888888888','10','1','https://tse4-mm.cn.bing.net/th/id/OIP-C.sdXsJDq4Q-UoglC2xrnWtwAAAA?w=180&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('15','pbkdf2_sha256$1000000$8OmqP8KQPv29nRL11T39p5$axUPahN+jfDfFQgYwrO5sJuV2LFPLaBK/l88WvW7l2o=',NULL,0,'周师傅','','','27@qq.com',0,1,'2025-07-10 09:57:04.421870','100010','1','19999999999','10','1','https://tse4-mm.cn.bing.net/th/id/OIP-C.sdXsJDq4Q-UoglC2xrnWtwAAAA?w=180&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('16','pbkdf2_sha256$1000000$dHJDVc9f5jn3Ka7KBpBa5w$Qg7Ufy/d5Afm2UKGHdbCS+j5wRHr+cbbhvpnFxa8mAc=',NULL,0,'铲车人','','','87899@qq.com',0,1,'2025-07-10 10:08:14.694586','100011','1','18799992731','7','1','https://tse4-mm.cn.bing.net/th/id/OIP-C.sdXsJDq4Q-UoglC2xrnWtwAAAA?w=180&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7');
INSERT INTO `User` (`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`,`job_number`,`gender`,`mobile`,`position`,`status`,`avatar`)  VALUES ('17','pbkdf2_sha256$1000000$18uJnE38pxx9pvzUpRmgY7$26ool4CrF2zBDXulIPK68kMMlVtnfxutttAV/YUE2SI=',NULL,0,'与与与','','','2452867400@qq.com',0,1,'2025-07-10 11:08:57.261133','100030','1','18890807654','2','1','');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of Vehicle
-- ----------------------------
INSERT INTO `Vehicle` (`id`,`vehicle_type`,`current_load`,`max_load`,`health_status`,`plate_number`,`purchase_time`,`storage_status`,`current_route`,`is_enabled`,`driver_job_number`)  VALUES ('1','大型卡车','0','64','正常','沪A12345','2025-03-15 09:30:00','正在装货','上海市浦东新区总部 → 江苏省苏州市姑苏区分部',1,'100006');
INSERT INTO `Vehicle` (`id`,`vehicle_type`,`current_load`,`max_load`,`health_status`,`plate_number`,`purchase_time`,`storage_status`,`current_route`,`is_enabled`,`driver_job_number`)  VALUES ('2','小型卡车','2','16','正常','沪B67890','2025-05-20 14:20:00','正在装货','上海市浦东新区总部 → 浙江省杭州市西湖区分部',1,'100008');
INSERT INTO `Vehicle` (`id`,`vehicle_type`,`current_load`,`max_load`,`health_status`,`plate_number`,`purchase_time`,`storage_status`,`current_route`,`is_enabled`,`driver_job_number`)  VALUES ('6','电动三轮车','1','2','正常','沪F44444','2025-07-03 13:20:00','外出送货','短途配送中，无固定线路',1,'100004');
INSERT INTO `Vehicle` (`id`,`vehicle_type`,`current_load`,`max_load`,`health_status`,`plate_number`,`purchase_time`,`storage_status`,`current_route`,`is_enabled`,`driver_job_number`)  VALUES ('7','中型卡车','0','32','大破','沪G55555','2025-04-18 15:10:00','车辆维修','无',0,'100007');
INSERT INTO `Vehicle` (`id`,`vehicle_type`,`current_load`,`max_load`,`health_status`,`plate_number`,`purchase_time`,`storage_status`,`current_route`,`is_enabled`,`driver_job_number`)  VALUES ('8','面包车','5','8','小破','沪H66666','2025-06-30 12:00:00','外出送货','短途配送中，无固定线路',1,'100009');
INSERT INTO `Vehicle` (`id`,`vehicle_type`,`current_load`,`max_load`,`health_status`,`plate_number`,`purchase_time`,`storage_status`,`current_route`,`is_enabled`,`driver_job_number`)  VALUES ('16','大型卡车','0','64','正常','沪G66687','2025-06-30 12:00:00','正在装货','上海市浦东新区总部 → 湖北省武汉市江汉区分部',1,'100010');
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('20','Core','0002_alter_user_avatar_alter_user_gender_and_more','2025-07-07 03:02:12.805909');
INSERT INTO `django_migrations` (`id`,`app`,`name`,`applied`)  VALUES ('21','Core','0003_alter_user_avatar_alter_user_gender_and_more','2025-07-07 21:51:18.571013');
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
