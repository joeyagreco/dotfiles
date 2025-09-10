from typing import List, Literal, NotRequired, TypedDict

Color = Literal["red", "green", "yellow", "blue", "magenta", "cyan", "white", "reset"]

ColorPart = TypedDict(
    "ColorPart",
    {
        "text": str,
        "color": NotRequired[Color],
    },
)


def print_color(text: str, color: Color = "reset") -> None:
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
