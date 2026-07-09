-- ============================================================================
-- 文旅综合服务平台 - 数据库设计
-- 版本: v1.0
-- 日期: 2026-07-08
-- 数据库: MySQL 5.7+ / MariaDB 10.2+
-- 说明: 包含14张表，覆盖用户、景区、特产、酒店、攻略、订单、评论、收藏、审计日志
-- ============================================================================

CREATE DATABASE IF NOT EXISTS tourism_platform
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE tourism_platform;

-- ============================================================================
-- 第一部分：用户层 (2张表)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. 用户表（用户与管理员统一存储，通过role字段区分）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '用户ID',
    username        VARCHAR(50)     NOT NULL UNIQUE             COMMENT '用户名',
    password   VARCHAR(255)    NOT NULL                    COMMENT '密码(明文)',
    nickname        VARCHAR(50)     DEFAULT NULL                COMMENT '昵称',
    email           VARCHAR(100)    DEFAULT NULL                COMMENT '邮箱',
    phone           VARCHAR(20)     DEFAULT NULL                COMMENT '手机号',
    avatar          VARCHAR(500)    DEFAULT NULL                COMMENT '头像URL',
    role            ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER' COMMENT '角色: USER=普通用户, ADMIN=管理员',
    status          TINYINT         NOT NULL DEFAULT 1          COMMENT '状态: 0=禁用, 1=正常',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_role (role),
    INDEX idx_status (status),
    INDEX idx_phone (phone)
) ENGINE=InnoDB COMMENT '用户表';

-- ----------------------------------------------------------------------------
-- 2. 管理员操作审计日志表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS sys_audit_log;
CREATE TABLE sys_audit_log (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '日志ID',
    admin_id        BIGINT          NOT NULL                    COMMENT '操作管理员ID',
    admin_name      VARCHAR(50)     NOT NULL                    COMMENT '管理员用户名(冗余,防用户删除后无法追溯)',
    operation       VARCHAR(50)     NOT NULL                    COMMENT '操作类型: CREATE/UPDATE/DELETE/LOGIN/LOGOUT/EXPORT/STATUS_CHANGE/REVIEW',
    target_type     VARCHAR(50)     NOT NULL                    COMMENT '操作目标模块: SCENIC_SPOT/SCENIC_TICKET/NEWS/SPECIALTY/HOTEL/HOTEL_ROOM/TRAVEL_GUIDE/ORDER/COMMENT/USER/SYSTEM',
    target_id       BIGINT          DEFAULT NULL                COMMENT '操作目标记录ID',
    target_name     VARCHAR(200)    DEFAULT NULL                COMMENT '操作目标名称(冗余,便于人工阅读)',
    detail          JSON            DEFAULT NULL                COMMENT '操作详情: {"before":{...},"after":{...},"remark":"..."}',
    ip_address      VARCHAR(50)     DEFAULT NULL                COMMENT '操作来源IP地址',
    user_agent      VARCHAR(500)    DEFAULT NULL                COMMENT '浏览器User-Agent',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_admin      (admin_id),
    INDEX idx_target     (target_type, target_id),
    INDEX idx_operation  (operation),
    INDEX idx_created    (created_at)
) ENGINE=InnoDB COMMENT '管理员操作审计日志表';


