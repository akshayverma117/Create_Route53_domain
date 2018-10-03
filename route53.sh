#!/bin/bash
ENV=ENV_NAME
DNS=DNS_NAME
TEST=""
function search_zones () {
  local zones
  # Enumerate all zones
  zones=$(aws route53 list-resource-record-sets --hosted-zone-id HOSTED_ZONE_ID --query "ResourceRecordSets[].Name[]" --output text )
  for zone in $zones
  do
        if [ "$zone" != "$ENV" ];
        then
        TEST="NEW"

        else
        TEST="OLD"
        break
        fi
  done
        if [ "$TEST" = "NEW" ]
        then
        # Creates route 53 records based on env name
        aws route53 change-resource-record-sets --hosted-zone-id HOSTED_ZONE_ID --change-batch '{ "Comment": "Testing creating a record set","Changes": [ { "Action": "CREATE", "ResourceRecordSet": { "Name": "'"$ENV"'", "Type": "CNAME", "TTL":120, "ResourceRecords": [ { "Value": "'"$DNS"'" } ] } } ] }'
        echo "New Record set created"
        else
        echo "No Record set Created"
        fi

}
search zones
