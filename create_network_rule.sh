#!/usr/bin/env sh

set -euo pipefail 

# Get GitHub Actions IP ranges only IPV4
GH_CIDRS=$(curl -s https://api.github.com/meta | jq -r '.actions | map(select(contains(":") | not)) | map("'\''" + . + "'\''") | join(",")')

# Get local IP and add /32 suffix
LOCAL_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)/32"

# Combine GitHub CIDRs and local IP
CIDR_VALUE_LIST="${GH_CIDRS},'${LOCAL_IP}'"

snow sql --stdin <<EOF
use role $MY_PAT_DEMO_ROLE;
-- create a new network rule that allows all CIDR (for demo only)
create network rule if not exists my_demo_db.networks.pat_allow_all_access_rule
mode = ingress
type = ipv4
value_list = ($CIDR_VALUE_LIST)
comment = 'Allow all IPv4 addresses for demo purposes.';

use role accountadmin;
-- attach the network rule to the network policy
create network policy if not exists ALLOW_ALL_PAT_NETWORK_POLICY
allowed_network_rule_list = ('my_demo_db.networks.pat_allow_all_access_rule')
comment = 'Network policy to allow all IPv4 addresses.';

-- set the network policy to the user to allow using pat with snowflake cli
alter user $SNOWFLAKE_USER set network_policy='ALLOW_ALL_PAT_NETWORK_POLICY';
EOF