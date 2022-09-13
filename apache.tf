resource "aws_security_group" "apache" {
  name        = "allow_apache"
  description = "Allow apache inbound traffic"
  vpc_id      = aws_vpc.lenin-vpc.id

  ingress {
    description     = "ssh from admin"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    //cidr_blocks      = ["${ chomp(data.http.myip.body)}/32"]
    //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    description     = "for alb enduser"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    //cidr_blocks      = ["${ chomp(data.http.myip.body)}/32"]
    //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "lenin-apache-sg"
    Terraform = "true"
  }
}

resource "aws_instance" "apache1" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  key_name = "dev"
  //vpc_id                 = aws_vpc.vpc.id
  subnet_id              = aws_subnet.leninsubpri.id
  vpc_security_group_ids = [aws_security_group.apache.id]
  iam_instance_profile=aws_iam_instance_profile.test_profile.name
  tags = {
    Name = "lenin-ec22"
  }
}
