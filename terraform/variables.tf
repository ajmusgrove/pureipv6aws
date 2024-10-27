
variable "region" {
  default = "us-east-1"
}

variable "ipv4_vpc_cidr" {
  description = "VPC requires an IPv4 CIDR, this is a limited one"
  default     = "10.100.100.0/24"
}

variable "ipv6_cidr_any" {
  default = ["::/0"]
}

variable "keypair_file" {
  description = "Keypair public key file for accessing the instance"
  default     = "pureipv6.pub"
}

variable "keypair_name" {
  description = "Name in EC2 for the keypair"
  default     = "pureipv6-serverkey"
}

variable "instance_type" {
  default = "t4g.nano"
}
