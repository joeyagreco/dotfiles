from typing import Optional
from datetime import datetime
import subprocess
import os

from util import (
    print_color,
)

# HOME_DIR = os.path.expanduser("~")
# NOTES_DIR = os.path.join(HOME_DIR, ".local.notes")
NOTES_DIR = os.environ.get("NOTES_PATH")
if NOTES_DIR is None:
    print_color("could not load notes path from $NOTES_PATH", color="red")
    exit(1)


def execute_command(command: str) -> str:
    try:
        result = subprocess.run(
            command, shell=True, check=True, text=True, capture_output=True
        )
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"command failed with error: {e}")

    return result.stdout


def initial_setup() -> None:
    # check if notes folder exists
    if not os.path.isdir(NOTES_DIR):
        # doesn't exist, do setup
        selection = input(f"create notes directory at '{NOTES_DIR}'?:\n(y/N): ")
        if selection == "y":
            execute_command(f"mkdir {NOTES_DIR}")
            print_color("created!", color="green")


def create_new_note(name: Optional[str] = None) -> str:
    name = name or "Untitled"
    name = name.replace(" ", "_")
    # timestamp = datetime.now().strftime("%Y.%m.%d_%H.%M.%S")
    timestamp = datetime.now().strftime("%Y%m%dT%H%M%S")
    filename = f"{timestamp}_{name}.txt"
    new_note_path = os.path.join(NOTES_DIR, filename)
    open(new_note_path, "w")
    return new_note_path


def open_file_in_nvim(file_path: str) -> None:
    os.chdir(NOTES_DIR)
    subprocess.run(["nvim", file_path])


if __name__ == "__main__":
    execute_command("clear")
    initial_setup()
    new_note_path = create_new_note("my new note lol")
    open_file_in_nvim(new_note_path)
