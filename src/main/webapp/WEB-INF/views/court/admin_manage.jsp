<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>场地管理 - 网球通</title>
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
        .btn-tennis-outline {
            border-color: #2e7d32; color: #2e7d32;
        }
        .btn-tennis-outline:hover {
            background-color: #2e7d32; color: #fff;
        }
        .page-header {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            padding: 28px 0;
            margin-bottom: 32px;
            border-radius: 0 0 16px 16px;
        }
        .badge-available {
            background-color: #4caf50; color: #fff;
            padding: 4px 12px; border-radius: 20px; font-size: 0.8rem;
        }
        .badge-maintenance {
            background-color: #f44336; color: #fff;
            padding: 4px 12px; border-radius: 20px; font-size: 0.8rem;
        }
        .table th { border-top: none; background-color: #f1f8e9; }
        .action-btn { margin-right: 4px; }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="mb-1 tennis-green">场地管理</h2>
                <p class="text-muted mb-0">管理所有网球场馆信息</p>
            </div>
            <button type="button" class="btn btn-tennis" data-toggle="modal" data-target="#courtModal" onclick="resetModal()">
                + 添加场地
            </button>
        </div>
    </div>
</div>

<!-- Courts Table -->
<div class="container mb-5">
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>编号</th>
                        <th>场地名称</th>
                        <th>位置</th>
                        <th>价格</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty courts}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">暂无场地数据</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="court" items="${courts}">
                                <tr>
                                    <td>${court.id}</td>
                                    <td>${court.courtName}</td>
                                    <td>${court.location}</td>
                                    <td><fmt:formatNumber value="${court.price}" pattern="#0"/> 元/小时</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${court.status == 1}">
                                                <span class="badge-available">可用</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-maintenance">维护中</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-tennis-outline action-btn" onclick="editCourt(${court.id}, '${court.courtName}', '${court.location}', '${court.description}', ${court.price}, '${court.status}')" data-toggle="modal" data-target="#courtModal">编辑</button>
                                        <button class="btn btn-sm btn-outline-danger action-btn" onclick="deleteCourt(${court.id})">删除</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add / Edit Modal -->
<div class="modal fade" id="courtModal" tabindex="-1" role="dialog" aria-labelledby="courtModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header tennis-green-bg">
                <h5 class="modal-title" id="courtModalLabel">添加场地</h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form id="courtForm">
                <div class="modal-body">
                    <input type="hidden" id="courtId" name="id" value="">
                    <div class="form-group">
                        <label for="courtName">场地名称</label>
                        <input type="text" class="form-control" id="courtName" name="courtName" required placeholder="例如：1号场地">
                    </div>
                    <div class="form-group">
                        <label for="location">位置</label>
                        <input type="text" class="form-control" id="location" name="location" required placeholder="例如：南区体育馆">
                    </div>
                    <div class="form-group">
                        <label for="description">描述</label>
                        <textarea class="form-control" id="description" name="description" rows="3" placeholder="场地描述信息（可选）"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="price">价格（元/小时）</label>
                        <input type="number" class="form-control" id="price" name="price" required min="0" step="0.01" placeholder="50">
                    </div>
                    <div class="form-group" id="statusGroup" style="display:none;">
                        <label for="status">状态</label>
                        <select class="form-control" id="status" name="status">
                            <option value="1">可用</option>
                            <option value="0">维护中</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-tennis" id="modalSubmitBtn">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
var contextPath = '${pageContext.request.contextPath}';

function resetModal() {
    $('#courtModalLabel').text('添加场地');
    $('#courtForm')[0].reset();
    $('#courtId').val('');
    $('#statusGroup').hide();
    $('#modalSubmitBtn').text('保存');
    // Remove old validation states
    $('.is-invalid').removeClass('is-invalid');
}

function editCourt(id, name, location, description, price, status) {
    $('#courtModalLabel').text('编辑场地');
    $('#courtId').val(id);
    $('#courtName').val(name);
    $('#location').val(location);
    $('#description').val(description);
    $('#price').val(price);
    $('#status').val(status);
    $('#statusGroup').show();
    $('#modalSubmitBtn').text('更新');
}

$('#courtForm').on('submit', function(e) {
    e.preventDefault();
    var id = $('#courtId').val();
    var isEdit = id !== '';
    var url = isEdit
        ? contextPath + '/court/admin/update'
        : contextPath + '/court/admin/add';

    $.ajax({
        type: 'POST',
        url: url,
        data: $(this).serialize(),
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                $('#courtModal').modal('hide');
                location.reload();
            } else {
                alert(resp.message || '操作失败，请重试');
            }
        },
        error: function() {
            alert('网络错误，请重试');
        }
    });
});

function deleteCourt(id) {
    if (!confirm('确定要删除该场地吗？此操作不可撤销。')) {
        return;
    }
    $.ajax({
        type: 'POST',
        url: contextPath + '/court/admin/delete',
        data: { id: id },
        dataType: 'json',
        success: function(resp) {
            if (resp.success) {
                location.reload();
            } else {
                alert(resp.message || '删除失败，请重试');
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
