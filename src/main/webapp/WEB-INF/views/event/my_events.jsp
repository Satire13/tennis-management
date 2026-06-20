<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的赛事 - 网球通</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .tennis-green { color: #2e7d32; }
        .page-header {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 28px 0; margin-bottom: 32px;
            border-radius: 0 0 16px 16px;
        }
        .btn-tennis { background-color: #2e7d32; border-color: #2e7d32; color: #fff; }
        .btn-tennis:hover { background-color: #1b5e20; border-color: #1b5e20; color: #fff; }
        .table-container { border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
        .table th { border-top: none; background-color: #f1f8e9; }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp"/>
<div class="page-header">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="mb-1 tennis-green">我的赛事</h2>
                <p class="text-muted mb-0">查看已报名的校园网球赛事</p>
            </div>
            <a href="${pageContext.request.contextPath}/event/list" class="btn btn-tennis">浏览赛事</a>
        </div>
    </div>
</div>
<div class="container mb-5">
    <c:if test="${empty enrollments}">
        <div class="text-center py-5">
            <p class="text-muted mb-3">暂未报名任何赛事</p>
            <a href="${pageContext.request.contextPath}/event/list" class="btn btn-tennis">浏览赛事并报名</a>
        </div>
    </c:if>
    <c:if test="${not empty enrollments}">
        <div class="table-container">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>赛事名称</th>
                            <th>日期</th>
                            <th>地点</th>
                            <th>报名时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="enrollment" items="${enrollments}">
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/event/detail?id=${enrollment.eventId}">${enrollment.eventTitle}</a></td>
                                <td>${enrollment.eventDate}</td>
                                <td>${enrollment.eventLocation}</td>
                                <td>${enrollment.enrollTime}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${enrollment.status == 'enrolled'}"><span class="badge badge-success">已报名</span></c:when>
                                        <c:when test="${enrollment.status == 'cancelled'}"><span class="badge badge-secondary">已取消</span></c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${enrollment.status == 'enrolled'}">
                                        <button class="btn btn-danger btn-sm" onclick="cancelEnroll(${enrollment.eventId}, this)">取消报名</button>
                                    </c:if>
                                    <c:if test="${enrollment.status == 'cancelled'}"><span class="text-muted">--</span></c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>
    <div id="messageArea"></div>
</div>
<jsp:include page="../common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function cancelEnroll(eventId, btn) {
    if (!confirm('确定要取消报名吗？')) return;
    var originalText = btn.textContent;
    btn.disabled = true; btn.textContent = '处理中...';
    $.ajax({
        type: 'POST', url: '${pageContext.request.contextPath}/event/cancelEnroll', data: { eventId: eventId }, dataType: 'json',
        success: function(r) {
            if (r.success) {
                $('#messageArea').html('<div class="alert alert-success mt-3">已取消报名</div>');
                $(btn).closest('tr').find('td:eq(4)').html('<span class="badge badge-secondary">已取消</span>');
                $(btn).closest('td').html('<span class="text-muted">--</span>');
            } else {
                $('#messageArea').html('<div class="alert alert-danger mt-3">'+(r.message||'取消失败')+'</div>');
                btn.disabled=false; btn.textContent=originalText;
            }
        },
        error: function() {
            $('#messageArea').html('<div class="alert alert-danger mt-3">网络错误</div>');
            btn.disabled=false; btn.textContent=originalText;
        }
    });
}
</script>
</body>
</html>
