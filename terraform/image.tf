
/*
 * Search for an image rather that hardcoding an AMI, which is region-specific
 */

data "aws_ami" "ubuntu_2404" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu-noble-24.04-*-server-20240927"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

