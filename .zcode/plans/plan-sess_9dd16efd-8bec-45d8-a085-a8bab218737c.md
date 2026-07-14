# 攻略标签系统改造计划

## 一、数据库

### 新建 `guide_tag` 表
```sql
CREATE TABLE guide_tag (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    category ENUM('FEATURE','TIME','AUDIENCE','BUDGET') NOT NULL,
    sort_order INT DEFAULT 0
);
```

### 初始标签数据（4类 × 8个 = 32个标签）

| 特点 FEATURE | 时间 TIME | 适合人群 AUDIENCE | 预算 BUDGET |
|-------------|----------|-----------------|------------|
| 自然风光 | 1日游 | 亲子 | 穷游 |
| 历史文化 | 2天1晚 | 情侣 | 经济实惠 |
| 美食之旅 | 3天2晚 | 学生党 | 中等预算 |
| 摄影打卡 | 5天4晚 | 家庭出游 | 豪华体验 |
| 户外探险 | 春季 | 独自旅行 | 性价比高 |
| 网红打卡 | 夏季 | 朋友结伴 | 精致小资 |
| 古镇风情 | 秋季 | 摄影爱好者 | 丰俭由人 |
| 民俗体验 | 冬季 | 美食爱好者 | 不差钱 |

---

## 二、后端

### 新建 POJO
- `GuideTag.java` — id, name, category, sortOrder

### 新建 Mapper
- `GuideTagMapper.java` — findAll, findByCategory, insert, update, delete
- `GuideTagMapper.xml`

### 新建 Admin Servlet
- `AdminGuideTagServlet.java` (`@WebServlet("/admin/guideTag")`)
  - GET: 加载所有标签 → forward 到 Admin-guideTag.jsp
  - POST action=save: 新增/编辑标签
  - GET action=delete: 删除标签
  - GET action=list: 返回 JSON（供前端 AJAX 获取可选标签）

---

## 三、前端

### 新建管理员标签管理页
- `Admin-guideTag.jsp` — 四列表格，分类显示，可新增/编辑/删除

### 修改标签输入方式（3个页面）
- **TravelGuide.jsp** 发布弹窗 — 移除标签文本框和简介文本框，替换为 4 组标签选择区（点击选中/取消）
- **PersonalCenter.jsp** 发布弹窗 — 同上
- **Admin-strategy.jsp** 编辑弹窗 — 同上

### 标签选择 UI 设计
```
┌─ 特点 ─────────────────────────┐
│ [自然风光] [历史文化] [美食之旅] [摄影打卡] │
│ [户外探险] [网红打卡] [古镇风情] [民俗体验] │
└────────────────────────────────┘
┌─ 时间 ─────────────────────────┐
│ [1日游] [2天1晚] [3天2晚] [5天4晚]      │
│ [春季] [夏季] [秋季] [冬季]              │
└────────────────────────────────┘
...
（选中标签高亮为绿色）
```

### 修改 TravelGuide-detail.jsp
- 移除"攻略简介"拆分逻辑，完整显示 content

### 修改 TravelGuide.jsp 列表
- 标签显示保持不变（仍从 `tags` 字段逗号分隔渲染）

---

## 四、移除攻略简介

- TravelGuide.jsp: 发布弹窗删除"攻略简介"输入框，只保留"攻略详情"
- PersonalCenter.jsp: 同上
- Admin-strategy.jsp: 同上
- GuideServlet.java: `handlePublish()` 中 content 不再拼接 intro
- TravelGuide-detail.jsp: 移除 intro/detail 拆分逻辑

---

## 五、文件变更清单

| 文件 | 操作 |
|------|------|
| `sql/guide_tag.sql` | 新建 |
| `GuideTag.java` | 新建 |
| `GuideTagMapper.java` | 新建 |
| `GuideTagMapper.xml` | 新建 |
| `AdminGuideTagServlet.java` | 新建 |
| `Admin-guideTag.jsp` | 新建 |
| `Admin-Head_And_Side.jsp` | 修改：添加导航链接 |
| `TravelGuide.jsp` | 修改：移除简介 + 标签选择UI |
| `TravelGuide-detail.jsp` | 修改：移除简介拆分 |
| `PersonalCenter.jsp` | 修改：移除简介 + 标签选择UI |
| `Admin-strategy.jsp` | 修改：移除简介 + 标签选择UI |
| `GuideServlet.java` | 修改：不再拼接intro |
