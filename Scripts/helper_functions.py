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
            print("\n[!] Running terraform plan (no color)...")
            subprocess.run(["terraform", "plan", "-no-color", "-input=false"], cwd=project_path, check=True)
            if approve:
                print("\n[!] Running terraform apply -auto-approve (no color)...")
                subprocess.run(["terraform", "apply", "-auto-approve", "-input=false", "-no-color"], cwd=project_path, check=True)
        elif command == "destroy":
            if approve:
                print("\n[!] Running terraform destroy -auto-approve (no color)...")
                subprocess.run(["terraform", "destroy", "-auto-approve", "-input=false", "-no-color"], cwd=project_path, check=True)
            else:
                print("\n[!] Running terraform plan -destroy (plan only, no color)...")
                subprocess.run(["terraform", "plan", "-destroy", "-no-color", "-input=false"], cwd=project_path, check=True)
    except subprocess.CalledProcessError as e:
        print(f"\n[!] Terraform command failed: {e}")