-- ============================================================================
-- 第二部分：核心业务层 (8张表)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 3. 景区表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS scenic_spot;
CREATE TABLE scenic_spot (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '景区ID',
    name            VARCHAR(100)    NOT NULL                    COMMENT '景区名称',
    description     TEXT            DEFAULT NULL                COMMENT '景区介绍',
    address         VARCHAR(255)    DEFAULT NULL                COMMENT '详细地址',
    province        VARCHAR(50)     DEFAULT NULL                COMMENT '省',
    city            VARCHAR(50)     DEFAULT NULL                COMMENT '市',
    district        VARCHAR(50)     DEFAULT NULL                COMMENT '区/县',
    latitude        DECIMAL(10,7)   DEFAULT NULL                COMMENT '纬度',
    longitude       DECIMAL(10,7)   DEFAULT NULL                COMMENT '经度',
    opening_hours   VARCHAR(200)    DEFAULT NULL                COMMENT '开放时间描述(如: 08:00-18:00)',
    contact_phone   VARCHAR(20)     DEFAULT NULL                COMMENT '景区联系电话',
    cover_image     VARCHAR(500)    DEFAULT NULL                COMMENT '封面图URL',
    images          JSON            DEFAULT NULL                COMMENT '图片列表JSON: ["url1","url2"]',
    min_price       DECIMAL(10,2)   DEFAULT NULL                COMMENT '最低门票价(列表展示用)',
    view_count      BIGINT          NOT NULL DEFAULT 0          COMMENT '浏览量',
    favorite_count  BIGINT          NOT NULL DEFAULT 0          COMMENT '收藏数(冗余计数)',
    status          ENUM('OPEN','CLOSED','MAINTENANCE')
                                    NOT NULL DEFAULT 'OPEN'     COMMENT '运营状态: OPEN=开放, CLOSED=关闭, MAINTENANCE=维护中',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_city      (province, city),
    INDEX idx_status    (status),
    INDEX idx_view      (view_count)
) ENGINE=InnoDB COMMENT '景区表';

-- ----------------------------------------------------------------------------
-- 4. 景区门票表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS scenic_ticket;
CREATE TABLE scenic_ticket (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '门票ID',
    scenic_spot_id  BIGINT          NOT NULL                    COMMENT '所属景区ID',
    ticket_name     VARCHAR(100)    NOT NULL                    COMMENT '票种名称(如: 成人票/儿童票/学生票)',
    ticket_type     ENUM('ADULT','CHILD','STUDENT','SENIOR','GROUP')
                                    NOT NULL                    COMMENT '票种类型',
    price           DECIMAL(10,2)   NOT NULL                    COMMENT '原价',
    discount_price  DECIMAL(10,2)   DEFAULT NULL                COMMENT '折后价(活动价)',
    stock           INT             NOT NULL DEFAULT 0          COMMENT '每日库存限额',
    description     TEXT            DEFAULT NULL                COMMENT '购买须知/票种说明',
    status          TINYINT         NOT NULL DEFAULT 1          COMMENT '状态: 1=上架, 0=下架',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_ticket_spot FOREIGN KEY (scenic_spot_id) REFERENCES scenic_spot(id) ON DELETE CASCADE,
    INDEX idx_spot       (scenic_spot_id),
    INDEX idx_type       (ticket_type),
    INDEX idx_status     (status)
) ENGINE=InnoDB COMMENT '景区门票表';

-- ----------------------------------------------------------------------------
-- 5. 旅游资讯公告表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS news_announcement;
CREATE TABLE news_announcement (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '资讯ID',
    title           VARCHAR(200)    NOT NULL                    COMMENT '标题',
    content         LONGTEXT        NOT NULL                    COMMENT '正文内容(富文本)',
    type            ENUM('NOTICE','ANNOUNCEMENT','PROMOTION')
                                    NOT NULL DEFAULT 'NOTICE'   COMMENT '类型: NOTICE=通知, ANNOUNCEMENT=公告, PROMOTION=促销/降价',
    scenic_spot_id  BIGINT          DEFAULT NULL                COMMENT '关联景区ID(NULL=平台级公告)',
    cover_image     VARCHAR(500)    DEFAULT NULL                COMMENT '封面图',
    is_top          TINYINT         NOT NULL DEFAULT 0          COMMENT '是否置顶: 1=是, 0=否',
    is_published    TINYINT         NOT NULL DEFAULT 0          COMMENT '是否已发布: 1=是, 0=草稿',
    published_at    DATETIME        DEFAULT NULL                COMMENT '发布时间',
    created_by      BIGINT          DEFAULT NULL                COMMENT '发布人(管理员ID)',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_news_spot   FOREIGN KEY (scenic_spot_id) REFERENCES scenic_spot(id) ON DELETE SET NULL,
    CONSTRAINT fk_news_author FOREIGN KEY (created_by)     REFERENCES sys_user(id)   ON DELETE SET NULL,
    INDEX idx_type_pub   (type, is_published),
    INDEX idx_spot       (scenic_spot_id),
    INDEX idx_top        (is_top, published_at)
) ENGINE=InnoDB COMMENT '旅游资讯公告表';

