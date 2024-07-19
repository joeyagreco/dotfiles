import sys

import requests


def check_package_availability(package_name: str) -> dict[str, bool]:
    """
    Check if a package name is available on PyPI and TestPyPI.

    :param package_name: The name of the package to check.
    :return: A dictionary with the availability status on PyPI and TestPyPI.
    """
    urls = {
        "PyPI": f"https://pypi.org/project/{package_name}/",
        "TestPyPI": f"https://test.pypi.org/project/{package_name}/",
    }
    availability = {}

    for namespace, url in urls.items():
        response = requests.head(url)
        availability[namespace] = response.status_code == 404

    return availability


def print_colored_availability(
    package_name: str, availability: dict[str, bool]
) -> None:
    """
    Prints the availability of the package in colored format.

    :param package_name: The name of the package to check.
    :param availability: A dictionary with the availability status.
    """
    colors = {"available": "\033[92m", "not available": "\033[91m", "reset": "\033[0m"}
    print(
        f"\nChecking availability for package: {colors['available']}{package_name}{colors['reset']}\n"
    )
    for namespace, is_available in availability.items():
        status = "available" if is_available else "not available"
        color = colors["available"] if is_available else colors["not available"]
        print(f"{namespace}: {color}{status}{colors['reset']}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <package_name>")
        sys.exit(1)

    package_name = sys.argv[1]
    availability = check_package_availability(package_name)
    print_colored_availability(package_name, availability)
