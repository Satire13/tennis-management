package com.tennis.dao;

import com.tennis.entity.Review;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface ReviewMapper {
    /** 根据场地ID查询所有评价 */
    List<Review> findByCourtId(Integer courtId);

    /** 根据预约ID查询评价（检查是否已评价） */
    Review findByReservationId(Integer reservationId);

    /** 根据用户ID查询评价 */
    List<Review> findByUserId(Integer userId);

    /** 根据场地ID获取平均评分 */
    Double getAvgRatingByCourtId(Integer courtId);

    /** 根据场地ID获取评价数量 */
    Integer getReviewCountByCourtId(Integer courtId);

    /** 插入一条评价 */
    int insert(Review review);

    /** 删除一条评价 */
    int deleteById(Integer id);

    /** 获取所有评价（管理员） */
    List<Review> findAll();
}
