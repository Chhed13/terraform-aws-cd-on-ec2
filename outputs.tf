output "asg" {
  value = "${aws_autoscaling_group.asg.name}"
}

output "launch_config" {
  value = "${aws_launch_configuration.lc.name}"
}

output "u" {
  value = "${data.template_file.userdata.rendered}"
}