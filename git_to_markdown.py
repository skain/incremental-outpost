import subprocess
import os
from datetime import datetime

def get_git_log():
    """Fetches the git log and returns it as a list of strings."""
    # Using a custom format to make parsing easier while keeping it clean
    # %h (short hash), %an (author name), %ad (author date, short), %s (subject)
    git_log_command = ["git", "log", "--pretty=format:%h|%an|%ad|%s", "--date=short", "--reverse"]
    try:
        result = subprocess.check_output(git_log_command, stderr=subprocess.STDOUT).decode('utf-8')
        return result.strip().split('\n')
    except subprocess.CalledProcessError as e:
        print(f"Error fetching git log: {e.output.decode('utf-8')}")
        return []

def format_to_markdown(log_lines):
    """Formats the raw log lines into a readable markdown string."""
    markdown = "# Project Git Log\n\n"
    markdown += f"*Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}*\n\n"

    if not log_lines:
        markdown += "_No commits found or not a git repository._"
        return markdown

    for line in log_lines:
        parts = line.split('|')
        if len(parts) == 4:
            hash_val, author, date, message = parts
            # markdown += f"### [{hash_val}] {author} ({date})\n"
            markdown += f"### ({date}) [{hash_val}]\n"
            markdown += f"{message}\n\n---\n\n"
    
    return markdown

def main():
    log_lines = get_git_log()
    if not log_lines:
        print("No logs retrieved.")
        return

    markdown_content = format_to_markdown(log_lines)
    
    filename = "git_log.md"
    with open(filename, "w", encoding="utf-8") as f:
        f.write(markdown_content)
    
    print(f"Successfully saved git log to {os.path.abspath(filename)}")

if __name__ == "__main__":
    main()
