@echo off
chcp 65001 >nul
setlocal

REM === Checking if a folder has been transferred ===
if "%~1"=="" (
    echo Drag the folder with JPG/JPEG files onto this script.
    pause
    exit /b 1
)

REM === Absolute path to the source folder ===
for %%A in ("%~1") do set "SRC_DIR=%%~fA"

REM === Folder name and parent ===
for %%A in ("%SRC_DIR%") do (
    set "SRC_NAME=%%~nxA"
    set "SRC_PARENT=%%~dpA"
)

REM === JXL base folder next to the original ===
set "JXL_BASE=%SRC_PARENT%JXL"

REM === Destination folder: JXL\<source_folder_name> ===
set "DST_DIR=%JXL_BASE%\%SRC_NAME%"

REM === Create folders if they don't exist ===
if exist "%JXL_BASE%" (
    if not exist "%JXL_BASE%\" (
        echo ERROR: "%JXL_BASE%" exists but is not a folder
        pause
        exit /b 1
    )
) else (
    echo Creating folder: "%JXL_BASE%"
    mkdir "%JXL_BASE%" || exit /b 1
)

if exist "%DST_DIR%" (
    if not exist "%DST_DIR%\" (
        echo ERROR: "%DST_DIR%" exists but is not a folder
        pause
        exit /b 1
    )
) else (
    echo Creating folder: "%DST_DIR%"
    mkdir "%DST_DIR%" || exit /b 1
)

REM === Activating conda ===
call "C:\Users\WS2023\miniconda3\Scripts\activate.bat" "C:\Users\WS2023\miniconda3"
call conda activate download

echo.
echo Transcoding JPG(JPEG) => JXL
echo Input folder : %SRC_DIR%
echo Output folder: %DST_DIR%
echo.
pause

REM === Looping through all JPG(JPEG) files ===
for %%F in (
    "%SRC_DIR%\*.jpg"
    "%SRC_DIR%\*.jpeg"
) do (
    if exist "%%~fF" (
        echo Processing: %%~nxF

        cjxl ^
            --lossless_jpeg=1 ^
            --effort=10 ^
            --allow_jpeg_reconstruction=1 ^
            --compress_boxes=1 ^
            --brotli_effort=11 ^
            "%%~fF" ^
            "%DST_DIR%\%%~nF.jxl"

        if errorlevel 1 (
            echo.
            echo =========================
            echo ERROR while processing:
            echo %%~fF
            echo Work has stopped.
            echo =========================
            pause
            exit /b 1
        )
    )
)

echo.
echo ================================================
echo Done. All files have been processed successfully: %DST_DIR%
echo ================================================
pause
