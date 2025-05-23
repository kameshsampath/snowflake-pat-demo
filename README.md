# Snowflake PAT (Programmatic Access Token) Demo

This repository demonstrates how to create and use Programmatic Access Tokens (PAT) with Snowflake using the Snow CLI.

## Prerequisites

- [Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli/index) installed
- [jq](https://stedolan.github.io/jq/) command-line JSON processor
- A [Snowflake account](https://signup.snowflake.com/) with appropriate permissions
- [GitHub CLI](https://cli.github.com/) installed
- Unix-like environment (macOS/Linux)

## Environment Setup

Set up your environment variables:

```bash
export SNOWFLAKE_USER="your_username"
export SNOWFLAKE_DEFAULT_CONNECTION_NAME="your_connection"
export MY_PAT_DEMO_ROLE="your_role"
```

## Demo Steps

1. **Prepare Environment**
   ```bash
   ./prepare.sh
   ```
   This creates the necessary database, schemas, and authentication policy.

2. **Setup Network Rules**
   ```bash
   ./create_network_rule.sh
   ```
   Creates network rules to allow access from:
   - GitHub Actions IP ranges
   - Your local machine's IP

3. **Generate PAT**
   ```bash
   export SNOWFLAKE_PASSWORD=$(snow sql --query "ALTER USER IF EXISTS $SNOWFLAKE_USER ADD PAT my_demo_pat ROLE_RESTRICTION = $MY_PAT_DEMO_ROLE" --format=json | jq -r '.[] | .token_secret')
   ```

4. **Verify PAT**
   ```bash
   snow connection test --format=json
   ```

## Cleanup

To remove all created resources:

```bash
./cleanup.sh
```

## Directory Structure

- `prepare.sh`: Sets up initial Snowflake objects
- `create_network_rule.sh`: Creates network rules and policies
- `cleanup.sh`: Removes all created resources
- `connection.json`: Connection details
- `cleanup.sql`: SQL cleanup statements

## Security Notes

- PATs are sensitive credentials and should be handled securely
- Network rules in this demo are for demonstration purposes
- In production, restrict network access to specific IP ranges

## Related Documentation

- [Snowflake PAT Documentation](https://docs.snowflake.com/en/user-guide/programmatic-access-tokens)
- [Snowflake CLI Documentation](https://docs.snowflake.com/en/developer-guide/snowflake-cli/index)