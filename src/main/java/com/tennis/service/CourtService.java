package com.tennis.service;

import com.tennis.entity.Court;

import java.util.List;

public interface CourtService {

    List<Court> findAll();

    List<Court> findAvailable();

    Court findById(Integer id);

    int addCourt(Court court);

    int updateCourt(Court court);

    int deleteCourt(Integer id);
}
