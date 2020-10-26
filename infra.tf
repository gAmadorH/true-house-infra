provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_key_pair" "default" {
  key_name   = "deployer-key"
  public_key = file("terraform_rsa.pub")
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow ssh"
  description = "allow ssh traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow web"
  description = "allow web traffic"
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}


variable "POSTGRES_DB" {
  type        = string
  default     = "db"
  description = "postgres db"
}

variable "POSTGRES_USER" {
  type        = string
  default     = "user"
  description = "postgres user"
}


variable "POSTGRES_PASSWORD" {
  type        = string
  default     = "password"
  description = "postgres password"
}

variable "POSTGRES_HOST" {
  type        = string
  default     = "localhost"
  description = "postgres host"
}

data "template_file" "init" {
  template = file("scripts/userdata.yaml")
  vars = {
    POSTGRES_DB       = var.POSTGRES_DB
    POSTGRES_USER     = var.POSTGRES_USER
    POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
    POSTGRES_HOST     = var.POSTGRES_HOST
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = data.template_file.init.rendered
  security_groups = [
    aws_security_group.allow_ssh.name,
    aws_security_group.allow_web.name
  ]
  key_name = aws_key_pair.default.key_name
}
