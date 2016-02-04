
cls
@echo off
chcp 936
title APK 反编译和图标获取工具 by. ForthXu.com
COLOR 3f

GOTO MENU
:MENU
cls
ECHO.
if exist apks (echo .) else (mkdir apks)
ECHO.========================================================================
ECHO.             　          APK 反编译和图标获取工具 
ECHO.
ECHO.                                          -- POWER BY forthxu.com    
ECHO.                                                                            
ECHO.说明：本工具要求安装Java环境;
ECHO.      要处理的apk请放入apks目录中
ECHO.
ECHO.                                                                 
ECHO.      1. 获取指定apk信息；       
ECHO.      2. 反编译指定apk；  
ECHO.      3. 提取apks目录下应用对应的图标；        
ECHO.      0. 退出。
ECHO.                                                    
ECHO.========================================================================
if exist tmp (echo .) else (mkdir tmp)
ECHO.请输入您的选择：1、2、3、0（按回车键）
set /p ID=
if "%id%"=="1" goto cmd1
if "%id%"=="2" goto cmd2
if "%id%"=="3" goto cmd3
if "%id%"=="0" goto cmd0
pause
goto menu

:cmd1
@echo off
ECHO.    请输入apks目录下apk包（如：a.apk）：
set /p APK=
ECHO.　  "正在查看%APK% apk包信息..."
if exist "apks\%APK%" (
    aapt.exe d badging "apks\%APK%"
) else (
    echo "%APK% 不存在"
)
ECHO. 
ECHO. 
ECHO. 按任意键返回菜单
pause>nul
@echo off
goto menu

:cmd2
@echo off
ECHO.    请输入apks目录下apk包（如：a.apk）：
set /p APK=
ECHO.　  "正在反编译整个 %APK% apk包..."
echo %APK:~0,-4%
if exist "apks\%APK%" (
    if exist "tmp\%APK:~0,-4%" (
        echo .
    ) else (
        mkdir "tmp\%APK:~0,-4%"
    )
    java -jar apktool.jar d -f "apks\%APK%" "tmp\%APK:~0,-4%"
    echo "反编译完成，文件在 tmp\%APK:~0,-4% 目录"
) else (
    echo "%APK% 不存在"
)
ECHO. 
ECHO. 
ECHO. 按任意键返回菜单
pause>nul
@echo off
goto menu


:cmd3
ECHO.　　正在拷贝图标中...
@echo off

for /f "delims=" %%a in ('dir /b /s /a:-d apks\*.apk') do (
    set "APK_PATH=%%a"
    set "APK_NAME=%%~nxa"
    REM set "str=%%~nxa"
    
    setlocal enabledelayedexpansion
        REM echo "!str:~3!"
        echo !APK_PATH!
        for /f "tokens=1,2,3,4 delims=\'" %%b in ('aapt.exe d badging "!APK_PATH!" ^| findstr "png"') do (
            set "tmp_D=%%d"
            set "tmp_E=%%e"
            
            REM echo !tmp_D!
            if {!tmp_D:~1!}=={icon=} (
                set "PNG=!tmp_E!"
            ) else (
                set "PNG=!tmp_D!"
            )
            REM echo !PNG!
        )
    REM endlocal
    echo  !PNG!
    for /f "tokens=1,2,3 delims=\/" %%f in ('echo !PNG!') do ( set "ICON=%%h" )

    echo !ICON!
    
    if exist "tmp\!APK_NAME:~0,-4!" (echo "应用图标临时目录存在，继续...") else (mkdir "tmp\!APK_NAME:~0,-4!")
    "C:\Program Files\WinRAR\WinRAR.exe" x "!APK_PATH!" *\!ICON! "tmp\!APK_NAME:~0,-4!"
    
    if exist "tmp\!APK_NAME:~0,-4!\res\drawable-xxhdpi\!ICON!" (
        COPY "tmp\!APK_NAME:~0,-4!\res\drawable-xxhdpi\!ICON!"  "apks\!APK_NAME:~0,-4!_144.png"
    ) else if exist "tmp\!APK_NAME:~0,-4!\res\drawable-xxhdpi-v4\!ICON!" (
        COPY "tmp\!APK_NAME:~0,-4!\res\drawable-xxhdpi-v4\!ICON!"  "apks\!APK_NAME:~0,-4!_144.png"
    ) else if exist "tmp\!APK_NAME:~0,-4!\res\drawable-xhdpi\!ICON!" (
        COPY "tmp\!APK_NAME:~0,-4!\res\drawable-xhdpi\!ICON!"  "apks\!APK_NAME:~0,-4!_96.png"
    ) else if exist "tmp\!APK_NAME:~0,-4!\res\drawable-xhdpi-v4\!ICON!" (
        COPY "tmp\!APK_NAME:~0,-4!\res\drawable-xhdpi-v4\!ICON!"  "apks\!APK_NAME:~0,-4!_96.png"
    ) else if exist "tmp\!APK_NAME:~0,-4!\res\drawable-hdpi\!ICON!" (
        COPY "tmp\!APK_NAME:~0,-4!\res\drawable-hdpi\!ICON!"  "apks\!APK_NAME:~0,-4!_72.png"
    ) else if exist "tmp\!APK_NAME:~0,-4!\res\drawable-hdpi-v4\!ICON!" (
        COPY "tmp\!APK_NAME:~0,-4!\res\drawable-hdpi-v4\!ICON!"  "apks\!APK_NAME:~0,-4!_72.png"
    ) else if exist "tmp\!APK_NAME:~0,-4!\res\drawable\!ICON!" (
        COPY "tmp\!APK_NAME:~0,-4!\res\drawable\!ICON!"  "apks\!APK_NAME:~0,-4!_72.png"
    ) else (
        echo "图标不存在"
    )
    endlocal
)
ECHO. 
ECHO. 
ECHO. 按任意键返回菜单
pause>nul
@echo off
goto menu

:cmd0
exit