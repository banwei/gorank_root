@echo off
echo Deploying SECURE Firebase Storage rules...
echo.

echo Current rules will enforce:
echo - Profile images are publicly readable
echo - Only authenticated users can upload
echo - Users can only upload files with their Firebase Auth UID
echo - All other paths are blocked by default
echo.

pause

echo Deploying rules...
firebase deploy --only storage --project gorank-8c97f

echo.
echo ✅ Secure Firebase Storage rules deployed!
echo.
echo Security features:
echo ✓ Profile images: Public read, authenticated write only
echo ✓ Users can only upload files starting with their UID
echo ✓ All other paths blocked by default
echo ✓ No anonymous uploads allowed
echo.
pause
