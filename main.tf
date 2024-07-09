resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
  user_data = file("set_jenkins_sonarqube.sh")

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "Jenkins_SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.sg_name
  }

  ingress {
   for port in [22,80,443,8080,9000]: 
    {
      description = "Inbound rule"
      from_port = port
      to_port = port
      protocol = "tcp"
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
