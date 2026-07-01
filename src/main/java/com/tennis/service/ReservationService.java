package com.tennis.service;

import com.tennis.entity.Court;
import com.tennis.entity.Reservation;

import java.util.List;

public interface ReservationService {

    List<Reservation> findByUserId(Integer userId);

    List<Reservation> findAll();

    boolean book(Reservation res);

    boolean cancel(Integer id, Integer userId);

    /** 标记预约为已完成（用于评价流程） */
    boolean complete(Integer id, Integer userId);

    /** 按场地和日期查询预约（用于可视化看板） */
    List<Reservation> findByCourtAndDate(Integer courtId, String reserveDate);

    List<Reservation> findConflicting(Court court, String date, String start, String end);
}
