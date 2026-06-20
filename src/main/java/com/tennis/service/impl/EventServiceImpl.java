package com.tennis.service.impl;

import com.tennis.dao.EnrollmentMapper;
import com.tennis.dao.EventMapper;
import com.tennis.entity.Enrollment;
import com.tennis.entity.Event;
import com.tennis.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class EventServiceImpl implements EventService {

    @Autowired
    private EventMapper eventMapper;

    @Autowired
    private EnrollmentMapper enrollmentMapper;

    @Override
    public List<Event> findAll() {
        List<Event> events = eventMapper.findAll();
        refreshEventStatuses(events);
        return events;
    }

    @Override
    public Event findById(Integer id) {
        Event event = eventMapper.findById(id);
        if (event != null) {
            refreshEventStatus(event);
        }
        return event;
    }

    @Override
    public int createEvent(Event event) {
        event.setStatus("upcoming");
        return eventMapper.insert(event);
    }

    @Override
    public int updateEvent(Event event) {
        return eventMapper.update(event);
    }

    @Override
    public int deleteEvent(Integer id) {
        return eventMapper.deleteById(id);
    }

    @Override
    public boolean enroll(Integer eventId, Integer userId) {
        Event event = eventMapper.findById(eventId);
        if (event == null) {
            return false;
        }
        // 刷新赛事状态
        refreshEventStatus(event);
        if (!"upcoming".equals(event.getStatus())) {
            return false;
        }
        // 检查名额 — 使用子查询实时计数
        int count = enrollmentMapper.countByEventId(eventId);
        if (count >= event.getMaxPlayers()) {
            return false;
        }
        // 检查重复报名
        Enrollment existing = enrollmentMapper.findByUserAndEvent(userId, eventId);
        if (existing != null && "enrolled".equals(existing.getStatus())) {
            return false;
        }
        // 如果之前取消过，恢复报名
        if (existing != null && "cancelled".equals(existing.getStatus())) {
            existing.setStatus("enrolled");
            enrollmentMapper.updateStatus(existing);
            return true;
        }
        Enrollment enrollment = new Enrollment();
        enrollment.setEventId(eventId);
        enrollment.setUserId(userId);
        enrollment.setStatus("enrolled");
        int result = enrollmentMapper.insert(enrollment);
        return result > 0;
    }

    @Override
    public boolean cancelEnrollment(Integer eventId, Integer userId) {
        Enrollment enrollment = enrollmentMapper.findByUserAndEvent(userId, eventId);
        if (enrollment == null) {
            return false;
        }
        enrollment.setStatus("cancelled");
        int result = enrollmentMapper.updateStatus(enrollment);
        return result > 0;
    }

    @Override
    public List<Enrollment> getMyEnrollments(Integer userId) {
        return enrollmentMapper.findByUserId(userId);
    }

    @Override
    public List<Enrollment> getEventEnrollments(Integer eventId) {
        return enrollmentMapper.findByEventId(eventId);
    }

    @Override
    public boolean isEnrolled(Integer eventId, Integer userId) {
        Enrollment enrollment = enrollmentMapper.findByUserAndEvent(userId, eventId);
        return enrollment != null && "enrolled".equals(enrollment.getStatus());
    }

    /**
     * 刷新单个赛事状态：根据当前日期自动更新状态
     */
    private void refreshEventStatus(Event event) {
        if (event == null || "cancelled".equals(event.getStatus())) {
            return;
        }
        LocalDate today = LocalDate.now();
        LocalDate eventDate = LocalDate.parse(event.getEventDate());
        if (eventDate.isBefore(today) && "upcoming".equals(event.getStatus())) {
            event.setStatus("finished");
            eventMapper.updateStatus(event);
        } else if (eventDate.isEqual(today) && "upcoming".equals(event.getStatus())) {
            event.setStatus("ongoing");
            eventMapper.updateStatus(event);
        }
    }

    /**
     * 批量刷新赛事状态
     */
    private void refreshEventStatuses(List<Event> events) {
        if (events == null) return;
        for (Event event : events) {
            refreshEventStatus(event);
        }
    }
}
