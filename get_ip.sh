declare nicId=""
declare ipdId=""
declare vmName=""
declare resourceGroup=""
declare debugMode=false
declare help=false
me=`basename "$0"`

usage() { 
    echo "Usage: $me options"; 
    echo "  -n <virtual machine name>"
    echo "  -g <resource group>"
    echo "  -d <image tag> (optional)"
    exit 1; 
}

#parse input
while getopts ":b:r:t:s:d:n:g:" arg; do
    case "${arg}" in
        n)
            vmName=${OPTARG}
        ;;
        g)
            resourceGroup=${OPTARG}
        ;;
        d)
            debugMode=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

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

