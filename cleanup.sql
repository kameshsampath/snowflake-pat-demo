use role accountadmin;
alter user <%current_user%> unset network_policy;
alter user <%current_user%> remove pat my_demo_pat;

drop network policy if exists ALLOW_ALL_PAT_NETWORK_POLICY;
drop database if exists my_demo_db;