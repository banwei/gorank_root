# PowerShell script to deploy secure Firebase Storage rules

Write-Host "Deploying SECURE Firebase Storage rules..." -ForegroundColor Green
Write-Host ""

Write-Host "Current rules will enforce:" -ForegroundColor Yellow
Write-Host "- Profile images are publicly readable" -ForegroundColor White
Write-Host "- Only authenticated users can upload" -ForegroundColor White  
Write-Host "- Users can only upload files with their Firebase Auth UID" -ForegroundColor White
Write-Host "- All other paths are blocked by default" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to continue or Ctrl+C to cancel"

Write-Host "Deploying rules..." -ForegroundColor Blue
try {
    firebase deploy --only storage --project gorank-8c97f
    
    Write-Host ""
    Write-Host "✅ Secure Firebase Storage rules deployed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Security features:" -ForegroundColor Cyan
    Write-Host "✓ Profile images: Public read, authenticated write only" -ForegroundColor Green
    Write-Host "✓ Users can only upload files starting with their UID" -ForegroundColor Green
    Write-Host "✓ All other paths blocked by default" -ForegroundColor Green
    Write-Host "✓ No anonymous uploads allowed" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to deploy rules" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"
