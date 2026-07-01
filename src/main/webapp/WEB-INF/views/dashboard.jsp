<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>网球通 - 首页</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/favicon.ico" type="image/x-icon">
    <style>
        body {
            background-color: #f0f8f0;
        }
        .jumbotron {
            background: linear-gradient(135deg, #1b5e20, #388e3c);
            color: #fff;
            border-radius: 0.5rem;
            padding: 3rem 2rem;
        }
        .jumbotron h1 {
            font-weight: 700;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
        }
        .jumbotron p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        .card {
            border: none;
            border-radius: 0.75rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }
        .card-title {
            color: #1b5e20;
            font-weight: 600;
        }
        .card-admin {
            border-left: 4px solid #f39c12;
        }
    </style>
</head>
<body>
<%@include file="common/header.jsp"%>

<div class="container pt-4">
    <!-- Hero Section -->
    <div class="jumbotron text-center">
        <h1 class="display-4">欢迎来到网球通</h1>
        <p class="lead">高校网球场智能预约与赛事管理系统</p>
        <hr class="my-4" style="border-color: rgba(255,255,255,0.3);">
        <p>为高校师生提供便捷的网球场预约、赛事报名及个人管理一站式服务，让网球运动更加轻松有序。</p>
        <c:if test="${empty sessionScope.loginUser}">
            <a class="btn btn-light btn-lg mt-2" href="${pageContext.request.contextPath}/user/login" role="button">立即体验</a>
        </c:if>
        <c:if test="${not empty sessionScope.loginUser}">
            <a class="btn btn-light btn-lg mt-2" href="${pageContext.request.contextPath}/court/list" role="button">预约场地</a>
        </c:if>
    </div>

    <!-- Feature Cards -->
    <div class="row mt-4">
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center p-4">
                    <div style="font-size: 3rem; color: #1b5e20;">&#127934;</div>
                    <h5 class="card-title mt-3">场地预约</h5>
                    <p class="card-text text-muted">查看网球场馆信息，在线预约空闲时段</p>
                    <a href="${pageContext.request.contextPath}/court/list" class="btn btn-outline-success btn-sm">了解详情</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center p-4">
                    <div style="font-size: 2.8rem; color: #1b5e20;">
                        <svg width="48" height="48" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="24" cy="24" r="18" fill="#d4e157" stroke="#7cb342" stroke-width="2"/>
                            <path d="M10 16 Q24 28 38 16" stroke="#fff" stroke-width="2" fill="none"/>
                            <path d="M10 32 Q24 20 38 32" stroke="#fff" stroke-width="2" fill="none"/>
                        </svg>
                    </div>
                    <h5 class="card-title mt-3">赛事报名</h5>
                    <p class="card-text text-muted">参与校园网球赛事，与其他选手同台竞技</p>
                    <a href="${pageContext.request.contextPath}/event/list" class="btn btn-outline-success btn-sm">了解详情</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center p-4">
                    <div style="font-size: 3rem; color: #1b5e20;">&#128100;</div>
                    <h5 class="card-title mt-3">个人管理</h5>
                    <p class="card-text text-muted">管理个人信息，查看预约记录与赛事动态</p>
                    <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline-success btn-sm">了解详情</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Admin Card -->
    <c:if test="${sessionScope.loginUser.role eq 'admin'}">
        <div class="row mt-2 mb-4">
            <div class="col-12">
                <div class="card card-admin">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div style="font-size: 2.5rem; color: #f39c12; margin-right: 1rem;">&#9881;</div>
                            <div>
                                <h5 class="card-title mb-1" style="color: #e67e22;">管理员面板</h5>
                                <p class="card-text text-muted mb-2">管理系统资源、预约、赛事及用户信息</p>
                                <a href="${pageContext.request.contextPath}/court/admin/manage" class="btn btn-warning btn-sm mr-2">场地管理</a>
                                <a href="${pageContext.request.contextPath}/reservation/admin/list" class="btn btn-warning btn-sm mr-2">预约管理</a>
                                <a href="${pageContext.request.contextPath}/event/admin/manage" class="btn btn-warning btn-sm mr-2">赛事管理</a>
                                <a href="${pageContext.request.contextPath}/user/admin/users" class="btn btn-warning btn-sm">用户管理</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<%@include file="common/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
