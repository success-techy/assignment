resource "aws_security_group" "demo_var" {

name = "demo_var"
vpc_id = "vpc-0ee6acba0b2dc76e3"

ingress {
        description = "Demo-SG"
        from_port = 19999
        to_port = 19999
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
ingress {
        description = "Demo-SG"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
ingress {
        description = "Demo-SG"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

}
resource "aws_instance" "centos_instance" {
  ami = "ami-0d3a2960fcac852bc"
  instance_type = "t2.micro"
  key_name = "chaco-key"
  security_groups = [aws_security_group.demo_var.id]
  subnet_id = "subnet-07fb9578b80d60728"

  tags = {
    Name = "c8.local"
  }
user_data = <<EOF
#!/bin/bash
sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
systemctl restart sshd
echo "redhat" | passwd --stdin root
hostnamectl set-hostname c8.local
EOF
}

output "frontend_ip" {
  value = aws_instance.centos_instance.public_ip
}

resource "aws_instance" "ubuntu_instance" {
  ami = "ami-0705384c0b33c194c"
  instance_type = "t2.micro"
  key_name = "chaco-key"
  security_groups = [aws_security_group.demo_var.id]
  subnet_id = "subnet-07fb9578b80d60728"
  tags = {
    Name = "u21.local"
  }
user_data = <<EOF
#!/bin/bash
sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
systemctl restart sshd
echo "root:redhat" | sudo chpasswd
hostnamectl set-hostname u21.local
EOF
}

output "backend_ip" {
  value = aws_instance.ubuntu_instance.public_ip
}
