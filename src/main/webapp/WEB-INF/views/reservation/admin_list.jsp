<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约管理 - 网球通</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .tennis-green { color: #2e7d32; }
        .page-header {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 28px 0;
            margin-bottom: 32px;
            border-radius: 0 0 16px 16px;
        }
        .table th { border-top: none; background-color: #f1f8e9; }
        .badge-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .filter-card {
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .table-container {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }
        .btn-tennis {
            background-color: #2e7d32; border-color: #2e7d32; color: #fff;
        }
        .btn-tennis:hover {
            background-color: #1b5e20; border-color: #1b5e20; color: #fff;
        }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="mb-1 tennis-green">预约管理</h2>
        <p class="text-muted mb-0">查看和管理所有用户的场地预约记录
            <a href="${pageContext.request.contextPath}/reservation/admin/board" class="btn btn-sm btn-tennis ml-3">看板模式</a>
        </p>
    </div>
</div>

<div class="container mb-5">
    <!-- Filter Card -->
    <div class="card filter-card mb-4">
        <div class="card-body">
            <form class="form-inline" id="filterForm" method="get" action="${pageContext.request.contextPath}/reservation/admin/list">
                <div class="form-group mr-3 mb-2 mb-sm-0">
                    <label for="filterDate" class="mr-2">日期</label>
                    <input type="date" class="form-control form-control-sm" id="filterDate" name="date" value="${param.date}">
                </div>
                <div class="form-group mr-3 mb-2 mb-sm-0">
                    <label for="filterStatus" class="mr-2">状态</label>
                    <select class="form-control form-control-sm" id="filterStatus" name="status">
                        <option value="">全部</option>
                        <option value="confirmed" ${param.status == 'confirmed' ? 'selected' : ''}>已确认</option>
                        <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>已完成</option>
                        <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>已取消</option>
                        <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>待确认</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-sm btn-tennis mr-2">筛选</button>
                <a href="${pageContext.request.contextPath}/reservation/admin/list" class="btn btn-sm btn-outline-secondary">重置</a>
            </form>
        </div>
    </div>

    <!-- Reservations Table -->
    <div class="table-container">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>用户</th>
                        <th>场地</th>
                        <th>日期</th>
                        <th>时间</th>
                        <th>状态</th>
                        <th>预约时间</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty reservations}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">暂无预约记录</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${reservations}">
                                <tr>
                                    <td>${r.id}</td>
                                    <td>${r.username}</td>
                                    <td>${r.courtName}</td>
                                    <td>${r.reserveDate}</td>
                                    <td>${r.startTime} - ${r.endTime}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'confirmed' || r.status == 'CONFIRMED'}">
                                                <span class="badge-status" style="background-color:#2196f3;color:#fff;">已确认</span>
                                            </c:when>
                                            <c:when test="${r.status == 'completed' || r.status == 'COMPLETED'}">
                                                <span class="badge-status" style="background-color:#4caf50;color:#fff;">已完成</span>
                                            </c:when>
                                            <c:when test="${r.status == 'cancelled' || r.status == 'CANCELLED'}">
                                                <span class="badge-status" style="background-color:#9e9e9e;color:#fff;">已取消</span>
                                            </c:when>
                                            <c:when test="${r.status == 'pending' || r.status == 'PENDING'}">
                                                <span class="badge-status" style="background-color:#ff9800;color:#fff;">待确认</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status" style="background-color:#9e9e9e;color:#fff;">${r.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${r.createTime}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
