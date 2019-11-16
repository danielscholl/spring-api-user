# Spring API Sample

This repository is a simple API example using CosmosDB.

### Create Environment File

Create an environment setting file in the root directory and microservice directories ie:  `.env.ps1`

Default Environment Settings

| Parameter                     | Default                              | Description                              |
| --------------------          | ------------------------------------ | ---------------------------------------- |
| _ARM_SUBSCRIPTION_ID_         | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Azure Subscription Id                    |
| _AZURE_LOCATION_              | CentralUS                            | Azure Region for Resources to be located |
| _cosmosdb_database_           | __(Post Provision Value)__           | CosmosDB Name                            |
| _cosmosdb_account_            | __(Post Provision Value)__           | CosmosDB URI                             |
| _cosmosdb_key_                | __(Post Provision Value)__           | CosmosDB Primary Key                     |

### Provision Infrastruture

>Note: Scripts are using powershell core and the AZ module

```powershell
./install.ps1 -Show $true  ## Load and validate the environment variables.
./install.ps1   # Provision the Resources
```

After provisioning fill in the __(Post Provision Value)__ for the ComsosDB Name, URI, and Key.

```powershell
./install.ps1 -Show $true ## Load and validate the environment variables.
```

### Run the Application and Test the API

```powershell
mvn clean spring-boot:run
```

Execute the [integration-tests](https://github.com/danielscholl/spring-api-user/blob/master/integration-tests/user.http) using the [Rest Client Extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)