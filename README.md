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

## GitHub Actions Integration

Fork and clone repository to your local machine. 

```bash
gh repo fork --clone https://github.com/kameshsama/snowflake-pat-demo.git
cd snowflake-pat-demo
```

Then, set up the GitHub secrets for your repository:

```bash
gh secret set SNOWFLAKE_PASSWORD --body "$SNOWFLAKE_PASSWORD"
gh secret set SNOWFLAKE_ACCOUNT --body "$SNOWFLAKE_ACCOUNT"
gh secret set SNOWFLAKE_USER --body "$SNOWFLAKE_USER"
gh secret set SNOWFLAKE_USER --body "$SNOWFLAKE_USER"
```

Now just do a empty commit and push to trigger the GitHub Actions workflow.

```bash
git commit --allow-empty -m "Trigger GitHub Actions"
git push
```

This will run the workflow defined in `.github/workflows/snowflake-pat-demo.yml`, which will use the PAT to connect to Snowflake and perform operations.

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
- `.github/workflows/snowflake-pat-demo.yml`: GitHub Actions workflow file

## Security Notes

- PATs are sensitive credentials and should be handled securely
- Network rules in this demo are for demonstration purposes
- In production, restrict network access to specific IP ranges

## Related Documentation

- [Snowflake PAT Documentation](https://docs.snowflake.com/en/user-guide/programmatic-access-tokens)
- [Snowflake CLI Documentation](https://docs.snowflake.com/en/developer-guide/snowflake-cli/index)