<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>赛事详情 - 网球通</title>
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
        .detail-card { border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp"/>
<div class="page-header">
    <div class="container">
        <h2 class="mb-1 tennis-green">赛事详情</h2>
        <p class="text-muted mb-0"><a href="${pageContext.request.contextPath}/event/list">返回赛事列表</a></p>
    </div>
</div>
<div class="container mb-5">
    <div class="card detail-card">
        <div class="card-header d-flex justify-content-between align-items-center" style="background:linear-gradient(135deg,#2e7d32,#4caf50);color:#fff;border-radius:12px 12px 0 0;">
            <h3 class="mb-0">${event.title}</h3>
            <c:choose>
                <c:when test="${event.status == 'upcoming'}"><span class="badge badge-light" style="font-size:1rem;">即将开始</span></c:when>
                <c:when test="${event.status == 'ongoing'}"><span class="badge badge-success" style="font-size:1rem;">进行中</span></c:when>
                <c:when test="${event.status == 'finished'}"><span class="badge badge-secondary" style="font-size:1rem;">已结束</span></c:when>
                <c:when test="${event.status == 'cancelled'}"><span class="badge badge-danger" style="font-size:1rem;">已取消</span></c:when>
            </c:choose>
        </div>
        <div class="card-body">
            <table class="table table-borderless">
                <tr><td style="width:120px;"><strong>日期</strong></td><td>${event.eventDate}</td></tr>
                <tr><td><strong>时间</strong></td><td>${event.startTime} - ${event.endTime}</td></tr>
                <tr><td><strong>地点</strong></td><td>${event.location}</td></tr>
                <tr><td><strong>发布者</strong></td><td>${event.creatorName}</td></tr>
                <tr><td><strong>描述</strong></td><td>${event.description}</td></tr>
                <tr><td><strong>参赛人数</strong></td><td>${event.enrolledCount}/${event.maxPlayers}<c:if test="${event.enrolledCount >= event.maxPlayers}"><span class="badge badge-warning ml-2">已满员</span></c:if></td></tr>
            </table>
            <div class="mb-3">
                <c:set var="percent" value="${event.enrolledCount / event.maxPlayers * 100}"/>
                <div class="progress" style="height:24px;">
                    <div class="progress-bar <c:choose><c:when test="${percent >= 100}">bg-danger</c:when><c:when test="${percent >= 80}">bg-warning</c:when><c:otherwise>bg-success</c:otherwise></c:choose>" role="progressbar" style="width:${percent}%;"><fmt:formatNumber value="${percent}" maxFractionDigits="0"/>%</div>
                </div>
            </div>
            <div class="mt-4">
                <c:choose>
                    <c:when test="${enrolled == false && event.status == 'upcoming' && event.enrolledCount < event.maxPlayers}"><button id="enrollBtn" class="btn btn-tennis btn-lg" onclick="enrollEvent(${event.id})">立即报名</button></c:when>
                    <c:when test="${enrolled == true}"><button id="cancelBtn" class="btn btn-danger btn-lg" onclick="cancelEnroll(${event.id})">取消报名</button></c:when>
                    <c:when test="${event.enrolledCount >= event.maxPlayers}"><button class="btn btn-secondary btn-lg" disabled>已满员</button></c:when>
                    <c:otherwise><button class="btn btn-secondary btn-lg" disabled>不可报名</button></c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/event/list" class="btn btn-outline-secondary btn-lg ml-2">返回列表</a>
            </div>
            <div id="messageArea" class="mt-3"></div>
        </div>
    </div>
</div>
<jsp:include page="../common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function enrollEvent(eventId) {
    var btn = document.getElementById('enrollBtn');
    btn.disabled = true; btn.textContent = '处理中...';
    $.ajax({
        type: 'POST', url: '${pageContext.request.contextPath}/event/enroll', data: { eventId: eventId }, dataType: 'json',
        success: function(r) {
            if (r.success) { $('#messageArea').html('<div class="alert alert-success">报名成功！</div>'); setTimeout(function(){location.reload();},1500); }
            else { $('#messageArea').html('<div class="alert alert-danger">'+(r.message||'报名失败')+'</div>'); btn.disabled=false; btn.textContent='立即报名'; }
        },
        error: function() { $('#messageArea').html('<div class="alert alert-danger">网络错误</div>'); btn.disabled=false; btn.textContent='立即报名'; }
    });
}
function cancelEnroll(eventId) {
    if (!confirm('确定要取消报名吗？')) return;
    var btn = document.getElementById('cancelBtn');
    btn.disabled = true; btn.textContent = '处理中...';
    $.ajax({
        type: 'POST', url: '${pageContext.request.contextPath}/event/cancelEnroll', data: { eventId: eventId }, dataType: 'json',
        success: function(r) {
            if (r.success) { $('#messageArea').html('<div class="alert alert-success">已取消报名</div>'); setTimeout(function(){location.reload();},1500); }
            else { $('#messageArea').html('<div class="alert alert-danger">'+(r.message||'取消失败')+'</div>'); btn.disabled=false; btn.textContent='取消报名'; }
        },
        error: function() { $('#messageArea').html('<div class="alert alert-danger">网络错误</div>'); btn.disabled=false; btn.textContent='取消报名'; }
    });
}
</script>
</body>
</html>
