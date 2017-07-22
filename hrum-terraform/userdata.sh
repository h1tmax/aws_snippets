#!/bin/bash -v
yum update -y
yum install -y nginx > /tmp/nginx.log
service nginx start
