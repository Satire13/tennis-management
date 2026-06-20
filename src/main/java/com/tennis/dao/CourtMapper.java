package com.tennis.dao;

import com.tennis.entity.Court;
import java.util.List;

public interface CourtMapper {
    Court findById(Integer id);
    List<Court> findAll();
    List<Court> findAvailable();
    int insert(Court court);
    int update(Court court);
    int deleteById(Integer id);
}
