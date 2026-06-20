package com.tennis.entity;

/**
 * 赛事实体类
 */
public class Event {
    private Integer id;
    private String title;
    private String description;
    private String eventDate;      // 比赛日期 yyyy-MM-dd
    private String startTime;      // 开始时间 HH:mm
    private String endTime;        // 结束时间 HH:mm
    private String location;
    private Integer maxPlayers;    // 最大参赛人数
    private Integer enrolledCount; // 已报名人数（非数据库字段，由查询计算）
    private String status;         // "upcoming" 即将开始, "ongoing" 进行中, "finished" 已结束, "cancelled" 已取消
    private Integer creatorId;     // 发布者ID
    private String createTime;

    // 关联字段
    private String creatorName;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getEventDate() { return eventDate; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }
    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }
    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public Integer getMaxPlayers() { return maxPlayers; }
    public void setMaxPlayers(Integer maxPlayers) { this.maxPlayers = maxPlayers; }
    public Integer getEnrolledCount() { return enrolledCount; }
    public void setEnrolledCount(Integer enrolledCount) { this.enrolledCount = enrolledCount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getCreatorId() { return creatorId; }
    public void setCreatorId(Integer creatorId) { this.creatorId = creatorId; }
    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }
    public String getCreatorName() { return creatorName; }
    public void setCreatorName(String creatorName) { this.creatorName = creatorName; }
}
