output "ec2_a_public_ip" {
  value = module.ec2_a.public_ip
}

output "ec2_b_public_ip" {
  value = module.ec2_b.public_ip
}

output "ec2_a_private_ip" {
  value = module.ec2_a.private_ip
}

output "ec2_b_private_ip" {
  value = module.ec2_b.private_ip
}