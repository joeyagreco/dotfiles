import os

def find_venv_folders(directory):
    venv_folders = []
    for item in os.listdir(directory):
        item_path = os.path.join(directory, item)
        if os.path.isdir(item_path) and 'pyvenv.cfg' in os.listdir(item_path):
            venv_folders.append(item)
    return venv_folders

if __name__ == "__main__":
    current_directory = os.getcwd()
    venv_folders = find_venv_folders(current_directory)
    if len(venv_folders):
        print()
        for i, venv_folder in enumerate(venv_folders):
            print(f"{i+1} - {venv_folder}")
    else:
        print("none found")
