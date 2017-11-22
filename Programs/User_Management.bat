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

cls
set /p "auth=Is %Name% an authorized user? (y|n)    "
if "%auth%"=="y" goto auth
if "%auth%"=="n" goto delUser

:auth
cls
echo Auth
set /p "type=Is %userName% an Admin? (y|n)  "
if "%type%"=="y" goto setAdmin
if "%type%"=="n" goto setNormal

:setAdmin
cls
echo setAdmin
net localgroup administrators "%Name%" /add
net localgroup users "%Name%" /del

:setNormal
cls
echo setNormal
net localgroup users "%Name%" /add
net localgroup administrators "%Name%" /del

:delUser
cls
echo delUser
net localgroup users "%Name%" /del
net localgroup administrators "%Name%" /del
net user %Name% /del

:TrimLeft
if "%Line:~0,1%"==" " (
    set "Line=%Line:~1%"
    goto TrimLeft
)

if not "%Line%"=="" goto NextUser

goto :EOF
