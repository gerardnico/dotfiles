@REM Copy this file next to the program to wrap and replace the %* with the command name
@REM Not powershell because it can't be written in a single file

setlocal
set "HTTP_PROXY=http://localhost:8080"
set "HTTPS_PROXY=http://localhost:8080"
set "http_proxy=http://localhost:8080"
set "https_proxy=http://localhost:8080"
set "NODE_USE_ENV_PROXY=1"
set "NO_PROXY=localhost,127.0.0.1,.svc,.cluster.local,.localhost"

@REM Start as subprocess
@REM start "" %*

%*

exit /b %ERRORLEVEL%
