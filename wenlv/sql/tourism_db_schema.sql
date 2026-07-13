-- ============================================================================
-- 文旅综合服务平台 - 数据库设计
-- 版本: v1.0
-- 日期: 2026-07-08
-- 数据库: MySQL 5.7+ / MariaDB 10.2+
-- 说明: 包含15张表，覆盖用户、景区、特产、酒店、攻略、订单、评论、收藏、日志、新闻动态、通知公告
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
    password        VARCHAR(255)    NOT NULL                    COMMENT '密码(明文)',
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
-- 2. 平台日志表（记录用户注册、登录、发评论、发攻略、下单等活动）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS sys_platform_log;
CREATE TABLE sys_platform_log (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '日志ID',
    user_id         BIGINT          NOT NULL                    COMMENT '用户ID',
    user_name       VARCHAR(50)     NOT NULL                    COMMENT '用户名(冗余)',
    log_type        ENUM('REGISTER','LOGIN','LOGOUT','POST_COMMENT','POST_GUIDE','PLACE_ORDER','CANCEL_ORDER','CONFIRM_RECEIPT','UPDATE_PROFILE')
                                    NOT NULL                    COMMENT '日志类型: REGISTER=注册, LOGIN=登录, LOGOUT=登出, POST_COMMENT=发布评论, POST_GUIDE=发布攻略, PLACE_ORDER=下单, CANCEL_ORDER=取消订单, CONFIRM_RECEIPT=确认收货, UPDATE_PROFILE=修改资料',
    target_type     VARCHAR(50)     DEFAULT NULL                COMMENT '关联目标类型: USER/COMMENT/GUIDE/ORDER',
    target_id       BIGINT          DEFAULT NULL                COMMENT '关联目标记录ID',
    target_name     VARCHAR(200)    DEFAULT NULL                COMMENT '关联目标名称(冗余)',
    detail          JSON            DEFAULT NULL                COMMENT '详细信息: {"ip":"...","remark":"..."}',
    ip_address      VARCHAR(50)     DEFAULT NULL                COMMENT '操作来源IP地址',
    user_agent      VARCHAR(500)    DEFAULT NULL                COMMENT '浏览器User-Agent',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user      (user_id),
    INDEX idx_type      (log_type),
    INDEX idx_target    (target_type, target_id),
    INDEX idx_created   (created_at),

    CONSTRAINT fk_platform_log_user FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT '平台日志表（用户活动记录）';


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
-- 5. 新闻动态表（民间视角：见义勇为、拾金不昧、游玩见闻等）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS news_dynamic;
CREATE TABLE news_dynamic (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '新闻ID',
    title           VARCHAR(200)    NOT NULL                    COMMENT '标题',
    content         LONGTEXT        NOT NULL                    COMMENT '正文内容(富文本)',
    cover_image     VARCHAR(500)    DEFAULT NULL                COMMENT '封面图',
    source          VARCHAR(100)    DEFAULT NULL                COMMENT '来源(如: 宁夏日报/网友投稿)',
    author_name     VARCHAR(50)     DEFAULT NULL                COMMENT '投稿人/作者',
    view_count      INT             NOT NULL DEFAULT 0          COMMENT '浏览量',
    is_published    TINYINT         NOT NULL DEFAULT 0          COMMENT '是否已发布: 1=是, 0=草稿',
    published_at    DATETIME        DEFAULT NULL                COMMENT '发布时间',
    created_by      BIGINT          DEFAULT NULL                COMMENT '发布人(管理员ID)',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_news_dynamic_author FOREIGN KEY (created_by) REFERENCES sys_user(id) ON DELETE SET NULL,
    INDEX idx_published (is_published, published_at),
    INDEX idx_view      (view_count)
) ENGINE=InnoDB COMMENT '新闻动态表（民间视角）';

-- ----------------------------------------------------------------------------
-- 6. 通知公告表（官方视角：景区关闭、价格调整、路段封闭等）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS official_notice;
CREATE TABLE official_notice (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '公告ID',
    title           VARCHAR(200)    NOT NULL                    COMMENT '标题',
    content         LONGTEXT        NOT NULL                    COMMENT '正文内容(富文本)',
    scenic_spot_id  BIGINT          DEFAULT NULL                COMMENT '关联景区ID(NULL=平台级公告)',
    cover_image     VARCHAR(500)    DEFAULT NULL                COMMENT '封面图',
    is_top          TINYINT         NOT NULL DEFAULT 0          COMMENT '是否置顶: 1=是, 0=否',
    is_published    TINYINT         NOT NULL DEFAULT 0          COMMENT '是否已发布: 1=是, 0=草稿',
    published_at    DATETIME        DEFAULT NULL                COMMENT '发布时间',
    created_by      BIGINT          DEFAULT NULL                COMMENT '发布人(管理员ID)',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_notice_spot   FOREIGN KEY (scenic_spot_id) REFERENCES scenic_spot(id) ON DELETE SET NULL,
    CONSTRAINT fk_notice_author FOREIGN KEY (created_by)     REFERENCES sys_user(id)   ON DELETE SET NULL,
    INDEX idx_published (is_published, published_at),
    INDEX idx_spot      (scenic_spot_id),
    INDEX idx_top       (is_top)
) ENGINE=InnoDB COMMENT '通知公告表（官方视角）';

-- ----------------------------------------------------------------------------
-- 7. 特产分类表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS specialty_category;
CREATE TABLE specialty_category (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '分类ID',
    name            VARCHAR(50)     NOT NULL                    COMMENT '分类名称(如: 地道美食/文创手作)',
    description     VARCHAR(255)    DEFAULT NULL                COMMENT '分类描述',
    icon            VARCHAR(500)    DEFAULT NULL                COMMENT '分类图标URL',
    sort_order      INT             NOT NULL DEFAULT 0          COMMENT '排序(越小越靠前)',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT '特产分类表';

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
-- 11. 订单主表（特产订单）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS order_main;
CREATE TABLE order_main (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '订单ID',
    order_no        VARCHAR(32)     NOT NULL UNIQUE             COMMENT '订单编号',
    user_id         BIGINT          NOT NULL                    COMMENT '下单用户ID',
    total_amount    DECIMAL(10,2)   NOT NULL                    COMMENT '订单总额',
    discount_amount DECIMAL(10,2)   NOT NULL DEFAULT 0.00       COMMENT '优惠金额',
    pay_amount      DECIMAL(10,2)   NOT NULL                    COMMENT '实付金额',
    pickup_method   ENUM('PICKUP','DELIVERY') NOT NULL DEFAULT 'PICKUP' COMMENT '取货方式: PICKUP=自取, DELIVERY=快递',
    delivery_name   VARCHAR(50)     DEFAULT NULL                COMMENT '收件人姓名(DELIVERY时必填)',
    delivery_phone  VARCHAR(20)     DEFAULT NULL                COMMENT '收件人电话(DELIVERY时必填)',
    delivery_address VARCHAR(255)   DEFAULT NULL                COMMENT '收件地址(DELIVERY时必填)',
    status          ENUM('PENDING','PAID','SHIPPED','CANCELLED','REFUNDED','COMPLETED')
                                    NOT NULL DEFAULT 'PENDING'  COMMENT '订单状态: PENDING=待支付, PAID=已支付, SHIPPED=已发货, CANCELLED=已取消, REFUNDED=已退款, COMPLETED=已确认收货',
    payment_method  VARCHAR(50)     DEFAULT NULL                COMMENT '支付方式: WECHAT/ALIPAY',
    paid_at         DATETIME        DEFAULT NULL                COMMENT '支付时间',
    shipped_at      DATETIME        DEFAULT NULL                COMMENT '发货时间',
    completed_at    DATETIME        DEFAULT NULL                COMMENT '确认收货时间',
    remark          VARCHAR(500)    DEFAULT NULL                COMMENT '用户备注',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE RESTRICT,
    INDEX idx_user          (user_id),
    INDEX idx_order_no      (order_no),
    INDEX idx_status        (status),
    INDEX idx_pickup        (pickup_method),
    INDEX idx_created       (created_at)
) ENGINE=InnoDB COMMENT '订单主表（特产订单）';

-- ----------------------------------------------------------------------------
-- 12. 订单明细表（特产）
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS order_item;
CREATE TABLE order_item (
    id              BIGINT          PRIMARY KEY AUTO_INCREMENT  COMMENT '明细ID',
    order_id        BIGINT          NOT NULL                    COMMENT '所属订单ID',
    specialty_id    BIGINT          NOT NULL                    COMMENT '特产ID',
    item_name       VARCHAR(200)    NOT NULL                    COMMENT '商品名称(冗余)',
    item_image      VARCHAR(500)    DEFAULT NULL                COMMENT '商品图片(冗余)',
    quantity        INT             NOT NULL DEFAULT 1          COMMENT '购买数量',
    unit_price      DECIMAL(10,2)   NOT NULL                    COMMENT '单价',
    subtotal        DECIMAL(10,2)   NOT NULL                    COMMENT '小计(quantity × unit_price)',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_item_order     FOREIGN KEY (order_id)     REFERENCES order_main(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_specialty FOREIGN KEY (specialty_id) REFERENCES specialty(id)  ON DELETE RESTRICT,
    INDEX idx_order     (order_id),
    INDEX idx_specialty (specialty_id)
) ENGINE=InnoDB COMMENT '订单明细表（特产）';

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
-- 密码: admin123
-- ----------------------------------------------------------------------------
INSERT INTO sys_user (username, password, nickname, role) VALUES
('admin', '$SHA$240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '系统管理员', 'ADMIN');

-- ----------------------------------------------------------------------------
-- 初始化特产分类
-- ----------------------------------------------------------------------------
INSERT INTO specialty_category (name, description, sort_order) VALUES
('地道美食',   '为美食爱好者推荐的地方特色美食、小吃、农产品',             1),
('文创手作',   '文艺青年喜爱的文创产品、手工艺品、明信片等',               2),
('亲子好物',   '适合亲子出游的纪念品、趣味零食、玩具',                     3),
('户外装备',   '户外探险爱好者的必备装备和功能性用品',                     4),
('文化藏品',   '文化爱好者偏好的传统工艺品、非遗作品、文玩',               5);

-- ----------------------------------------------------------------------------
-- 初始化特产（宁夏特色美食与手信，6条）
-- ----------------------------------------------------------------------------
INSERT INTO specialty (category_id, name, description, price, stock, main_image, images, sales_count, status) VALUES
(1, '盐池手抓滩羊礼盒', '盐池滩羊是中国国家地理标志产品，肉质细嫩无膻味。选用6-8月龄滩羊，清水慢火焖煮。礼盒含2斤熟羊肉+蘸料，真空包装，开袋即食。', 168.00, 200, 'images/service-1-370x389.jpg', '["images/food-img-1-270x260.jpg"]', 356, 1),
(1, '吴忠八宝茶礼盒', '宁夏回族传统养生茶饮，精选枸杞、红枣、桂圆、葡萄干等八味原料。解腻暖胃，老少皆宜。30袋独立包装。', 68.00, 500, 'images/service-2-370x389.jpg', NULL, 1024, 1),
(2, '中卫手工酿皮套装', '中卫传统小吃，粗粮手工制作，面皮筋道爽滑。搭配秘制酸辣调料。6份酿皮+6份调料，真空锁鲜。', 39.90, 300, 'images/service-3-370x389.jpg', NULL, 687, 1),
(3, '宁夏枸杞原浆（中宁头茬）', '中宁头茬枸杞，低温冷榨工艺保留营养。30ml×10袋装，每日一袋，滋补养颜。', 89.00, 400, 'images/service-4-370x389.jpg', NULL, 1520, 1),
(4, '贺兰山东麓葡萄酒（赤霞珠干红）', '贺兰山东麓北纬38°黄金产区，橡木桶陈酿12个月，酒体饱满果香浓郁。750ml×2瓶礼盒。', 298.00, 150, 'images/service-5-370x389.jpg', NULL, 234, 1),
(5, '贺兰石篆刻印章套装', '贺兰石中国名砚石材，非遗传承人手工雕刻。含印章+篆刻工具+印泥，可定制姓名或闲章。', 258.00, 80, 'images/service-6-370x389.jpg', NULL, 98, 1);

-- ----------------------------------------------------------------------------
-- 初始化酒店（宁夏特色民宿，6条）
-- ----------------------------------------------------------------------------
INSERT INTO hotel (name, description, address, city, star_rating, contact_phone, facilities, cover_image, images, min_price, status) VALUES
('黄河宿集', '坐落于黄河岸边，融合传统与现代的高端民宿集群。由大乐之野、西坡、墟里等知名品牌共同打造，每一间客房都面向黄河，让您在清晨醒来就能看到壮美的黄河日出。', '中卫市沙坡头区常乐镇', '中卫', 5, '0955-7668888', '["WiFi","停车场","餐厅","无边泳池","书吧","黄河观景台"]', 'images/service-1-370x389.jpg', '["images/grid-gallery-1-370x250.jpg","images/grid-gallery-2-370x250.jpg"]', 1288.00, 1),

('沙漠星空营地', '腾格里沙漠腹地的轻奢帐篷营地。夜晚躺在帐篷里就能看到满天繁星，是观星爱好者的天堂。提供沙漠烧烤、篝火晚会、骑骆驼等特色体验活动。', '中卫市沙坡头区腾格里沙漠', '中卫', 4, '0955-7666666', '["WiFi","停车","帐篷","篝火","观星台","沙漠越野车"]', 'images/service-2-370x389.jpg', NULL, 680.00, 1),

('贺兰山房', '依贺兰山而建的山间民宿，推窗即见贺兰山巍峨山景。采用宁夏传统民居风格设计，融入现代舒适设施。每间客房配置私人温泉泡池，享受山间宁静时光。', '银川市西夏区贺兰山脚下', '银川', 4, '0951-3888666', '["WiFi","停车场","温泉","茶室","登山向导"]', 'images/service-3-370x389.jpg', NULL, 580.00, 1),

('枸杞庄园民宿', '隐藏在万亩枸杞园中的田园民宿。每年6-9月可体验枸杞采摘乐趣，品尝新鲜的枸杞鲜果。庄园自产枸杞产品可供购买，是将农业观光与住宿完美结合的特色民宿。', '中卫市中宁县枸杞种植基地', '中卫', 3, '0955-5666888', '["WiFi","停车场","采摘园","餐厅","特产商店"]', 'images/service-4-370x389.jpg', NULL, 398.00, 1),

('镇北堡影视客栈', '紧邻镇北堡西部影城的主题客栈。每间客房以经典电影命名，内部陈设还原电影场景。住客可享影城门票优惠，仿佛穿越到电影的精彩世界。', '银川市西夏区镇北堡镇', '银川', 4, '0951-2136999', '["WiFi","停车场","影城接驳","主题餐厅","电影放映厅"]', 'images/service-5-370x389.jpg', NULL, 468.00, 1),

('沙湖木屋度假村', '沙湖景区内的生态木屋度假村。木屋依湖而建，融合湿地自然风光。早起可观鸟，傍晚可赏落日，是亲子出游和情侣度假的理想选择。', '石嘴山市平罗县沙湖景区内', '石嘴山', 4, '0952-6688999', '["WiFi","停车场","餐厅","游船码头","儿童乐园","垂钓区"]', 'images/service-6-370x389.jpg', NULL, 888.00, 1);

-- ----------------------------------------------------------------------------
-- 初始化景区（8条，参考前台页面)
-- ----------------------------------------------------------------------------
INSERT INTO scenic_spot (name, description, address, city, opening_hours, contact_phone, cover_image, images, min_price, view_count, favorite_count, status) VALUES
('沙坡头景区', '沙坡头位于宁夏中卫市，集大漠、黄河、高山、绿洲为一体，是国家5A级旅游景区。这里既有西北风光的雄奇，又有江南景色的秀美。黄河与沙漠在这里交汇形成了独特的自然景观，游客可以体验黄河漂流、沙漠探险、滑沙等多种活动。', '中卫市沙坡头区迎水桥镇', '中卫', '08:00-18:00', '0955-7689103', 'images/tour-1-370x284.jpg', '["images/grid-gallery-1-370x250.jpg","images/grid-gallery-2-370x250.jpg","images/grid-gallery-3-370x250.jpg"]', 100.00, 12345, 2345, 'OPEN'),
('沙湖景区', '沙湖旅游区是国家5A级景区，以沙、水、苇、鸟、山五大自然景观有机结合而闻名。景区面积80平方公里，其中水域面积45平方公里，每年春夏之交数万只候鸟在此栖息繁衍。', '石嘴山市平罗县', '石嘴山', '08:00-17:30', '0952-6688123', 'images/tour-2-370x284.jpg', '["images/grid-gallery-4-370x250.jpg","images/grid-gallery-5-370x250.jpg"]', 60.00, 9876, 1856, 'OPEN'),
('西夏王陵', '西夏王陵是西夏王朝历代帝王的陵墓群，被誉为"东方金字塔"。位于银川市西郊，占地面积约50平方公里。现存9座帝陵、253座陪葬墓，神秘的西夏文明在这里留下了最宏伟的建筑遗迹。', '银川市西夏区贺兰山东麓', '银川', '08:30-17:30', '0951-5666888', 'images/tour-3-370x284.jpg', NULL, 85.00, 7654, 1521, 'OPEN'),
('镇北堡西部影城', '镇北堡西部影城是国家5A级景区，由著名作家张贤亮创办。这里拍摄过《大话西游》《红高粱》《新龙门客栈》等百余部经典影视作品，漫步其中仿佛穿越时空走进电影的世界。', '银川市西夏区镇北堡镇', '银川', '08:00-18:00', '0951-2136888', 'images/tour-4-370x284.jpg', '["images/grid-gallery-1-370x250.jpg","images/grid-gallery-6-370x250.jpg"]', 80.00, 8901, 2034, 'OPEN'),
('贺兰山岩画', '贺兰山岩画是中国重点文物保护单位，分布在贺兰山东麓的悬崖峭壁上，创作于3000至10000年前，记录了远古先民的狩猎、放牧、战争等生活场景，是研究北方游牧民族历史文化的重要资料。', '银川市贺兰县贺兰山', '银川', '08:30-17:00', '0951-4110888', 'images/tour-5-370x284.jpg', NULL, 60.00, 6543, 1245, 'OPEN'),
('水洞沟遗址', '水洞沟是中国最早发现的旧石器时代遗址之一，距今约3万年。这里有古人类遗址、明代长城、藏兵洞等众多历史文化遗迹，景区集考古、探险、观光于一体。', '银川市灵武市临河镇', '银川', '08:30-17:30', '0951-5018888', 'images/tour-6-370x284.jpg', NULL, 76.00, 4321, 876, 'OPEN'),
('青铜峡108塔', '青铜峡108塔位于黄河青铜峡峡口西岸，是一组排列成三角形的实心喇嘛塔群，始建于西夏时期。塔群依山势自上而下排列共108座，是我国现存最大的喇嘛塔群之一。', '吴忠市青铜峡市黄河西岸', '吴忠', '08:30-18:00', '0953-3056666', 'images/tour-7-370x284.jpg', NULL, 45.00, 3456, 654, 'OPEN'),
('须弥山石窟', '须弥山石窟始建于北魏，历经西魏、北周、隋、唐等朝代的开凿与修缮，是中国十大石窟之一。现存石窟162座，造像350余尊，石窟依山而建规模宏大雕刻精美。', '固原市原州区须弥山', '固原', '08:30-17:30', '0954-2685999', 'images/tour-8-370x284.jpg', NULL, 50.00, 2345, 432, 'OPEN');

-- ----------------------------------------------------------------------------
-- 初始化新闻动态（民间视角：见义勇为、拾金不昧、游玩见闻等灌水帖子）
-- ----------------------------------------------------------------------------
INSERT INTO news_dynamic (title, content, cover_image, source, author_name, is_published, published_at) VALUES
('游客在沙坡头景区拾金不昧，万元现金物归原主',
 '近日，一名来自北京的游客张先生在沙坡头景区游玩时不慎将装有万元现金的钱包遗落在休息区。景区工作人员李女士发现后立即上报，通过广播寻人、监控排查，仅用半小时便联系到失主。张先生激动地表示："宁夏不仅风景美，人心更美！"景区已对李女士进行了通报表扬。',
 'images/news-1.jpg', '宁夏日报', '王记者', 1, '2026-06-15 09:30:00'),

('贺兰山岩画景区工作人员勇救落水儿童',
 '6月10日下午，一名8岁男童在贺兰山岩画景区内的溪流边玩耍时不慎落水。景区安保人员马师傅听到呼救后，毫不犹豫跳入水中，成功将孩子救上岸。经检查，孩子仅受轻微擦伤。家长感激涕零，当场拿出5000元酬谢，被马师傅婉拒。',
 'images/news-2.jpg', '银川晚报', '李编辑', 1, '2026-06-12 14:00:00'),

('沙湖景区惊现候鸟大规模迁徙奇观，游客纷纷拍照打卡',
 '5月底至6月初，沙湖景区迎来了一年一度的候鸟迁徙季。数万只苍鹭、白鹭、鸬鹚在此停留栖息，形成了一道壮观的生态风景线。来自全国各地的摄影爱好者蜂拥而至，景区为此专门开辟了观鸟摄影区。',
 'images/news-3.jpg', '宁夏文旅频道', '小马', 1, '2026-06-01 08:00:00'),

('水洞沟遗址发现疑似新考古线索，专家团队已进驻',
 '据知情人士透露，水洞沟遗址在近期的一次常规维护中，工作人员意外发现了一些疑似旧石器时代的石器碎片。宁夏文物考古研究所已派出专家团队进驻现场进行勘察。',
 'images/news-4.jpg', '新华社宁夏分社', '陈记者', 1, '2026-07-01 10:00:00'),

('镇北堡西部影城偶遇剧组拍摄，游客近距离感受电影魅力',
 '7月5日，前往镇北堡西部影城游玩的游客们惊喜地发现，一支知名剧组正在影城内取景拍摄。影城方面表示，在不影响拍摄的前提下游客依然可以正常参观。',
 'images/news-5.jpg', '网友投稿', '影迷小王', 1, '2026-07-06 16:00:00'),

('西夏王陵景区推出夜游项目，月光下的东方金字塔别样壮观',
 '西夏王陵景区近日正式推出了"月下王陵"夜游体验项目。每周五、六晚间19:30-22:00开放，游客可在月光和灯光的映衬下游览王陵。',
 'images/news-6.jpg', '宁夏旅游资讯', '小周', 1, '2026-07-08 11:00:00'),

('黄河宿集获评"全国最美民宿集群"，成网红打卡新地标',
 '宁夏中卫黄河宿集入选文旅部评选的"全国最美民宿集群"，莫干山、西坡等知名品牌纷纷入驻。《亲爱的客栈》等综艺取景地，吸引大量游客前来体验黄河岸边的慢生活。',
 'images/news-1.jpg', '人民日报', '张记者', 1, '2026-07-10 08:00:00'),

('宁夏第一家沙漠图书馆落成，书香伴驼铃',
 '中卫沙坡头景区内宁夏首家沙漠图书馆正式对外开放。馆藏图书3000余册，涵盖宁夏历史文化、沙漠生态等主题。读者可坐在落地窗前，一边阅读一边欣赏大漠风光，成为新的网红打卡地。',
 'images/news-2.jpg', '宁夏日报', '王记者', 1, '2026-07-09 10:00:00'),

('贺兰山东麓葡萄酒获国际金奖，宁夏红酒走向世界',
 '在2026年国际葡萄酒挑战赛上，贺兰山东麓产区三款葡萄酒斩获金奖。评委盛赞宁夏葡萄酒"果香浓郁、单宁丝滑，具有国际顶级水准"。宁夏葡萄酒产业已成为中国葡萄酒走向世界的名片。',
 'images/news-3.jpg', '新华社', '李记者', 1, '2026-07-05 14:00:00'),

('宁夏旅游专列开通，一线串联十二景区',
 '宁夏文化和旅游厅联合铁路部门开通"塞上江南号"旅游专列，从银川出发途经沙湖、西夏王陵、沙坡头等12个核心景区。列车上配备导游讲解、宁夏特色餐饮，实现"上车休息、下车游玩"的全新体验。',
 'images/news-4.jpg', '人民铁道报', '刘记者', 1, '2026-07-03 09:00:00'),

('大学生暑期"特种兵式"游宁夏，三天打卡十大景点走红网络',
 '一位大学生在社交平台分享了自己三天内打卡宁夏十大景区的极限旅行经历，引发大量讨论。宁夏文旅厅顺势推出"青春畅游卡"，大学生凭学生证可享景区门票半价优惠。',
 'images/news-5.jpg', '网友投稿', '旅行达人阿杰', 1, '2026-07-01 16:00:00'),

('西夏陵申遗工作取得重大进展，已进入终审阶段',
 '西夏陵申报世界文化遗产工作迎来里程碑。联合国教科文组织专家组已完成实地考察评估，对西夏陵的历史价值、保护现状给予高度评价。宁夏将以此为契机进一步加强文化遗产保护。',
 'images/news-6.jpg', '光明日报', '陈记者', 1, '2026-06-28 08:00:00'),

('宁夏发布"星空旅游"精品线路，打造中国最佳观星地',
 '宁夏文旅厅发布三条"星空旅游"精品线路，依托贺兰山、沙坡头、盐池等光污染极低的优质观星资源，打造集星空观测、沙漠露营、科普研学于一体的星空旅游目的地。',
 'images/news-1.jpg', '宁夏文旅频道', '小周', 1, '2026-06-25 11:00:00'),

('黄河流域非遗大展在银川开幕，百位传承人现场展演',
 '2026年黄河流域非物质文化遗产大展在银川国际会展中心盛大开幕。来自沿黄九省区的108位非遗传承人现场展示剪纸、泥塑、刺绣等传统技艺，吸引数万市民和游客参观体验。',
 'images/news-2.jpg', '中国文化报', '赵记者', 1, '2026-06-20 09:00:00'),

('银川河东国际机场开通多条国际航线，入境游持续升温',
 '银川河东国际机场新增迪拜、新加坡、曼谷三条国际航线。上半年宁夏入境游客同比增长58%，其中来自中东和东南亚的游客增幅最大，宁夏正在成为"一带一路"旅游新枢纽。',
 'images/news-3.jpg', '宁夏新闻网', '马记者', 1, '2026-06-18 10:00:00'),

('宁夏"葡萄酒+旅游"融合发展，酒庄游成新风尚',
 '宁夏积极探索葡萄酒产业与文旅深度融合，贺兰山东麓已建成20余座集葡萄种植、酿造、品鉴、住宿于一体的精品酒庄。游客可体验采摘、酿酒、品酒等沉浸式活动，酒庄游预订量同比增长120%。',
 'images/news-4.jpg', '经济日报', '孙记者', 1, '2026-06-15 08:00:00'),

('沙坡头"沙漠音乐节"官宣阵容，知名乐队齐聚大漠',
 '2026沙坡头沙漠音乐节正式官宣演出阵容，包括痛仰、新裤子等知名乐队将在腾格里沙漠腹地激情开唱。音乐节融合沙漠露营、星空观影、篝火晚会等元素，预计将吸引超过5万名乐迷。',
 'images/news-5.jpg', '宁夏日报', '王记者', 1, '2026-06-10 14:00:00'),

('六盘山国家森林公园获评"中国天然氧吧"',
 '经中国气象局专家组评审，宁夏六盘山国家森林公园正式获评"中国天然氧吧"称号。六盘山森林覆盖率高达72%，负氧离子含量常年保持在每立方厘米2万个以上，是避暑康养的理想之地。',
 'images/news-6.jpg', '宁夏日报', '李记者', 1, '2026-06-05 09:00:00'),

('宁夏推出"一卡通"旅游年票，百余景区全年无限畅游',
 '宁夏文旅厅发布"宁夏旅游一卡通"年票产品，售价298元。持卡人可在一年内不限次游览全区100余个A级景区。同步推出电子卡和实体卡，线上即可办理。',
 'images/news-1.jpg', '宁夏新闻网', '小马', 1, '2026-06-01 10:00:00');

-- ----------------------------------------------------------------------------
-- 初始化通知公告（官方视角：景区关闭、价格调整、路段封闭等）
-- ----------------------------------------------------------------------------
INSERT INTO official_notice (title, content, scenic_spot_id, is_top, is_published, published_at) VALUES
('沙坡头景区关于暑期延长开放时间的通知',
 '尊敬的游客朋友们：为满足暑期旅游需求，沙坡头景区自2026年7月15日至8月31日期间，开放时间调整为每日07:00-20:00（原为08:00-18:00）。请各位游客合理安排出行时间，祝您游玩愉快！',
 NULL, 1, 1, '2026-07-08 08:00:00'),

('关于沙湖景区部分区域临时封闭维护的公告',
 '各位游客：因沙湖景区东区芦苇荡区域进行生态维护施工，自2026年7月20日起至7月30日，该区域将临时封闭，其他区域正常开放。施工期间游船路线略有调整，详情请咨询景区服务中心。',
 NULL, 1, 1, '2026-07-15 09:00:00'),

('宁夏文旅厅关于景区门票价格调整的公告',
 '根据自治区发改委批复，区内部分A级景区门票价格自2026年8月1日起进行调整：西夏王陵由75元调整为85元，贺兰山岩画由60元调整为70元，青铜峡108塔由45元调整为50元。现役军人、残疾人、65岁以上老人凭证免票，学生凭证半价不变。',
 NULL, 1, 1, '2026-07-05 10:00:00'),

('关于G110国道银川—贺兰山路段封闭施工的通告',
 '广大市民和游客朋友：因G110国道银川至贺兰山段路面改造工程需要，自2026年7月25日至9月30日该路段将实行分段封闭施工。过往车辆请绕行G6京藏高速或西夏区城区道路。',
 NULL, 1, 1, '2026-07-10 12:00:00'),

('镇北堡西部影城关于临时调整参观路线的通知',
 '亲爱的游客朋友们：因景区内部分影视布景进行年度翻新维护，7月18日至7月22日期间明清街区及部分影棚区域将暂停对外开放，其他区域正常开放。门票价格临时调整为60元/人（原价80元/人）。',
 NULL, 0, 1, '2026-07-12 15:00:00'),

('2026年宁夏"塞上江南·神奇宁夏"文旅惠民消费券发放公告',
 '为促进文旅消费，宁夏文旅厅联合财政厅推出2026年文旅惠民消费券，总额500万元。发放时间：7月15日至10月31日，每月1日和15日上午10:00。券面类型：景区门票满100减30、酒店住宿满300减80、特产购物满200减50。登录"宁夏智慧文旅"微信公众号或支付宝小程序领取，每人每月限领2张，先到先得。',
 NULL, 1, 1, '2026-07-01 09:00:00'),

('关于开展2026年旅游市场秩序专项整治的通知',
 '各市、县（区）文化和旅游局：为进一步规范旅游市场秩序，维护游客合法权益，决定自2026年7月起开展为期三个月的旅游市场专项整治行动。重点整治强制购物、虚假宣传、不合理低价游等违法违规行为。',
 NULL, 1, 1, '2026-06-28 09:00:00'),

('关于做好暑期旅游安全工作的通知',
 '各景区管理处、旅行社：暑期旅游高峰即将到来，为切实保障游客人身财产安全，现就有关事项通知如下：一、全面排查景区安全隐患；二、加强水上及高风险项目监管；三、完善应急预案并组织演练；四、做好高温防暑应急准备。',
 NULL, 1, 1, '2026-06-25 10:00:00'),

('宁夏文化和旅游厅关于表彰2025年度优秀旅行社的决定',
 '各市、县（区）文化和旅游局、各旅行社：根据2025年度服务质量考核结果，决定授予宁夏中国国际旅行社等10家单位"2025年度优秀旅行社"荣誉称号。希望受表彰的单位珍惜荣誉，再接再厉，为宁夏文旅高质量发展作出更大贡献。',
 NULL, 0, 1, '2026-06-20 08:00:00'),

('关于规范景区周边停车管理的联合通告',
 '各位游客及市民朋友：为进一步规范各大景区周边停车秩序，宁夏交通运输厅联合公安厅发布通告：自7月1日起，沙坡头、沙湖、西夏王陵等核心景区周边新增智慧停车场12处，新增停车位3500个。请广大游客遵守交通指引，文明停车。',
 NULL, 0, 1, '2026-06-15 14:00:00'),

('关于征集2027年宁夏旅游宣传口号和形象标识的公告',
 '为全面提升宁夏旅游品牌影响力，现面向全社会公开征集2027年宁夏旅游宣传口号和形象标识（LOGO）。征集时间：2026年7月1日至9月30日。作品要求突出宁夏地域特色和文化底蕴。设一等奖1名奖金5万元，二等奖2名奖金各2万元，三等奖5名奖金各5000元。',
 NULL, 0, 1, '2026-06-10 09:00:00'),

('宁夏"引客入宁"旅游奖励政策（2026年修订版）公布',
 '各旅行社、旅游企业：现将《宁夏回族自治区"引客入宁"旅游奖励政策（2026年修订版）》予以公布。对组织包机、专列、自驾车队来宁旅游的旅行社给予最高10万元奖励，对年度累计输送游客超过1万人次的给予额外奖励。本政策自公布之日起施行。',
 NULL, 1, 1, '2026-06-05 08:00:00');
