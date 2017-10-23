#This file spins up a new ec2 Server and Security Group

provider "aws" {

    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.aws_region}"
}

resource "aws_security_group" "projectsg1" {
  name        = "projectSG"
  description = "Security group for my project"
  
	tags {
        Name = "ProjectSg"
        }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = 449
    to_port     = 449
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }
}

resource "aws_instance" "Projectinstance" {
        ami = "ami-6f68cf0f"
        instance_type ="${var.instance_type}"
        key_name = "${var.key_name}"
        subnet_id = "subnet-296d6371"
        vpc_security_group_ids = ["${aws_security_group.projectSG.id}"]
        tags {
        Name = "ProjectInstance"
        }
		
	provisioner "file" {
    source = "/home/ec2-user/httpd.conf"
    destination = "/etc/httpd/conf/httpd.conf"
  }

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
        
user_data = "${file("apache.sh")}"
user_data = "${file("ssl.sh")}"
user_data = "${file("testconfig.sh")}"
}
