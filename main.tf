terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }
  }
}
#K8 provider
provider "kubernetes" {
  config_path = "~/.kube/config"
}
#Postgres k8 deployment resource
resource "kubernetes_deployment" "deployment-postgres" {
  metadata {
    name = "postgres-deploy"
    labels = {
      name = "postgres-deploy"
      app = "demo-voting-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "postgres-pod"
        app = "demo-voting-app"
      }
    }

    template {
      metadata {
        name = "postgres-pod"
        labels = {
          name = "postgres-pod"
          app = "demo-voting-app"
        }
      }

      spec {
        container {
          image = "postgres"
          name  = "postgres"
          port {
            container_port = "5432"
          }
          env {
            name = "POSTGRES_USER"
            value = "postgres"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value = "postgres"
          }
          env {
            name = "POSTGRES_HOST_AUTH_METHOD"
            value = "trust"
          }
        }
      }
    }
  }
}

#Redis k8 deployment resource
resource "kubernetes_deployment" "deployment-redis" {
  metadata {
    name = "redis-deploy"
    labels = {
      name = "redis-deploy"
      app = "demo-voting-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "redis-pod"
        app = "demo-voting-app"
      }
    }

    template {
      metadata {
        name = "redis-pod"
        labels = {
          name = "redis-pod"
          app = "demo-voting-app"
        }
      }

      spec {
        container {
          image = "redis"
          name  = "redis"
          port {
            container_port = "6379"
          }
        }
      }
    }
  }
}
#Result-app k8 deployment resource
resource "kubernetes_deployment" "deployment-result-app" {
  metadata {
    name = "result-app-deploy"
    labels = {
      name = "result-app-deploy"
      app = "demo-voting-app"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "result-app-pod"
        app = "demo-voting-app"
      }
    }
    template {
      metadata {
        name = "result-app-pod"
        labels = {
          name = "result-app-pod"
          app = "demo-voting-app"
        }
      }
      spec {
        container {
          image = "result-app"
          name  = var.result_app_image
          port {
            container_port = "80"
          }
        }
      }
    }
  }
}
#Voting-app k8 deployment resource
resource "kubernetes_deployment" "deployment-voting-app" {
  metadata {
    name = "voting-app-deploy"
    labels = {
      name = "voting-app-deploy"
      app = "demo-voting-app"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "voting-app-pod"
        app = "demo-voting-app"
      }
    }
    template {
      metadata {
        name = "voting-app-pod"
        labels = {
          name = "voting-app-pod"
          app = "demo-voting-app"
        }
      }
      spec {
        container {
          image = "voting-app"
          name  = var.voting_app_image
          port {
            container_port = "80"
          }
        }
      }
    }
  }
}
#Worker-app k8 deployment resource
resource "kubernetes_deployment" "deployment-worker-app" {
  metadata {
    name = "worker-app-deploy"
    labels = {
      name = "worker-app-deploy"
      app = "demo-voting-app"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "worker-app-pod"
        app = "demo-voting-app"
      }
    }
    template {
      metadata {
        name = "worker-app-pod"
        labels = {
          name = "worker-app-pod"
          app = "demo-voting-app"
        }
      }
      spec {
        container {
          image = "worker-app"
          name  = var.worker_app_image
        }
      }
    }
  }
}
#Postgres k8 service
resource "kubernetes_service" "postgres_service" {
  metadata {
    name = "db"
    labels = {
      name = "postgres-service"
      app = "demo-voting-app"
    }
  }
  spec {
    selector = {
      name = "postgres-pod"
      app = "demo-voting-app"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}
#Redis k8 service
resource "kubernetes_service" "redis_service" {
  metadata {
    name = "redis"
    labels = {
      name = "redis-service"
      app = "demo-voting-app"
    }
  }
  spec {
    selector = {
      name = "redis-pod"
      app = "demo-voting-app"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}
#Result-app k8 service
resource "kubernetes_service" "result_app_service" {
  metadata {
    name = "result-service"
    labels = {
      name = "result-service"
      app = "demo-voting-app"
    }
  }
  spec {
    selector = {
      name = "result-app-pod"
      app = "demo-voting-app"
    }
    port {
      port        = 80
      target_port = 80
      node_port = 30005
    }
    type = "NodePort"
  }
}
#Voting-app k8 service
resource "kubernetes_service" "voting_app_service" {
  metadata {
    name = "voting-service"
    labels = {
      name = "voting-service"
      app = "demo-voting-app"
    }
  }
  spec {
    selector = {
      name = "voting-app-pod"
      app = "demo-voting-app"
    }
    port {
      port        = 80
      target_port = 80
      node_port = 30004
    }
    type = "NodePort"
  }
}


#Create an IAM  user on aws console and attach Admin access policy and copy the access and secret keys
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_iam_access_key
  secret_key = var.aws_iam_secret_key
}

#To connect to the EC2 we need a key-pair, for which we would be using the below providers
resource "tls_private_key" "keypair_rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2_key_pair"
  public_key = tls_private_key.keypair_rsa_4096.public_key_openssh
}
resource "local_file" "ec2_private_key" {
  content  = tls_private_key.keypair_rsa_4096.private_key_pem
  filename = var.private_key
}

resource "aws_instance" "web_server" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  subnet_id                   = aws_subnet.webserver_subnet.id
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  associate_public_ip_address = true
  availability_zone = aws_subnet.webserver_subnet.availability_zone

  tags = {
    Name = "3_Tier_WebApplication"
  }

  provisioner "file" {
    source      = "preDep.sh"
    destination = "/tmp/preDep.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /tmp/preDep.sh",
      "sudo /tmp/preDep.sh"
    ]

  }

  connection {
    type        = "ssh"
    user        = var.webser_user
    host        = aws_instance.web_server.public_ip
    timeout     = "5m"
    private_key = tls_private_key.keypair_rsa_4096.private_key_pem
  }
}
#Define a virtual private cloud with /16 block cidr
resource "aws_vpc" "webserver_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "webserver_vpc"
  }
}
#Create a subnet
resource "aws_subnet" "webserver_subnet" {
  vpc_id                  = aws_vpc.webserver_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.aws_az
  tags = {
    Name = "webserver_subnet"
  }
}
#Attach the vpc with a internet gateway to access the instance over internet.
resource "aws_internet_gateway" "internet_gateway_for_webserver" {
  vpc_id = aws_vpc.webserver_vpc.id

  tags = {
    Name = "Internet Gateway for WebServer"
  }
}
#Define a rout table for that
resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.webserver_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_for_webserver.id
  }

  tags = {
    Name = "Route"
  }
}
#Attach the Subnet and Route table
resource "aws_route_table_association" "route_table" {
  subnet_id      = aws_subnet.webserver_subnet.id
  route_table_id = aws_route_table.vpc_route_table.id
}

#Define in-bound and out-bound traffic
resource "aws_security_group" "webserver_sg" {
  name   = "webserver_sg"
  vpc_id = aws_vpc.webserver_vpc.id

  ingress {
    description = "Allow SSH port to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    description = "Allow Postgres port to EC2"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    description = "Allow Redis port to EC2"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    description = "Allow Redis port to EC2"
    from_port   = 30005
    to_port     = 30005
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }
  
  ingress {
    description = "Allow Redis port to EC2"
    from_port   = 30004
    to_port     = 30004
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = "Allow HTTP Port to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = "Allow HTTPs Port to EC2"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }
}

output "public_ip_ec2" {
  value = aws_instance.web_server.public_ip
}
output "webserver_user" {
  value = var.webser_user
}
