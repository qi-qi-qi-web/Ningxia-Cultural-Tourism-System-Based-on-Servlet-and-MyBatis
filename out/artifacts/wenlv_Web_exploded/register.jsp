<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta name="auto" content='homo'>
	<meta charset="UTF-8">
	<title>宁夏智慧文旅 -注册</title>
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<link rel="stylesheet" type="text/css" href="css/base.css">
    <link rel="stylesheet" type="text/css" href="css/login.css">
</head>
<body>
	<header id='header'>
		<div class='center'>
			<h1 class="logo">宁夏智慧文旅</h1>
			<nav>
				<h2 class="none">网站导航</h2>
				<ul class="link">
					<li><a href="index.jsp">首页</a></li>
					<li><a href="scenic.jsp">景区服务</a></li>
					<li><a href="food.jsp">特色美食</a></li>
					<li><a href="hotel.jsp">民宿酒店</a></li>
					<li><a href="strategy.jsp">旅游攻略</a></li>
					<li><a href="user_center.jsp">个人中心</a></li>
					<li class="active"><a href="register.jsp">注册</a></li>
				</ul>
			</nav>
		</div>
	</header>
    <script>
        function jump(){
            window.location="login.jsp";
        }
        function jump_1(){
            window.location="register.jsp";
        }
    </script>
		<div id="search">
            <div id="login">
                <div style="text-align: center;"><span id="login_header" onclick="jump()">登录</span><b>·</b><span id="login_header1" onclick="jump1()">注册</span></div>
                <form action="register" method="post">
                    <div><input class="input" placeholder="手机号" type="text" name="phone" style="margin: 0px 40 0px; border-radius: 0px 0px 0px 0px;"></div>
					<div><input class="input" placeholder="邮箱" type="email" name="email" style="margin: 0px auto 0px; border-radius: 0px 0px 0px 0px;"></div>
                    <div><input class="input" placeholder="密码" type="password" name="password" style="margin: 0px auto 0px; border-radius: 0px 0px 4px 4px;"></div>
                    <div><input class="input" placeholder="确认密码" type="password" name="confirmPassword" style="margin: 0px auto 0px; border-radius: 0px 0px 4px 4px;"></div>
                    <div style="color: red; text-align: center; margin-top: 10px;">${error}</div>
                    <div class=""><button class="button_1" type="submit" style="margin-top: 15%;">提交</button></div>
                </form>
            </div>
        </div>
</body>
</html>