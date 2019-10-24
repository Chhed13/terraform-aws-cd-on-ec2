locals {
  name                  = "${format("%0.1s%s", lower(var.env_name), var.short_name)}${var.for_windows ? "w" : "l"}"
  default_bootstrap_dir = var.for_windows ? "C:\\bootstrap" : "/opt/bootstrap"
  cidr                  = length(var.security_groups_inbound_cidrs) == 0 ? [data.aws_vpc.vpc.cidr_block] : var.security_groups_inbound_cidrs
  linux_params          = join(" ", formatlist("%s='%s'", keys(var.bootstrap_params), values(var.bootstrap_params)))
  windows_params        = join("\n", formatlist("$env:%s='%s'", keys(var.bootstrap_params), values(var.bootstrap_params)))

  default_health_timeout = var.for_windows ? 480 : 240
  health_timeout         = var.health_timeout == 0 ? local.default_health_timeout : var.health_timeout
  health_script          = var.health_endpoint == "" ? "import time; import os; time.sleep(int(os.environ['HEALTH_TIMEOUT']))" : file("${path.module}/health.py")

  tags = merge({
    Name = local.name,
    env  = var.env_name
  }, var.add_tags)
}

data "aws_ami" "image" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_name]
  }
  owners      = [var.ami_owner]
}

data aws_subnet sn {
  id = var.subnet_ids[0]
}

data "aws_vpc" "vpc" {
  id = data.aws_subnet.sn.vpc_id
}


data "template_file" "userdata" {
  template = file("${path.module}/${var.for_windows ? "userdata_windows.tpl" : "userdata_linux.tpl"}")
  vars     = {
    hostname      = local.name
    params        = var.for_windows ? local.windows_params : local.linux_params
    bootstrap_dir = var.bootstrap_dir == "" ? local.default_bootstrap_dir : var.bootstrap_dir
    custom_script = var.for_windows ? var.bootstrap_custom_script : base64encode(var.bootstrap_custom_script)
  }
}