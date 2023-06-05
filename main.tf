resource "aws_vpc" "CUSTOM_VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Custom VPC"
  }
}





