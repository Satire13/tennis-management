package com.tennis.dao;

import com.tennis.entity.Enrollment;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface EnrollmentMapper {
    Enrollment findById(Integer id);
    Enrollment findByUserAndEvent(@Param("userId") Integer userId, @Param("eventId") Integer eventId);
    List<Enrollment> findByUserId(Integer userId);
    List<Enrollment> findByEventId(Integer eventId);
    int countByEventId(Integer eventId);
    int insert(Enrollment enrollment);
    int updateStatus(Enrollment enrollment);
}
