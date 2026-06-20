<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 网球场地管理系统</title>
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
            <div class="col-md-8 col-lg-6">
                <div class="card p-4">
                    <div class="card-body">
                        <h3 class="text-center mb-4" style="color: #1b5e20;">用户注册</h3>

                        <div id="errorAlert" class="alert alert-danger d-none" role="alert"></div>
                        <div id="successAlert" class="alert alert-success d-none" role="alert"></div>

                        <form id="registerForm">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="username">用户名 <span style="color: red;">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="realName">真实姓名 <span style="color: red;">*</span></label>
                                    <input type="text" class="form-control" id="realName" name="realName" placeholder="请输入真实姓名" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="password">密码 <span style="color: red;">*</span></label>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="confirmPassword">确认密码 <span style="color: red;">*</span></label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="请再次输入密码" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="email">邮箱 <span style="color: red;">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" placeholder="请输入邮箱" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="phone">手机号</label>
                                    <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入手机号">
                                </div>
                            </div>
                            <button type="button" id="registerBtn" class="btn btn-success btn-block btn-lg">注册</button>
                        </form>

                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/user/login" style="color: #388e3c;">已有账号？立即登录</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(function () {
            $("#registerBtn").click(function () {
                var username = $("#username").val().trim();
                var password = $("#password").val().trim();
                var confirmPassword = $("#confirmPassword").val().trim();
                var realName = $("#realName").val().trim();
                var email = $("#email").val().trim();
                var phone = $("#phone").val().trim();

                $("#errorAlert").addClass("d-none");
                $("#successAlert").addClass("d-none");

                if (!username || !password || !confirmPassword || !realName || !email) {
                    $("#errorAlert").text("请填写所有必填字段").removeClass("d-none");
                    return;
                }

                if (password !== confirmPassword) {
                    $("#errorAlert").text("两次输入的密码不一致").removeClass("d-none");
                    return;
                }

                if (password.length < 6) {
                    $("#errorAlert").text("密码长度不能少于6位").removeClass("d-none");
                    return;
                }

                $.ajax({
                    url: "${pageContext.request.contextPath}/user/doRegister",
                    type: "POST",
                    data: {
                        username: username,
                        password: password,
                        realName: realName,
                        email: email,
                        phone: phone
                    },
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            $("#successAlert").text("注册成功！即将跳转到登录页面...").removeClass("d-none");
                            $("#registerBtn").prop("disabled", true);
                            setTimeout(function () {
                                window.location.href = "${pageContext.request.contextPath}/user/login";
                            }, 2000);
                        } else {
                            $("#errorAlert").text(response.message || "注册失败，请稍后重试").removeClass("d-none");
                        }
                    },
                    error: function () {
                        $("#errorAlert").text("网络错误，请稍后重试").removeClass("d-none");
                    }
                });
            });

            $("#registerForm").on("keypress", function (e) {
                if (e.which === 13) {
                    $("#registerBtn").click();
                }
            });
        });
    </script>
</body>
</html>
