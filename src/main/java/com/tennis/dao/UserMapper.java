package com.tennis.dao;

import com.tennis.entity.User;
import java.util.List;

public interface UserMapper {
    User findById(Integer id);
    User findByUsername(String username);
    int insert(User user);
    int update(User user);
    List<User> findAll();
}
