locals {
  name                  = "${format("%0.1s%s",lower(var.env_name),var.short_name)}"
  hostname              = "${local.name}${var.for_windows ? "w" : "l"}"
  default_bootstrap_dir = "${var.for_windows ? "C:\\bootstrap" : "/opt/bootstrap"}"
  linux_params          = "${join(" ",formatlist("%s='%s'",keys(var.params),values(var.params)))}"
  windows_params        = "${join("\n",formatlist("$env:%s=\"%s\"",keys(var.params),values(var.params)))}"
  health_script         = "${ var.health_endpoint == "" ? format("import time; time.sleep(%v)", var.health_timeout) : data.template_file.health.rendered }"
  default_health_timeout = "${ var.for_windows ? 480 : 240}"
}

data "aws_ami" "image" {
  most_recent = true
  filter {
    name   = "name"
    values = ["${var.ami_name != "" ? var.ami_name : format("%s_%s",lower(var.full_name),var.ami_version)}"]
  }
  owners      = ["${var.ami_owner}"]
}

data aws_subnet sn {
  id = "${var.subnet_ids[0]}"
}


data "template_file" "userdata" {
  template = "${file("${path.module}/${var.for_windows ? "userdata.ps1.tpl" : "userdata.tpl"}")}"
  vars {
    hostname      = "${local.hostname}"
    params        = "${var.for_windows ? local.windows_params : local.linux_params}"
    bootstrap_dir = "${var.bootstrap_dir == "" ? local.default_bootstrap_dir : var.bootstrap_dir}"
  }
}

data template_file health {
  template = "${file("${path.module}/health.py.tpl")}"
  vars {
    timeout  = "${var.health_timeout == 0 ? local.default_health_timeout : var.health_timeout}"
    endpoint = "${var.health_endpoint}"
  }
}