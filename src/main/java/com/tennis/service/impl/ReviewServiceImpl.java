package com.tennis.service.impl;

import com.tennis.dao.ReviewMapper;
import com.tennis.entity.Review;
import com.tennis.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewMapper reviewMapper;

    @Override
    public List<Review> findByCourtId(Integer courtId) {
        return reviewMapper.findByCourtId(courtId);
    }

    @Override
    public Review findByReservationId(Integer reservationId) {
        return reviewMapper.findByReservationId(reservationId);
    }

    @Override
    public boolean hasReviewed(Integer reservationId) {
        return reviewMapper.findByReservationId(reservationId) != null;
    }

    @Override
    public boolean addReview(Review review) {
        // 验证评分范围
        if (review.getRating() == null || review.getRating() < 1 || review.getRating() > 5) {
            return false;
        }
        // 验证是否已评价过该预约
        if (hasReviewed(review.getReservationId())) {
            return false;
        }
        int result = reviewMapper.insert(review);
        return result > 0;
    }

    @Override
    public boolean deleteReview(Integer reviewId, Integer userId) {
        // 管理员可以删除任何评价，普通用户只能删除自己的评价
        // userId参数在此处用于Service层判断，Controller层已做管理员校验
        int result = reviewMapper.deleteById(reviewId);
        return result > 0;
    }

    @Override
    public List<Review> findAll() {
        return reviewMapper.findAll();
    }
}
