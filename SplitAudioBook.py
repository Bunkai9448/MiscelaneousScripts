import subprocess
import json
import os

# File paths
input_file = "Audiobook.m4b"
output_data = "data.txt"

# Run ffprobe to extract chapter and format information
ffprobe_cmd = [
    "ffprobe",
    "-i", input_file,
    "-print_format", "json",
    "-show_chapters",
    "-show_format"
]

try:
    # Capture ffprobe output directly
    result = subprocess.run(ffprobe_cmd, capture_output=True, text=True, encoding="utf-8", check=True)
    # Write the JSON output to data.txt
    with open(output_data, "w", encoding="utf-8") as file:
        file.write(result.stdout)
except subprocess.CalledProcessError as e:
    print(f"Error running ffprobe: {e}")
    exit(1)

# Read the generated data.txt
try:
    with open(output_data, "r", encoding="utf-8") as file:
        data = json.load(file)
except FileNotFoundError:
    print(f"Error: {output_data} not found")
    exit(1)
except json.JSONDecodeError as e:
    print(f"Error: Failed to parse JSON from data.txt: {e}")
    exit(1)

# Extract chapters
chapters = data.get("chapters", [])

# Base name for output files (remove extension from input file)
base_name = os.path.splitext(input_file)[0]

# Loop through chapters and split using ffmpeg
for index, chapter in enumerate(chapters):
    start_time = chapter["start_time"]
    end_time = chapter["end_time"]
    chapter_title = chapter.get("tags", {}).get("title", f"Chapter_{index + 1}")
    # Sanitize chapter title for filename
    safe_title = "".join(c for c in chapter_title if c.isalnum() or c in (' ', '_')).replace(' ', '_')
    # Add zero-padded ordinal number
    ordinal = f"{index:03d}"
    output_file = f"{base_name}_{ordinal}_{safe_title}.m4a"
    ffmpeg_cmd = [
        "ffmpeg",
        "-i", input_file,
        "-ss", str(start_time),
        "-to", str(end_time),
        "-c", "copy",
        output_file
    ]

    print(f"Processing: {output_file}")
    try:
        subprocess.run(ffmpeg_cmd, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error splitting chapter {chapter_title}: {e}")

print("Splitting complete!")

# Create directory and move files
try:
    os.makedirs("AudiolibroChapetered", exist_ok=True)
    subprocess.run(["move", "*.m4a", ".\\AudiolibroChapetered"], check=True, shell=True)
except subprocess.CalledProcessError as e:
    print(f"Error moving files: {e}")
except OSError as e:
    print(f"Error creating directory: {e}")