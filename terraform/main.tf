provider "aws" {
    region = "us-east-2"
}

resource "aws_security_group" "myapp_SG" {
    #vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 5672
        to_port = 5672
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 15672
        to_port = 15672
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
        prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-myapp_SG"
  }
  
}


data "aws_ami" "self_linux_image" {
  most_recent = true
  #owners = ["self"]
  owners = ["312991214358"]
  filter {
    name   = "name"
    values = ["ubuntu-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh_key" {
    key_name = "server-ssh-key"
    #public_key = var.my_public_key
    public_key = file(var.public_key_location)

}

resource "aws_instance" "myapp_server" {
    ami = data.aws_ami.self_linux_image.id
    instance_type = var.instance_type

    vpc_security_group_ids = [aws_security_group.myapp_SG.id]
    #subnet_id = var.subnet_id
    #availability_zone = var.avail_zone

    associate_public_ip_address = true
    #key_name = "jenkins-ssh"
    key_name = aws_key_pair.ssh_key.key_name

    # user_data = file("./entry-script.sh")
    tags = {
      "Name" = "${var.env_prefix}-server"
    }
}
