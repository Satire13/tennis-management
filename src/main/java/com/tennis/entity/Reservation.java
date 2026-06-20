package com.tennis.entity;

/**
 * 预约记录实体类
 */
public class Reservation {
    private Integer id;
    private Integer userId;
    private Integer courtId;
    private String reserveDate;    // 预约日期 yyyy-MM-dd
    private String startTime;      // 开始时间 HH:mm
    private String endTime;        // 结束时间 HH:mm
    private String status;         // "pending" 待确认, "confirmed" 已确认, "cancelled" 已取消, "completed" 已完成
    private String createTime;
    private String updateTime;

    // 关联字段（非数据库字段）
    private String username;
    private String courtName;
    private String courtLocation;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getCourtId() { return courtId; }
    public void setCourtId(Integer courtId) { this.courtId = courtId; }
    public String getReserveDate() { return reserveDate; }
    public void setReserveDate(String reserveDate) { this.reserveDate = reserveDate; }
    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }
    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }
    public String getUpdateTime() { return updateTime; }
    public void setUpdateTime(String updateTime) { this.updateTime = updateTime; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getCourtName() { return courtName; }
    public void setCourtName(String courtName) { this.courtName = courtName; }
    public String getCourtLocation() { return courtLocation; }
    public void setCourtLocation(String courtLocation) { this.courtLocation = courtLocation; }
}
