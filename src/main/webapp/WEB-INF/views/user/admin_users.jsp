<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 网球通</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .tennis-green { color: #2e7d32; }
        .tennis-green-bg { background-color: #2e7d32; color: #fff; }
        .btn-tennis {
            background-color: #2e7d32; border-color: #2e7d32; color: #fff;
        }
        .btn-tennis:hover {
            background-color: #1b5e20; border-color: #1b5e20; color: #fff;
        }
        .page-header {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 28px 0;
            margin-bottom: 32px;
            border-radius: 0 0 16px 16px;
        }
        .card {
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: none;
        }
        .table th { border-top: none; background-color: #f1f8e9; }
        .badge-enabled {
            background-color: #28a745;
            color: #fff;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
        }
        .badge-disabled {
            background-color: #dc3545;
            color: #fff;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1 tennis-green"><i class="fas fa-users-cog"></i> 用户管理</h2>
                    <p class="text-muted mb-0">管理所有用户账号信息</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div id="actionAlert" class="alert d-none" role="alert"></div>

        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>用户名</th>
                                <th>真实姓名</th>
                                <th>邮箱</th>
                                <th>电话</th>
                                <th>角色</th>
                                <th>状态</th>
                                <th>创建时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="9" class="text-center text-muted py-4">暂无用户数据</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.username}</td>
                                            <td>${user.realName}</td>
                                            <td>${user.email}</td>
                                            <td>${user.phone}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.role == 'admin'}">
                                                        <span class="badge badge-dark">管理员</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-info">普通用户</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="${user.status == 1 ? 'badge-enabled' : 'badge-disabled'}">
                                                    ${user.status == 1 ? '正常' : '禁用'}
                                                </span>
                                            </td>
                                            <td>${user.createTime}</td>
                                            <td>
                                                <button class="btn btn-sm ${user.status == 1 ? 'btn-warning' : 'btn-success'} toggleStatusBtn"
                                                        data-user-id="${user.id}"
                                                        data-current-status="${user.status}">
                                                    ${user.status == 1 ? '禁用' : '启用'}
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(function () {
            $(".toggleStatusBtn").click(function () {
                var btn = $(this);
                var userId = btn.data("user-id");
                var currentStatus = btn.data("current-status");
                var actionText = currentStatus == 1 ? "禁用" : "启用";

                if (!confirm("确定要" + actionText + "该用户吗？")) {
                    return;
                }

                $.ajax({
                    url: "${pageContext.request.contextPath}/user/admin/toggleStatus",
                    type: "POST",
                    data: {
                        userId: userId
                    },
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            $("#actionAlert").text("操作成功").removeClass("d-none alert-danger").addClass("alert-success");
                            setTimeout(function () {
                                location.reload();
                            }, 800);
                        } else {
                            $("#actionAlert").text(response.message || "操作失败").removeClass("d-none alert-success").addClass("alert-danger");
                        }
                    },
                    error: function () {
                        $("#actionAlert").text("网络错误，请稍后重试").removeClass("d-none").addClass("alert-danger");
                    }
                });
            });
        });
    </script>
</body>
</html>
