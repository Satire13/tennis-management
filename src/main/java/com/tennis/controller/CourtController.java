package com.tennis.controller;

import com.tennis.entity.Court;
import com.tennis.service.CourtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/court")
public class CourtController {

    @Autowired
    private CourtService courtService;

    /**
     * 场地列表页
     */
    @GetMapping("/list")
    public String listPage(Model model) {
        model.addAttribute("courts", courtService.findAllWithRating());
        return "court/list";
    }

    /**
     * AJAX获取可用场地
     */
    @GetMapping("/available")
    @ResponseBody
    public Map<String, Object> availableCourts() {
        Map<String, Object> result = new HashMap<>();
        result.put("data", courtService.findAvailable());
        result.put("success", true);
        return result;
    }

    // =================== 后台管理 ===================

    /**
     * 管理员：场地管理页
     */
    @GetMapping("/admin/manage")
    public String adminManage(Model model) {
        model.addAttribute("courts", courtService.findAll());
        return "court/admin_manage";
    }

    /**
     * 管理员：添加场地
     */
    @PostMapping("/admin/add")
    @ResponseBody
    public Map<String, Object> addCourt(Court court, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!isAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        court.setStatus(1);
        int i = courtService.addCourt(court);
        result.put("success", i > 0);
        result.put("message", i > 0 ? "添加成功" : "添加失败");
        return result;
    }

    /**
     * 管理员：更新场地
     */
    @PostMapping("/admin/update")
    @ResponseBody
    public Map<String, Object> updateCourt(Court court, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!isAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        int i = courtService.updateCourt(court);
        result.put("success", i > 0);
        result.put("message", i > 0 ? "更新成功" : "更新失败");
        return result;
    }

    /**
     * 管理员：删除场地
     */
    @PostMapping("/admin/delete")
    @ResponseBody
    public Map<String, Object> deleteCourt(Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!isAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        int i = courtService.deleteCourt(id);
        result.put("success", i > 0);
        result.put("message", i > 0 ? "删除成功" : "删除失败");
        return result;
    }

    private boolean isAdmin(HttpSession session) {
        Object user = session.getAttribute("loginUser");
        return user != null && "admin".equals(((com.tennis.entity.User) user).getRole());
    }
}
