## 修改计划：Specialty-detail.jsp — 增加评论按钮

### 改动位置
`Specialty-detail.jsp` 第 134-139 行（收藏按钮区域）

### 改动内容

**1. 容器 div 样式调整**
- 将 `text-align:right` 改为 `display:flex;justify-content:space-between;align-items:center`
- 使评论按钮居左、收藏按钮居右，同一行显示

**2. 新增评论按钮（居左）**
```html
<button onclick="location.href='Specialty-comment.jsp?id=${food.id}'" 
        style="background:none;border:1px solid #e0e0e0;border-radius:20px;padding:8px 20px;cursor:pointer;color:#666;font-size:14px;">
    💬 评论
</button>
```
- 样式与收藏按钮完全一致
- 点击跳转到 `Specialty-comment.jsp?id=${food.id}`（预留页面，后续实现）
- 收藏按钮保持不变，自动居右

**3. 收藏按钮不变**
- 保留现有 `toggleFavorite()` 和样式，仅因父容器改为 flex 而自然居右

### 不涉及
- 无需修改后端 Servlet
- 无需修改数据库
- 无需创建实际评论页面（仅预留跳转地址）
