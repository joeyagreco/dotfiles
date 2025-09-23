import os
import subprocess

from util import (
    print_color,
    print_color_v2,
)

if __name__ == "__main__":
    # TODO: instead of using these ignore things just use the .gitignore file
    IGNORE_FILES = [
        "README.md",
        ".git",
        ".gitignore",
        "node_modules",
        "Brewfile.lock.json",
        "package-lock.json",
        "akeyless",
        ".ruff_cache",
        ".mise.toml",
        "CLAUDE.md",
        "AGENTS.md",
        ".swp",
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
        link
        for link in os.listdir(dotfiles_path)
        if link not in IGNORE_FILES and link.split(".")[-1] not in IGNORE_EXTENSIONS
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
            print_color_v2(
                [
                    {"text": "link "},
                    {"text": f"'{link}'", "color": "green"},
                    {"text": " already exists, continuing..."},
                ]
            )
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

    print_color_v2(
        [
            {"text": "\nlinking complete: "},
            {"text": f"{created_count} created", "color": "green"},
            {"text": " - "},
            {"text": f"{err_count} errors", "color": "red"},
            {"text": " - "},
            {"text": f"{skipped_count} skips", "color": "yellow"},
            {"text": "\n\n"},
        ]
    )
