# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
#  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraform"
}

resource "aws_iam_server_certificate" "le_cert" {
  name = "Lets_Encrypt_cert"
  certificate_body = "${file("cert.pem")}"
  private_key = "${file("key.pem")}"
}

resource "aws_elb" "hrum2-elb" {
  name = "terraform-hrum-v2"
#  availability_zones = ["${split(",", var.availability_zones)}"]

  subnets         = ["${var.aws_subnet}"]
  security_groups = ["${var.aws_sg}"]
#  instances       = ["${aws_instance.web.*.id}"]

  listener {
    instance_port = 80
    instance_protocol = "HTTP"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.le_cert.arn}"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "${var.health_check_path}"
    interval            = 30
  }
}

resource "aws_autoscaling_group" "hrum2-asg" {
#  availability_zones   = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier  = ["${var.aws_subnet}"]
  name                 = "Terraform-HRUMv2Autoscaling"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.hrum2-lc.name}"
  load_balancers       = ["${aws_elb.hrum2-elb.name}"]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key                 = "Name"
    value               = "${var.tag_Name}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Team"
    value               = "${var.tag_Team}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = "${var.tag_Environment}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "DataClassification"
    value               = "${var.tag_DataClassification}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "CostCenter"
    value               = "${var.tag_CostCenter}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Application"
    value               = "${var.tag_Application}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "LaunchedBy"
    value               = "${var.tag_LaunchedBy}"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "hrum2-lc" {
  name          = "Terraform-HRUMv2Prod"
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"

  # Security group
  security_groups = ["${var.aws_sg}"]
  user_data       = "${file("userdata.sh")}"
  key_name        = "${var.key_name}"
}


#resource "aws_key_pair" "auth" {
#  key_name   = "${var.key_name}"
#  public_key = "${file(var.public_key_path)}"
#}

