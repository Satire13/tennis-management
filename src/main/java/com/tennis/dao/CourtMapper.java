package com.tennis.dao;

import com.tennis.entity.Court;
import java.util.List;

public interface CourtMapper {
    Court findById(Integer id);
    List<Court> findAll();
    List<Court> findAvailable();
    /** 查询所有场地（含评分信息） */
    List<Court> findAllWithRating();
    int insert(Court court);
    int update(Court court);
    int deleteById(Integer id);
}
