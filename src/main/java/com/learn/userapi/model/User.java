package com.learn.userapi.model;

import com.microsoft.azure.spring.data.cosmosdb.core.mapping.Document;
import com.microsoft.azure.spring.data.cosmosdb.core.mapping.PartitionKey;

import org.springframework.data.annotation.Id;

import lombok.Data;

@Data
@Document(collection = "users")
public class User {

    @Id
    private String id;
    private String firstName;

    @PartitionKey
    private String lastName;
    private String address;


    public String getName() {
        return firstName + " " + lastName;
    }

}