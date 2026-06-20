<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约场地 - 网球通</title>
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

        /* Time slot grid */
        .slots-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 10px;
            margin-top: 16px;
        }
        .slot-item {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 12px 6px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.9rem;
            user-select: none;
        }
        .slot-item:hover:not(.slot-disabled):not(.slot-selected) {
            border-color: #2e7d32;
            background-color: #e8f5e9;
        }
        .slot-available {
            background-color: #fff;
            color: #333;
        }
        .slot-selected {
            background-color: #2e7d32;
            border-color: #1b5e20;
            color: #fff;
            font-weight: bold;
        }
        .slot-disabled {
            background-color: #f5f5f5;
            border-color: #e0e0e0;
            color: #bdbdbd;
            cursor: not-allowed;
            position: relative;
        }
        .slot-disabled::after {
            content: "已预约";
            display: block;
            font-size: 0.7rem;
            color: #f44336;
            margin-top: 2px;
        }

        /* Summary panel */
        .summary-card {
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            position: sticky;
            top: 24px;
        }
        .summary-card .card-header {
            background: linear-gradient(135deg, #2e7d32, #4caf50);
            color: #fff;
            border-radius: 12px 12px 0 0;
            font-weight: bold;
        }
        .summary-label {
            color: #888;
            font-size: 0.85rem;
        }
        .summary-value {
            font-weight: 500;
        }
        .loading-slots {
            text-align: center;
            padding: 40px 0;
            color: #999;
        }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h2 class="mb-1 tennis-green">预约场地</h2>
        <p class="text-muted mb-0">选择场地、日期和时间进行预约</p>
    </div>
</div>

<div class="container mb-5">
    <div class="row">
        <!-- Left: Calendar / Time slot selection -->
        <div class="col-md-8">
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h5 class="card-title tennis-green mb-3">选择预约信息</h5>

                    <!-- Court Select -->
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="courtSelect">选择场地</label>
                            <select class="form-control" id="courtSelect">
                                <option value="">-- 请选择场地 --</option>
                                <c:forEach var="court" items="${courts}">
                                    <option value="${court.id}"
                                        data-name="${court.courtName}"
                                        data-price="<fmt:formatNumber value='${court.price}' pattern='#0'/>"
                                        ${param.courtId eq court.id ? 'selected' : ''}>
                                        ${court.courtName} - ${court.location}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="reserveDate">选择日期</label>
                            <input type="date" class="form-control" id="reserveDate">
                        </div>
                    </div>

                    <!-- Time Slots -->
                    <div class="mt-3">
                        <label class="font-weight-bold tennis-green">选择时间段</label>
                        <div id="slotsContainer">
                            <div class="loading-slots">请先选择场地和日期</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right: Booking Summary -->
        <div class="col-md-4">
            <div class="card summary-card">
                <div class="card-header py-3">
                    <h5 class="mb-0">预约摘要</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <div class="summary-label">场地</div>
                        <div class="summary-value" id="summaryCourt">未选择</div>
                    </div>
                    <div class="mb-3">
                        <div class="summary-label">日期</div>
                        <div class="summary-value" id="summaryDate">未选择</div>
                    </div>
                    <div class="mb-3">
                        <div class="summary-label">时间</div>
                        <div class="summary-value" id="summaryTime">未选择</div>
                    </div>
                    <div class="mb-3">
                        <div class="summary-label">费用</div>
                        <div class="summary-value" id="summaryPrice">0 元</div>
                    </div>
                    <hr>
                    <button class="btn btn-tennis btn-block btn-lg" id="confirmBookingBtn" disabled>
                        确认预约
                    </button>
                    <c:if test="${empty sessionScope.loginUser}">
                        <div class="alert alert-warning mt-3 mb-0 py-2 small">
                            请先 <a href="${pageContext.request.contextPath}/user/login" class="alert-link">登录</a> 后进行预约
                        </div>
                    </c:if>
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
var selectedCourtId = null;
var selectedDate = null;
var selectedStartTime = null;
var selectedEndTime = null;
var allSlots = [];

// Business hours
var BUSINESS_START = 8;  // 08:00
var BUSINESS_END = 21;   // 21:00 (last slot starts at 20:00)

$(function() {
    // Set min date to today
    var today = new Date().toISOString().split('T')[0];
    $('#reserveDate').attr('min', today);

    // If courtId param exists, pre-select and load slots
    var courtIdParam = '${param.courtId}';
    if (courtIdParam) {
        $('#courtSelect').val(courtIdParam);
        $('#reserveDate').val(today);
        loadSlots();
    }

    // On court change
    $('#courtSelect').on('change', function() {
        selectedCourtId = $(this).val();
        clearSelection();
        if (selectedCourtId && $('#reserveDate').val()) {
            loadSlots();
        } else {
            $('#slotsContainer').html('<div class="loading-slots">请先选择场地和日期</div>');
        }
    });

    // On date change
    $('#reserveDate').on('change', function() {
        selectedDate = $(this).val();
        clearSelection();
        if (selectedCourtId && selectedDate) {
            loadSlots();
        } else {
            $('#slotsContainer').html('<div class="loading-slots">请先选择场地和日期</div>');
        }
    });
});

function loadSlots() {
    var courtId = $('#courtSelect').val();
    var reserveDate = $('#reserveDate').val();
    if (!courtId || !reserveDate) return;

    $('#slotsContainer').html('<div class="loading-slots"><span class="spinner-border spinner-border-sm mr-2" role="status"></span>加载中...</div>');

    $.ajax({
        type: 'GET',
        url: contextPath + '/reservation/slots',
        data: { courtId: courtId, date: reserveDate },
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                buildSlotsGrid(resp.data || []);
            } else {
                $('#slotsContainer').html('<div class="alert alert-danger">' + (resp.message || '加载失败') + '</div>');
            }
        },
        error: function() {
            $('#slotsContainer').html('<div class="alert alert-danger">网络错误，请重试</div>');
        }
    });
}

