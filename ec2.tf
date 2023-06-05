# EC2



resource "aws_instance" "PUBLIC_VM" {
  ami           = "ami-abc123"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key_pair.key_name
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "Public VM"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_instance" "PRIVATE_VM" {
  ami           = "ami-xyz789"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key_pair.key_name
  subnet_id     = aws_subnet.private_subnet.id

  tags = {
    Name = "Private VM"
  }

   provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx"
    ]
  }
}