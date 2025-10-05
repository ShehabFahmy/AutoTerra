from helper_functions import *

if __name__ == "__main__":
    data = ReadYaml(sys.argv, Path(__file__).resolve().name)
    # Get parent directory of this script
    parent_dir = Path(__file__).resolve().parent.parent
    project_path = parent_dir / f"{data["project"]["project_id"]}"
    RunTerraform("destroy", project_path)
