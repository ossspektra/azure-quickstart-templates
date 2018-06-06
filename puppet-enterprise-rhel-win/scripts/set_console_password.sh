
#!/bin/bash
#
# set_console_password.sh: Set Puppet Enterprise console password
#

ME=$(basename "$0")
pass=$1

# Terminate script with error message
function die
{
    echo "$ME: $1" >&2
    exit 1
}


# Check for root permissions
[ $EUID -ne 0 ] && die "script requires root permissions"

# Use configure-pe.rb to set console password
exec /opt/puppetlabs/azure/bin/configure-pe.rb -i -p "${pass}"
die "exec /opt/puppetlabs/azure/bin/configure-pe.rb failed"
