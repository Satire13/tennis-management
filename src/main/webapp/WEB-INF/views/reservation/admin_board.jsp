<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约看板 - 网球通</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .tennis-green { color: #2e7d32; }
        .tennis-green-bg { background-color: #2e7d32; color: #fff; }
        .btn-tennis { background-color: #2e7d32; border-color: #2e7d32; color: #fff; }
        .btn-tennis:hover { background-color: #1b5e20; border-color: #1b5e20; color: #fff; }
        .page-header {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 28px 0; margin-bottom: 32px;
            border-radius: 0 0 16px 16px;
        }

        /* 看板网格 */
        .board-wrapper { max-width: 100%; overflow-x: auto; }
        .board-table { min-width: 900px; border-collapse: separate; border-spacing: 0; }
        .board-table thead th {
            position: sticky; top: 0; z-index: 2;
            background: #2e7d32; color: #fff; text-align: center;
            padding: 10px 6px; font-size: 0.85rem; font-weight: 500;
            border: 1px solid #1b5e20; white-space: nowrap;
        }
        .board-table thead th:first-child {
            background: #1b5e20; font-weight: 700; width: 70px;
        }
        .board-table tbody td {
            text-align: center; vertical-align: middle;
            padding: 8px 4px; border: 1px solid #e0e0e0;
            font-size: 0.82rem; height: 52px;
            transition: background-color 0.15s;
        }
        .board-table tbody td:first-child {
            background: #f1f8e9; font-weight: 700; color: #2e7d32;
            white-space: nowrap;
        }
        .slot-free     { background-color: #f9fdf9; cursor: default; }
        .slot-booked   { background-color: #bbdefb; color: #1565c0; font-weight: 600; }
        .slot-completed{ background-color: #c8e6c9; color: #2e7d32; font-weight: 500; }
        .slot-pending  { background-color: #ffe0b2; color: #e65100; font-weight: 500; }

        .tooltip-user {
            font-size: 0.7rem; color: #555; display: block;
            margin-top: 2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
            max-width: 100px; margin-left: auto; margin-right: auto;
        }

        .legend { display: flex; gap: 20px; flex-wrap: wrap; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 0.85rem; }
        .legend-swatch { width: 18px; height: 18px; border-radius: 4px; border: 1px solid #ccc; }

        .summary-cards .card { border-radius: 10px; border-left: 4px solid #2e7d32; }
        .loading-overlay {
            display: none; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(255,255,255,0.7); z-index: 5;
            justify-content: center; align-items: center; font-size: 1.2rem;
        }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<div class="page-header">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="mb-1 tennis-green">预约看板</h2>
                <p class="text-muted mb-0">可视化查看每片场地各时段预约情况</p>
            </div>
            <a href="${pageContext.request.contextPath}/reservation/admin/list" class="btn btn-outline-secondary">列表模式</a>
        </div>
    </div>
</div>

<div class="container mb-5">
    <!-- 选择器 -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <div class="form-row align-items-end">
                <div class="form-group col-md-5 mb-0">
                    <label for="courtSelect" class="font-weight-bold small">选择场地</label>
                    <select class="form-control" id="courtSelect">
                        <option value="">-- 请选择场地 --</option>
                        <c:forEach var="court" items="${courts}">
                            <option value="${court.id}">${court.courtName}（${court.location}）</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group col-md-4 mb-0">
                    <label for="boardDate" class="font-weight-bold small">选择日期</label>
                    <input type="date" class="form-control" id="boardDate">
                </div>
                <div class="form-group col-md-3 mb-0">
                    <button class="btn btn-tennis btn-block" id="loadBtn" disabled onclick="loadBoard()">查看看板</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 图例 -->
    <div class="legend mb-3">
        <div class="legend-item"><div class="legend-swatch" style="background:#f9fdf9;"></div> 空闲</div>
        <div class="legend-item"><div class="legend-swatch" style="background:#bbdefb;"></div> 已预约</div>
        <div class="legend-item"><div class="legend-swatch" style="background:#c8e6c9;"></div> 已完成</div>
        <div class="legend-item"><div class="legend-swatch" style="background:#ffe0b2;"></div> 待确认</div>
    </div>

    <!-- 统计摘要 -->
    <div class="row summary-cards mb-3" id="summaryRow" style="display:none;">
        <div class="col-md-3 col-6 mb-2">
            <div class="card"><div class="card-body py-2 px-3"><small class="text-muted">总时段</small><h5 class="mb-0 tennis-green" id="statTotal">0</h5></div></div>
        </div>
        <div class="col-md-3 col-6 mb-2">
            <div class="card"><div class="card-body py-2 px-3"><small class="text-muted">已预约</small><h5 class="mb-0 text-primary" id="statBooked">0</h5></div></div>
        </div>
        <div class="col-md-3 col-6 mb-2">
            <div class="card"><div class="card-body py-2 px-3"><small class="text-muted">已完成</small><h5 class="mb-0 text-success" id="statCompleted">0</h5></div></div>
        </div>
        <div class="col-md-3 col-6 mb-2">
            <div class="card"><div class="card-body py-2 px-3"><small class="text-muted">空闲</small><h5 class="mb-0 text-muted" id="statFree">0</h5></div></div>
        </div>
    </div>

    <!-- 看板表格 -->
    <div class="card shadow-sm position-relative">
        <div class="loading-overlay" id="loadingOverlay"><div class="spinner-border text-success mr-2"></div>加载中...</div>
        <div class="card-body p-2">
            <div class="board-wrapper">
                <div id="boardContent" class="text-center text-muted py-5">
                    <div style="font-size:3rem;">&#128203;</div>
                    <p>请选择场地和日期查看预约看板</p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
var contextPath = '${pageContext.request.contextPath}';
var BUSINESS_START = 8;
var BUSINESS_END = 21;

$(function() {
    // 初始日期设为今天
    var today = new Date().toISOString().split('T')[0];
    $('#boardDate').val(today);

    // 控制加载按钮状态
    function checkReady() {
        $('#loadBtn').prop('disabled', !($('#courtSelect').val() && $('#boardDate').val()));
    }
    $('#courtSelect').on('change', checkReady);
    $('#boardDate').on('change', checkReady);
    checkReady();
});

function loadBoard() {
    var courtId = $('#courtSelect').val();
    var date = $('#boardDate').val();
    if (!courtId || !date) return;

    $('#loadingOverlay').css('display','flex');
    $.ajax({
        type: 'GET',
        url: contextPath + '/reservation/admin/boardData',
        data: { courtId: courtId, date: date },
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                renderBoard(resp.data || []);
            } else {
                $('#boardContent').html('<div class="alert alert-danger m-3">加载失败</div>');
            }
        },
        error: function() {
            $('#boardContent').html('<div class="alert alert-danger m-3">网络错误，请重试</div>');
        },
        complete: function() {
            $('#loadingOverlay').css('display','none');
        }
    });
}

function renderBoard(bookings) {
    // 构建预约映射:  "HH:mm" → { username, status, ... }
    var bookingMap = {};
    if (bookings && bookings.length) {
        $.each(bookings, function(i, b) {
            bookingMap[b.startTime] = b;
        });
    }

    // 计算统计数据
    var total = BUSINESS_END - BUSINESS_START;
    var booked = 0, completed = 0, free = 0;
    for (var h = BUSINESS_START; h < BUSINESS_END; h++) {
        var key = pad(h) + ':00';
        var b = bookingMap[key];
        if (b) {
            if (b.status === 'completed') completed++;
            else booked++;
        } else {
            free++;
        }
    }

    // 渲染统计
    $('#statTotal').text(total);
    $('#statBooked').text(booked);
    $('#statCompleted').text(completed);
    $('#statFree').text(free);
    $('#summaryRow').show();

    // 渲染表格
    var html = '<table class="board-table table table-bordered mb-0">';
    html += '<thead><tr><th>场地\\时间</th>';
    for (var h = BUSINESS_START; h < BUSINESS_END; h++) {
        html += '<th>' + pad(h) + ':00<br>~<br>' + pad(h+1) + ':00</th>';
    }
    html += '</tr></thead><tbody>';

    // 只显示一行（当前选中的场地）
    var courtName = $('#courtSelect option:selected').text();
    html += '<tr><td>' + courtName + '</td>';
    for (var h2 = BUSINESS_START; h2 < BUSINESS_END; h2++) {
        var key2 = pad(h2) + ':00';
        var b2 = bookingMap[key2];
        var cls = 'slot-free';
        var content = '空闲';
        if (b2) {
            if (b2.status === 'completed') {
                cls = 'slot-completed';
                content = '已完成';
            } else if (b2.status === 'pending') {
                cls = 'slot-pending';
                content = '待确认';
            } else {
                cls = 'slot-booked';
                content = '已预约';
            }
            content += '<span class="tooltip-user">' + (b2.realName || b2.username || '') + '</span>';
        }
        html += '<td class="' + cls + '">' + content + '</td>';
    }
    html += '</tr></tbody></table>';

    $('#boardContent').html(html);
}

function pad(n) { return n < 10 ? '0' + n : '' + n; }
</script>

</body>
</html>
