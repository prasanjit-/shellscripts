#!/bin/bash
## -PUPPET MASTER

# Script at - https://github.com/prasanjit-/shellscripts/blob/master/puppet_master_install.bash

#Some Prerequisites--
#If you are not using DNS in your envrionment, you will need to manually edit your hosts file on both  machines .
#vim /etc/hosts
#10.1.x.x                node
#10.1.x.y                puppet-server
# The the pem file in below script shpuld be named as `hostname`.pem (modify script and run)


# Installs Puppet Server on CentOS-7
rpm -ivh https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-11.noarch.rpm
yum install -y puppet-server
systemctl start  puppetmaster.service
systemctl enable  puppetmaster.service
yum install -y httpd httpd-devel mod_ssl ruby-devel rubygems gcc-c++ curl-devel zlib-devel make automake  openssl-devel
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
#Check for stable – https://www.ruby-lang.org/en/downloads/
rvm install 2.3.1
gem install rack passenger
passenger-install-apache2-module

### Check the pem file name should be hostname.pem or apache will not start
FILE="/etc/httpd/conf.d/puppetmaster.conf"
cat <<EOF >$FILE
# RHEL/CentOS:
LoadModule passenger_module /usr/local/rvm/gems/ruby-2.3.1/gems/passenger-5.1.4/buildout/apache2/mod_passenger.so
#<IfModule mod_passenger.c>
  PassengerRoot /usr/local/rvm/gems/ruby-2.3.1/gems/passenger-5.1.4
  PassengerDefaultRuby /usr/local/rvm/gems/ruby-2.3.1/wrappers/ruby
#</IfModule>
# And the passenger performance tuning settings:
PassengerHighPerformance On
PassengerUseGlobalQueue On
# Set this to about 1.5 times the number of CPU cores in your master:
PassengerMaxPoolSize 6
# Recycle master processes after they service 1000 requests
PassengerMaxRequests 1000
# Stop processes if they sit idle for 10 minutes
PassengerPoolIdleTime 600
Listen 8140
<VirtualHost *:8140>
    SSLEngine On
    # Only allow high security cryptography. Alter if needed for compatibility.
    SSLProtocol             All -SSLv2
    SSLCipherSuite          HIGH:!ADH:RC4+RSA:-MEDIUM:-LOW:-EXP
    SSLCertificateFile      /var/lib/puppet/ssl/certs/ansible.pem
    SSLCertificateKeyFile   /var/lib/puppet/ssl/private_keys/ansible.pem
    SSLCertificateChainFile /var/lib/puppet/ssl/ca/ca_crt.pem
    SSLCACertificateFile    /var/lib/puppet/ssl/ca/ca_crt.pem
    SSLCARevocationFile     /var/lib/puppet/ssl/ca/ca_crl.pem
    SSLVerifyClient         optional
    SSLVerifyDepth          1
    SSLOptions              +StdEnvVars +ExportCertData
    # These request headers are used to pass the client certificate
    # authentication information on to the puppet master process
    RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
    RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
    RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e
    #RackAutoDetect On
    DocumentRoot /usr/share/puppet/rack/puppetmasterd/public/
    <Directory /usr/share/puppet/rack/puppetmasterd/>
        Options None
        AllowOverride None
        Order Allow,Deny
        Allow from All
    </Directory>
</VirtualHost>

EOF
firewall-cmd --zone=public --add-port=8140/tcp --permanent
firewall-cmd --reload
systemctl restart puppetmaster httpd
#
echo "[master]" >> /etc/puppet/puppet.conf
echo "certname = puppet-server #Use the FQDN here" >> /etc/puppet/puppet.conf
echo "autosign = true" >> /etc/puppet/puppet.conf

#
mkdir -p /usr/share/puppet/rack/puppetmasterd/
cp /usr/share/puppet/ext/rack/config.ru /usr/share/puppet/rack/puppetmasterd/
chown puppet:puppet /usr/share/puppet/rack/puppetmasterd/config.ru
