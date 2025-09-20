# PowerShell script to configure Firebase Storage CORS
# Run this script from the project root directory

Write-Host "Configuring Firebase Storage CORS for GoRank..." -ForegroundColor Green

# Check if gcloud is installed
try {
    gcloud --version | Out-Null
    Write-Host "✓ Google Cloud SDK is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Google Cloud SDK is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Google Cloud SDK from: https://cloud.google.com/sdk/docs/install-sdk" -ForegroundColor Yellow
    exit 1
}

# Check if user is authenticated
try {
    $account = gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>$null
    if ([string]::IsNullOrEmpty($account)) {
        Write-Host "❌ Not authenticated with Google Cloud" -ForegroundColor Red
        Write-Host "Please run: gcloud auth login" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✓ Authenticated as: $account" -ForegroundColor Green
} catch {
    Write-Host "❌ Authentication check failed" -ForegroundColor Red
    Write-Host "Please run: gcloud auth login" -ForegroundColor Yellow
    exit 1
}

# Set the project
Write-Host "Setting project to gorank-8c97f..." -ForegroundColor Blue
try {
    gcloud config set project gorank-8c97f
    Write-Host "✓ Project set successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to set project" -ForegroundColor Red
    exit 1
}

# Apply CORS configuration
Write-Host "Applying CORS configuration to Firebase Storage..." -ForegroundColor Blue
try {
    gsutil cors set firebase-storage-cors.json gs://gorank-8c97f.firebasestorage.app
    Write-Host "✓ CORS configuration applied successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 Firebase Storage is now configured to allow uploads from localhost" -ForegroundColor Green
    Write-Host "You can now upload profile images from your web app!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to apply CORS configuration" -ForegroundColor Red
    Write-Host "Make sure you have the necessary permissions for the Firebase project" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Start your backend: npm start" -ForegroundColor White
Write-Host "2. Start your frontend: flutter run -d chrome --hot" -ForegroundColor White
Write-Host "3. Test profile image upload functionality" -ForegroundColor White
