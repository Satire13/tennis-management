<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>撰写评价 - 网球通</title>
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
        .star-rating {
            direction: rtl;
            display: inline-flex;
            font-size: 2rem;
        }
        .star-rating input[type="radio"] {
            display: none;
        }
        .star-rating label {
            color: #ddd;
            cursor: pointer;
            padding: 0 3px;
            transition: color 0.2s;
        }
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input[type="radio"]:checked ~ label {
            color: #ffc107;
        }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<div class="page-header">
    <div class="container">
        <h2 class="mb-1 tennis-green">撰写评价</h2>
        <p class="text-muted mb-0">分享您的体验，帮助其他球友了解场地情况</p>
    </div>
</div>

<div class="container mb-5">
    <c:choose>
        <c:when test="${not empty error}">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow-sm">
                        <div class="card-body text-center py-5">
                            <div style="font-size: 3rem; color: #f44336;">&#10060;</div>
                            <h5 class="mt-3 text-muted">${error}</h5>
                            <a href="${pageContext.request.contextPath}/reservation/my" class="btn btn-tennis mt-3">返回我的预约</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:when test="${not empty reservation}">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <!-- 预约信息摘要 -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-header tennis-green-bg py-2">
                            <strong>预约信息</strong>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-6">
                                    <small class="text-muted d-block">场地</small>
                                    <span>${reservation.courtName}</span>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted d-block">位置</small>
                                    <span>${reservation.courtLocation}</span>
                                </div>
                                <div class="col-6 mt-3">
                                    <small class="text-muted d-block">日期</small>
                                    <span>${reservation.reserveDate}</span>
                                </div>
                                <div class="col-6 mt-3">
                                    <small class="text-muted d-block">时间</small>
                                    <span>${reservation.startTime} - ${reservation.endTime}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 评价表单 -->
                    <div class="card shadow-sm">
                        <div class="card-header tennis-green-bg py-2">
                            <strong>我的评价</strong>
                        </div>
                        <div class="card-body">
                            <form id="reviewForm">
                                <input type="hidden" name="reservationId" value="${reservation.id}">
                                <input type="hidden" name="courtId" value="${reservation.courtId}">

                                <!-- 星级评分 -->
                                <div class="form-group text-center mb-4">
                                    <label class="d-block mb-2 font-weight-bold">您的评分</label>
                                    <div class="star-rating">
                                        <input type="radio" id="star5" name="rating" value="5">
                                        <label for="star5" title="5星">&#9733;</label>
                                        <input type="radio" id="star4" name="rating" value="4">
                                        <label for="star4" title="4星">&#9733;</label>
                                        <input type="radio" id="star3" name="rating" value="3">
                                        <label for="star3" title="3星">&#9733;</label>
                                        <input type="radio" id="star2" name="rating" value="2">
                                        <label for="star2" title="2星">&#9733;</label>
                                        <input type="radio" id="star1" name="rating" value="1">
                                        <label for="star1" title="1星">&#9733;</label>
                                    </div>
                                    <small class="text-muted d-block mt-1">点击星星进行评分</small>
                                </div>

                                <!-- 文字评价 -->
                                <div class="form-group">
                                    <label for="content" class="font-weight-bold">文字评价</label>
                                    <textarea class="form-control" id="content" name="content" rows="5"
                                              placeholder="请分享您对场地的真实感受，例如场地状况、设施配备、服务体验等..."
                                              maxlength="500"></textarea>
                                    <small class="text-muted float-right"><span id="charCount">0</span>/500</small>
                                </div>

                                <div class="text-center mt-4">
                                    <button type="button" id="submitBtn" class="btn btn-tennis btn-lg px-5">提交评价</button>
                                    <a href="${pageContext.request.contextPath}/reservation/my" class="btn btn-outline-secondary btn-lg px-4 ml-2">取消</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <p class="text-muted">预约信息不存在</p>
                <a href="${pageContext.request.contextPath}/reservation/my" class="btn btn-tennis">返回我的预约</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
var contextPath = '${pageContext.request.contextPath}';

// 字数统计
$('#content').on('input', function() {
    $('#charCount').text($(this).val().length);
});

// 提交评价
$('#submitBtn').on('click', function() {
    var rating = $('input[name="rating"]:checked').val();
    var content = $('#content').val().trim();

    if (!rating) {
        alert('请选择评分（1-5星）');
        return;
    }
    if (!content) {
        alert('请输入评价内容');
        return;
    }
    if (content.length > 500) {
        alert('评价内容不能超过500字');
        return;
    }

    var $btn = $(this);
    $btn.prop('disabled', true).text('提交中...');

    $.ajax({
        type: 'POST',
        url: contextPath + '/review/submit',
        data: {
            reservationId: $('input[name="reservationId"]').val(),
            courtId: $('input[name="courtId"]').val(),
            rating: rating,
            content: content
        },
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                alert('评价提交成功！');
                window.location.href = contextPath + '/reservation/my';
            } else {
                alert(resp.message || '提交失败，请重试');
                $btn.prop('disabled', false).text('提交评价');
            }
        },
        error: function() {
            alert('网络错误，请重试');
            $btn.prop('disabled', false).text('提交评价');
        }
    });
});
</script>

</body>
</html>
