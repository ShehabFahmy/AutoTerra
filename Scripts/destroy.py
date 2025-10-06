import os
import shutil
from helper_functions import *

if __name__ == "__main__":
    data = ReadYaml(sys.argv, Path(__file__).resolve().name)
    # Get parent directory of this script
    parent_dir = Path(__file__).resolve().parent.parent
    project_path = parent_dir / f"{data['project']['project_id']}"

    # Determine scope: modules-only vs all (including removing folder)
    scope = os.environ.get("DESTROY_SCOPE", "").strip().lower()
    if scope not in ("modules", "all"):
        choice = input("Destroy scope - modules only (m) or all (a)? [m/a]: ").strip().lower()
        scope = "all" if choice in ("a", "all") else "modules"

    RunTerraform("destroy", project_path)

    if scope == "all":
        try:
            if project_path.exists():
                shutil.rmtree(project_path)
                print(f"\n[!] Removed project directory: {project_path}")
        except Exception as e:
            print(f"\n[!] Failed to remove project directory {project_path}: {e}")
