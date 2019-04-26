# az_helpers
Azure CLI helper scripts

## get_ip.sh

Script to get an IP address associated with an Azure Virtual Machine

usage: ./get_ip.sh -n <Virtual Machine Name> -g <Resource Group Name>

switches:

| short  | long | param | description |
| - | ---- | ---| --|
| -n  | --name  | vm | name of the Virtual Machine.
| -g  | --group  | resource_group | Resource group for the virtual machine.
| -d  | --debug  |  | Enable Debug mode.  prints out  detailed azure resource info.
| -h  | --help  |  | Prints out usage information for the script.

