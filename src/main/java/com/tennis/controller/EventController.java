package com.tennis.controller;

import com.tennis.entity.Event;
import com.tennis.entity.User;
import com.tennis.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/event")
public class EventController {

    @Autowired
    private EventService eventService;

    /**
     * 赛事列表页
     */
    @GetMapping("/list")
    public String listPage(Model model) {
        model.addAttribute("events", eventService.findAll());
        return "event/list";
    }

    /**
     * 赛事详情
     */
    @GetMapping("/detail")
    public String detail(Integer id, Model model, HttpSession session) {
        Event event = eventService.findById(id);
        if (event == null) {
            return "redirect:/event/list";
        }
        User user = (User) session.getAttribute("loginUser");
        boolean enrolled = eventService.isEnrolled(id, user.getId());
        model.addAttribute("event", event);
        model.addAttribute("enrolled", enrolled);
        return "event/detail";
    }

    /**
     * 报名参赛
     */
    @PostMapping("/enroll")
    @ResponseBody
    public Map<String, Object> enroll(Integer eventId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("loginUser");
        boolean ok = eventService.enroll(eventId, user.getId());
        result.put("success", ok);
        if (ok) {
            result.put("message", "报名成功");
        } else {
            result.put("message", "报名失败，可能已报名或名额已满");
        }
        return result;
    }

    /**
     * 取消报名
     */
    @PostMapping("/cancelEnroll")
    @ResponseBody
    public Map<String, Object> cancelEnroll(Integer eventId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("loginUser");
        boolean ok = eventService.cancelEnrollment(eventId, user.getId());
        result.put("success", ok);
        result.put("message", ok ? "取消报名成功" : "取消报名失败");
        return result;
    }

    /**
     * 我的赛事（已报名的）
     */
    @GetMapping("/my")
    public String myEvents(Model model, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        model.addAttribute("enrollments", eventService.getMyEnrollments(user.getId()));
        return "event/my_events";
    }

    // =================== 后台管理 ===================

    /**
     * 管理员：赛事管理页
     */
    @GetMapping("/admin/manage")
    public String adminManage(Model model) {
        model.addAttribute("events", eventService.findAll());
        return "event/admin_events";
    }

    /**
     * 管理员：发布赛事
     */
    @PostMapping("/admin/create")
    @ResponseBody
    public Map<String, Object> createEvent(Event event, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User admin = (User) session.getAttribute("loginUser");
        if (!"admin".equals(admin.getRole())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        event.setCreatorId(admin.getId());
        int i = eventService.createEvent(event);
        result.put("success", i > 0);
        result.put("message", i > 0 ? "发布成功" : "发布失败");
        return result;
    }

    /**
     * 管理员：更新赛事
     */
    @PostMapping("/admin/update")
    @ResponseBody
    public Map<String, Object> updateEvent(Event event, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!isAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        int i = eventService.updateEvent(event);
        result.put("success", i > 0);
        result.put("message", i > 0 ? "更新成功" : "更新失败");
        return result;
    }

    /**
     * 管理员：删除赛事
     */
    @PostMapping("/admin/delete")
    @ResponseBody
    public Map<String, Object> deleteEvent(Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!isAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        int i = eventService.deleteEvent(id);
        result.put("success", i > 0);
        result.put("message", i > 0 ? "删除成功" : "删除失败");
        return result;
    }

    /**
     * 管理员：查看赛事报名列表
     */
    @GetMapping("/admin/enrollments")
    public String eventEnrollments(Integer eventId, Model model) {
        model.addAttribute("enrollments", eventService.getEventEnrollments(eventId));
        Event event = eventService.findById(eventId);
        model.addAttribute("event", event);
        return "event/admin_enrollments";
    }

    private boolean isAdmin(HttpSession session) {
        Object user = session.getAttribute("loginUser");
        return user != null && "admin".equals(((User) user).getRole());
    }
}
