
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="Admin-Head_And_Side.jsp"%>

                <div id="orders" class="section" style="display:none;">
                    <div class="admin-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3>订单管理</h3>
                            <button class="btn btn-primary btn-sm">统计报表</button>
                        </div>
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>订单号</th>
                                <th>用户</th>
                                <th>类型</th>
                                <th>金额</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>ORD20240115001</td>
                                <td>游客张三</td>
                                <td>景区门票</td>
                                <td>¥60</td>
                                <td><span class="badge bg-success">已完成</span></td>
                                <td>
                                    <button class="btn btn-info btn-sm btn-action">详情</button>
                                </td>
                            </tr>
                            <tr>
                                <td>ORD20240116002</td>
                                <td>游客李四</td>
                                <td>民宿预订</td>
                                <td>¥580</td>
                                <td><span class="badge bg-warning">待支付</span></td>
                                <td>
                                    <button class="btn btn-info btn-sm btn-action">详情</button>
                                    <button class="btn btn-danger btn-sm btn-action">取消</button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                </div>
            </div>
        </div>
</body>
</html>