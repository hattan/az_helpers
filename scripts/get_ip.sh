declare nicId=""
declare ipdId=""
declare vmName=""
declare resourceGroup=""
declare debugMode=false
declare help=false
me=`basename "$0"`

usage() { 
    echo "Usage: $me options"; 
    echo "  -n|--name <virtual machine name>"
    echo "  -g|--group <resource group>"
    echo "  -d|--debug debug mode (optional)"
    echo "  -h|--help help (optional)"
    exit 1; 
}

#parse input
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -n|--name)
    vmName="$2"
    shift # past argument
    shift # past value
    ;;
    -g|--group)
    resourceGroup="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--debug)
    debugMode=true
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    usage
    shift # past argument
    shift # past value
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -z "$vmName" && -z "$resourceGroupName" ]]; then
    usage
fi

if [[ -z "$vmName" ]]; then
    echo "Enter a virtual machine name"
    read vmName
    [[ "${vmName:?}" ]]
fi

if [[ -z "$resourceGroup" ]]; then
    echo "Enter a resource group name"
    read resourceGroup
    [[ "${resourceGroup:?}" ]]
fi



if [ "$debugMode" = true ] ; then
    echo "Looking up NIC ID . VM = $vmName , RG = $resourceGroup"
fi

nicId=$(az vm show -n $vmName -g $resourceGroup --query "networkProfile.networkInterfaces[].id | [0]" --out tsv)

if [ "$debugMode" = true ] ; then
    echo "Looking up IP ID . NIC ID = $nicId"
fi
ipdId=$(az network nic show --id "$nicId" --query "ipConfigurations[].publicIpAddress[].id | [0]" --out tsv)

if [ "$debugMode" = true ] ; then
    echo "Looking up IP Address . IP ID = $ipdId"
fi
az network public-ip show --id "$ipdId" --query "ipAddress"

