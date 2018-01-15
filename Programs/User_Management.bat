@echo off
for /F "usebackq skip=4 delims=" %%L in (`%SystemRoot%\System32\net.exe user`) do (
    if "%%L"=="The command was successfully executed." goto :EOF
    call :ProcessAccounts "%%L"
)
goto :EOF
:ProcessAccounts
set "Line=%~1"
:NextUser
set "Name=%Line:~0,20%"
set "Line=%Line:~20%"
:TrimRight
if "%Name:~-1%"==" " (
    set "Name=%Name:~0,-1%"
    goto TrimRight
)
echo Valid user account name is: %Name%
if "%Name%"=="Administrator" goto TrimLeft
if "%Name%"=="Guest" goto TrimLeft
if "%Name%"=="The command complete" goto EOF
set /p "auth=Is %Name% an authorized user? y|n  "
if "%auth%"=="y" set /p "type=Is %Name% an Admin? y|n  "
if "%auth%"=="n" net user %Name% /del
if "%type%"=="y" net localgroup administrators %Name% /add
if "%type%"=="n" (
  net localgroup users %Name% /add
  net localgroup administrators %Name% /del
)
:TrimLeft
if "%Line:~0,1%"==" " (
    set "Line=%Line:~1%"
    goto TrimLeft
)
if not "%Line%"=="" goto NextUser
goto :EOF
