provider "aws" {
    region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state-devops5"

    # Защита от случайного удаления S3 bucket
    # Даже командой terraform destroy невозможно будет удалить эту корзину
    # Если потребуется ее удалить, то просто закомментируйте эти строки
    lifecycle {
        prevent_destroy = true
       }

    versioning {
        enabled = true
    }
    
    # Включить шифрование на стороне Amazon
       server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
            }
        }
    }
}

//locals {
//  devops5-test-bucket_acl_map = {
//    stage = "private"
//    prod = "public"
//  }
//  devops5-test-bucket_acl = devops5-test-bucket_acl_map[terraform.workspace]
//}



resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-state-locks-devops5"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    
    attribute {
        name = "LockID"
        type = "S"
    }
}



locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod = "t3.large"
  }
}

locals {
  web_instance_count_map = {
    stage = 1
    prod  = 2
  }
}

//locals {
//  instances = {
//    "t3.micro" = data.aws_ami.ubuntu.id
//    "t3.large" = data.aws_ami.ubuntu.id
//  }
//}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count_map[terraform.workspace]

  tags = {
    Name = "appServInstance-devops5"
  }
  lifecycle {
    create_before_destroy = true
  }
}

//
//resource "aws_instance" "web2" {
//  for_each = local.instances
//  ami           = each.value
//  instance_type = each.key
//
//  tags = {
//    Name = "appServInstance2"
//  }
//}