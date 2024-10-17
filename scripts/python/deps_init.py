import os
import subprocess

from util import print_color


def install(*, deps_file_name: str, install_command: str) -> None:
    """
    install_command should have {DEP} in it, which will be swapped out with the dep name
    """
    DEPS_DIR_PATH = os.environ.get("DEPS_DIR_PATH")
    if DEPS_DIR_PATH is None:
        print_color("no env var found for '$DEPS_DIR_PATH'", color="red")
        exit(1)
    DEPS_FILE_PATH = os.path.join(DEPS_DIR_PATH, deps_file_name)

    err_count = 0
    success_count = 0

    with open(DEPS_FILE_PATH, "r") as file:
        deps = [dep.strip() for dep in file.readlines()]

    for dep in deps:
        if dep.startswith("#"):
            # ignore commented lines
            continue
        command = install_command.replace("{DEP}", dep)
        print(f"running command '{command}'")
        result = subprocess.run(command, shell=True)
        if result.returncode != 0:
            print_color(f"command failed with code {result.returncode}", color="red")
            err_count += 1
        else:
            print_color("success!", color="green")
            success_count += 1

    color = "green"
    if err_count > 0:
        color = "red"
    print_color(
        f"\nsuccessfully installed {success_count} deps with {err_count} errors\n\n",
        color=color,
    )


if __name__ == "__main__":
    # npm
    install(
        deps_file_name="npm_deps.txt", install_command="npm install -g --silent {DEP}"
    )

    # go
    install(deps_file_name="go_deps.txt", install_command="go install {DEP}")

    # cargo
    install(deps_file_name="cargo_deps.txt", install_command="cargo install -q {DEP}")
