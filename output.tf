# output "ec2_global_ips" {
#   value = ["${aws_instance.main.*.public_ip}"]
# }

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2-public1.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2-public1.public_ip
}
