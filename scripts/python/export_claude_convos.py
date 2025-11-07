#!/usr/bin/env python3
"""
export claude conversations from jsonl files to text format
"""

import json
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional

# configuration
PROJECTS_BASE_DIR = Path("~/.claude/projects").expanduser()
OUTPUT_DIR = Path("convos")


def extract_message_content(message: Dict) -> Optional[str]:
    """extract text content from a message object"""
    if not message or not isinstance(message, dict):
        return None

    # handle different message formats
    if "content" in message:
        content = message["content"]

        # if content is a string, return it directly
        if isinstance(content, str):
            return content

        # if content is a list of content blocks
        if isinstance(content, list):
            text_parts = []
            for block in content:
                if isinstance(block, dict) and "text" in block:
                    text_parts.append(block["text"])
            return "\n".join(text_parts) if text_parts else None

    return None


def parse_conversation(file_path: Path) -> List[Dict]:
    """parse a jsonl file and extract conversation messages"""
    messages = []

    try:
        with open(file_path) as f:
            for line in f:
                if not line.strip():
                    continue

                try:
                    data = json.loads(line)

                    # look for message data
                    if "message" in data and isinstance(data["message"], dict):
                        message = data["message"]
                        role = message.get("role", "unknown")
                        content = extract_message_content(message)
                        timestamp = data.get("timestamp", "")

                        if content:
                            messages.append(
                                {
                                    "role": role,
                                    "content": content,
                                    "timestamp": timestamp,
                                    "uuid": data.get("uuid", ""),
                                }
                            )

                    # also check for summaries at the beginning
                    elif data.get("type") == "summary":
                        summary = data.get("summary", "")
                        if summary:
                            messages.append(
                                {
                                    "role": "summary",
                                    "content": summary,
                                    "timestamp": "",
                                    "uuid": data.get("leafUuid", ""),
                                }
                            )

                except json.JSONDecodeError:
                    # skip malformed json lines
                    continue

    except Exception as e:
        print(f"error reading {file_path}: {e}")

    return messages


def format_conversation_to_text(messages: List[Dict], file_name: str) -> str:
    """convert messages to readable text format"""
    lines = []
    lines.append("=" * 80)
    lines.append(f"CONVERSATION: {file_name}")
    lines.append("=" * 80)
    lines.append("")

    # add summaries if any
    summaries = [m for m in messages if m["role"] == "summary"]
    if summaries:
        lines.append("SUMMARIES:")
        for summary in summaries:
            lines.append(f"  - {summary['content']}")
        lines.append("")
        lines.append("-" * 40)
        lines.append("")

    # add conversation messages
    conversation = [m for m in messages if m["role"] in ["user", "assistant"]]

    for _, msg in enumerate(conversation):
        role = msg["role"].upper()
        timestamp = msg.get("timestamp", "")

        if timestamp:
            try:
                dt = datetime.fromisoformat(timestamp.replace("Z", "+00:00"))
                timestamp_str = dt.strftime("%Y-%m-%d %H:%M:%S")
                lines.append(f"[{timestamp_str}] {role}:")
            except Exception as e:
                print(e)
                lines.append(f"{role}:")
        else:
            lines.append(f"{role}:")

        lines.append("")

        # add message content with proper indentation
        content_lines = msg["content"].split("\n")
        for line in content_lines:
            lines.append(f"  {line}")

        lines.append("")
        lines.append("-" * 40)
        lines.append("")

    return "\n".join(lines)


def export_project_conversations(
    project_dir: Path, output_dir: Path
) -> tuple[int, int]:
    """export conversations for a single project"""
    # get all jsonl files
    jsonl_files = sorted(project_dir.glob("*.jsonl"))

    if not jsonl_files:
        return 0, 0

    exported_count = 0
    skipped_count = 0

    for file_path in jsonl_files:
        file_name = file_path.stem
        print(f"    processing: {file_name}...", end=" ")

        # parse conversation
        messages = parse_conversation(file_path)

        if not messages:
            print("no messages found, skipping")
            skipped_count += 1
            continue

        # convert to text format
        text_content = format_conversation_to_text(messages, file_name)

        # save to output file
        output_file = output_dir / f"{file_name}.txt"
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(text_content)

        print(f"exported ({len(messages)} messages)")
        exported_count += 1

    return exported_count, skipped_count


def export_conversations():
    """main function to export all conversations from all projects"""
    # check if projects directory exists
    if not PROJECTS_BASE_DIR.exists():
        print(f"projects directory not found: {PROJECTS_BASE_DIR}")
        return

    # get all project directories
    project_dirs = [d for d in PROJECTS_BASE_DIR.iterdir() if d.is_dir()]

    if not project_dirs:
        print(f"no project directories found in {PROJECTS_BASE_DIR}")
        return

    print(f"found {len(project_dirs)} project(s)")
    print("=" * 60)

    # create main output directory if it doesn't exist
    OUTPUT_DIR.mkdir(exist_ok=True)

    total_exported = 0
    total_skipped = 0

    for project_dir in sorted(project_dirs):
        project_name = project_dir.name
        print(f"\nproject: {project_name}")
        print("-" * 40)

        # create project-specific output directory
        project_output_dir = OUTPUT_DIR / project_name
        project_output_dir.mkdir(exist_ok=True)

        # export conversations for this project
        exported, skipped = export_project_conversations(
            project_dir, project_output_dir
        )

        if exported == 0 and skipped == 0:
            print("    no conversation files found")
        else:
            print(f"    summary: {exported} exported, {skipped} skipped")

        total_exported += exported
        total_skipped += skipped

    print()
    print("=" * 60)
    print("export complete!")
    print(f"  - total conversations exported: {total_exported}")
    print(f"  - total files skipped: {total_skipped}")
    print(f"  - output directory: {OUTPUT_DIR.absolute()}")
    print("=" * 60)


if __name__ == "__main__":
    export_conversations()
