@ECHO OFF
SETLOCAL EnableExtensions

SET "JAVA_HOME=C:\Users\Ricar\.jdks\corretto-17.0.11"
IF NOT EXIST "%JAVA_HOME%\bin\java.exe" (
  ECHO ERROR: JDK 17 no encontrado en %JAVA_HOME%
  EXIT /B 1
)

REM Quitar barra final (%~dp0 trae \ al final y rompe las comillas en -D...)
SET "MAVEN_PROJECTBASEDIR=%~dp0"
IF "%MAVEN_PROJECTBASEDIR:~-1%"=="\" SET "MAVEN_PROJECTBASEDIR=%MAVEN_PROJECTBASEDIR:~0,-1%"

SET "WRAPPER_JAR=%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar"
IF NOT EXIST "%WRAPPER_JAR%" (
  ECHO ERROR: Falta %WRAPPER_JAR%
  EXIT /B 1
)

"%JAVA_HOME%\bin\java.exe" -classpath "%WRAPPER_JAR%" "-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%" org.apache.maven.wrapper.MavenWrapperMain %*

ENDLOCAL
