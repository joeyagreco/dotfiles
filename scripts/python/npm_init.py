import os
import subprocess

if __name__ == "__main__":
    HOME_PATH = os.environ.get("HOME")
    if HOME_PATH is None:
        print("no env var found for '$HOME'")
        exit(1)
    NPM_DEPS_PATH = os.path.join(HOME_PATH, "npm_deps.txt")

    err_count = 0
    success_count = 0

    with open(NPM_DEPS_PATH, "r") as file:
        deps = [dep.strip() for dep in file.readlines()]

    for dep in deps:
        command = f"npm install -g {dep}"
        print(f"running command '{command}'")
        result = subprocess.run(command, shell=True)
        if result.returncode != 0:
            print(f"command failed with code {result.returncode}")
            err_count += 1
        else:
            print("success!")
            success_count += 1

    print(f"\nsuccessfully installed {success_count} deps with {err_count} errors")
