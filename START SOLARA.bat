\
@echo off
title SOLARA Website
echo Starting SOLARA...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1"
if errorlevel 1 (
  echo.
  echo SOLARA could not start. Please send a screenshot of this window.
  pause
)
