package com.tennis.service;

import com.tennis.entity.Review;

import java.util.List;

public interface ReviewService {

    /** 根据场地ID查询所有评价 */
    List<Review> findByCourtId(Integer courtId);

    /** 根据预约ID查询评价 */
    Review findByReservationId(Integer reservationId);

    /** 检查某预约是否已评价 */
    boolean hasReviewed(Integer reservationId);

    /** 提交评价 */
    boolean addReview(Review review);

    /** 删除评价 */
    boolean deleteReview(Integer reviewId, Integer userId);

    /** 获取所有评价（管理员） */
    List<Review> findAll();
}
