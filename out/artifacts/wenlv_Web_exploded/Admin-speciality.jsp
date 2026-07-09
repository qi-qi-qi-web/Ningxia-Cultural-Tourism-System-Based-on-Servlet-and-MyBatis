
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="Admin-Head_And_Side.jsp"%>

                <div id="food" class="section" style="display:none;">
                    <div class="admin-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3>美食管理</h3>
                            <a href="admin-food-add.html" class="btn btn-primary btn-sm">新增美食</a>
                        </div>
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>美食名称</th>
                                <th>分类</th>
                                <th>产地</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>1</td>
                                <td>手抓羊肉</td>
                                <td>肉类</td>
                                <td>盐池县</td>
                                <td>
                                    <a href="admin-food-edit.html?id=1" class="btn btn-info btn-sm btn-action">编辑</a>
                                    <button class="btn btn-danger btn-sm btn-action">删除</button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>八宝茶</td>
                                <td>饮品</td>
                                <td>宁夏各地</td>
                                <td>
                                    <a href="admin-food-edit.html?id=2" class="btn btn-info btn-sm btn-action">编辑</a>
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
