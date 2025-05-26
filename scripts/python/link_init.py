import os
import subprocess

from util import (
    print_color,
)

if __name__ == "__main__":
    # TODO: instead of using these ingore things just use the .gitignore file
    IGNORE_THINGS = [
        "README.md",
        ".git",
        ".gitignore",
        "node_modules",
        "Brewfile.lock.json",
        "package-lock.json",
        "akeyless",
        ".ruff_cache",
        ".mise.toml",
    ]
    IGNORE_EXTENSIONS = ["log"]
    local_git_repo_path = os.environ.get("LOCAL_GIT_REPO_PATH")
    if local_git_repo_path is None:
        print_color(
            "could not load local git repo path from $LOCAL_GIT_REPO_PATH",
            color="red",
        )
        exit(1)

    dotfiles_path = os.path.join(
        local_git_repo_path,
        "dotfiles",
    )
    # filter out things we don't want to link
    links = [
        l
        for l in os.listdir(dotfiles_path)
        if l not in IGNORE_THINGS and l.split(".")[-1] not in IGNORE_EXTENSIONS
    ]
    # links now holds the things we want to create a sym link for in $HOME
    home_dir_path = os.environ.get("HOME")
    if home_dir_path is None:
        print_color(
            "could not load home path from $HOME",
            color="red",
        )
        exit(1)
    home_dir_existing_links = os.listdir(home_dir_path)
    err_count = 0
    skipped_count = 0
    created_count = 0

    for link in links:
        if link in home_dir_existing_links:
            print(f"link '{link}' already exists, continuing...")
            continue
        # this link is expected, prompt to create it
        command = f"ln -s {os.path.join(dotfiles_path, link)} {link}"
        selection = input(f"create link '{link}'?\ncommand: '{command}'\n(Y/n): ")
        if selection == "Y":
            print(f"creating link '{link}' ...")
            # ensure we are in the correct dir
            os.chdir(home_dir_path)
            result = subprocess.run(
                command,
                shell=True,
            )
            if result.returncode != 0:
                print_color(
                    f"command failed with code {result.returncode}",
                    color="red",
                )
                err_count += 1
            else:
                print_color(
                    "success!",
                    color="green",
                )
                created_count += 1
        else:
            print(f"skipping creation of link '{link}' ...")
            skipped_count += 1

    color = "green" if err_count == 0 else "red"
    print_color(
        f"\nlinking complete: {created_count} created - {err_count} errors - {skipped_count} skips\n\n",
        color=color,
    )
