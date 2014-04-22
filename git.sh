#!/usr/bin/env bash

# This is just a reminder, no error check

echo -n '- GIT Username: '
read username
echo -n '- GIT Email: '
read email

git config --global user.name $username
git config --global user.email $email
git config --global credential.helper 'cache --timeout=3600'
git config --global push.default simple
