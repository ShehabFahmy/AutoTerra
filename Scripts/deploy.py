import shutil
import re
import json
from helper_functions import *

def WriteTfvars(data, tfvars_path):
    # Open terraform.tfvars in write mode (always overwrite)
    with open(tfvars_path, "w") as tfvars:
        if isinstance(data, dict):
            for key, value in data.items():
                if value is None:
                    tfvars.write(f"{key} = null\n")
                elif isinstance(value, str):
                    tfvars.write(f'{key} = "{value}"\n')
                elif isinstance(value, (dict, list)):
                    # Use json.dumps for proper double-quote formatting
                    tfvars.write(f"{key} = {json.dumps(value, indent=2)}\n")
                else:
                    # Numbers, booleans, etc.
                    tfvars.write(f"{key} = {value}\n")
        else:
            print("YAML root is not a dictionary.")

def WriteMainTf(modules, source_path, main_path):
    with open(source_path, "r") as f:
        content = f.read()
    # Regex to capture each module block
    pattern = r'(module\s+"([^"]+)"\s*{[^}]*\})'
    selected_blocks = []
    for match in re.finditer(pattern, content, re.DOTALL):
        block, name = match.groups()
        if name in modules:
            selected_blocks.append(block.strip())
    # Write only the selected modules into the new main.tf
    with open(main_path, "w") as f:
        f.write("\n\n".join(selected_blocks) + "\n")

def WriteVarsTf(modules, source_path, vars_path):
    with open(source_path, "r") as f:
        content = f.read()
    # Regex to capture full variable blocks (non-greedy, supports nested braces)
    pattern = r'(variable\s+"([^"]+)"\s*{.*?^\})'
    selected_blocks = []
    for match in re.finditer(pattern, content, re.DOTALL | re.MULTILINE):
        block, var_name = match.groups()
        # Match variable names starting with module name
        for module in modules:
            if var_name.startswith(module):
                selected_blocks.append(block.strip())
                break
    with open(vars_path, "w") as f:
        f.write("\n\n".join(selected_blocks) + "\n")

def CopyModules(modules, source_path, mods_path):
    mods_path.mkdir(parents=True, exist_ok=True)
    for module in modules:
        src = source_path / module
        dest = mods_path / module
        # If not found, try without trailing 's'
        if not src.exists() or not src.is_dir():
            src = source_path / module[:-1]
            dest = mods_path / module[:-1]
        if src.exists() and src.is_dir():
            # If dest already exists, remove it before copying
            if dest.exists():
                shutil.rmtree(dest)
            shutil.copytree(src, dest)
        else:
            print(f"[!] Warning: module folder not found: {src}")

def CheckAvailModules(data):
    modules = set()
    for key, value in data.items():
        if value:  # check if not empty / None / []
            # if key is "vpc_name", module should be "vpc"
            if key == "vpc_name":
                module = "vpc"
            elif key == "cloud_dns_zones":
                module = "cloud_dns"
            else:
                module = key
            modules.add(module)
    return modules

if __name__ == "__main__":
    data = ReadYaml(sys.argv, Path(__file__).resolve().name)

    # Get parent directory of this script
    parent_dir = Path(__file__).resolve().parent.parent
    # Create folder named after the project_id
    project_path = parent_dir / f"{data['project']['project_id']}"
    project_path.mkdir(parents=True, exist_ok=True)

    availModules = CheckAvailModules(data)

    tfvars_path = project_path / "terraform.tfvars"
    main_path = project_path / "main.tf"
    vars_path = project_path / "variables.tf"
    mods_path = project_path / "Modules"

    # Ensure provider configuration is available inside the generated project folder
    providers_src = parent_dir / "providers.tf"
    providers_dest = project_path / "providers.tf"
    if providers_src.exists():
        shutil.copyfile(providers_src, providers_dest)

    WriteMainTf(availModules, parent_dir/"main.tf", main_path)
    WriteVarsTf(availModules, parent_dir/"variables.tf", vars_path)
    CopyModules(availModules, parent_dir/"Modules", mods_path)
    WriteTfvars(data, tfvars_path)
    RunTerraform("apply", project_path)
