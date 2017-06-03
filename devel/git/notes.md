

### Create package

```
git archive --format=zip HEAD > app.zip
```
```
git pull
```

### Tracking empty directories

Create a _.gitignore_ file inside the empty directory with the following content:

```
# Ignore everything in this directory
*
# Except this file
!.gitignore
```
