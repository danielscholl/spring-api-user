package com.learn.userapi.api;

import java.util.List;

import com.learn.userapi.model.User;
import com.learn.userapi.service.UserService;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;


@RestController
@RequestMapping(value={"/api"})

public class UserApi {

    @Autowired
    UserService userService;

    // CREATE
    @PostMapping(value="/user", headers="Accept=application/json")
    @PreAuthorize("hasRole('ROLE_Owner')")
    public ResponseEntity<User> createUser(@RequestBody User user, UriComponentsBuilder ucBuilder){
        System.out.println("Creating User " + user.getName());
        User newUser = userService.createUser(user);
        HttpHeaders headers = new HttpHeaders();

        headers.setLocation(ucBuilder.path("/api/user/{id}").buildAndExpand(user.getId()).toUri());
        return new ResponseEntity<User>(newUser, headers, HttpStatus.CREATED);
    }

    // READ
    @GetMapping(value = "/user/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<User> getUserById(@PathVariable("id") String id) {
        System.out.println("Fetching User with id " + id);
        User user = userService.getUser(id);
        if (user == null) {
            return new ResponseEntity<User>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<User>(user, HttpStatus.OK);
    }

    @GetMapping(value="/user", headers="Accept=application/json")
    public List<User> getAllUser() {
        List<User> userList = userService.listUsers();
        return userList;
    }

    // UPDATE
    @PutMapping(value="/user", headers="Accept=application/json")
    public ResponseEntity<User> updateUser(@RequestBody User currentUser)
    {
        User user = userService.getUser(currentUser.getId());
        if (user==null) {
            return new ResponseEntity<User>(HttpStatus.NOT_FOUND);
        }
        user.setFirstName(currentUser.getFirstName());
        user.setLastName(currentUser.getLastName());
        user.setAddress(currentUser.getAddress());
        userService.updateUser(user);
        return new ResponseEntity<User>(user, HttpStatus.OK);
    }

    @DeleteMapping(value="/user/{id}", headers ="Accept=application/json")
    public ResponseEntity<User> deleteUser(@PathVariable("id") String id){
        User user = userService.getUser(id);
        if (user == null) {
            return new ResponseEntity<User>(HttpStatus.NOT_FOUND);
        }
        userService.deleteUser(id);
        return new ResponseEntity<User>(HttpStatus.NO_CONTENT);
    }

}