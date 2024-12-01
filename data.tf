data "aws_vpc" "selected" {
  id = "vpc-03384bddf29ad7137"
}

data "aws_subnet" "subnet1" {
  id = "subnet-05e4bf85d0505a16d"
}

data "aws_subnet" "subnet2" {
  id = "subnet-0b6c79aeddba8a452"
}
