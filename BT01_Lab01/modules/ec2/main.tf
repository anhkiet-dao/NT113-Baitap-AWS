resource "aws_security_group" "this" {
  name   = "${var.name}-sg"
  vpc_id = var.vpc_id

  # SSH từ internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ping từ VPC còn lại
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.allowed_cidr]
  }

  # SSH từ VPC còn lại
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  # Outbound all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami           = "ami-0c802847a7dd848c0"
  instance_type = "t3.micro"

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]

  associate_public_ip_address = true

  key_name = var.key_name

  tags = {
    Name = var.name
  }
}