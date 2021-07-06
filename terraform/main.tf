provider "aws" {
  region = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"
}

data "aws_ami" "latest-ubuntu-ami" {
  most_recent = true
  owners      = ["312991214358"]
  filter {
    name   = "name"
    values = ["ubuntu-latest-prod-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "server-ssh-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp_server" {
  ami           = data.aws_ami.latest-ubuntu-ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.myapp_SG.id]

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name

  tags = {
    "Name" = "${var.env_prefix}-server"
  }
}
