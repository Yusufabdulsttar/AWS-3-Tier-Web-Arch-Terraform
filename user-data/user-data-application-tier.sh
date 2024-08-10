 #!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo docker build -t apptier:v1 ../application-tier/

docker run -p 80:80 --restart always -e RDS_HOSTNAME=${rds_hostname} -e RDS_USERNAME=${rds_username} -e RDS_PASSWORD=${rds_password} -e RDS_PORT=${rds_port} -e RDS_DB_NAME=${rds_db_name} -d 'apptier:v1'
