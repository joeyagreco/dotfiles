import subprocess

from openai import OpenAI
from util import print_color

if __name__ == "__main__":
    # first, check if there's anything that can be committed
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only"],
        capture_output=True,
        text=True,
        check=True,
    )
    if not bool(result.stdout.strip()):
        print_color("nothing to commit", "yellow")
        exit(0)

    result = subprocess.run(
        "git diff",
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    response = OpenAI().chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "user",
                "content": f"Generate a git commit message for this diff: {result.stdout}",
            }
        ],
        # NOTE: @joeyagreco - prolly need to tweak this
        max_tokens=300,
    )

    result = subprocess.run(
        f"git commit -m '{response.choices[0].message.content}'", shell=True
    )

    if result.returncode != 0:
        print_color(
            f"command failed with code {result.returncode}",
            color="red",
        )