-- ----------------------------------------------------------------------------
-- 6. 特产分类表（按role/人群角色分类）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS specialty_category;
CREATE TABLE specialty_category (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '分类ID',
    name            VARCHAR(50)     NOT NULL                    COMMENT '分类名称(如: 地道美食/文创手作)',
    role_tag        VARCHAR(50)     NOT NULL UNIQUE             COMMENT '人群标签: FOODIE=美食爱好者, ARTSY=文艺青年, FAMILY=亲子家庭, OUTDOOR=户外达人, CULTURE=文化爱好者',
    description     VARCHAR(255)    DEFAULT NULL                COMMENT '分类描述',
    icon            VARCHAR(500)    DEFAULT NULL                COMMENT '分类图标URL',
    sort_order      INT             NOT NULL DEFAULT 0          COMMENT '排序(越小越靠前)',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE INDEX idx_role_tag (role_tag)
) ENGINE=InnoDB COMMENT '特产分类表(按人群角色)';

-- ----------------------------------------------------------------------------
-- 7. 本地特产表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS specialty;
CREATE TABLE specialty (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '特产ID',
    category_id     BIGINT          NOT NULL                    COMMENT '所属分类ID',
    scenic_spot_id  BIGINT          DEFAULT NULL                COMMENT '产地景区ID(可为空,表示非景区特产)',
    name            VARCHAR(100)    NOT NULL                    COMMENT '特产名称',
    description     TEXT            DEFAULT NULL                COMMENT '特产描述',
    price           DECIMAL(10,2)   NOT NULL                    COMMENT '价格',
    stock           INT             NOT NULL DEFAULT 0          COMMENT '库存',
    main_image      VARCHAR(500)    DEFAULT NULL                COMMENT '主图URL',
    images          JSON            DEFAULT NULL                COMMENT '图片列表JSON',
    sales_count     INT             NOT NULL DEFAULT 0          COMMENT '累计销量',
    favorite_count  BIGINT          NOT NULL DEFAULT 0          COMMENT '收藏数(冗余计数)',
    status          TINYINT         NOT NULL DEFAULT 1          COMMENT '状态: 1=上架, 0=下架',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_specialty_category FOREIGN KEY (category_id)    REFERENCES specialty_category(id) ON DELETE RESTRICT,
    CONSTRAINT fk_specialty_spot     FOREIGN KEY (scenic_spot_id) REFERENCES scenic_spot(id)        ON DELETE SET NULL,
    INDEX idx_category   (category_id),
    INDEX idx_spot       (scenic_spot_id),
    INDEX idx_status     (status),
    INDEX idx_sales      (sales_count)
) ENGINE=InnoDB COMMENT '本地特产表';

-- ----------------------------------------------------------------------------
-- 8. 民宿酒店表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS hotel;
CREATE TABLE hotel (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '酒店ID',
    name            VARCHAR(100)    NOT NULL                    COMMENT '酒店名称',
    description     TEXT            DEFAULT NULL                COMMENT '酒店介绍',
    address         VARCHAR(255)    DEFAULT NULL                COMMENT '详细地址',
    province        VARCHAR(50)     DEFAULT NULL                COMMENT '省',
    city            VARCHAR(50)     DEFAULT NULL                COMMENT '市',
    district        VARCHAR(50)     DEFAULT NULL                COMMENT '区/县',
    latitude        DECIMAL(10,7)   DEFAULT NULL                COMMENT '纬度',
    longitude       DECIMAL(10,7)   DEFAULT NULL                COMMENT '经度',
    star_rating     TINYINT         DEFAULT NULL                COMMENT '星级(1-5)',
    contact_phone   VARCHAR(20)     DEFAULT NULL                COMMENT '联系电话',
    facilities      JSON            DEFAULT NULL                COMMENT '设施列表JSON: ["WiFi","停车场","餐厅","健身房"]',
    cover_image     VARCHAR(500)    DEFAULT NULL                COMMENT '封面图',
    images          JSON            DEFAULT NULL                COMMENT '图片列表JSON',
    min_price       DECIMAL(10,2)   DEFAULT NULL                COMMENT '最低房价(列表展示用)',
    favorite_count  BIGINT          NOT NULL DEFAULT 0          COMMENT '收藏数(冗余计数)',
    status          TINYINT         NOT NULL DEFAULT 1          COMMENT '状态: 1=营业, 0=歇业',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_city      (province, city),
    INDEX idx_star      (star_rating),
    INDEX idx_status    (status)
) ENGINE=InnoDB COMMENT '民宿酒店表';

