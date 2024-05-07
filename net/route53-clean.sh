#!/usr/bin/env bash

set -xe

# Check if AWS in installed
hash aws >/dev/null 2>&1 || pip install awscli 


# Listing all zones
ALL_ZONES=$(aws route53 list-hosted-zones-by-name)

# Excluding important zones
# Define SKIP_ZONES as domain.com. <-don't forget the dot in the end
if [[ -v SKIP_ZONES ]]
then
  EXCLUDE_DOMAINS='select ('
    for SKIP_ZONE in $SKIP_ZONES
    do
      EXCLUDE_DOMAINS+="$ADD_AND.Name!=\"${SKIP_ZONE}\""
      ADD_AND=" and "
    done
  EXCLUDE_DOMAINS+=")"
fi

# Get hosted zones ids
ZONES=$(echo ${ALL_ZONES} | jq -r ".HostedZones[] | $EXCLUDE_DOMAINS | .Id")

for ZONE in ${ZONES}
do
  ALL_RECORDS=$(aws route53 list-resource-record-sets --hosted-zone-id ${ZONE} | \
	  jq '[.ResourceRecordSets[] | select (.Type!="SOA" and .Type!="NS") ] | 
    map ({ "Action": "DELETE", "ResourceRecordSet": . }) | {"Changes": . } ')
  if [[ "$(echo $ALL_RECORDS | jq length)" -gt "1" ]]
  then
    aws route53 change-resource-record-sets --hosted-zone-id ${ZONE} --change-batch file://<(echo ${ALL_RECORDS})
  else
    aws route53 delete-hosted-zone --id ${ZONE}
  fi
done
