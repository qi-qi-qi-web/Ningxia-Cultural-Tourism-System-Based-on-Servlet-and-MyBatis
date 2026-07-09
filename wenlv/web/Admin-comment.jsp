
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="Admin-Head_And_Side.jsp"%>


                <div id="comments" class="section" style="display:none;">
                    <div class="admin-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3>评论管理</h3>
                            <button class="btn btn-primary btn-sm">批量删除</button>
                        </div>
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>用户</th>
                                <th>评论内容</th>
                                <th>关联内容</th>
                                <th>时间</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>1</td>
                                <td>游客张三</td>
                                <td>景区非常美丽，值得一去...</td>
                                <td>沙湖旅游区</td>
                                <td>2024-01-15</td>
                                <td>
                                    <button class="btn btn-danger btn-sm btn-action">删除</button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>游客李四</td>
                                <td>服务很好，下次还来</td>
                                <td>镇北堡西部影城</td>
                                <td>2024-01-16</td>
                                <td>
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
