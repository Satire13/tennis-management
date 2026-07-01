package com.tennis.dao;

import com.tennis.entity.Reservation;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface ReservationMapper {
    Reservation findById(Integer id);
    List<Reservation> findByUserId(Integer userId);
    List<Reservation> findAll();
    List<Reservation> findConflicting(@Param("courtId") Integer courtId,
                                       @Param("reserveDate") String reserveDate,
                                       @Param("startTime") String startTime,
                                       @Param("endTime") String endTime);

    /** 冲突检查（带行级锁，防止并发插入） */
    List<Reservation> findConflictingForUpdate(@Param("courtId") Integer courtId,
                                               @Param("reserveDate") String reserveDate,
                                               @Param("startTime") String startTime,
                                               @Param("endTime") String endTime);

    int insert(Reservation res);
    int updateStatus(Reservation res);
    int completeReservation(Integer id);
}