-- ----------------------------------------------------------------------------
-- 9. 酒店房间表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS hotel_room;
CREATE TABLE hotel_room (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '房间ID',
    hotel_id        BIGINT          NOT NULL                    COMMENT '所属酒店ID',
    room_name       VARCHAR(100)    NOT NULL                    COMMENT '房间名称',
    room_type       VARCHAR(50)     NOT NULL                    COMMENT '房型: 大床房/双床房/套房/家庭房',
    price           DECIMAL(10,2)   NOT NULL                    COMMENT '原价(每晚)',
    discount_price  DECIMAL(10,2)   DEFAULT NULL                COMMENT '折后价(每晚)',
    stock           INT             NOT NULL DEFAULT 0          COMMENT '可售房间数',
    max_guests      TINYINT         NOT NULL DEFAULT 2          COMMENT '最大入住人数',
    bed_type        VARCHAR(50)     DEFAULT NULL                COMMENT '床型描述(如: 大床1.8m×2m)',
    area            DECIMAL(6,2)    DEFAULT NULL                COMMENT '房间面积(m²)',
    facilities      JSON            DEFAULT NULL                COMMENT '房间设施JSON: ["空调","电视","浴缸"]',
    images          JSON            DEFAULT NULL                COMMENT '房间图片JSON',
    status          TINYINT         NOT NULL DEFAULT 1          COMMENT '状态: 1=可订, 0=不可订',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_room_hotel FOREIGN KEY (hotel_id) REFERENCES hotel(id) ON DELETE CASCADE,
    INDEX idx_hotel     (hotel_id),
    INDEX idx_type      (room_type),
    INDEX idx_status    (status)
) ENGINE=InnoDB COMMENT '酒店房间表';

-- ----------------------------------------------------------------------------
-- 10. 旅游攻略表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS travel_guide;
CREATE TABLE travel_guide (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '攻略ID',
    user_id         BIGINT          NOT NULL                    COMMENT '发布者ID',
    title           VARCHAR(200)    NOT NULL                    COMMENT '攻略标题',
    content         LONGTEXT        NOT NULL                    COMMENT '攻略正文(富文本)',
    cover_image     VARCHAR(500)    DEFAULT NULL                COMMENT '封面图',
    tags            JSON            DEFAULT NULL                COMMENT '标签JSON: ["亲子","自驾","3天2晚"]',
    like_count      INT             NOT NULL DEFAULT 0          COMMENT '点赞数',
    view_count      INT             NOT NULL DEFAULT 0          COMMENT '浏览数',
    comment_count   INT             NOT NULL DEFAULT 0          COMMENT '评论数(冗余计数)',
    favorite_count  BIGINT          NOT NULL DEFAULT 0          COMMENT '收藏数(冗余计数)',
    status          ENUM('PUBLISHED','DRAFT','HIDDEN')
                                    NOT NULL DEFAULT 'PUBLISHED' COMMENT '状态: PUBLISHED=已发布, DRAFT=草稿, HIDDEN=已隐藏',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_guide_user FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
    INDEX idx_user      (user_id),
    INDEX idx_status    (status),
    INDEX idx_hot       (like_count, view_count),
    INDEX idx_created   (created_at)
) ENGINE=InnoDB COMMENT '旅游攻略表';


