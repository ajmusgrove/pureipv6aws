
output "public_ipv6" {
  value = aws_instance.pureipv6.ipv6_addresses[0]
}

output "ipv6_cidr_block" {
  value = aws_vpc.dualstack.ipv6_cidr_block
}

output "ipv6_subnet_cidr_block" {
  value = aws_subnet.pureipv6.ipv6_cidr_block
}

output "instance_ami_id" {
  value = data.aws_ami.ubuntu_2404.id
}

output "instance_ami_name" {
  value = data.aws_ami.ubuntu_2404.name
}

output "availability_zone" {
  value = data.aws_availability_zones.azs.names[0]
}

