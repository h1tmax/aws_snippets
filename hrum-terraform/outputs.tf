output "address" {
  value = "${aws_elb.hrum2-elb.dns_name}"
}
