import sys
from pathlib import Path
from typing import Union

from pytube import YouTube
from pytube.cli import on_progress


def download_youtube_video(url: str, format: str, save_path: Union[Path, str]) -> None:
    yt = YouTube(url, on_progress_callback=on_progress)
    title = yt.title.replace(" ", "_")

    if format == "mp4":
        stream = yt.streams.filter(file_extension="mp4").get_highest_resolution()
        filename = f"{title}.mp4"
    elif format == "mp3":
        stream = yt.streams.filter(only_audio=True).first()
        filename = f"{title}.mp3"
    else:
        raise ValueError("Invalid format. Choose 'mp4' or 'mp3'.")

    stream.download(output_path=save_path, filename=filename)


if __name__ == "__main__":
    if len(sys.argv) != 3 or not sys.argv[2]:
        print("Usage: py mp_download.py [format] [url]")
        sys.exit(1)

    video_format = sys.argv[1]
    video_url = sys.argv[2]
    
    downloads_folder = Path.home() / "Downloads"
    download_youtube_video(video_url, video_format, downloads_folder)
