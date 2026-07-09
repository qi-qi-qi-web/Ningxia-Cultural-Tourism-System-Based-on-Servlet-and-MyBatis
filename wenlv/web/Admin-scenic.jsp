<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="Admin-Head_And_Side.jsp"%>

<!-- 景区管理内容 -->
                    <div id="scenic" class="section" style="display:block;">
                        <div class="admin-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h3>景区管理</h3>
                                <a href="admin-scenic-add.html" class="btn btn-primary btn-sm">新增景区</a>
                            </div>
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>景区名称</th>
                                    <th>门票价格</th>
                                    <th>地址</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>沙湖旅游区</td>
                                    <td>¥60</td>
                                    <td>石嘴山市平罗县</td>
                                    <td><span class="badge bg-success">上架</span></td>
                                    <td>
                                        <a href="admin-scenic-edit.html?id=1" class="btn btn-info btn-sm btn-action">编辑</a>
                                        <button class="btn btn-warning btn-sm btn-action">下架</button>
                                        <button class="btn btn-danger btn-sm btn-action">删除</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>镇北堡西部影城</td>
                                    <td>¥80</td>
                                    <td>银川市西夏区</td>
                                    <td><span class="badge bg-success">上架</span></td>
                                    <td>
                                        <a href="admin-scenic-edit.html?id=2" class="btn btn-info btn-sm btn-action">编辑</a>
                                        <button class="btn btn-warning btn-sm btn-action">下架</button>
                                        <button class="btn btn-danger btn-sm btn-action">删除</button>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
<!-- 结束：景区管理内容 -->
            </div>
        </div>
    </div>
</body>
</html>