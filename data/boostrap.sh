#!/bin/bash
sudo yum update -y

# Install git
sudo yum install git -y
#Clone airflow-repositry
git clone https://github.com/lucasobispo/aws-airflow.git

sudo yum install docker -y

sudo docker-compose up --build

sudo yum install python3-pip -y

sudo pip3 install docker-compose

wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose

sudo systemctl enable docker.service
sudo systemctl start docker.service

sudo usermod -a -G docker ec2-user
id ec2-user
# Reload a Linux user's group assignments to docker w/o logout
newgrp docker


cd ~/aws-airflow/
mkdir -p ./dags ./logs ./plugins ./config
echo -e "AIRFLOW_UID=$(id -u)" > .env

sudo docker-compose up --build





