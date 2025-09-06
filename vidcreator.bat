@echo off
REM ==========================================================
REM Image + Suno audio (WebM/Opus or MP3) → Video
REM Usage: vidcreator.bat "song.webm" "cover.jpeg"
REM ==========================================================

if "%~1"=="" (
    echo Please provide an audio file.
    pause
    exit /b
)

if "%~2"=="" (
    echo Please provide an image file.
    pause
    exit /b
)

set "audio=%~1"
set "img=%~2"
set "basename=%~n1"

REM Temporary AAC audio
set "aacaudio=%basename%_audio.m4a"

REM Convert audio to AAC
ffmpeg -y -i "%audio%" -c:a aac -b:a 192k "%aacaudio%"

REM Output video file
set "videofile=%basename%_video.mp4"

REM Combine image + converted audio into video
ffmpeg -y -loop 1 -framerate 5 -i "%img%" -i "%aacaudio%" ^
-c:v libx264 -tune stillimage -c:a copy -shortest -pix_fmt yuv420p "%videofile%"

REM Cleanup temp audio
del "%aacaudio%"

echo Done! Video created: %videofile%
pause
