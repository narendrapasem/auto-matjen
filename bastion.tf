data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
resource "aws_security_group" "bastion" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.lenin-vpc.id

  ingress {
    description = "ssh from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
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
    Name      = "lenin-bastion-sg"
    Terraform = "true"
  }
}

resource "aws_instance" "bastion1" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  key_name = "dev"
  //vpc_id                 = aws_vpc.vpc.id
  subnet_id              = aws_subnet.leninsubpub.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags = {
    Name = "lenin-ec21"
  }
}
