@echo off

if /i "%1"=="copyrelease" set copyrelease=1
if /i "%1"=="arm"         set target_arch=arm
if /i "%1"=="x86"         set target_arch=x86
if /i "%1"=="x64"         set target_arch=x64

set node_dir=c:\Repos\node
set release_dir=c:\buildoutput\node-uwp

if "%target_arch%"=="arm" goto arm
if "%target_arch%"=="x86" goto x86
if "%target_arch%"=="x64" goto x64

:arm
@rem build node.dll
call "%node_dir%\vcbuild.bat" arm chakra uwp-dll withoutssl
cd %~dp0
@rem build nodeuwp.dll
set WindowsSdkDir=%programfiles(x86)%\Windows Kits\10\
msbuild nodeuwp.sln /p:configuration=release /p:platform=arm

@rem copy to release directory
if defined copyrelease (
  echo D | xcopy /y /f /i "%node_dir%\Release\node.dll" "%release_dir%\ARM"
  echo D | xcopy /y /f /i %~dp0\ARM\release\nodeuwp\nodeuwp.dll "%release_dir%\ARM"
)
@rem reset target_arch and exit
set target_arch=arm
if "%target_arch%"=="arm" goto end

:x86
@rem build node.dll
call "%node_dir%\vcbuild.bat" x86 chakra uwp-dll withoutssl
cd %~dp0
@rem build nodeuwp.dll
set WindowsSdkDir=%programfiles(x86)%\Windows Kits\10\
msbuild nodeuwp.sln /p:configuration=release /p:platform=x86

@rem copy to release directory
if defined copyrelease (
  echo D | xcopy /y /f /i "%node_dir%\Release\node.dll" "%release_dir%\x86"
  echo D | xcopy /y /f /i %~dp0\release\nodeuwp\nodeuwp.dll "%release_dir%\x86"
)
@rem reset target_arch and exit
set target_arch=x86
if "%target_arch%"=="x86" goto end

:x64
@rem build node.dll
call "%node_dir%\vcbuild.bat" x64 chakra uwp-dll withoutssl
cd %~dp0
@rem build nodeuwp.dll
set WindowsSdkDir=%programfiles(x86)%\Windows Kits\10\
msbuild nodeuwp.sln /p:configuration=release /p:platform=x64

@rem copy to release directory
if defined copyrelease (
  echo D | xcopy /y /f /i "%node_dir%\Release\node.dll" "%release_dir%\x64"
  echo D | xcopy /y /f /i %~dp0\x64\release\nodeuwp\nodeuwp.dll "%release_dir%\x64"
)

:end