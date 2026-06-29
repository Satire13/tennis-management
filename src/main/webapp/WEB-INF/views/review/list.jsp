<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isAdminView ? '评价管理' : '场地评价'} - 网球通</title>
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
        .star-rating-display {
            color: #ffc107;
            font-size: 1.1rem;
        }
        .star-empty {
            color: #ddd;
        }
        .rating-summary {
            background: linear-gradient(135deg, #fff8e1, #fff3e0);
            border-radius: 12px;
            padding: 24px;
        }
        .review-card {
            border-radius: 10px;
            border-left: 3px solid #4caf50;
            margin-bottom: 16px;
            box-shadow: 0 1px 6px rgba(0,0,0,0.05);
        }
        .review-card .card-body {
            padding: 16px 20px;
        }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<div class="page-header">
    <div class="container">
        <h2 class="mb-1 tennis-green">${isAdminView ? '评价管理' : '场地评价'}</h2>
        <p class="text-muted mb-0">${isAdminView ? '管理所有用户评价' : '查看其他用户对该场地的真实评价'}</p>
    </div>
</div>

<div class="container mb-5">
    <!-- 评分概览 -->
    <c:if test="${!isAdminView}">
    <div class="rating-summary mb-4">
        <div class="row align-items-center">
            <div class="col-md-4 text-center border-right">
                <div style="font-size: 2.8rem; font-weight: bold; color: #2e7d32;">${avgRating}</div>
                <div class="star-rating-display mb-1">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= avgRating}">&#9733;</c:when>
                            <c:when test="${i - 0.5 <= avgRating}">&#9733;</c:when>
                            <c:otherwise><span class="star-empty">&#9734;</span></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <small class="text-muted">共 ${reviewCount} 条评价</small>
            </div>
            <div class="col-md-8">
                <div class="d-flex align-items-center justify-content-center h-100">
                    <a href="${pageContext.request.contextPath}/court/list" class="btn btn-tennis mr-2">返回场地列表</a>
                    <c:if test="${not empty sessionScope.loginUser}">
                        <a href="${pageContext.request.contextPath}/reservation/my" class="btn btn-outline-success">我的预约</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    </c:if>

    <!-- 评价列表 -->
    <c:choose>
        <c:when test="${empty reviews}">
            <div class="card shadow-sm">
                <div class="card-body text-center py-5">
                    <div style="font-size: 3rem; color: #ccc;">&#128172;</div>
                    <h5 class="text-muted mt-3">暂无评价</h5>
                    <p class="text-muted">${isAdminView ? '还没有任何用户评价' : '该场地还没有人评价，快来第一个评价吧！'}</p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="review" items="${reviews}">
                <div class="card review-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <strong class="tennis-green">${review.username}</strong>
                                <c:if test="${isAdminView}">
                                    <small class="text-muted ml-1">(场地: ${review.courtName})</small>
                                </c:if>
                                <span class="star-rating-display ml-2">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= review.rating}">&#9733;</c:when>
                                            <c:otherwise><span class="star-empty">&#9734;</span></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                            </div>
                            <div>
                                <small class="text-muted">${fn:substring(review.createTime, 0, 16)}</small>
                                <c:if test="${isAdminView && sessionScope.loginUser.role eq 'admin'}">
                                    <button class="btn btn-sm btn-outline-danger ml-2" onclick="deleteReview(${review.id})">删除</button>
                                </c:if>
                            </div>
                        </div>
                        <c:if test="${not empty review.content}">
                            <p class="mt-2 mb-0 text-muted" style="line-height: 1.6;">${review.content}</p>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <!-- 返回按钮 -->
    <div class="text-center mt-4">
        <a href="<c:choose><c:when test='${isAdminView}'>${pageContext.request.contextPath}/</c:when><c:otherwise>${pageContext.request.contextPath}/court/list</c:otherwise></c:choose>" class="btn btn-outline-secondary">${isAdminView ? '返回首页' : '返回场地列表'}</a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
var contextPath = '${pageContext.request.contextPath}';

function deleteReview(id) {
    if (!confirm('确定要删除该评价吗？此操作不可恢复。')) {
        return;
    }
    $.ajax({
        type: 'POST',
        url: contextPath + '/review/admin/delete',
        data: { id: id },
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                location.reload();
            } else {
                alert(resp.message || '删除失败');
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
