terraform {
    backend "s3" {
        bucket = "terraform-state-devops5"
        key = "global/s3/terraform.tfstate"
        region = "us-east-2"
        dynamodb_table = "terraform-state-locks-devops5"
        encrypt = true
    }
}