-- ============================================================================
-- 第三部分：交互交易层 (4张表)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 11. 订单主表（统一门票/特产/酒店预订）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS order_main;
CREATE TABLE order_main (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '订单ID',
    order_no        VARCHAR(32)     NOT NULL UNIQUE             COMMENT '订单编号(雪花ID或UUID)',
    user_id         BIGINT          NOT NULL                    COMMENT '下单用户ID',
    order_type      ENUM('TICKET','SPECIALTY','HOTEL')
                                    NOT NULL                    COMMENT '订单类型: TICKET=门票, SPECIALTY=特产, HOTEL=酒店',
    total_amount    DECIMAL(10,2)   NOT NULL                    COMMENT '订单总额',
    discount_amount DECIMAL(10,2)   NOT NULL DEFAULT 0.00       COMMENT '优惠金额',
    pay_amount      DECIMAL(10,2)   NOT NULL                    COMMENT '实付金额',
    status          ENUM('PENDING','PAID','CANCELLED','REFUNDED','COMPLETED')
                                    NOT NULL DEFAULT 'PENDING'  COMMENT '订单状态: PENDING=待支付, PAID=已支付, CANCELLED=已取消, REFUNDED=已退款, COMPLETED=已完成',
    payment_method  VARCHAR(50)     DEFAULT NULL                COMMENT '支付方式: WECHAT/ALIPAY',
    paid_at         DATETIME        DEFAULT NULL                COMMENT '支付时间',
    remark          VARCHAR(500)    DEFAULT NULL                COMMENT '用户备注',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE RESTRICT,
    INDEX idx_user          (user_id),
    INDEX idx_order_no      (order_no),
    INDEX idx_status        (status),
    INDEX idx_type_status   (order_type, status),
    INDEX idx_created       (created_at)
) ENGINE=InnoDB COMMENT '订单主表';

-- ----------------------------------------------------------------------------
-- 12. 订单明细表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS order_item;
CREATE TABLE order_item (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '明细ID',
    order_id        BIGINT          NOT NULL                    COMMENT '所属订单ID',
    item_type       ENUM('TICKET','SPECIALTY','HOTEL_ROOM')
                                    NOT NULL                    COMMENT '商品类型',
    item_id         BIGINT          NOT NULL                    COMMENT '商品ID(对应scenic_ticket/specialty/hotel_room的ID)',
    item_name       VARCHAR(200)    NOT NULL                    COMMENT '商品名称(冗余,防止原商品删除后无法显示)',
    item_image      VARCHAR(500)    DEFAULT NULL                COMMENT '商品图片(冗余)',
    quantity        INT             NOT NULL DEFAULT 1          COMMENT '购买数量',
    unit_price      DECIMAL(10,2)   NOT NULL                    COMMENT '单价',
    subtotal        DECIMAL(10,2)   NOT NULL                    COMMENT '小计(quantity × unit_price)',
    extra_info      JSON            DEFAULT NULL                COMMENT '扩展信息:
                                                                -- 门票: {"visit_date":"2026-08-01","visitor_names":["张三","李四"]}
                                                                -- 特产: {"delivery_address":"...","delivery_phone":"..."}
                                                                -- 酒店: {"check_in_date":"2026-08-01","check_out_date":"2026-08-03","guest_name":"张三","guest_phone":"138***"}',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES order_main(id) ON DELETE CASCADE,
    INDEX idx_order     (order_id),
    INDEX idx_item      (item_type, item_id)
) ENGINE=InnoDB COMMENT '订单明细表';

-- ----------------------------------------------------------------------------
-- 13. 评论表（多态关联：景区/特产/酒店/攻略）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS comment;
CREATE TABLE comment (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '评论ID',
    user_id         BIGINT          NOT NULL                    COMMENT '评论用户ID',
    target_type     ENUM('SCENIC','SPECIALTY','HOTEL','GUIDE')
                                    NOT NULL                    COMMENT '评论目标类型: SCENIC=景区, SPECIALTY=特产, HOTEL=酒店, GUIDE=攻略',
    target_id       BIGINT          NOT NULL                    COMMENT '评论目标ID',
    content         TEXT            NOT NULL                    COMMENT '评论内容',
    rating          TINYINT         DEFAULT NULL                COMMENT '评分(1-5), 景区/特产/酒店评分, 攻略评论可为NULL',
    images          JSON            DEFAULT NULL                COMMENT '评论图片JSON',
    parent_id       BIGINT          DEFAULT NULL                COMMENT '父评论ID(支持楼中楼回复)',
    like_count      INT             NOT NULL DEFAULT 0          COMMENT '点赞数',
    status          TINYINT         NOT NULL DEFAULT 1          COMMENT '状态: 1=显示, 0=隐藏(管理员可屏蔽)',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_comment_user   FOREIGN KEY (user_id)   REFERENCES sys_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_parent FOREIGN KEY (parent_id) REFERENCES comment(id)   ON DELETE CASCADE,
    INDEX idx_target    (target_type, target_id),
    INDEX idx_user      (user_id),
    INDEX idx_parent    (parent_id),
    INDEX idx_rating    (target_type, target_id, rating)
) ENGINE=InnoDB COMMENT '评论表';

