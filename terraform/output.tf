data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "region_name" {
  value = aws_instance.web.availability_zone
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "instance_private_ip" {
  value = aws_instance.web.private_ip
  description = "this private_ip"
}

output "network_id" {
  value = aws_instance.web.subnet_id
  description = "subnet_id"
}


