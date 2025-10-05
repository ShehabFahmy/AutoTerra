import sys
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
        if command == "apply":
            print("\n[!] Running terraform init...")
            subprocess.run(["terraform", "init"], cwd=project_path, check=True)
            subprocess.run(["terraform", "plan"], cwd=project_path, check=True)
            # if isApproved:
            # print("\n[!] Running terraform apply...")
            # subprocess.run(["terraform", "apply"], cwd=project_path, check=True)
        elif command == "destroy":
            print("\n[!] Running terraform destroy...")
            subprocess.run(["terraform", "destroy"], cwd=project_path, check=True)
    except subprocess.CalledProcessError as e:
        print(f"\n[!] Terraform command failed: {e}")