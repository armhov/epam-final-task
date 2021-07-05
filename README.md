# epam-final-task

# api-gateway

## Introduction
Netflix Zuul is a the reverse proxy server which acts as the API Gateway for accessing the micro services behind the gateway which routes the request to the respective service. Microservice’s stay behind reverse proxy server and needs to be consumed via api gateway. The api-gateway micro service with docker profile runs on port 8080 and can be accessed by http://localhost:8080 .   

Configuration done in API Gateway for Routing:   
```
zuul:
  ignoredServices: '*'
  routes:
    one:
      path: /service-one/**
      serviceId: Service-One
    two:
      path: /service-two/**
      serviceId: Service-Two
```

## Prerequisites 
1. Operating System: Ubuntu 20.04
2. Install `openjdk-8-jdk` and `maven` on your Ubuntu machine 

## Steps to deploy the api-gateway
1. Clone the repository into your Ubuntu machine and navigate to that folder
2. Update the params in the `<>` brackets with the actual values in the `src/main/resources/application.yml` file
3. Run `mvn clean package` in the root directory of the repo (where the pom.xml file is located)
4. Run `java -Xmx256m -Xss32m -Djava.security.egd=file:/dev/./urandom -jar target/api-gateway.jar` to run the app
