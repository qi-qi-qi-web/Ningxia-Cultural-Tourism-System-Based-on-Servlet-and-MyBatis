<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="Admin-Head_And_Side.jsp"%>

                <div id="hotel" class="section" style="display:none;">
                    <div class="admin-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3>民宿管理</h3>
                            <a href="admin-hotel-add.html" class="btn btn-primary btn-sm">新增民宿</a>
                        </div>
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>民宿名称</th>
                                <th>价格</th>
                                <th>位置</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>1</td>
                                <td>黄河宿集</td>
                                <td>¥580/晚</td>
                                <td>中卫市沙坡头区</td>
                                <td><span class="badge bg-success">营业中</span></td>
                                <td>
                                    <a href="admin-hotel-edit.html?id=1" class="btn btn-info btn-sm btn-action">编辑</a>
                                    <button class="btn btn-danger btn-sm btn-action">删除</button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>星空营地</td>
                                <td>¥320/晚</td>
                                <td>银川市贺兰县</td>
                                <td><span class="badge bg-success">营业中</span></td>
                                <td>
                                    <a href="admin-hotel-edit.html?id=2" class="btn btn-info btn-sm btn-action">编辑</a>
                                    <button class="btn btn-danger btn-sm btn-action">删除</button>
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
