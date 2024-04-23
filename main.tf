resource "aws_s3_bucket" "create_bucket" {
  bucket = "767398038964-raw"
}

resource "aws_s3_bucket" "create_bucket_application" {
  bucket = "767398038964s3-application"
}

resource "aws_security_group" "ssh_http" {
  name        = "permitir_ssh"
  description = "Permite SSH e HTTP na instancia EC2"
  vpc_id      = "vpc-0258b6485b6eeb43f"

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Personalized HTTP to EC2"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "permitir_ssh_e_http"
  }
}

output "security_group_id" {
  value = aws_security_group.ssh_http.id
}

resource "aws_eip" "elastic_ip" {
  vpc = true
  instance = aws_instance.airflow.id
}

resource "aws_instance" "airflow" {
  ami                     = "ami-0f403e3180720dd7e"
  instance_type           = "t2.medium"
  key_name                = "vockey"
  vpc_security_group_ids  = [aws_security_group.ssh_http.id]
  user_data               = "${path.module}/data/bootstrap.sh"


  tags = {
    Name = "airflow"
  }
}

