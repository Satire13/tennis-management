package com.tennis.entity;

/**
 * 用户实体类
 */
public class User {
    private Integer id;
    private String username;
    private String password;
    private String realName;
    private String email;
    private String phone;
    private String role;       // "user" 普通用户, "admin" 管理员
    private Integer status;    // 0-禁用 1-正常
    private String createTime;

    // Constructors
    public User() {}

    public User(String username, String password, String realName, String email, String phone, String role) {
        this.username = username;
        this.password = password;
        this.realName = realName;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = 1;
    }

    // Getters & Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getRealName() { return realName; }
    public void setRealName(String realName) { this.realName = realName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }
}
