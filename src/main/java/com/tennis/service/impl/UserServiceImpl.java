package com.tennis.service.impl;

import com.tennis.dao.UserMapper;
import com.tennis.entity.User;
import com.tennis.service.UserService;
import com.tennis.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String username, String password) {
        User user = userMapper.findByUsername(username);
        if (user == null) {
            return null;
        }
        String encryptedPassword = MD5Util.encrypt(password);
        if (!encryptedPassword.equals(user.getPassword())) {
            return null;
        }
        if (user.getStatus() == null || user.getStatus() == 0) {
            return null;
        }
        return user;
    }

    @Override
    public int register(User user) {
        User existingUser = userMapper.findByUsername(user.getUsername());
        if (existingUser != null) {
            return 0;
        }
        user.setPassword(MD5Util.encrypt(user.getPassword()));
        user.setRole("user");
        user.setStatus(1);
        return userMapper.insert(user);
    }

    @Override
    public User findById(Integer id) {
        return userMapper.findById(id);
    }

    @Override
    public int updateProfile(User user) {
        return userMapper.update(user);
    }

    @Override
    public int updatePassword(Integer id, String oldPwd, String newPwd) {
        User user = userMapper.findById(id);
        if (user == null) {
            return 0;
        }
        String encryptedOldPwd = MD5Util.encrypt(oldPwd);
        if (!encryptedOldPwd.equals(user.getPassword())) {
            return 0;
        }
        user.setPassword(MD5Util.encrypt(newPwd));
        return userMapper.update(user);
    }

    @Override
    public List<User> findAll() {
        return userMapper.findAll();
    }

    @Override
    public List<User> findAllUsers() {
        return userMapper.findAll();
    }
}
