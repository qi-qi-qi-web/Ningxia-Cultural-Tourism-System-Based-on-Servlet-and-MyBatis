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
-- 初始化新闻动态（民间视角：见义勇为、拾金不昧、游玩见闻等灌水帖子）
-- ----------------------------------------------------------------------------
INSERT INTO news_dynamic (title, content, cover_image, source, author_name, is_published, published_at) VALUES
('游客在沙坡头景区拾金不昧，万元现金物归原主',
 '<p>近日，一名来自北京的游客张先生在沙坡头景区游玩时不慎将装有万元现金的钱包遗落在休息区。景区工作人员李女士发现后立即上报，通过广播寻人、监控排查，仅用半小时便联系到失主。</p><p>张先生激动地表示："宁夏不仅风景美，人心更美！"景区已对李女士进行了通报表扬。</p>',
 'images/news-1.jpg', '宁夏日报', '王记者', 1, '2026-06-15 09:30:00'),

('贺兰山岩画景区工作人员勇救落水儿童',
 '<p>6月10日下午，一名8岁男童在贺兰山岩画景区内的溪流边玩耍时不慎落水。景区安保人员马师傅听到呼救后，毫不犹豫跳入水中，成功将孩子救上岸。</p><p>经检查，孩子仅受轻微擦伤。家长感激涕零，当场拿出5000元酬谢，被马师傅婉拒。</p>',
 'images/news-2.jpg', '银川晚报', '李编辑', 1, '2026-06-12 14:00:00'),

('沙湖景区惊现候鸟大规模迁徙奇观，游客纷纷拍照打卡',
 '<p>5月底至6月初，沙湖景区迎来了一年一度的候鸟迁徙季。数万只苍鹭、白鹭、鸬鹚在此停留栖息，形成了一道壮观的生态风景线。</p><p>来自全国各地的摄影爱好者蜂拥而至，景区为此专门开辟了观鸟摄影区。</p>',
 'images/news-3.jpg', '宁夏文旅频道', '小马', 1, '2026-06-01 08:00:00'),

('水洞沟遗址发现疑似新考古线索，专家团队已进驻',
 '<p>据知情人士透露，水洞沟遗址在近期的一次常规维护中，工作人员意外发现了一些疑似旧石器时代的石器碎片。宁夏文物考古研究所已派出专家团队进驻现场进行勘察。</p>',
 'images/news-4.jpg', '新华社宁夏分社', '陈记者', 1, '2026-07-01 10:00:00'),

('镇北堡西部影城偶遇剧组拍摄，游客近距离感受电影魅力',
 '<p>7月5日，前往镇北堡西部影城游玩的游客们惊喜地发现，一支知名剧组正在影城内取景拍摄。影城方面表示，在不影响拍摄的前提下游客依然可以正常参观。</p>',
 'images/news-5.jpg', '网友投稿', '影迷小王', 1, '2026-07-06 16:00:00'),

('西夏王陵景区推出夜游项目，月光下的东方金字塔别样壮观',
 '<p>西夏王陵景区近日正式推出了"月下王陵"夜游体验项目。每周五、六晚间19:30-22:00开放，游客可在月光和灯光的映衬下游览王陵。</p>',
 'images/news-6.jpg', '宁夏旅游资讯', '小周', 1, '2026-07-08 11:00:00');

-- ----------------------------------------------------------------------------
-- 初始化通知公告（官方视角：景区关闭、价格调整、路段封闭等）
-- ----------------------------------------------------------------------------
INSERT INTO official_notice (title, content, scenic_spot_id, is_top, is_published, published_at) VALUES
('沙坡头景区关于暑期延长开放时间的通知',
 '<p>尊敬的游客朋友们：</p><p>为满足暑期旅游需求，沙坡头景区自2026年7月15日至8月31日期间，开放时间调整为每日07:00-20:00（原为08:00-18:00）。</p><p>请各位游客合理安排出行时间，祝您游玩愉快！</p>',
 1, 1, 1, '2026-07-08 08:00:00'),

('关于沙湖景区部分区域临时封闭维护的公告',
 '<p>各位游客：</p><p>因沙湖景区东区芦苇荡区域进行生态维护施工，自2026年7月20日起至7月30日，该区域将临时封闭，其他区域正常开放。施工期间游船路线略有调整，详情请咨询景区服务中心。</p>',
 2, 1, 1, '2026-07-15 09:00:00'),

('宁夏文旅厅关于景区门票价格调整的公告',
 '<p>根据自治区发改委批复，区内部分A级景区门票价格自2026年8月1日起进行调整：西夏王陵由75元调整为85元，贺兰山岩画由60元调整为70元，青铜峡108塔由45元调整为50元。现役军人、残疾人、65岁以上老人凭证免票，学生凭证半价不变。</p>',
 NULL, 1, 1, '2026-07-05 10:00:00'),

('关于G110国道银川—贺兰山路段封闭施工的通告',
 '<p>广大市民和游客朋友：</p><p>因G110国道银川至贺兰山段路面改造工程需要，自2026年7月25日至9月30日该路段将实行分段封闭施工。过往车辆请绕行G6京藏高速或西夏区城区道路。</p>',
 NULL, 1, 1, '2026-07-10 12:00:00'),

('镇北堡西部影城关于临时调整参观路线的通知',
 '<p>亲爱的游客朋友们：</p><p>因景区内部分影视布景进行年度翻新维护，7月18日至7月22日期间明清街区及部分影棚区域将暂停对外开放，其他区域正常开放。门票价格临时调整为60元/人（原价80元/人）。</p>',
 NULL, 0, 1, '2026-07-12 15:00:00'),

('2026年宁夏"塞上江南·神奇宁夏"文旅惠民消费券发放公告',
 '<p>为促进文旅消费，宁夏文旅厅联合财政厅推出2026年文旅惠民消费券，总额500万元。发放时间：7月15日至10月31日，每月1日和15日上午10:00。券面类型：景区门票满100减30、酒店住宿满300减80、特产购物满200减50。登录"宁夏智慧文旅"微信公众号或支付宝小程序领取，每人每月限领2张，先到先得。</p>',
 NULL, 1, 1, '2026-07-01 09:00:00');


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

-- -- 查询用户活动日志（按时间倒序）
-- SELECT * FROM sys_platform_log
-- WHERE user_id = ?
-- ORDER BY created_at DESC
-- LIMIT 50;

-- -- 查询某用户最近30天的活动统计
-- SELECT log_type, COUNT(*) AS cnt
-- FROM sys_platform_log
-- WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
-- GROUP BY log_type
-- ORDER BY cnt DESC;
