#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

sudo docker run --restart always -e APPLICATION_LOAD_BALANCER=${application_load_balancer} -p 80:80 -d yusufabdulsttar/web
