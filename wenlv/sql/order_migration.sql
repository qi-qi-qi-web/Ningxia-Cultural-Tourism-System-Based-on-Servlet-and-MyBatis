-- ============================================================================
-- 订单功能迁移脚本 - 添加新状态和退货原因字段
-- 执行方式：在 MySQL 中执行此脚本
-- ============================================================================

USE tourism_platform;

-- 1. 修改 order_main.status 枚举，添加新状态
ALTER TABLE order_main 
    MODIFY COLUMN status ENUM(
        'PENDING','PAID','SHIPPED','CANCELLED','REFUNDED','COMPLETED',
        'PLACED','RECEIVED','RETURNING'
    ) NOT NULL DEFAULT 'PLACED';

-- 2. 添加退货原因字段
ALTER TABLE order_main 
    ADD COLUMN return_reason VARCHAR(500) DEFAULT NULL COMMENT '退货原因';
