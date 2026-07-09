<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="Admin-Head_And_Side.jsp"%>

<!-- 用户管理内容 -->
                <div id="users" class="section" style="display:block;">
                    <div class="admin-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3>用户管理</h3>
                        </div>
                        <table class="table table-striped">
                            <thead>
                            <tr>
                                <th class="text-center">ID</th>
                                <th class="text-center">账号</th>
                                <th class="text-center">昵称</th>
                                <th class="text-center">邮箱</th>
                                <th class="text-center">手机号</th>
                                <th class="text-center">账号状态(正常&禁止发表)</th>
                                <th class="text-center">用户注册时间</th>
                                <th class="text-center">信息更新时间</th>
                                <th class="text-center">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td class="text-center">1</td>
                                <td class="text-center">000001</td>
                                <td class="text-center">三儿</td>
                                <td class="text-center">345234544@qq.com</td>
                                <td class="text-center">13844321234</td>
                                <td class="text-center"><span class="badge bg-success">正常</span></td>
                                <td class="text-center">2024-01-15</td>
                                <td class="text-center">2026-07-09</td>
                                <td>
                                    <button class="btn btn-info btn-sm btn-action">禁用</button>
                                    <button class="btn btn-danger btn-sm btn-action">删除</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">2</td>
                                <td class="text-center">000002</td>
                                <td class="text-center">李四儿</td>
                                <td class="text-center">1314920660@qq.com</td>
                                <td class="text-center">13956605678</td>
                                <td class="text-center"><span class="badge bg-danger">禁止发表</span></td>
                                <td class="text-center">2024-01-16</td>
                                <td class="text-center">2026-07-09</td>

                                <td>
                                    <button class="btn btn-info btn-sm btn-action">禁用</button>
                                    <button class="btn btn-danger btn-sm btn-action">删除</button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
<!-- 结束：用户管理内容 -->
            </div>
        </div>
    </div>
</body>
</html>