def print_color(text, color=None):
    color_codes = {
        "red": "\033[91m",
        "green": "\033[92m",
        "yellow": "\033[93m",
        "blue": "\033[94m",
        "magenta": "\033[95m",
        "cyan": "\033[96m",
        "white": "\033[97m",
        "reset": "\033[0m",
    }

    color_code = color_codes.get(color, color_codes["reset"])
    print(f"{color_code}{text}{color_codes['reset']}")
