package com.tennis.controller;

import com.tennis.entity.User;
import com.tennis.service.UserService;
import com.tennis.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 跳转登录页
     */
    @GetMapping("/login")
    public String loginPage() {
        return "user/login";
    }

    /**
     * 执行登录
     */
    @PostMapping("/doLogin")
    @ResponseBody
    public Map<String, Object> doLogin(String username, String password, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = userService.login(username, password);
        if (user == null) {
            result.put("success", false);
            result.put("message", "用户名或密码错误");
        } else if (user.getStatus() == 0) {
            result.put("success", false);
            result.put("message", "账号已被禁用，请联系管理员");
        } else {
            session.setAttribute("loginUser", user);
            result.put("success", true);
            result.put("message", "登录成功");
            result.put("role", user.getRole());
        }
        return result;
    }

    /**
     * 跳转注册页
     */
    @GetMapping("/register")
    public String registerPage() {
        return "user/register";
    }

    /**
     * 执行注册
     */
    @PostMapping("/doRegister")
    @ResponseBody
    public Map<String, Object> doRegister(@RequestParam String username,
                                          @RequestParam String password,
                                          @RequestParam String realName,
                                          @RequestParam String email,
                                          @RequestParam String phone) {
        Map<String, Object> result = new HashMap<>();
        User user = new User(username, password, realName, email, phone, "user");
        int i = userService.register(user);
        if (i > 0) {
            result.put("success", true);
            result.put("message", "注册成功");
        } else {
            result.put("success", false);
            result.put("message", "注册失败，用户名可能已存在");
        }
        return result;
    }

    /**
     * 退出登录
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/login";
    }

    /**
     * 个人信息页
     */
    @GetMapping("/profile")
    public String profilePage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        User fresh = userService.findById(user.getId());
        model.addAttribute("user", fresh);
        return "user/profile";
    }

    /**
     * 更新个人信息
     */
    @PostMapping("/updateProfile")
    @ResponseBody
    public Map<String, Object> updateProfile(@RequestParam String realName,
                                             @RequestParam String email,
                                             @RequestParam String phone,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User loginUser = (User) session.getAttribute("loginUser");
        User user = userService.findById(loginUser.getId());
        user.setRealName(realName);
        user.setEmail(email);
        user.setPhone(phone);
        int i = userService.updateProfile(user);
        if (i > 0) {
            session.setAttribute("loginUser", user);
            result.put("success", true);
            result.put("message", "个人信息更新成功");
        } else {
            result.put("success", false);
            result.put("message", "更新失败");
        }
        return result;
    }

    /**
     * 修改密码
     */
    @PostMapping("/updatePassword")
    @ResponseBody
    public Map<String, Object> updatePassword(@RequestParam String oldPassword,
                                              @RequestParam String newPassword,
                                              HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User loginUser = (User) session.getAttribute("loginUser");
        int i = userService.updatePassword(loginUser.getId(), oldPassword, newPassword);
        if (i > 0) {
            result.put("success", true);
            result.put("message", "密码修改成功");
        } else {
            result.put("success", false);
            result.put("message", "原密码错误");
        }
        return result;
    }

    /**
     * 管理员：用户列表管理
     */
    @GetMapping("/admin/users")
    public String userManage(Model model) {
        model.addAttribute("users", userService.findAll());
        return "user/admin_users";
    }

    /**
     * 管理员：切换用户状态
     */
    @PostMapping("/admin/toggleStatus")
    @ResponseBody
    public Map<String, Object> toggleStatus(Integer userId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User admin = (User) session.getAttribute("loginUser");
        if (!"admin".equals(admin.getRole())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        User user = userService.findById(userId);
        if (user == null) {
            result.put("success", false);
            result.put("message", "用户不存在");
            return result;
        }
        user.setStatus(user.getStatus() == 1 ? 0 : 1);
        userService.updateProfile(user);
        result.put("success", true);
        result.put("message", "状态已更新");
        return result;
    }
}
