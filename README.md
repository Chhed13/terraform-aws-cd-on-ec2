# terraform-aws-cd-on-ec2
Terraform framework module doing CD on simple ec2 instances


## Usage

### Full featured case example

Prerequisites: 
* AWS acc
* know how to create custom AMI
* non-default VPC with private subnets
* VPN into it
* Consul cluster present
* Consul DNS resolving is working
* For external balancing: ALB listeners are prepared
* For health check:
  * `python3` command is working. Python 3.6 is expected
  * package `requests` is installed.
    * on Windows it should be installed separately by running `pip install requests` 

Workflow:
(for details - watch examples)
* prepare (bake) custom AMI
  * Consul
    * install Consul as service
    * put Consul update script into `<bootstrap>/1` dir. It should use ENV variables as parameters
  * Your service 
    * install your service.
    * include into install registration into Consul json. Provision it with healthcheck and version tag (in DNS compliant way)
    * put your service update script into `<bootstrap>/2` dir. It should use ENV variables as parameters
  * any other service - do the same.
  * second layer of dirs in `<bootstrap>` dir will be execute in alphabetical order.
  * AMI bake can be split into several bakes. First install base services (like Consul), next - app services
  * It is very convenient to use Packer for this purposes. Watch examples 
  
* run it with this module
  * prepare module runner
  * fill it with ENV variables that used in scripts
  * pass as health_enpdoint consul DNS name prefixed with version tag that was passed on baking phase and on which you service should return 200
  * make sure that you are in the private network where you Consul DNS names are visible (up VPN if needed)
  * make `terraform apply`
    * it will finish successfully only if healthcheck pass
    * if you update to new version: old version will be terminated only if healthcheck on new one passed
    * if healthcheck failed: both versions will be available, on 2nd fail - 3 verisons, and so on.
      * to fix this: apply successfully and terraform will terminate all the old versions
      * limitation: if the healthcheck fails it's not possible to re-try exact same AMI at once. 
      It will fail with message that ASG with same name already existed. 
      Need to apply any other AMI/version - that will be ok  
  * if ALB listeners were provided - module add service to balancing into ALB
