package com.tennis.entity;

/**
 * 评价实体类
 */
public class Review {
    private Integer id;
    private Integer reservationId;
    private Integer userId;
    private Integer courtId;
    private Integer rating;         // 评分 1-5星
    private String content;         // 评价内容
    private String createTime;

    // 关联字段（非数据库字段）
    private String username;
    private String courtName;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getReservationId() { return reservationId; }
    public void setReservationId(Integer reservationId) { this.reservationId = reservationId; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getCourtId() { return courtId; }
    public void setCourtId(Integer courtId) { this.courtId = courtId; }
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getCourtName() { return courtName; }
    public void setCourtName(String courtName) { this.courtName = courtName; }
}
