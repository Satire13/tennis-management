package com.tennis.controller;

import com.tennis.entity.Reservation;
import com.tennis.entity.Review;
import com.tennis.entity.User;
import com.tennis.service.ReservationService;
import com.tennis.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private ReservationService reservationService;

    /**
     * 撰写评价页面
     */
    @GetMapping("/write")
    public String writePage(@RequestParam Integer reservationId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");

        // 检查是否已评价
        if (reviewService.hasReviewed(reservationId)) {
            model.addAttribute("error", "该预约已评价过，每笔预约只能评价一次");
            return "review/write";
        }

        // 获取预约信息
        List<Reservation> reservations = reservationService.findByUserId(user.getId());
        Reservation target = null;
        for (Reservation r : reservations) {
            if (r.getId().equals(reservationId)) {
                target = r;
                break;
            }
        }

        if (target == null || !target.getUserId().equals(user.getId())) {
            model.addAttribute("error", "无权评价该预约");
            return "review/write";
        }

        model.addAttribute("reservation", target);
        return "review/write";
    }

    /**
     * 提交评价
     */
    @PostMapping("/submit")
    @ResponseBody
    public Map<String, Object> submitReview(@RequestParam Integer reservationId,
                                            @RequestParam Integer courtId,
                                            @RequestParam Integer rating,
                                            @RequestParam(required = false) String content,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("loginUser");

        // 检查是否已评价
        if (reviewService.hasReviewed(reservationId)) {
            result.put("success", false);
            result.put("message", "该预约已评价过");
            return result;
        }

        Review review = new Review();
        review.setReservationId(reservationId);
        review.setUserId(user.getId());
        review.setCourtId(courtId);
        review.setRating(rating);
        review.setContent(content != null ? content.trim() : "");

        if (review.getContent().isEmpty()) {
            result.put("success", false);
            result.put("message", "请输入评价内容");
            return result;
        }

        boolean ok = reviewService.addReview(review);
        result.put("success", ok);
        result.put("message", ok ? "评价提交成功" : "评价失败，请重试");
        return result;
    }

    /**
     * 场地评价列表页
     */
    @GetMapping("/list")
    public String courtReviews(@RequestParam Integer courtId, Model model) {
        List<Review> reviews = reviewService.findByCourtId(courtId);
        // 计算平均评分
        double avgRating = 0;
        if (reviews != null && !reviews.isEmpty()) {
            int total = 0;
            for (Review r : reviews) {
                total += r.getRating();
            }
            avgRating = Math.round(total * 10.0 / reviews.size()) / 10.0;
        }
        model.addAttribute("reviews", reviews);
        model.addAttribute("courtId", courtId);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("reviewCount", reviews != null ? reviews.size() : 0);
        return "review/list";
    }

    /**
     * 管理员：删除评价
     */
    @PostMapping("/admin/delete")
    @ResponseBody
    public Map<String, Object> deleteReview(Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("loginUser");
        if (!"admin".equals(user.getRole())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        boolean ok = reviewService.deleteReview(id, user.getId());
        result.put("success", ok);
        result.put("message", ok ? "删除成功" : "删除失败");
        return result;
    }

    /**
     * 管理员：查看所有评价
     */
    @GetMapping("/all")
    public String allReviews(Model model) {
        List<Review> reviews = reviewService.findAll();
        model.addAttribute("reviews", reviews);
        model.addAttribute("isAdminView", true);
        return "review/list";
    }
}
