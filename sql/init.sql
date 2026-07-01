/*
 * 网球通 — 高校网球场智能预约与赛事管理系统
 * 数据库初始化脚本
 * 适用数据库: MySQL 5.5
 */

CREATE DATABASE IF NOT EXISTS tennis_db DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

USE tennis_db;

-- 禁用外键检查，避免 DROP TABLE 时的顺序问题
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================
-- 用户表
-- =============================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id`          INT(11)       NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username`    VARCHAR(50)   NOT NULL COMMENT '用户名',
  `password`    VARCHAR(64)   NOT NULL COMMENT '密码(MD5)',
  `real_name`   VARCHAR(50)   DEFAULT NULL COMMENT '真实姓名',
  `email`       VARCHAR(100)  DEFAULT NULL COMMENT '邮箱',
  `phone`       VARCHAR(20)   DEFAULT NULL COMMENT '手机号',
  `role`        VARCHAR(10)   NOT NULL DEFAULT 'user' COMMENT '角色: user普通用户, admin管理员',
  `status`      INT(1)        NOT NULL DEFAULT 1 COMMENT '状态: 0禁用, 1正常',
  `create_time` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- =============================================
-- 场地表
-- =============================================
DROP TABLE IF EXISTS `courts`;
CREATE TABLE `courts` (
  `id`          INT(11)       NOT NULL AUTO_INCREMENT COMMENT '场地ID',
  `court_name`  VARCHAR(100)  NOT NULL COMMENT '场地名称',
  `location`    VARCHAR(200)  DEFAULT NULL COMMENT '位置',
  `description` TEXT          COMMENT '场地描述',
  `status`      INT(1)        NOT NULL DEFAULT 1 COMMENT '状态: 0维护中, 1可用',
  `price`       DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '每小时价格(元)',
  `image_url`   VARCHAR(255)  DEFAULT NULL COMMENT '图片URL',
  `create_time` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='场地表';

-- =============================================
-- 预约记录表
-- =============================================
DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations` (
  `id`           INT(11)      NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `user_id`      INT(11)      NOT NULL COMMENT '用户ID',
  `court_id`     INT(11)      NOT NULL COMMENT '场地ID',
  `reserve_date` DATE         NOT NULL COMMENT '预约日期',
  `start_time`   VARCHAR(10)  NOT NULL COMMENT '开始时间 HH:mm',
  `end_time`     VARCHAR(10)  NOT NULL COMMENT '结束时间 HH:mm',
  `status`       VARCHAR(20)  NOT NULL DEFAULT 'confirmed' COMMENT '状态: pending待确认, confirmed已确认, cancelled已取消, completed已完成',
  `create_time` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP    NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_court_id` (`court_id`),
  KEY `idx_reserve_date` (`reserve_date`),
  KEY `idx_court_date` (`court_id`, `reserve_date`),
  CONSTRAINT `fk_res_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_res_court` FOREIGN KEY (`court_id`) REFERENCES `courts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='预约记录表';

-- =============================================
-- 赛事表
-- =============================================
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `id`          INT(11)       NOT NULL AUTO_INCREMENT COMMENT '赛事ID',
  `title`       VARCHAR(200)  NOT NULL COMMENT '赛事标题',
  `description` TEXT          COMMENT '赛事描述',
  `event_date`  DATE          NOT NULL COMMENT '比赛日期',
  `start_time`  VARCHAR(10)   NOT NULL COMMENT '开始时间 HH:mm',
  `end_time`    VARCHAR(10)   NOT NULL COMMENT '结束时间 HH:mm',
  `location`    VARCHAR(200)  DEFAULT NULL COMMENT '比赛地点',
  `max_players` INT(11)       NOT NULL DEFAULT 16 COMMENT '最大参赛人数',
  `status`      VARCHAR(20)   NOT NULL DEFAULT 'upcoming' COMMENT '状态: upcoming即将开始, ongoing进行中, finished已结束, cancelled已取消',
  `creator_id`  INT(11)       NOT NULL COMMENT '发布者ID',
  `create_time` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_creator` (`creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='赛事表';

-- =============================================
-- 赛事报名表
-- =============================================
DROP TABLE IF EXISTS `enrollments`;
CREATE TABLE `enrollments` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT COMMENT '报名ID',
  `event_id`    INT(11)      NOT NULL COMMENT '赛事ID',
  `user_id`     INT(11)      NOT NULL COMMENT '用户ID',
  `enroll_time` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '报名时间',
  `status`      VARCHAR(20)  NOT NULL DEFAULT 'enrolled' COMMENT '状态: enrolled已报名, cancelled已取消',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_event_user` (`event_id`, `user_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_enroll_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_enroll_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='赛事报名表';

-- =============================================
-- 评价表
-- =============================================
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id`             INT(11)      NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `reservation_id` INT(11)      NOT NULL COMMENT '预约ID',
  `user_id`        INT(11)      NOT NULL COMMENT '用户ID',
  `court_id`       INT(11)      NOT NULL COMMENT '场地ID',
  `rating`         INT(1)       NOT NULL COMMENT '评分 1-5星',
  `content`        TEXT         COMMENT '评价内容',
  `create_time`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
  PRIMARY KEY (`id`),
  KEY `idx_court_id` (`court_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_reservation_id` (`reservation_id`),
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_review_court` FOREIGN KEY (`court_id`) REFERENCES `courts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_review_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='评价表';

-- =============================================
-- 初始数据
-- =============================================

-- 默认管理员 (密码: admin123)
INSERT INTO `users` (`username`, `password`, `real_name`, `email`, `phone`, `role`, `status`)
VALUES ('admin', '0192023a7bbd73250516f069df18b500', '管理员', 'admin@tennis.edu.cn', '13800000000', 'admin', 1);

-- 默认普通用户 (密码: test123)
INSERT INTO `users` (`username`, `password`, `real_name`, `email`, `phone`, `role`, `status`)
VALUES ('testuser', 'cc03e747a6afbbcbf8be7668acfebee5', '测试用户', 'test@tennis.edu.cn', '13900000000', 'user', 1);

-- 场地数据
INSERT INTO `courts` (`court_name`, `location`, `description`, `status`, `price`) VALUES
('中心网球场 1号场地', '体育馆东侧', '标准硬地球场，配备专业照明设施', 1, 30.00),
('中心网球场 2号场地', '体育馆东侧', '标准硬地球场，近期翻新', 1, 35.00),
('中心网球场 3号场地', '体育馆东侧', '标准硬地球场，带观众看台', 1, 40.00),
('红土球场 1号场地', '综合体育中心', '法网标准红土场地，体验专业赛事感受', 1, 50.00),
('红土球场 2号场地', '综合体育中心', '红土场地，配有休息区', 1, 50.00),
('室内球场 A', '体育馆二楼', '室内标准场地，不受天气影响', 0, 60.00);

-- 示例赛事
INSERT INTO `events` (`title`, `description`, `event_date`, `start_time`, `end_time`, `location`, `max_players`, `status`, `creator_id`)
VALUES
('2026年夏季网球公开赛', '面向全校师生的夏季网球单打比赛，欢迎各院系同学踊跃报名！', '2026-07-15', '09:00', '17:00', '中心网球场', 32, 'upcoming', 1),
('教职工网球友谊赛', '教职工网球爱好者交流赛，双打为主', '2026-06-22', '14:00', '18:00', '红土球场', 16, 'upcoming', 1);

-- 示例预约（已完成），用于评价功能演示
INSERT INTO `reservations` (`user_id`, `court_id`, `reserve_date`, `start_time`, `end_time`, `status`) VALUES
(2, 1, '2026-06-15', '09:00', '10:00', 'completed'),
(2, 2, '2026-06-16', '14:00', '15:00', 'completed'),
(2, 3, '2026-06-17', '16:00', '17:00', 'completed');

-- 示例评价
INSERT INTO `reviews` (`reservation_id`, `user_id`, `court_id`, `rating`, `content`) VALUES
(1, 2, 1, 5, '场地非常好！硬地平整，灯光照明充足，晚上打球也很舒服。工作人员服务态度很好，强烈推荐！'),
(2, 2, 2, 4, '近期翻新的场地确实不错，地面摩擦力适中。就是价格稍贵，但整体体验很好。'),
(3, 2, 3, 4, '带观众看台的场地很有比赛氛围，适合和朋友一起来。设施齐全，下次还会再来！');

-- 重新启用外键检查
SET FOREIGN_KEY_CHECKS = 1;
