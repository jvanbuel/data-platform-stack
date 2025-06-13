#!/usr/bin/env python3

import json
import os

import requests

# Configuration
PORTAL_API_KEY = os.environ["PORTAL_API_KEY"]
PORTAL_BASE_URL = "https://portal.exoscale.robberthofman.com"
OPA_BASE_URL = "http://localhost:8181"


def get_data_products():
    """Get data products from the portal API"""
    url = f"{PORTAL_BASE_URL}/api/data_products"
    headers = {"accept": "application/json", "x-key": PORTAL_API_KEY}
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()


def get_data_product_role_assignments(data_product_id):
    """Get role assignments for a data product from the portal API"""
    url = f"{PORTAL_BASE_URL}/api/role_assignments/data_product"
    headers = {"accept": "application/json", "x-key": PORTAL_API_KEY}
    params = {"data_product_id": data_product_id}
    response = requests.get(url, headers=headers, params=params)
    response.raise_for_status()
    return response.json()


def create_opa_policy_from_all_role_assignments(all_role_assignments, data_products):
    """Create an OPA policy from all role assignments data"""
    if not all_role_assignments:
        return None

    # Create a mapping of data_product_id to data_product_name
    dp_id_to_name = {dp.get("id"): dp.get("name") for dp in data_products}

    # Add data product names to role assignments
    enriched_assignments = {}
    for data_product_id, role_assignments in all_role_assignments.items():
        if role_assignments:
            enriched_assignments[data_product_id] = []
            for assignment in role_assignments:
                assignment_copy = assignment.copy()
                assignment_copy["data_product_name"] = dp_id_to_name.get(
                    data_product_id, data_product_id
                )
                enriched_assignments[data_product_id].append(assignment_copy)

    return enriched_assignments


def post_policy_to_opa(policy_data, policy_name="trino"):
    """Post a policy to OPA"""
    url = f"{OPA_BASE_URL}/v1/policies/{policy_name}"
    headers = {"Content-Type": "text/plain"}

    # Create allowed users list from role assignments
    catalog_users = {}

    for data_product_id, role_assignments in policy_data.items():
        if role_assignments:
            for assignment in role_assignments:
                user_email = assignment.get("user").get("email")
                if user_email:
                    # Group users by data product name (assuming it matches catalog name)
                    dp_name = assignment.get("data_product").get("namespace")
                    if dp_name not in catalog_users:
                        catalog_users[dp_name] = []
                    catalog_users[dp_name].append(user_email)

    # Convert policy to Rego format using your existing structure
    rego_policy = f"""package trino

default allow = false

# catalog-specific user mapping
catalog_users := {json.dumps(catalog_users)}

allow if {{
  input.action.operation != "SelectFromColumns"
}}

allow if {{
  input.action.resource.table.catalogName = "system"
}}

# catalog-specific access control
allow if {{
  catalog_name := input.action.resource.table.catalogName
  catalog_name in object.keys(catalog_users)
  input.context.identity.user in catalog_users[catalog_name]
}}
"""

    print("resulting rego policy:")
    print(f"{rego_policy}")
    response = requests.put(url, headers=headers, data=rego_policy)
    response.raise_for_status()
    return response


def main():
    """Main execution function"""
    print("Fetching data products from portal...")
    data_products = get_data_products()

    if not data_products:
        print("Failed to retrieve data products")
        return

    all_role_assignments = {}

    for dp in data_products:
        data_product_id = dp.get("id")
        data_product_name = dp.get("name")

        print(f"Data Product: {data_product_name} (ID: {data_product_id})")

        # Fetch role assignments for each data product
        role_assignments = get_data_product_role_assignments(data_product_id)

        if role_assignments:
            all_role_assignments[data_product_id] = role_assignments
            print(f"  Found {len(role_assignments)} role assignments")
        else:
            print(f"  No role assignments found")

    if all_role_assignments:
        print("\nAll role assignments retrieved successfully:")
        # print(json.dumps(all_role_assignments, indent=2))

        print("\nCreating OPA policy...")
        policy = create_opa_policy_from_all_role_assignments(
            all_role_assignments, data_products
        )
        print("Posting policy to OPA...")
        result = post_policy_to_opa(policy)
        print(result)
    else:
        print("No role assignments found for any data products")


if __name__ == "__main__":
    main()
