provider "aws" {
  region  = "us-east-1"
}

module "windows" {
  source           = "../../"
  ami_name         = "Windows_Server-2016-English-Core-Base-*" //"amzn2-ami-hvm-2.0.20180622.1-x86_64-gp2"
  ami_owner        = "amazon"
  ami_version      = "*"
  asg_desired_size = 1
  asg_max_size     = 1
  asg_min_size     = 1
  //  bootstrap_dir = ""
  enable_consul    = false
  env_name         = "some"
  for_windows      = true
  full_name        = "MyService"
  //  health_endpoint = ""
  //  health_timeout = ""
  //  iam_policies = ""
  instance_type    = "t3.micro"
  key_name         = "chhed13"
  //  lb_health_check_path = ""
  //  lb_health_check_port = ""
  //  lb_http_listener = ""
  //  lb_https_listener = ""
  params           = {
    CONSUL_JOIN            = "\"provider=aws tag_key=consul_env tag_value=tttag\""
    CONSUL_DATACENTER      = "abab"
    CONSUL_DOMAIN          = "abab"
    ENVIRONMENT            = "my"
    MYSERVICE_SPECIAL_INFO = "my_special_info"
  }
  service_port     = 8000
  short_name       = "msr"
  subnet_ids       = ["subnet-f7f961ab"]
}