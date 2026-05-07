region = "ap-southeast-1"

vpc_configs = {
  "vpc-a" = { cidr = "10.0.0.0/16", subnet = "10.0.0.0/24", instance_ip = "10.0.0.10", az = "ap-southeast-1a" }
  "vpc-b" = { cidr = "10.1.0.0/16", subnet = "10.1.0.0/24", instance_ip = "10.1.0.10", az = "ap-southeast-1b" }
  "vpc-c" = { cidr = "10.2.0.0/16", subnet = "10.2.0.0/24", instance_ip = "10.2.0.10", az = "ap-southeast-1a" }
}