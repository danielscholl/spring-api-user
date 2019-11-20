package com.learn.userapi.service;

import java.util.List;
import java.util.UUID;

import com.learn.userapi.model.User;
import com.learn.userapi.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
@Profile("azure")
public class UserServiceImp implements UserService {

    @Autowired
    UserRepository repository;

    public User createUser(User user) {
        log.debug("UserServiceImpl:createUser()");
        user.setId(UUID.randomUUID().toString());
        return this.repository.save(user).block();
    }

    public List<User> listUsers() {
        log.debug("UserServiceImpl:listUsers()");
        return this.repository.findAll().collectList().block();
    }

    public User getUser(String id) {
        log.debug("UserServiceImpl:getUser()");
        return this.repository.findById(id).block();
    }

    public User findUserByName(String name) {
        log.debug("UserServiceImpl:findUserByName()");
        return this.repository.findByFirstName(name);
    }

    public User updateUser(User user) {
        log.debug("UserServiceImpl:updateUser()");
        return this.repository.save(user).block();
    }

    public Void deleteUser(String id) {
        log.debug("UserServiceImpl:deleteUser()");
        User user = this.getUser(id);
        return this.repository.delete(user).block();
    }

    public User partialUpdateUser(User user, String id) {
        log.debug("UserServiceImpl:partialUpdateUser()");
        User currentUser = this.getUser(id);

        if(user.getFirstName() != null) {
            currentUser.setFirstName(user.getFirstName());
        }

        if(user.getLastName() != null) {
            currentUser.setLastName(user.getLastName());
        }

        if(user.getAddress() != null) {
            currentUser.setAddress(user.getAddress());
        }

        return repository.save(currentUser).block();
    }
    
}