<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="Admin-Head_And_Side.jsp"%>

                <div id="strategy" class="section" style="display:none;">
                    <div class="admin-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3>攻略管理</h3>
                            <button class="btn btn-primary btn-sm">审核攻略</button>
                        </div>
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>攻略标题</th>
                                <th>作者</th>
                                <th>发布时间</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>1</td>
                                <td>宁夏三日游攻略</td>
                                <td>游客张三</td>
                                <td>2024-01-15</td>
                                <td><span class="badge bg-success">已审核</span></td>
                                <td>
                                    <button class="btn btn-info btn-sm btn-action">查看</button>
                                    <button class="btn btn-danger btn-sm btn-action">删除</button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>沙坡头游玩指南</td>
                                <td>游客李四</td>
                                <td>2024-01-16</td>
                                <td><span class="badge bg-warning">待审核</span></td>
                                <td>
                                    <button class="btn btn-success btn-sm btn-action">通过</button>
                                    <button class="btn btn-danger btn-sm btn-action">拒绝</button>
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
