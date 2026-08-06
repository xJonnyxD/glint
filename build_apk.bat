@echo off
set JAVA_TOOL_OPTIONS=-Dsun.net.useExclusiveBind=false
cd /d D:\Proyectos\Glint
flutter build apk --release > D:\Proyectos\Glint\build_output.txt 2>&1
echo BUILD_EXIT_CODE=%ERRORLEVEL% >> D:\Proyectos\Glint\build_output.txt
