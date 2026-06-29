package com.tennis.service.impl;

import com.tennis.dao.CourtMapper;
import com.tennis.entity.Court;
import com.tennis.service.CourtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourtServiceImpl implements CourtService {

    @Autowired
    private CourtMapper courtMapper;

    @Override
    public List<Court> findAll() {
        return courtMapper.findAll();
    }

    @Override
    public List<Court> findAllWithRating() {
        return courtMapper.findAllWithRating();
    }

    @Override
    public List<Court> findAvailable() {
        return courtMapper.findAvailable();
    }

    @Override
    public Court findById(Integer id) {
        return courtMapper.findById(id);
    }

    @Override
    public int addCourt(Court court) {
        return courtMapper.insert(court);
    }

    @Override
    public int updateCourt(Court court) {
        return courtMapper.update(court);
    }

    @Override
    public int deleteCourt(Integer id) {
        return courtMapper.deleteById(id);
    }
}
