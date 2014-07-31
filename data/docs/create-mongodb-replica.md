# Create mongoDB Replicas


## Basic Infrastructure Configuration

### Hosts

Configure _/etc/hosts_ 


### Installation




```
openssl rand -base64 741 > mongodb-keyfile
chmod 600 mongodb-keyfile
```




### Create Administrative Users

```
use admin
db.createUser( {
    user: "siteUserAdmin",
    pwd: "<password>",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
});
db.createUser( {
    user: "siteRootAdmin",
    pwd: "<password>",
    roles: [ { role: "root", db: "admin" } ]
});
```

[Source](http://docs.mongodb.org/manual/tutorial/deploy-replica-set-with-auth/)

