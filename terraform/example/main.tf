resource "aws_instance" "example" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
}

terraform {
    backend "s3" {
        bucket = "terraform-state-devops5"
        key = "workspaces-example/terraform.tfstate"
        region = "us-east-2"
        dynamodb_table = "terraform-state-locks-devops5"
        encrypt = true
    }
}
