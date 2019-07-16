terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = "us-east-1"
  profile = "chhed13"
  version = "~> 2.17.0"
}

data "aws_caller_identity" "current" {
}

module "windows" {
  source           = "../../"
  ami_name         = "Windows_Server-2016-English-Core-Base-*" // "myservice_windows_core_2016*"
  ami_owner        = "amazon"// data.aws_caller_identity.current.account_id
  asg_desired_size = 1
  asg_max_size     = 1
  asg_min_size     = 1

  //  bootstrap_dir = ""
  enable_consul = false
  for_windows   = true

  //    health_endpoint = "http://128.53.75.4:8000/health"
  health_timeout = "300"

  //  iam_policies = ""
  instance_type = "t3.micro"
  key_name      = "chhed13"

  //  lb_health_check_path = ""
  //  lb_health_check_port = ""
  //  lb_http_listener = ""
  //  lb_https_listener = ""
  bootstrap_params = {
    CONSUL_JOIN            = "\"provider=aws tag_key=consul_env tag_value=my\""
    CONSUL_DATACENTER      = "my_center"
    CONSUL_DOMAIN          = "my.consul"
    ENVIRONMENT            = "my_env"
    MYSERVICE_SPECIAL_INFO = "my_special_info"
  }
  env_name     = "my"
  service_port = 8000
  full_name    = "MyService"
  short_name   = "msr"
  subnet_ids   = ["subnet-f7f961ab"]
  add_tags = {
    version    = "0.1.1"
    consul_env = "my"
  }
  security_groups_inbound_cidrs = ["0.0.0.0/0"] # only for test purposes
}