-- ----------------------------------------------------------------------------
-- 14. 收藏表（多态关联：景区/特产/酒店/攻略）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS favorite;
CREATE TABLE favorite (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '收藏ID',
    user_id         BIGINT          NOT NULL                    COMMENT '用户ID',
    target_type     ENUM('SCENIC','SPECIALTY','HOTEL','GUIDE')
                                    NOT NULL                    COMMENT '收藏目标类型',
    target_id       BIGINT          NOT NULL                    COMMENT '收藏目标ID',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_favorite_user FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_user_target (user_id, target_type, target_id),  -- 防止重复收藏
    INDEX idx_target (target_type, target_id)
) ENGINE=InnoDB COMMENT '收藏表';


-- ============================================================================
-- 第四部分：初始化数据
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 初始化管理员账号
-- 密码: admin123 (明文存储)
-- ----------------------------------------------------------------------------
INSERT INTO sys_user (username, password, nickname, role) VALUES
('admin', 'admin123', '系统管理员', 'ADMIN');

-- ----------------------------------------------------------------------------
-- 初始化特产分类（按role/人群角色）
-- ----------------------------------------------------------------------------
INSERT INTO specialty_category (name, role_tag, description, sort_order) VALUES
('地道美食',   'FOODIE',  '为美食爱好者推荐的地方特色美食、小吃、农产品',             1),
('文创手作',   'ARTSY',   '文艺青年喜爱的文创产品、手工艺品、明信片等',               2),
('亲子好物',   'FAMILY',  '适合亲子出游的纪念品、趣味零食、玩具',                     3),
('户外装备',   'OUTDOOR', '户外探险爱好者的必备装备和功能性用品',                     4),
('文化藏品',   'CULTURE', '文化爱好者偏好的传统工艺品、非遗作品、文玩',               5);


-- ============================================================================
-- 附录：常用查询示例
-- ============================================================================

-- -- 查询某景区的平均评分
-- SELECT target_id, ROUND(AVG(rating), 1) AS avg_rating, COUNT(*) AS comment_count
-- FROM comment
-- WHERE target_type = 'SCENIC' AND status = 1
-- GROUP BY target_id;

-- -- 查询某用户的收藏列表
-- SELECT f.id, f.target_type, f.target_id, f.created_at
-- FROM favorite f
-- WHERE f.user_id = ? AND f.target_type = ?
-- ORDER BY f.created_at DESC;

-- -- 查询管理员操作日志（按时间倒序）
-- SELECT * FROM sys_audit_log
-- WHERE admin_id = ?
-- ORDER BY created_at DESC
-- LIMIT 50;

-- -- 查询某酒店在指定日期范围内的可用房间
-- SELECT hr.*
-- FROM hotel_room hr
-- WHERE hr.hotel_id = ?
--   AND hr.status = 1
--   AND hr.stock > (
--     SELECT COALESCE(SUM(oi.quantity), 0)
--     FROM order_item oi
--     JOIN order_main om ON oi.order_id = om.id
--     WHERE oi.item_type = 'HOTEL_ROOM'
--       AND oi.item_id = hr.id
--       AND om.status IN ('PAID', 'COMPLETED')
--       AND JSON_EXTRACT(oi.extra_info, '$.check_in_date') < ?
--       AND JSON_EXTRACT(oi.extra_info, '$.check_out_date') > ?
--   );
