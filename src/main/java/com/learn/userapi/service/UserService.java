package com.learn.userapi.service;

import java.util.List;

import com.learn.userapi.model.User;

public interface UserService {
    
    public User createUser(User user);
    public List<User> listUsers();
    public User getUser(String id);
    public User findUserByName(String name);
    public User updateUser(User user);
    public Void deleteUser(String id);
    public User partialUpdateUser(User user, String id);
    
}
