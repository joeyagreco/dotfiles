from typing import List, NotRequired, TypedDict

ColorPart = TypedDict(
    "ColorPart",
    {
        "text": str,
        "color": NotRequired[str],
    },
)


def print_color(text: str, color: str = "") -> None:
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


def print_color_v2(parts: List[ColorPart]) -> None:
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

    result = ""
    for part in parts:
        color = part.get("color") or ""
        text = part.get("text", "")
        color_code = color_codes.get(color, color_codes["reset"])
        result += f"{color_code}{text}{color_codes['reset']}"

    print(result)
