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
| _PROJECT_PLAN_                | __(Post Provision Value)__           | Azure App Service Plan Name              |
| _PROJECT_WEB_                 | __(Post Provision Value)__           | Azure Web App Name                       |

### Provision Infrastruture

>Note: Scripts are using powershell core and the AZ module

```powershell
./install.ps1 -Show $true  ## Load and validate the environment variables.
./install.ps1   # Provision the Resources
```

After provisioning fill in the __(Post Provision Value)__ for the .env.ps1 variables neccessary to run locally found in the output response from install script.
    - cosmosdb_database
    - cosmosdb_account
    - cosmosdb_key
    - PROJECT_PLAN
    - PROJECT_WEB

_Example Output_
```json
cosmosDbObject:  {
    "cosmosdb_database": "db-cosmos000",
    "cosmosdb_account": "https://db-cosmos000.documents.azure.com:443/",
    "cosmosdb_key": "fNzvwAosQHoDto0ViThuyTm64Uu1Fyuz0gw7nh0NZP5w7MWBeoxQxRZEn2TJPTkLqrd70s6vBgj9yBX9hnxXXg=="
}
webAppObject:    {
    "PROJECT_PLAN": "plan-linux000",
    "PROJECT_WEB": "web-linux000"
}
```

### Run the Application Locally and Test the API  (Optional)

```powershell
# Run compiled locally.
mvn clean spring-boot:run

# Run with Docker
docker-compose up
```

Execute the [integration-tests](https://github.com/danielscholl/spring-api-user/blob/master/integration-tests/user.http) using the [Rest Client Extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)