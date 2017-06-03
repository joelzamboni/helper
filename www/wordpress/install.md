# Wordpress


```
sudo apt-get install mysql-server
```

```
mysql -p -u root
CREATE DATABASE wordpress_db;
CREATE USER wordpress_user@localhost;
SET PASSWORD FOR wordpress_user@localhost=PASSWORD("123456");
GRANT ALL PRIVILEGES ON wordpress_db.* TO ubuntuhandbook@localhost IDENTIFIED BY '12345678';
FLUSH PRIVILEGES;
```

