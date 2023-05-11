@echo off
cd /d "%~dp0"

REM Step 1: Build the APK
echo Building the APK...
call flutter build apk
echo APK generated and renamed successfully!

REM Step 2: Move and rename the APK
move ".\build\app\outputs\apk\release\app-release.apk" "codeblue.apk"

timeout /t 2 >nul