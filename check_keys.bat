@echo off
setlocal enabledelayedexpansion

set PASS=nitik123
set DEBUG_PASS=android

echo --- CHECKING KEYSTORES ---

echo [DEBUG KEY]
keytool -list -v -keystore "C:\Users\Administrator\.android\debug.keystore" -storepass %DEBUG_PASS% | findstr "SHA256"

echo [DOWNLOADS]
keytool -list -v -keystore "C:\Users\Administrator\Downloads\upload-keystore.jks" -storepass %PASS% | findstr "SHA256"

echo [ROOT C]
keytool -list -v -keystore "C:\Users\Administrator\upload-keystore.jks" -storepass %PASS% | findstr "SHA256"

echo [G PROJECT]
keytool -list -v -keystore "G:\drnirmal_app\upload-keystore.jks" -storepass %PASS% | findstr "SHA256"

echo [G KEY 1]
keytool -list -v -keystore "G:\key\my-upload-key.jks" -storepass %PASS% | findstr "SHA256"

echo [G KEY 2]
keytool -list -v -keystore "G:\key\upload-keystore.jks" -storepass %PASS% | findstr "SHA256"
