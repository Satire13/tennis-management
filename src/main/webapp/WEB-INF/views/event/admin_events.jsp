<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>赛事管理 - 网球通</title>
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
        .table th { border-top: none; background-color: #f1f8e9; }
        .table-container { border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp"/>
<div class="page-header">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="mb-1 tennis-green">赛事管理</h2>
                <p class="text-muted mb-0">管理校园网球赛事</p>
            </div>
            <button type="button" class="btn btn-tennis" data-toggle="modal" data-target="#createModal">+ 发布赛事</button>
        </div>
    </div>
</div>
<div class="container mb-5">
    <c:if test="${empty events}">
        <div class="text-center py-5"><p class="text-muted">暂无赛事，点击"发布赛事"创建</p></div>
    </c:if>
    <c:if test="${not empty events}">
        <div class="table-container">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>标题</th>
                            <th>日期</th>
                            <th>地点</th>
                            <th>报名/上限</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="event" items="${events}">
                            <tr>
                                <td>${event.id}</td>
                                <td>${event.title}</td>
                                <td>${event.eventDate}</td>
                                <td>${event.location}</td>
                                <td>${event.enrolledCount}/${event.maxPlayers}<c:if test="${event.enrolledCount >= event.maxPlayers}"><span class="badge badge-warning ml-2">满</span></c:if></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${event.status == 'upcoming'}"><span class="badge badge-primary">即将开始</span></c:when>
                                        <c:when test="${event.status == 'ongoing'}"><span class="badge badge-success">进行中</span></c:when>
                                        <c:when test="${event.status == 'finished'}"><span class="badge badge-secondary">已结束</span></c:when>
                                        <c:when test="${event.status == 'cancelled'}"><span class="badge badge-danger">已取消</span></c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/event/admin/enrollments?eventId=${event.id}" class="btn btn-info btn-sm">报名列表</a>
                                    <button class="btn btn-warning btn-sm" onclick="editEvent(${event.id},'${event.title}','${event.description}','${event.eventDate}','${event.startTime}','${event.endTime}','${event.location}',${event.maxPlayers})">编辑</button>
                                    <button class="btn btn-danger btn-sm" onclick="deleteEvent(${event.id})">删除</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>
    <div id="messageArea" class="mt-3"></div>
</div>

<!-- Create Modal -->
<div class="modal fade" id="createModal" tabindex="-1"><div class="modal-dialog modal-lg"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title">发布赛事</h5><button type="button" class="close" data-dismiss="modal">&times;</button></div>
    <div class="modal-body">
        <form id="createForm">
            <div class="form-group"><label>赛事标题</label><input type="text" class="form-control" name="title" required></div>
            <div class="form-group"><label>赛事描述</label><textarea class="form-control" name="description" rows="3"></textarea></div>
            <div class="form-row">
                <div class="form-group col-md-4"><label>日期</label><input type="date" class="form-control" name="eventDate" required></div>
                <div class="form-group col-md-3"><label>开始时间</label><input type="time" class="form-control" name="startTime" required></div>
                <div class="form-group col-md-3"><label>结束时间</label><input type="time" class="form-control" name="endTime" required></div>
                <div class="form-group col-md-2"><label>最大人数</label><input type="number" class="form-control" name="maxPlayers" value="16" min="2"></div>
            </div>
            <div class="form-group"><label>地点</label><input type="text" class="form-control" name="location" required></div>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
        <button type="button" class="btn btn-success" onclick="submitCreate()">发布</button>
    </div>
</div></div></div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1"><div class="modal-dialog modal-lg"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title">编辑赛事</h5><button type="button" class="close" data-dismiss="modal">&times;</button></div>
    <div class="modal-body">
        <form id="editForm">
            <input type="hidden" name="id" id="editId">
            <div class="form-group"><label>赛事标题</label><input type="text" class="form-control" name="title" id="editTitle" required></div>
            <div class="form-group"><label>赛事描述</label><textarea class="form-control" name="description" id="editDescription" rows="3"></textarea></div>
            <div class="form-row">
                <div class="form-group col-md-4"><label>日期</label><input type="date" class="form-control" name="eventDate" id="editEventDate" required></div>
                <div class="form-group col-md-3"><label>开始时间</label><input type="time" class="form-control" name="startTime" id="editStartTime" required></div>
                <div class="form-group col-md-3"><label>结束时间</label><input type="time" class="form-control" name="endTime" id="editEndTime" required></div>
                <div class="form-group col-md-2"><label>最大人数</label><input type="number" class="form-control" name="maxPlayers" id="editMaxPlayers" min="2"></div>
            </div>
            <div class="form-group"><label>地点</label><input type="text" class="form-control" name="location" id="editLocation" required></div>
        </form>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
        <button type="button" class="btn btn-primary" onclick="submitEdit()">保存</button>
    </div>
</div></div></div>

<jsp:include page="../common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function submitCreate() {
    $.post('${pageContext.request.contextPath}/event/admin/create', $('#createForm').serialize(), function(r) {
        if(r.success){alert('发布成功');location.reload();}else{alert(r.message);}
    });
}
function editEvent(id,title,desc,date,st,ed,loc,max) {
    $('#editId').val(id);$('#editTitle').val(title);$('#editDescription').val(desc);
    $('#editEventDate').val(date);$('#editStartTime').val(st);$('#editEndTime').val(ed);
    $('#editLocation').val(loc);$('#editMaxPlayers').val(max);$('#editModal').modal('show');
}
function submitEdit() {
    $.post('${pageContext.request.contextPath}/event/admin/update', $('#editForm').serialize(), function(r) {
        if(r.success){alert('更新成功');location.reload();}else{alert(r.message);}
    });
}
function deleteEvent(id) {
    if(!confirm('确定删除？'))return;
    $.post('${pageContext.request.contextPath}/event/admin/delete',{id:id},function(r){
        if(r.success){alert('删除成功');location.reload();}else{alert(r.message);}
    });
}
</script>
</body>
</html>
