<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的预约 - 网球通</title>
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
        .table th { border-top: none; background-color: #f1f8e9; }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state svg {
            display: block;
            margin: 0 auto 16px;
        }
        .badge-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="mb-1 tennis-green">我的预约</h2>
        <p class="text-muted mb-0">查看和管理您的场地预约记录</p>
    </div>
</div>

<div class="container mb-5">
    <c:choose>
        <c:when test="${empty reservations}">
            <div class="card shadow-sm">
                <div class="card-body empty-state">
                    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="1.5">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                        <line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/>
                        <line x1="3" y1="10" x2="21" y2="10"/>
                    </svg>
                    <h5 class="text-muted">暂无预约记录</h5>
                    <p class="text-muted mb-3">您还没有任何场地预约，快去预约场地吧！</p>
                    <a href="${pageContext.request.contextPath}/court/list" class="btn btn-tennis">查看场地</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>场地</th>
                                    <th>日期</th>
                                    <th>时间</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="reservation" items="${reservations}">
                                    <tr>
                                        <td>${reservation.courtName}</td>
                                        <td>${reservation.reserveDate}</td>
                                        <td>${reservation.startTime} - ${reservation.endTime}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reservation.status == 'confirmed' || reservation.status == 'CONFIRMED'}">
                                                    <span class="badge-status" style="background-color:#2196f3;color:#fff;">已确认</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'completed' || reservation.status == 'COMPLETED'}">
                                                    <span class="badge-status" style="background-color:#4caf50;color:#fff;">已完成</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'cancelled' || reservation.status == 'CANCELLED'}">
                                                    <span class="badge-status" style="background-color:#9e9e9e;color:#fff;">已取消</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'pending' || reservation.status == 'PENDING'}">
                                                    <span class="badge-status" style="background-color:#ff9800;color:#fff;">待确认</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-status" style="background-color:#9e9e9e;color:#fff;">${reservation.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${reservation.status == 'confirmed' || reservation.status == 'CONFIRMED'}">
                                                <button class="btn btn-sm btn-outline-danger mr-1" onclick="cancelReservation(${reservation.id})">取消</button>
                                                <button class="btn btn-sm btn-outline-success" onclick="completeReservation(${reservation.id})">标记完成</button>
                                            </c:if>
                                            <c:if test="${reservation.status == 'completed' || reservation.status == 'COMPLETED'}">
                                                <a href="${pageContext.request.contextPath}/review/write?reservationId=${reservation.id}" class="btn btn-sm btn-tennis">评价</a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
var contextPath = '${pageContext.request.contextPath}';

function cancelReservation(id) {
    if (!confirm('确定要取消该预约吗？')) {
        return;
    }
    $.ajax({
        type: 'POST',
        url: contextPath + '/reservation/cancel',
        data: { id: id },
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                location.reload();
            } else {
                alert(resp.message || '取消失败，请重试');
            }
        },
        error: function() {
            alert('网络错误，请重试');
        }
    });
}

function completeReservation(id) {
    if (!confirm('确认该预约已完成？标记完成后即可对该场地进行评价。')) {
        return;
    }
    $.ajax({
        type: 'POST',
        url: contextPath + '/reservation/complete',
        data: { id: id },
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                alert(resp.message || '操作成功');
                location.reload();
            } else {
                alert(resp.message || '操作失败，请重试');
            }
        },
        error: function() {
            alert('网络错误，请重试');
        }
    });
}
</script>

</body>
</html>
