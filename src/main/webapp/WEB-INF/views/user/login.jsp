<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 网球场地管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background: linear-gradient(135deg, #1b5e20, #388e3c);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .card {
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border: none;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: transparent; position: fixed; top: 0; width: 100%; z-index: 10;">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/static/images/tennis-icon.png" alt="" width="30" height="30" class="d-inline-block align-top">
            网球场地管理系统
        </a>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card p-4">
                    <div class="card-body">
                        <h3 class="text-center mb-4" style="color: #1b5e20;">用户登录</h3>

                        <div id="errorAlert" class="alert alert-danger d-none" role="alert"></div>

                        <form id="loginForm">
                            <div class="form-group">
                                <label for="username">用户名</label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
                            </div>
                            <div class="form-group">
                                <label for="password">密码</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
                            </div>
                            <button type="button" id="loginBtn" class="btn btn-success btn-block btn-lg">登录</button>
                        </form>

                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/user/register" style="color: #388e3c;">还没有账号？立即注册</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(function () {
            $("#loginBtn").click(function () {
                var username = $("#username").val().trim();
                var password = $("#password").val().trim();

                if (!username || !password) {
                    $("#errorAlert").text("请输入用户名和密码").removeClass("d-none");
                    return;
                }

                $.ajax({
                    url: "${pageContext.request.contextPath}/user/doLogin",
                    type: "POST",
                    data: {
                        username: username,
                        password: password
                    },
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            if (response.role === "admin") {
                                window.location.href = "${pageContext.request.contextPath}/court/admin/manage";
                            } else {
                                window.location.href = "${pageContext.request.contextPath}/";
                            }
                        } else {
                            $("#errorAlert").text(response.message || "登录失败，请检查用户名和密码").removeClass("d-none");
                        }
                    },
                    error: function () {
                        $("#errorAlert").text("网络错误，请稍后重试").removeClass("d-none");
                    }
                });
            });

            $("#loginForm").on("keypress", function (e) {
                if (e.which === 13) {
                    $("#loginBtn").click();
                }
            });
        });
    </script>
</body>
</html>
