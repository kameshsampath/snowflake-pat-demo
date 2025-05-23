#!/usr/bin/env sh

set -euo pipefail

snow sql --stdin <<EOF
-- create demo database to hold all our demo objects
create or replace database my_demo_db;
use database my_demo_db;
-- schema to hold all the policies
create or replace schema policies;
-- schema to hold all network rules
create or replace schema networks;
-- Create or alter the authentication policy
create or alter authentication policy my_demo_db.policies.demos_auth_policy
  authentication_methods = ('PASSWORD', 'OAUTH', 'KEYPAIR', 'PROGRAMMATIC_ACCESS_TOKEN')
  pat_policy = (
    default_expiry_in_days=7,
    max_expiry_in_days=90,
    network_policy_evaluation = ENFORCED_NOT_REQUIRED
  );
EOF