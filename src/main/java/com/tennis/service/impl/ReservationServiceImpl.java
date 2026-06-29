package com.tennis.service.impl;

import com.tennis.dao.CourtMapper;
import com.tennis.dao.ReservationMapper;
import com.tennis.entity.Court;
import com.tennis.entity.Reservation;
import com.tennis.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationMapper reservationMapper;

    @Autowired
    private CourtMapper courtMapper;

    @Override
    public List<Reservation> findByUserId(Integer userId) {
        return reservationMapper.findByUserId(userId);
    }

    @Override
    public List<Reservation> findAll() {
        return reservationMapper.findAll();
    }

    @Override
    public boolean book(Reservation res) {
        Court court = courtMapper.findById(res.getCourtId());
        if (court == null || court.getStatus() == null || court.getStatus() == 0) {
            return false;
        }
        List<Reservation> conflicts = reservationMapper.findConflicting(
                res.getCourtId(), res.getReserveDate(), res.getStartTime(), res.getEndTime());
        if (conflicts != null && !conflicts.isEmpty()) {
            return false;
        }
        res.setStatus("confirmed");
        int result = reservationMapper.insert(res);
        return result > 0;
    }

    @Override
    public boolean cancel(Integer id, Integer userId) {
        Reservation reservation = reservationMapper.findById(id);
        if (reservation == null) {
            return false;
        }
        if (!reservation.getUserId().equals(userId)) {
            return false;
        }
        LocalDate reserveDate = LocalDate.parse(reservation.getReserveDate());
        LocalDate today = LocalDate.now();
        if (reserveDate.isBefore(today)) {
            return false;
        }
        reservation.setStatus("cancelled");
        int result = reservationMapper.updateStatus(reservation);
        return result > 0;
    }

    @Override
    public boolean complete(Integer id, Integer userId) {
        Reservation reservation = reservationMapper.findById(id);
        if (reservation == null) {
            return false;
        }
        if (!reservation.getUserId().equals(userId)) {
            return false;
        }
        // 只有已确认的预约才能标记为完成
        if (!"confirmed".equals(reservation.getStatus())) {
            return false;
        }
        int result = reservationMapper.completeReservation(id);
        return result > 0;
    }

    @Override
    public List<Reservation> findConflicting(Court court, String date, String start, String end) {
        return reservationMapper.findConflicting(court.getId(), date, start, end);
    }
}
