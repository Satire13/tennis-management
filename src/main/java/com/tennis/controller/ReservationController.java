package com.tennis.controller;

import com.tennis.entity.Court;
import com.tennis.entity.Reservation;
import com.tennis.entity.User;
import com.tennis.service.CourtService;
import com.tennis.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private CourtService courtService;

    /**
     * 预约页面
     */
    @GetMapping("/book")
    public String bookPage(Model model) {
        List<Court> courts = courtService.findAvailable();
        model.addAttribute("courts", courts);
        return "reservation/book";
    }

    /**
     * 查看场地某日已预约时段
     */
    @GetMapping("/slots")
    @ResponseBody
    public Map<String, Object> getSlots(Integer courtId, String date) {
        Map<String, Object> result = new HashMap<>();
        Court court = courtService.findById(courtId);
        if (court == null) {
            result.put("success", false);
            result.put("message", "场地不存在");
            return result;
        }
        List<Reservation> reservations = reservationService.findConflicting(court, date, "00:00", "23:59");
        result.put("success", true);
        result.put("data", reservations);
        return result;
    }

    /**
     * 执行预约
     */
    @PostMapping("/doBook")
    @ResponseBody
    public Map<String, Object> doBook(Integer courtId, String reserveDate,
                                      String startTime, String endTime, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("loginUser");

        Reservation res = new Reservation();
        res.setUserId(user.getId());
        res.setCourtId(courtId);
        res.setReserveDate(reserveDate);
        res.setStartTime(startTime);
        res.setEndTime(endTime);

        boolean ok = reservationService.book(res);
        if (ok) {
            result.put("success", true);
            result.put("message", "预约成功");
        } else {
            result.put("success", false);
            result.put("message", "预约失败，该时段已被占用");
        }
        return result;
    }

    /**
     * 我的预约
     */
    @GetMapping("/my")
    public String myReservations(Model model, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        List<Reservation> list = reservationService.findByUserId(user.getId());
        model.addAttribute("reservations", list);
        return "reservation/my_reservations";
    }

    /**
     * 取消预约
     */
    @PostMapping("/cancel")
    @ResponseBody
    public Map<String, Object> cancel(Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("loginUser");
        boolean ok = reservationService.cancel(id, user.getId());
        result.put("success", ok);
        result.put("message", ok ? "取消成功" : "取消失败，仅可取消未开始的预约");
        return result;
    }

    /**
     * 标记预约为已完成
     */
    @PostMapping("/complete")
    @ResponseBody
    public Map<String, Object> complete(Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("loginUser");
        boolean ok = reservationService.complete(id, user.getId());
        result.put("success", ok);
        result.put("message", ok ? "操作成功，快去评价吧！" : "操作失败，仅已确认的预约可标记为完成");
        return result;
    }

    // =================== 后台管理 ===================

    /**
     * 管理员：预约记录查看
     */
    @GetMapping("/admin/list")
    public String adminList(Model model) {
        model.addAttribute("reservations", reservationService.findAll());
        return "reservation/admin_list";
    }
}
