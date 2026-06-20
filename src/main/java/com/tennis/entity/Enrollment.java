package com.tennis.entity;

/**
 * 赛事报名实体类
 */
public class Enrollment {
    private Integer id;
    private Integer eventId;
    private Integer userId;
    private String enrollTime;
    private String status;       // "enrolled" 已报名, "cancelled" 已取消

    // 关联字段
    private String eventTitle;
    private String eventDate;
    private String eventLocation;
    private String username;
    private String realName;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getEventId() { return eventId; }
    public void setEventId(Integer eventId) { this.eventId = eventId; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getEnrollTime() { return enrollTime; }
    public void setEnrollTime(String enrollTime) { this.enrollTime = enrollTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }
    public String getEventDate() { return eventDate; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }
    public String getEventLocation() { return eventLocation; }
    public void setEventLocation(String eventLocation) { this.eventLocation = eventLocation; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getRealName() { return realName; }
    public void setRealName(String realName) { this.realName = realName; }
}
