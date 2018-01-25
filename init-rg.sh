#If necessary, do an az login first
#./init-rg.sh RG-Name southeastasia
RG=$1
LOC=$2
KV="$1-kv"
SEC="$1-secret"
SUB="/subscriptions/ff6294e2-6c87-4b62-b3a3-aba5e0a17c8d/resourceGroups/$RG"
az group create -n $RG -l $LOC
az keyvault create -n $KV -g $RG -l $LOC --enabled-for-template-deployment true
az keyvault secret set --vault-name $KV -n $SEC --file ~/.ssh/id_rsa

sp_id=$(az ad sp list --display-name $RG-cloudprovider|grep objectId|awk -F\" '{ print $4 }')
if [ "$sp_id" != "" ]
then
  az ad sp delete --id $sp_id
fi

az ad sp create-for-rbac -n $RG-cloudprovider --password Pass@word1 --role contributor --scopes $SUB
