import sys
import os
import yaml
import subprocess
from pathlib import Path

def ReadYaml(sysArgs, callerName):
    if len(sysArgs) != 2:
        print(f"[!] Usage: python {callerName} <path-to-yaml>")
        sys.exit(1)

    yaml_file = sysArgs[1]

    try:
        with open(yaml_file, "r") as file:
            data = yaml.safe_load(file)
    except FileNotFoundError:
        print(f"[!] Error: File '{yaml_file}' not found.")
        sys.exit(1)
    except yaml.YAMLError as e:
        print(f"[!] Error parsing YAML: {e}")
        sys.exit(1)
    return data

def RunTerraform(command, project_path):
    try:
        approve = os.environ.get("APPROVE", "no").lower() == "yes"
        print("\n[!] Running terraform init...")
        subprocess.run(["terraform", "init", "-input=false"], cwd=project_path, check=True)

        if command == "apply":
            print("\n[!] Running terraform init...")
            subprocess.run(["terraform", "init"], cwd=project_path, check=True)
            subprocess.run(["terraform", "plan"], cwd=project_path, check=True)
            # Ask for approval
            approval = input("\nDo you want to apply the Terraform changes? (yes/no): ").strip().lower()
            if approval in ["yes", "y", "Y", "YES", "Yes"]:
                print("\n[!] Running terraform apply...")
                subprocess.run(["terraform", "apply", "-auto-approve"], cwd=project_path, check=True)
            else:
                print("\n[!] Terraform apply canceled by user.")
        elif command == "destroy":
            approval = input("\n[!] Are you sure you want to destroy all Terraform-managed resources? (yes/no): ").strip().lower()
            if approval in ["yes", "y"]:
                print("\n[!] Running terraform destroy...")
                subprocess.run(["terraform", "destroy"], cwd=project_path, check=True)
            else:
                print("\n[!] Terraform destroy canceled by user.")
    except subprocess.CalledProcessError as e:
        print(f"\n[!] Terraform command failed: {e}")
