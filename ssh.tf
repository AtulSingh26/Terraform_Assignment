# SSH-Key
resource "tls_private_key" "SSH_KEY" {
  algorithm = "RSA"
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "ssh-key"
  public_key = tls_private_key.SSH_KEY.public_key_openssh
}