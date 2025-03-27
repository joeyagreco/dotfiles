import subprocess

from openai import OpenAI
from util import print_color

if __name__ == "__main__":
    # first, check if there's anything that can be committed
    # we can exit early if not
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only"],
        capture_output=True,
        text=True,
        check=True,
    )
    if not bool(result.stdout.strip()):
        print_color("nothing to commit", "yellow")
        exit(0)

    # get the diff and ask ai for a commit message
    result = subprocess.run(
        ["git", "diff", "--cached"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=True,
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

    commit_message = response.choices[0].message.content
    assert isinstance(commit_message, str)
    # remove any leading or trailing backticks
    commit_message.strip("`")

    # actually commit with the ai commit message
    print(commit_message)
    subprocess.run(
        ["git", "commit", "-m", commit_message],
        text=True,
        check=True,
    )
