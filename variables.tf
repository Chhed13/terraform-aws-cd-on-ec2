// Source and service //////////////////
variable "full_name" {
  type        = "string"
  description = "Required. Full name of service. Can be cammel case, but without spaces. Ex: MyService"
}

variable "short_name" {
  type        = "string"
  description = "Required. Short name of service. Only lower case, 2-4 letters. Ex: msr"
}

variable "ami_owner" {
  type        = "string"
  description = "Required. Owner of AMI toi use. Account ID or alias"
}

variable "ami_name" {
  type        = "string"
  description = "Required. Name of the AMI to run from. Good practice to have smth like {company_prefix}_{lower(var.full_name)}_{var.ami_version}"
}

variable bootstrap_dir {
  type        = "string"
  default     = ""
  description = "Path to directory with bootstrap scripts. Default is /opt/bootstrap for Lunix and C:\\bootstrap on Windows"
}

variable "bootstrap_params" {
  type        = "map"
  default     = {}
  description = "Optional. Map of bootstrap parameters needed for bootstrap scripts"
}

variable "service_port" {
  description = "Requiered. Port on which service will listen"
}
//// Rotation policy //////////////////////
variable "health_endpoint" {
  type        = "string"
  default     = ""
  description = "Optional. If provided it uses to check is service up and running. Must be in format http://host:port/path"
}

variable "health_timeout" {
  default     = 0
  description = "Optional. Time in seconds to wait new instance to be ready. By default 240 (4min) for Linux and 480 (8min) for Windows"
}

//// External balancing /////////////////
variable "lb_http_listener" {
  default     = ""
  type        = "string"
  description = "Requiered if {var.lb_user_http_listener} is true. Set rule to listen on /{var.middle_name}/* on provided listener"
}

variable "lb_https_listener" {
  default     = ""
  type        = "string"
  description = "Requiered if {var.lb_user_https_listener} is true. Set rule to listen on /{var.middle_name}/* on provided listener"
}

variable "lb_health_check_path" {
  default     = "/"
  type        = "string"
  description = "Optional. Health check path to set with listeners"
}

variable "lb_health_check_port" {
  default     = 0
  description = "Requiered for LB. Port on which health status will answer. Default same as service_port"
}

// AWS Auto-scaling, placement and policy params /////////////////
variable "asg_max_size" {
  default     = 1
  description = "Optional. Maximum instance count in auto-scaling. Must be >= then asg_min_size. Default 1"
}

variable "asg_min_size" {
  default     = 1
  description = "Optional. Minimum instances count in auto-scaling. Default 1"
}

variable "asg_desired_size" {
  default     = 1
  description = "Optional. Desired instances count in auto-scaling. Default 1"
}

variable "instance_type" {
  type        = "string"
  description = "Requiered. Instance type according to AWS notation"
}

variable "subnet_ids" {
  type        = "list"
  description = "Requiered. Subnets where to put instances"
}

variable "iam_policies" {
  default     = []
  type        = "list"
  description = "Optional. Required to access any other AWS resource"
}

variable "public_access" {
  default     = false
  description = "Only for test pupropses. Open Security Groups to the world"
}

variable "key_name" {
  type        = "string"
  description = "Requiered. Admin access SSH key name"
}

// Environment and infra params //////////
variable "env_name" {
  type        = "string"
  description = "Requiered. Envrironment name to run in. Must be at least 1 letter. Usually inheretted from base layer"
}

variable "for_windows" {
  default     = true
  description = "True - apply for Windows, false - for Linux. Default false"
}

variable "enable_consul" {
  default     = false
  description = "True - apply SG, tags for Consul"
}

variable "add_tags" {
  type        = "map"
  default     = {}
  description = "Map of additional tags to provide"
}