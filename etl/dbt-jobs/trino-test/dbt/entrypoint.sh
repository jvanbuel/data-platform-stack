#/bin/bash

# Exit immediately on any error
set -e

# Check if TARGET is set
if [[ -z "$TARGET" ]]; then
  echo "TARGET environment variable is not set, using default."
  if dbt run; then
    echo "dbt run succeeded."
  else
    echo "dbt run failed."
    exit 1
  fi
else
  if dbt run --target "$TARGET"; then
    echo "dbt run succeeded."
  else
    echo "dbt run failed."
    exit 1
  fi
fi

echo "dbt run completed successfully"