#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo docker build -t presenttier:v1 ../presentation-tier/
docker run --restart always -e APPLICATION_LOAD_BALANCER=${application_load_balancer} -p 80:80 -d presenttier:v1
