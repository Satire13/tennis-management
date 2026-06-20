<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 网球场地管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .card {
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: none;
        }
        .section-title {
            color: #1b5e20;
            border-bottom: 2px solid #388e3c;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%@include file="../common/header.jsp"%>

    <div class="container mt-4 mb-5">
        <h4 class="section-title">
            <i class="fas fa-user-circle"></i> 个人中心
        </h4>

        <div class="row">
            <!-- Personal Info Card -->
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">个人信息</h5>
                    </div>
                    <div class="card-body">
                        <div id="profileAlert" class="alert d-none" role="alert"></div>

                        <form id="profileForm">
                            <div class="form-group">
                                <label for="username">用户名</label>
                                <input type="text" class="form-control" id="username" value="${sessionScope.loginUser.username}" readonly>
                            </div>
                            <div class="form-group">
                                <label for="realName">真实姓名</label>
                                <input type="text" class="form-control" id="realName" name="realName" value="${sessionScope.loginUser.realName}" required>
                            </div>
                            <div class="form-group">
                                <label for="email">邮箱</label>
                                <input type="email" class="form-control" id="email" name="email" value="${sessionScope.loginUser.email}" required>
                            </div>
                            <div class="form-group">
                                <label for="phone">手机号</label>
                                <input type="text" class="form-control" id="phone" name="phone" value="${sessionScope.loginUser.phone}">
                            </div>
                            <button type="button" id="saveProfileBtn" class="btn btn-success">保存修改</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Change Password Card -->
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">修改密码</h5>
                    </div>
                    <div class="card-body">
                        <div id="passwordAlert" class="alert d-none" role="alert"></div>

                        <form id="passwordForm">
                            <div class="form-group">
                                <label for="oldPassword">原密码</label>
                                <input type="password" class="form-control" id="oldPassword" name="oldPassword" placeholder="请输入原密码" required>
                            </div>
                            <div class="form-group">
                                <label for="newPassword">新密码</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="请输入新密码" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmNewPassword">确认新密码</label>
                                <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" placeholder="请再次输入新密码" required>
                            </div>
                            <button type="button" id="changePasswordBtn" class="btn btn-success">修改密码</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@include file="../common/footer.jsp"%>

    <script>
        $(function () {
            // Save profile
            $("#saveProfileBtn").click(function () {
                var realName = $("#realName").val().trim();
                var email = $("#email").val().trim();
                var phone = $("#phone").val().trim();

                $("#profileAlert").addClass("d-none");

                if (!realName || !email) {
                    $("#profileAlert").text("真实姓名和邮箱不能为空").removeClass("d-none").addClass("alert-danger");
                    return;
                }

                $.ajax({
                    url: "${pageContext.request.contextPath}/user/updateProfile",
                    type: "POST",
                    data: {
                        realName: realName,
                        email: email,
                        phone: phone
                    },
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            $("#profileAlert").text("个人信息更新成功").removeClass("d-none alert-danger").addClass("alert-success");
                        } else {
                            $("#profileAlert").text(response.message || "更新失败，请稍后重试").removeClass("d-none alert-success").addClass("alert-danger");
                        }
                    },
                    error: function () {
                        $("#profileAlert").text("网络错误，请稍后重试").removeClass("d-none").addClass("alert-danger");
                    }
                });
            });

            // Change password
            $("#changePasswordBtn").click(function () {
                var oldPassword = $("#oldPassword").val().trim();
                var newPassword = $("#newPassword").val().trim();
                var confirmNewPassword = $("#confirmNewPassword").val().trim();

                $("#passwordAlert").addClass("d-none");

                if (!oldPassword || !newPassword || !confirmNewPassword) {
                    $("#passwordAlert").text("请填写所有密码字段").removeClass("d-none").addClass("alert-danger");
                    return;
                }

                if (newPassword !== confirmNewPassword) {
                    $("#passwordAlert").text("两次输入的新密码不一致").removeClass("d-none").addClass("alert-danger");
                    return;
                }

                if (newPassword.length < 6) {
                    $("#passwordAlert").text("新密码长度不能少于6位").removeClass("d-none").addClass("alert-danger");
                    return;
                }

                $.ajax({
                    url: "${pageContext.request.contextPath}/user/updatePassword",
                    type: "POST",
                    data: {
                        oldPassword: oldPassword,
                        newPassword: newPassword
                    },
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            $("#passwordAlert").text("密码修改成功").removeClass("d-none alert-danger").addClass("alert-success");
                            $("#passwordForm")[0].reset();
                        } else {
                            $("#passwordAlert").text(response.message || "密码修改失败").removeClass("d-none alert-success").addClass("alert-danger");
                        }
                    },
                    error: function () {
                        $("#passwordAlert").text("网络错误，请稍后重试").removeClass("d-none").addClass("alert-danger");
                    }
                });
            });
        });
    </script>
</body>
</html>
