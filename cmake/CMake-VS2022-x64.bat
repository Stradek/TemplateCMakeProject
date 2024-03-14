@echo off
setlocal

rem Copyright (c) 2024 Piotr Stradowski. All rights reserved.
rem Software distributed under the permissive MIT License.

set myPath=%~dp0
set sourceDir=%1
set buildDir=%2

if [%sourceDir%] == [] set sourceDir="%myPath%.."
if [%buildDir%] == [] set buildDir="%sourceDir%\build\CMake-VS2022-x64"

cd %sourceDir%

echo ---- Preparing build directory...
mkdir %buildDir% >nul 2>&1

where /q cmake.exe
if %ERRORLEVEL% NEQ 0 (
    goto Error_CMakeNotInstalled
)

echo ---- Generating CMake project for Visual Studio 2022...

cmake.exe -S %sourceDir% -B %buildDir% --preset x64-windows-release

if %ERRORLEVEL% NEQ 0 (
    goto Error_CMakeBuildingProjectFailed
)

move %buildDir%\*.sln %sourceDir%

goto:EndCall

:Error_CMakeNotInstalled
echo "CMake is not installed or not in environmental path."
goto:EndCall

:Error_CMakeBuildingProjectFailed
echo "CMake failed to build the project for Visual Studio 2022."
goto:EndCall

:EndCall
pause
