package com.tennis.service;

import com.tennis.entity.Court;

import java.util.List;

public interface CourtService {

    List<Court> findAll();

    /** 查询所有场地（含评分信息） */
    List<Court> findAllWithRating();

    List<Court> findAvailable();

    Court findById(Integer id);

    int addCourt(Court court);

    int updateCourt(Court court);

    int deleteCourt(Integer id);
}
