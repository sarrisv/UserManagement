@echo off
:Run
cls
echo 1) Change User
echo 2) Add User
echo 3) Exit
set /p run="Enter Number:	"
if "%run%"=="1" goto :Main
if "%run%"=="2" goto :addUser
if "%run%"=="3" EXIT

:Main
cls
wmic useraccount get name
set /p "userName=Enter name of User:	"
set /p "auth=Is %userName% an authorized user? (y|n)	"
if "%auth%"=="y" goto :auth
if "%auth%"=="n" goto :delUser

:auth
cls
echo Auth
set /p "type=Is %userName% an Admin? (y|n)	"
if "%type%"=="y" goto :setAdmin
if "%type%"=="n" goto :setNormal

:setAdmin
cls
echo setAdmin
net localgroup administrators "%userName%" /add
net localgroup users "%userName%" /del
goto :Run

:setNormal
cls
echo setNormal
net localgroup users "%userName%" /add
net localgroup administrators "%userName%" /del
goto :Run

:delUser
cls
echo delUser
net localgroup users "%userName%" /del
net localgroup administrators "%userName%" /del
net user %userName% /del
goto :Run

:addUser
cls
echo addUser
set /p name="Name of User?	"
net user "%name%" CyberPatriot1! /add
net localgroup users "%name%" /add
goto :Run
