# 登录注册功能实现计划

## 一、需求分析

根据 `login.html` 和 `register.html` 的表单结构分析：

### 登录表单（login.html）

* 手机号或邮箱（text）

* 密码（text）

### 注册表单（register.html）

* 手机号（text）

* 邮箱（email）

* 密码（text）

* 确认密码（text）

## 二、技术架构

* **框架**: Java Web + MyBatis 3.5.19

* **数据库**: MySQL

* **构建工具**: Maven

* **视图层**: JSP

## 三、文件结构设计

```
wenlv/
├── src/main/java/com/niit/
│   ├── pojo/
│   │   └── User.java                    # 用户实体类
│   ├── mapper/
│   │   └── UserMapper.java              # 用户数据访问接口
│   ├── servlet/
│   │   ├── LoginServlet.java            # 登录处理
│   │   └── RegisterServlet.java         # 注册处理
│   └── utils/
│       └── DBUtil.java                  # MyBatis 连接工具类
├── src/main/resources/
│   ├── jdbc.properties                  # 数据库配置
│   ├── mybatis-config.xml               # MyBatis 主配置
│   └── mapper/
│       └── UserMapper.xml               # 用户Mapper XML映射
├── web/
│   ├── login.jsp                        # 登录页面（转换自login.html）
│   └── register.jsp                     # 注册页面（转换自register.html）
└── sql/
    └── create_table.sql                 # 建表语句
```

## 四、实现步骤

### 步骤1：创建建表 SQL 文件

* 创建 `sql/create_table.sql`，包含用户表结构

### 步骤2：完善 User 实体类

* 字段：id, phone, email, password, createTime

### 步骤3：完善 DBUtil 工具类

* 实现 MyBatis SqlSessionFactory 初始化和获取方法

### 步骤4：创建 UserMapper 接口

* 方法：findByPhoneOrEmail, findByEmail, insertUser

### 步骤5：创建 UserMapper.xml 映射文件

* 编写 SQL 映射

### 步骤6：创建 LoginServlet

* 处理登录请求，验证用户

### 步骤7：创建 RegisterServlet

* 处理注册请求，验证并保存用户

### 步骤8：更新 mybatis-config.xml

* 添加属性配置和 Mapper 扫描

### 步骤9：更新 jdbc.properties

* 添加数据库连接配置

### 步骤10：转换 HTML 为 JSP

* 将 login.html → login.jsp

* 将 register.html → register.jsp

* 添加表单提交路径和错误提示

## 五、数据库配置（待用户确认）

| 配置项  | 默认值      |
| ---- | -------- |
| 数据库名 | wenlv    |
| 用户名  | root     |
| 密码   | password |
| 端口   | 3306     |

## 六、风险与注意事项

1. 密码应使用 MD5 或 BCrypt 加密存储
2. 需要处理用户名/邮箱重复的情况
3. 需要防止 SQL 注入（MyBatis 已内置保护）
4. 需要处理登录失败的错误提示

