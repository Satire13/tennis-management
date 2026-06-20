package com.tennis.dao;

import com.tennis.entity.Event;
import java.util.List;

public interface EventMapper {
    Event findById(Integer id);
    List<Event> findAll();
    List<Event> findByStatus(String status);
    List<Event> findByCreatorId(Integer creatorId);
    int insert(Event event);
    int update(Event event);
    int updateStatus(Event event);
    int deleteById(Integer id);
}
