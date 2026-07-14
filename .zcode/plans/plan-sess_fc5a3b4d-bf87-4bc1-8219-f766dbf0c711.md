# 订单流程重构计划

## 新状态流转

```
用户下单 → PLACED(已下单) → Pay.jsp付款页 → PAID(已付款) → 管理员发货 → SHIPPED(已发货)
                                                                                    ↓
                                                                        用户确认收货 → RECEIVED(已收货)
                                                                              ↓                ↓
                                                                     [完成订单]        [我要退货]
                                                                         ↓                ↓
                                                              COMPLETED(已完成)   RETURNING(退货中)
                                                                                       ↓
                                                                               管理员确认退款
                                                                                       ↓
                                                                              REFUNDED(已退款)
```

超时：PLACED 状态下 5 分钟未付款 → CANCELLED(已取消)

---

## 文件变更清单（基于已修改的代码）

### 1. `Pay.jsp` — **新建** 付款页面
- 通过 URL 参数 `orderId` 加载订单信息
- 显示订单编号、商品明细、金额、取货方式、收件信息
- **5分钟倒计时**（JS setInterval，300秒）
- 倒计时归零自动调用 `/order?action=cancelByUser` 取消订单
- 支付方式选择（微信/支付宝，纯展示）
- 「确认付款」按钮 → `/order?action=pay` → PLACED→PAID
- 付款成功后跳转 `personalCenter#orders`

### 2. `OrderMapper.java` — 追加方法
- `int payOrder(@Param("id") Long id)` — PLACED→PAID，设置 paid_at
- `int cancelByUser(@Param("id") Long id)` — PLACED→CANCELLED
- `int confirmRefund(@Param("id") Long id)` — RETURNING→REFUNDED

### 3. `OrderMapper.xml` — 追加 SQL
```xml
<update id="payOrder">
    UPDATE order_main SET status='PAID', paid_at=NOW() WHERE id=#{id} AND status='PLACED'
</update>
<update id="cancelByUser">
    UPDATE order_main SET status='CANCELLED' WHERE id=#{id} AND status='PLACED'
</update>
<update id="confirmRefund">
    UPDATE order_main SET status='REFUNDED', completed_at=NOW() WHERE id=#{id} AND status='RETURNING'
</update>
```
- `confirmReceipt`: 守卫条件改为 `status='SHIPPED'`

### 4. `OrderServlet.java` — 重写
- **POST（创建订单）**：返回 `{success, orderId}`，前端用 orderId 跳转 Pay.jsp
- **GET action=pay**：调用 payOrder，PLACED→PAID
- **GET action=cancelByUser**：调用 cancelByUser，PLACED→CANCELLED
- **GET action=confirmReceipt**：守卫改为 SHIPPED，SHIPPED→RECEIVED
- **GET action=requestReturn**：RECEIVED→RETURNING（不变）
- **GET/POST action=completeWithComment**：RECEIVED→COMPLETED（不变）

### 5. `AdminOrderServlet.java` — 修改
- `executeAction` 中：
  - `case "ship"`：PAID→SHIPPED（已有，不变）
  - `case "confirmRefund"`：RETURNING→REFUNDED（替代原来的 confirmReturn→COMPLETED）

### 6. `Specialty-detail.jsp` — 修改 submitOrder
- AJAX 成功后解析 `resp.orderId`
- 跳转 `window.location.href = 'Pay.jsp?orderId=' + resp.orderId;`

### 7. `PersonalCenter.jsp` — 重写订单渲染和交互

**状态 → UI 按钮映射：**

| 状态 | 按钮 |
|------|------|
| PLACED | `[去付款]` → 跳转 Pay.jsp?orderId=X |
| PAID | 「等待卖家发货」 |
| SHIPPED | `[确认收货]` |
| RECEIVED | `[评价商品]` `[申请退货]` |
| RETURNING | 「退货处理中，等待管理员确认」 |
| COMPLETED | ✅ 已完成 |
| REFUNDED | ↩ 已退款 |
| CANCELLED | ✕ 已取消 |

**确认收货弹窗（SHIPPED→RECEIVED 后）：**
- 「已确认收货！感谢您的购买」
- `[完成订单]` → 打开评价弹窗（评分 + 文字 + `[提交评价]` / `[算了吧]`）→ COMPLETED
- `[我要退货]` → 打开退货原因弹窗 → RETURNING

### 8. `Admin-order.jsp` — 更新状态 + 按钮

| 状态 | Badge | 操作按钮 |
|------|-------|----------|
| PLACED | 黄色「已下单」 | `[取消]` |
| PAID | 蓝色「已付款」 | `[发货]` |
| SHIPPED | 蓝色「已发货」| — |
| RECEIVED | 青色「已收货」| — |
| RETURNING | 红色「退货中」| `[确认退款]` |
| COMPLETED | 绿色「已完成」| — |
| REFUNDED | 灰色「已退款」| — |
| CANCELLED | 红色「已取消」| — |

### 9. `Admin-Head_And_Side.jsp` — 添加「返回前台」
- 在 header 栏右侧（"欢迎管理员"旁边）添加按钮
- 链接到 `index.jsp`

### 10. `OrderServlet.java` — 补充
- 创建订单返回时带上 orderId：
```java
sendJson(response, true, "下单成功", order.getId());
```
- 修改 sendJson 方法签名支持 orderId

---

## 需要修改的文件汇总

| 操作 | 文件 |
|------|------|
| **新建** | `web/Pay.jsp` |
| **修改** | `OrderMapper.java`（+payOrder, cancelByUser, confirmRefund） |
| **修改** | `OrderMapper.xml`（+SQL，改confirmReceipt守卫） |
| **修改** | `OrderServlet.java`（+pay/cancelByUser，返回orderId，改confirmReceipt守卫） |
| **修改** | `AdminOrderServlet.java`（confirmRefund替代confirmReturn） |
| **修改** | `Specialty-detail.jsp`（成功后跳转Pay.jsp） |
| **修改** | `PersonalCenter.jsp`（新状态流程+弹窗逻辑） |
| **修改** | `Admin-order.jsp`（新状态显示+按钮） |
| **修改** | `Admin-Head_And_Side.jsp`（+返回前台按钮） |