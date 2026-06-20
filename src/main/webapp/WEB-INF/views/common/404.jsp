<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>404 - 页面未找到</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
</head>
<body>
<%@include file="header.jsp"%>

<div class="container text-center pt-5">
    <h1 class="display-1 text-muted" style="font-size: 6rem; font-weight: 700;">404</h1>
    <p class="lead mb-4">抱歉，您访问的页面不存在</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-success btn-lg">返回首页</a>
</div>

<%@include file="footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
