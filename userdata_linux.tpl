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
  - for f in $( ls $bootstrap_dir/*/*.sh ) ; do sh $f; done

output : { all : '| tee -a /var/log/cloud-init-output.log' }