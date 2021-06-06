output "s3_bucket_arn" {
    value = aws_s3_bucket.terraform_state.arn
    description = "ARN(Amazon Resource Name) S3 Bucket"
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.terraform_locks.name
    description = "Таблица DynamoDB"
}