function buildSlotsGrid(bookedSlots) {
    // Build a set of booked time ranges for quick lookup: "HH:MM-HH:MM"
    var bookedSet = {};
    if (bookedSlots && bookedSlots.length) {
        $.each(bookedSlots, function(i, slot) {
            var key = slot.startTime + '-' + slot.endTime;
            bookedSet[key] = true;
        });
    }

    var html = '<div class="slots-grid">';
    for (var h = BUSINESS_START; h < BUSINESS_END; h++) {
        var startStr = pad(h) + ':00';
        var endStr = pad(h + 1) + ':00';
        var key = startStr + '-' + endStr;

        var isBooked = bookedSet[key] === true;
        var cls = 'slot-item';
        cls += isBooked ? ' slot-disabled' : ' slot-available';
        cls += ' slot-' + startStr.replace(':', '');

        html += '<div class="' + cls + '" data-start="' + startStr + '" data-end="' + endStr + '" data-booked="' + isBooked + '" onclick="selectSlot(this)">';
        html += startStr + ' - ' + endStr;
        html += '</div>';
    }
    html += '</div>';

    $('#slotsContainer').html(html);

    // Update summary court info
    var selectedOption = $('#courtSelect option:selected');
    $('#summaryCourt').text(selectedOption.data('name') || '未选择');
    $('#summaryDate').text($('#reserveDate').val() || '未选择');
}

function selectSlot(el) {
    if ($(el).data('booked') === true) {
        return;
    }

    // Toggle: if already selected, deselect
    if ($(el).hasClass('slot-selected')) {
        $(el).removeClass('slot-selected');
        selectedStartTime = null;
        selectedEndTime = null;
        $('#summaryTime').text('未选择');
        $('#summaryPrice').text('0 元');
        $('#confirmBookingBtn').prop('disabled', true);
        return;
    }

    // Deselect all other slots
    $('.slot-item').removeClass('slot-selected');

    // Select this one
    $(el).addClass('slot-selected');
    selectedStartTime = $(el).data('start');
    selectedEndTime = $(el).data('end');

    // Update summary
    $('#summaryTime').text(selectedStartTime + ' - ' + selectedEndTime);

    // Calculate price
    var selectedOption = $('#courtSelect option:selected');
    var priceText = selectedOption.data('price') || '0';
    $('#summaryPrice').text(priceText + ' 元');

    // Enable button
    $('#confirmBookingBtn').prop('disabled', false);
}

function clearSelection() {
    selectedStartTime = null;
    selectedEndTime = null;
    $('#summaryTime').text('未选择');
    $('#summaryPrice').text('0 元');
    $('#confirmBookingBtn').prop('disabled', true);
}

// Confirm booking
$('#confirmBookingBtn').on('click', function() {
    var courtId = $('#courtSelect').val();
    var reserveDate = $('#reserveDate').val();

    if (!courtId || !reserveDate || !selectedStartTime || !selectedEndTime) {
        alert('请完整选择预约信息');
        return;
    }

    $('#confirmBookingBtn').prop('disabled', true).text('提交中...');

    $.ajax({
        type: 'POST',
        url: contextPath + '/reservation/doBook',
        data: {
            courtId: courtId,
            reserveDate: reserveDate,
            startTime: selectedStartTime,
            endTime: selectedEndTime
        },
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                alert('预约成功！');
                // Reload slots to reflect the new booking
                loadSlots();
                clearSelection();
                $('#confirmBookingBtn').prop('disabled', true).text('确认预约');
            } else {
                alert(resp.message || '预约失败，请重试');
                $('#confirmBookingBtn').prop('disabled', false).text('确认预约');
            }
        },
        error: function() {
            alert('网络错误，请重试');
            $('#confirmBookingBtn').prop('disabled', false).text('确认预约');
        }
    });
});

function pad(n) {
    return n < 10 ? '0' + n : '' + n;
}
</script>

</body>
</html>
