<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>场地列表 - 网球通</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .tennis-green {
            color: #2e7d32;
        }
        .tennis-green-bg {
            background-color: #2e7d32;
            color: #fff;
        }
        .tennis-green-border {
            border-color: #2e7d32;
        }
        .court-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            height: 100%;
        }
        .court-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }
        .court-card .card-header {
            background: linear-gradient(135deg, #2e7d32, #4caf50);
            color: #fff;
            font-weight: bold;
            border-bottom: none;
        }
        .btn-tennis {
            background-color: #2e7d32;
            border-color: #2e7d32;
            color: #fff;
        }
        .btn-tennis:hover {
            background-color: #1b5e20;
            border-color: #1b5e20;
            color: #fff;
        }
        .page-header {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 28px 0;
            margin-bottom: 32px;
            border-radius: 0 0 16px 16px;
        }
        .price-tag {
            font-size: 1.3rem;
            font-weight: bold;
            color: #e65100;
        }
        .badge-available {
            background-color: #4caf50;
            color: #fff;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .badge-maintenance {
            background-color: #f44336;
            color: #fff;
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
        <h2 class="mb-1 tennis-green">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#2e7d32" stroke-width="2">
                <circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="3"/>
            </svg>
            场地列表
        </h2>
        <p class="text-muted mb-0">查看所有网球场馆信息</p>
    </div>
</div>

<!-- Court Cards -->
<div class="container mb-5">
    <c:choose>
        <c:when test="${empty courts}">
            <div class="text-center py-5">
                <p class="text-muted">暂无可预约的场地</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="court" items="${courts}">
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card court-card">
                            <div class="card-header py-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span>${court.courtName}</span>
                                    <c:choose>
                                        <c:when test="${court.status == 1}">
                                            <span class="badge-available">可用</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-maintenance">维护中</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <div class="mb-2">
                                    <small class="text-muted">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                                            <circle cx="12" cy="10" r="3"/>
                                        </svg>
                                        ${court.location}
                                    </small>
                                </div>
                                <c:if test="${not empty court.description}">
                                    <p class="card-text text-muted small flex-grow-1">${court.description}</p>
                                </c:if>
                                <c:if test="${empty court.description}">
                                    <div class="flex-grow-1"></div>
                                </c:if>
                                <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
                                    <span class="price-tag"><fmt:formatNumber value="${court.price}" pattern="#0"/> 元/小时</span>
                                    <c:choose>
                                        <c:when test="${court.status == 1}">
                                            <a href="${pageContext.request.contextPath}/reservation/book?courtId=${court.id}"
                                               class="btn btn-tennis btn-sm">
                                                立即预约
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary btn-sm" disabled>暂停预约</button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
