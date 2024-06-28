import pyperclip
import requests
import sys
from urllib.parse import urlparse


def get_copied_text() -> str:
    return pyperclip.paste()


def copy_to_clipboard(text: str) -> None:
    pyperclip.copy(text)


def is_valid_url(url: str) -> bool:
    parsed = urlparse(url)
    return all([parsed.scheme, parsed.netloc])


def get_shortened_url(original_url: str) -> str:
    original_url = original_url.strip()
    if not is_valid_url(original_url):
        print(f"invalid url: '{original_url}'")
        exit(1)
    resp = requests.post(
        "https://smolurl.com/api/links",
        json={"url": original_url},
        headers={"Accept": "application/json", "Content-Type": "application/json"},
    )
    resp.raise_for_status()
    return resp.json()["data"]["short_url"]


if __name__ == "__main__":
    # use copied text for url by default
    url = get_copied_text()
    if len(sys.argv) > 1:
        url = sys.argv[1]
    shortened_url = get_shortened_url(url)
    copy_to_clipboard(shortened_url)
    print(f"url shortened!\n\n❌ {url}\n\n✅ {shortened_url}")
