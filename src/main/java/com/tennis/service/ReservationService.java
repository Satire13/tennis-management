package com.tennis.service;

import com.tennis.entity.Court;
import com.tennis.entity.Reservation;

import java.util.List;

public interface ReservationService {

    List<Reservation> findByUserId(Integer userId);

    List<Reservation> findAll();

    boolean book(Reservation res);

    boolean cancel(Integer id, Integer userId);

    List<Reservation> findConflicting(Court court, String date, String start, String end);
}
