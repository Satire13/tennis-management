<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>报名列表 - 网球通</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .tennis-green { color: #2e7d32; }
        .page-header {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 28px 0; margin-bottom: 32px;
            border-radius: 0 0 16px 16px;
        }
        .table th { border-top: none; background-color: #f1f8e9; }
        .table-container { border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp"/>
<div class="page-header">
    <div class="container">
        <h2 class="mb-1 tennis-green">报名列表 - ${event.title}</h2>
        <p class="text-muted mb-0">
            日期：${event.eventDate} | 地点：${event.location} | 报名人数：${event.enrolledCount}/${event.maxPlayers}
            <c:if test="${event.enrolledCount >= event.maxPlayers}"><span class="badge badge-warning ml-2">已满员</span></c:if>
            &nbsp; <a href="${pageContext.request.contextPath}/event/admin/manage">返回赛事管理</a>
        </p>
    </div>
</div>
<div class="container mb-5">
    <c:if test="${empty enrollments}">
        <div class="text-center py-5"><p class="text-muted">暂无报名记录</p></div>
    </c:if>
    <c:if test="${not empty enrollments}">
        <div class="table-container">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr><th>ID</th><th>用户名</th><th>真实姓名</th><th>报名时间</th><th>状态</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="enrollment" items="${enrollments}">
                            <tr>
                                <td>${enrollment.id}</td>
                                <td>${enrollment.username}</td>
                                <td>${enrollment.realName}</td>
                                <td>${enrollment.enrollTime}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${enrollment.status == 'enrolled'}"><span class="badge badge-success">已报名</span></c:when>
                                        <c:when test="${enrollment.status == 'cancelled'}"><span class="badge badge-secondary">已取消</span></c:when>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <p class="text-muted mt-2">共 ${enrollments.size()} 条记录</p>
    </c:if>
</div>
<jsp:include page="../common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
