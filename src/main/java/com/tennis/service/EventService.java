package com.tennis.service;

import com.tennis.entity.Enrollment;
import com.tennis.entity.Event;

import java.util.List;

public interface EventService {

    List<Event> findAll();

    Event findById(Integer id);

    int createEvent(Event event);

    int updateEvent(Event event);

    int deleteEvent(Integer id);

    boolean enroll(Integer eventId, Integer userId);

    boolean cancelEnrollment(Integer eventId, Integer userId);

    List<Enrollment> getMyEnrollments(Integer userId);

    List<Enrollment> getEventEnrollments(Integer eventId);

    boolean isEnrolled(Integer eventId, Integer userId);
}
