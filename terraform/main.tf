
/***********************************
 * Enumerate the AZs for the Region
 ***********************************/
data "aws_availability_zones" "azs" {
  state = "available"
}

/******************************************************
 * VPC. Pure IPv6 is not allowed, so will be dual stack
 ******************************************************/
resource "aws_vpc" "dualstack" {
  cidr_block = var.ipv4_vpc_cidr

  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "dualstack"
  }
}

/******************************************************
 * Subnet. Notice ipv6_native, making this pure IPv6
 ******************************************************/
resource "aws_subnet" "pureipv6" {
  vpc_id            = aws_vpc.dualstack.id
  availability_zone = data.aws_availability_zones.azs.names[0]

  ipv6_native     = true
  ipv6_cidr_block = cidrsubnet(aws_vpc.dualstack.ipv6_cidr_block, 8, 100)

  assign_ipv6_address_on_creation                = true
  enable_dns64                                   = true
  enable_resource_name_dns_aaaa_record_on_launch = true

  tags = {
    Name = "pureipv6"
  }
}

/******************************************************
 * IGW is by definition dual stack on the VPC
 ******************************************************/
resource "aws_internet_gateway" "dualstack" {
  vpc_id = aws_vpc.dualstack.id

  tags = {
    Name = "dualstack"
  }
}

/******************************************************
 * IPv6 Route Table with default route to the IGW
 ******************************************************/
resource "aws_route_table" "pureipv6" {
  vpc_id = aws_vpc.dualstack.id

  tags = {
    Name = "puripv6"
  }
}

resource "aws_route" "pureipv6-defaultrt" {
  route_table_id              = aws_route_table.pureipv6.id
  destination_ipv6_cidr_block = var.ipv6_cidr_any[0]
  gateway_id                  = aws_internet_gateway.dualstack.id
}

resource "aws_route_table_association" "pureipv6" {
  subnet_id      = aws_subnet.pureipv6.id
  route_table_id = aws_route_table.pureipv6.id
}

/*****************************************************************
 * EC2 Instance: Instance, Key Pair, and IPv6 aware Security Group
 *****************************************************************/
resource "aws_key_pair" "pureipv6" {
  key_name   = var.keypair_name
  public_key = file(var.keypair_file)
}

resource "aws_security_group" "pureipv6" {
  name   = "pureipv6-sg"
  vpc_id = aws_vpc.dualstack.id

  ingress {
    description      = "ping"
    from_port        = -1
    to_port          = -1
    protocol         = "icmpv6"
    ipv6_cidr_blocks = var.ipv6_cidr_any
  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = var.ipv6_cidr_any
  }

  ingress {
    description      = "iperf"
    from_port        = 5001
    to_port          = 5001
    protocol         = "tcp"
    ipv6_cidr_blocks = var.ipv6_cidr_any
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = var.ipv6_cidr_any
  }

}

resource "aws_instance" "pureipv6" {
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu_2404.id

  vpc_security_group_ids = [aws_security_group.pureipv6.id]
  subnet_id              = aws_subnet.pureipv6.id
  key_name               = aws_key_pair.pureipv6.key_name

  ipv6_address_count = 1

  /* IMDS is not enabled by default for IPv6 */
  metadata_options {
    http_tokens            = "optional"
    http_protocol_ipv6     = "enabled"
    instance_metadata_tags = "enabled"
  }

  depends_on = [aws_internet_gateway.dualstack]

  tags = {
    Name = "pureipv3-ubuntu"
  }
}

