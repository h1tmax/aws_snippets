variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "id_rsa"

}

variable "availability_zones" {
  description = "List of availability zones, use AWS CLI to find your"
  default     = "us-west-2a"
}


variable "instance_type" {
  description = "AWS instance type"
  default     = "t2.micro"
}

variable "aws_subnet" {
  default = "subnet-9a5414ed"
}

variable "aws_sg" {
  default = "sg-8ef8b7f5"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "2"
}

variable "tag_Name" {
  default = "HRUMv2 Autoscaling"
}

variable "tag_Team" {
  default = "HRUM"
}

variable "tag_Environment" {
  default = "PROD"
}

variable "tag_DataClassification" {
  default = "Sensitive"
}

variable "tag_CostCenter" {
  default = "30119"
}

variable "tag_Application" {
  default = "HRUM"
}

variable "tag_LaunchedBy" {
  default = "igrynko"
}

variable "health_check_path" {
#  default = "HTTP:8080/1x1.gif"
  default = "HTTP:80/"
}

variable "aws_amis" {
  default = {
    us-west-1 = "ami-327f5352"
    us-west-2 = "ami-6df1e514"
  }
}
