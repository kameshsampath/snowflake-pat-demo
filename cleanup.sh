#!/usr/bin/env sh
snow sql --stdin <<EOF
use role accountadmin;
alter user ${SNOWFLAKE_USER} unset network_policy;
alter user ${SNOWFLAKE_USER} remove pat my_demo_pat;

drop network policy if exists ALLOW_ALL_PAT_NETWORK_POLICY;
use role $MY_PAT_DEMO_ROLE;
drop database if exists my_demo_db;
EOF

gh secret delete SNOWFLAKE_PASSWORD
gh secret delete SNOWFLAKE_ACCOUNT
gh secret delete SNOWFLAKE_USER
gh secret delete SNOWFLAKE_HOST

rm -rf "$PWD/connection.json"