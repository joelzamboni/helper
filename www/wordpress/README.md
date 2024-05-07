# Developing WordPress

## Mac

### Steps
1. Install Homebrew

Copy and paste the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install PHP

Copy and paste the following command:

```
brew install php
```

3. Install MySQL

Copy and paste the follow commands:

```
brew install mysql
brew services start mysql
```

4. Install and configure WordPress

Copy and paste the follow commands:

```
mysql -u root
CREATE DATABASE wordpress;
```

```
mkdir -p development/new-site
cd development/new-site
curl --output latest.tar.gz https://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz --strip-components=1
rm latest.tar.gz
php -S localhost:8000
```

Install plugins for development:

* Create Block Theme
* Debug Bar
* Health Check & Troubleshooting
* Performance Lab



