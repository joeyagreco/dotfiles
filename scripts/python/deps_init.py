import os
import subprocess

def install(*, deps_file_name: str, install_command: str) -> None:
    """
    install_command should have {DEP} in it, which will be swapped out with the dep name
    """
    HOME_PATH = os.environ.get("HOME")
    if HOME_PATH is None:
        print("no env var found for '$HOME'")
        exit(1)
    DEPS_FILE_PATH = os.path.join(HOME_PATH, deps_file_name)

    err_count = 0
    success_count = 0

    with open(DEPS_FILE_PATH, "r") as file:
        deps = [dep.strip() for dep in file.readlines()]

    for dep in deps:
        command = install_command.replace("{DEP}", dep)
        print(f"running command '{command}'")
        result = subprocess.run(command, shell=True)
        if result.returncode != 0:
            print(f"command failed with code {result.returncode}")
            err_count += 1
        else:
            print("success!")
            success_count += 1

    print(f"\nsuccessfully installed {success_count} deps with {err_count} errors")

if __name__ == "__main__":

    # npm
    install(deps_file_name="npm_deps.txt", install_command="npm install -g {DEP}")
    
    # go
    install(deps_file_name="go_deps.txt", install_command="go install {DEP}")
    
    # cargo
    install(deps_file_name="cargo_deps.txt", install_command="cargo install {DEP}")

    
    
