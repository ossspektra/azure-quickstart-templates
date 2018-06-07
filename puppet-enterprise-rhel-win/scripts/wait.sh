#!/bin/bash
#Configure Puppet Enterprise on first boot
#

ME=$(basename "$0")

# Terminate script with error message
function die
{
    echo "$ME: $1" >&2
    exit 1
}

function usage
{
  die "Usage: $0 [FQDN of vm]"
}

fqdn=$1
pass=$2
if [ -z "${fqdn}" ];then
  usage
fi
# Ensure local hostname is resolvable

publicip=$(dig "${fqdn}" +short) || die "Unable to dig ${fqdn} to determine the public ip"

cat << EOF >> /etc/hosts
# Puppet Enterprise must resolve local hostname(s)
${publicip} ${fqdn}
EOF

echo "Install started of PE" > /tmp/pe_install.log


# Use configure-pe.rb to configure PE
exec /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/azure/bin/configure-pe.rb -m "${fqdn}" >> /tmp/pe_install.log 2>&1
die "exec /opt/puppetlabs/azure/bin/configure-pe.rb failed"


while :
do
  curl -k -s https://localhost:8140/status/v1/services | python -c 'import json,sys;obj=json.load(sys.stdin);sys.exit(0) if (obj["pe-master"]["state"] == "running") else sys.exit(1);'
  if [[ $? == 0 ]]; then
    exit
  fi
  sleep 5
done
sleep 3m

curl -k https://raw.githubusercontent.com/ossspektra/azure-quickstart-templates/puppet-enterprise-version-update/puppet-enterprise-rhel-win/scripts/set_console_password.sh > set_password.sh
chmod +x set_password.sh
sudo sh set_password.sh $pass
