#cloud-config
manage_etc_hosts: true
preserve_hostname: false

packages:
  - mc
  - traceroute
  - telnet

package_upgrade: true

runcmd:
  - hostnamectl set-hostname ${hostname}-$(curl -s http://169.254.169.254/latest/meta-data/instance-id | tail -c 4)
  - cd ${bootstrap_dir}
  - export ${params}
  - for D in ${bootstrap_dir}/*/; do for f in $D*.sh; do sh $f; done; done

output : { all : '| tee -a /var/log/cloud-init-output.log' }