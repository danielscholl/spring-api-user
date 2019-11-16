package com.learn.userapi.repository;

import com.learn.userapi.model.User;
import com.microsoft.azure.spring.data.cosmosdb.repository.ReactiveCosmosRepository;

import org.springframework.stereotype.Repository;


@Repository
public interface UserRepository extends ReactiveCosmosRepository<User, String> {
    User findByFirstName(String firstName);
}