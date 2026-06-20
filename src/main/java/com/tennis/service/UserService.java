package com.tennis.service;

import com.tennis.entity.User;

import java.util.List;

public interface UserService {

    User login(String username, String password);

    int register(User user);

    User findById(Integer id);

    int updateProfile(User user);

    int updatePassword(Integer id, String oldPwd, String newPwd);

    List<User> findAll();

    List<User> findAllUsers();
}
