provider "aws" {
  region  = "us-east-1"
  profile = "chhed13"
}

data "aws_caller_identity" "current" {}

module "linux" {
  source           = "../../"
  ami_name         = "myservice_windows_core_2016*"
  ami_owner        = "${data.aws_caller_identity.current.account_id}"
  ami_version      = "*"
  asg_desired_size = 1
  asg_max_size     = 1
  asg_min_size     = 1
  //  bootstrap_dir = ""
  enable_consul    = false
  public_access    = true //only for test
  for_windows      = true
  //    health_endpoint = "http://128.53.75.4:8000/health"
  health_timeout = "300"
  //  iam_policies = ""
  instance_type    = "t3.micro"
  key_name         = "chhed13"
  //  lb_health_check_path = ""
  //  lb_health_check_port = ""
  //  lb_http_listener = ""
  //  lb_https_listener = ""
  params           = {
    CONSUL_JOIN            = "\"provider=aws tag_key=consul_env tag_value=my\""
    CONSUL_DATACENTER      = "my_center"
    CONSUL_DOMAIN          = "my.consul"
    ENVIRONMENT            = "my_env"
    MYSERVICE_SPECIAL_INFO = "my_special_info"
  }
  env_name         = "my"
  service_port     = 8000
  full_name        = "MyService"
  short_name       = "msr"
  subnet_ids       = ["subnet-f7f961ab"]
}

//output "health_script" {
//  value = "${module.linux.health_script}"
//}
//

//output "timeout" {
//  value = "${module.linux.timeout}"
//}