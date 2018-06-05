#! /bin/sh
puname="puppet"
sed -i "2i$1 $2" /etc/hosts
sed -i "2i$1 $puname" /etc/hosts
## Old Command ##
#rpm -ivh http://pm.puppetlabs.com/puppet-agent/2016.1.2/1.4.2/repos/el/7/PC1/x86_64/puppet-agent-1.4.2-1.el7.x86_64.rpm
#rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

yum install puppet-agent -y
export PATH=/opt/puppetlabs/bin:$PATH
systemctl start puppet
