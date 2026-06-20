<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>赛事列表 - 网球通</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .tennis-green { color: #2e7d32; }
        .page-header {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 28px 0;
            margin-bottom: 32px;
            border-radius: 0 0 16px 16px;
        }
        .event-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: transform 0.2s;
            height: 100%;
        }
        .event-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }
        .event-card .card-header {
            background: linear-gradient(135deg, #2e7d32, #4caf50);
            color: #fff;
            font-weight: bold;
            border-bottom: none;
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

<jsp:include page="../common/header.jsp"/>

<div class="page-header">
    <div class="container">
        <h2 class="mb-1 tennis-green">赛事列表</h2>
        <p class="text-muted mb-0">查看和报名校园网球赛事</p>
    </div>
</div>

<div class="container mb-5">
    <c:if test="${empty events}">
        <div class="alert alert-info text-center py-4" role="alert">暂无赛事信息</div>
    </c:if>

    <div class="row">
        <c:forEach var="event" items="${events}">
            <div class="col-lg-6 mb-4">
                <div class="card event-card">
                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                        <span>${event.title}</span>
                        <c:choose>
                            <c:when test="${event.status == 'upcoming'}"><span class="badge badge-primary">即将开始</span></c:when>
                            <c:when test="${event.status == 'ongoing'}"><span class="badge badge-success">进行中</span></c:when>
                            <c:when test="${event.status == 'finished'}"><span class="badge badge-secondary">已结束</span></c:when>
                            <c:when test="${event.status == 'cancelled'}"><span class="badge badge-danger">已取消</span></c:when>
                        </c:choose>
                    </div>
                    <div class="card-body d-flex flex-column">
                        <p class="card-text">
                            <strong>日期：</strong>${event.eventDate}<br>
                            <strong>时间：</strong>${event.startTime} - ${event.endTime}<br>
                            <strong>地点：</strong>${event.location}<br>
                        </p>
                        <p class="card-text text-muted small flex-grow-1">
                            <c:choose>
                                <c:when test="${fn:length(event.description) > 100}">${fn:substring(event.description, 0, 100)}...</c:when>
                                <c:otherwise>${event.description}</c:otherwise>
                            </c:choose>
                        </p>
                        <div class="mb-2">
                            <span>参赛人数：${event.enrolledCount}/${event.maxPlayers}</span>
                            <c:if test="${event.enrolledCount >= event.maxPlayers}">
                                <span class="badge badge-warning ml-2">已满员</span>
                            </c:if>
                        </div>
                        <div class="progress mb-3" style="height: 20px;">
                            <c:set var="percent" value="${event.enrolledCount / event.maxPlayers * 100}"/>
                            <div class="progress-bar
                                <c:choose>
                                    <c:when test="${percent >= 100}">bg-danger</c:when>
                                    <c:when test="${percent >= 80}">bg-warning</c:when>
                                    <c:otherwise>bg-success</c:otherwise>
                                </c:choose>
                            " role="progressbar" style="width: ${percent}%;" aria-valuenow="${percent}" aria-valuemin="0" aria-valuemax="100">
                                <fmt:formatNumber value="${percent}" maxFractionDigits="0"/>%
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/event/detail?id=${event.id}" class="btn btn-tennis mt-auto">查看详情</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
