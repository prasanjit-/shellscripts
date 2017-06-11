#!/bin/bash
## -PUPPET SLAVE

# Script at - https://github.com/prasanjit-/shellscripts/blob/master/puppet_slave_install.bash

#Some Prerequisites--
#If you are not using DNS in your envrionment, you will need to manually edit your hosts file on both  machines .
#vim /etc/hosts
#10.1.x.x                node
#10.1.x.y                puppet-server
# The the pem file in below script shpuld be named as `hostname`.pem (modify script and run)

rpm -ivh https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-11.noarch.rpm
yum install -y puppet

#Edit /etc/puppet/puppet.conf and add the agent variables:

#vim /etc/puppet/puppet.conf
# In the [agent] section

echo "server = puppet-server #Should be the FQDN!" >> /etc/puppet/puppet.conf
echo "report = true" >> /etc/puppet/puppet.conf
echo "pluginsync = true" >> /etc/puppet/puppet.conf

chkconfig puppet on
puppet agent --daemonize
puppet agent -t
puppet cert list
puppet cert sign --all
