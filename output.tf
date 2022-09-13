output "vpc" {
  //value = data.aws_availability_zone
  value = aws_vpc.lenin-vpc.id
}