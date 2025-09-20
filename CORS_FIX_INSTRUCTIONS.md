# Firebase Storage CORS Fix for GoRank

## Problem
When uploading images to Firebase Storage from localhost (web browser), you encounter CORS (Cross-Origin Resource Sharing) errors.

## Solutions

### Option 1: Configure Firebase Storage CORS Rules (Recommended)

1. **Install Google Cloud SDK** if you haven't already:
   - Download from: https://cloud.google.com/sdk/docs/install
   - Follow installation instructions for Windows

2. **Login to Google Cloud**:
   ```bash
   gcloud auth login
   ```

3. **Set your project**:
   ```bash
   gcloud config set project gorank-8c97f
   ```

4. **Apply CORS configuration**:
   ```bash
   gsutil cors set firebase-storage-cors.json gs://gorank-8c97f.firebasestorage.app
   ```

### Option 2: Firebase Storage Rules Update

Update your Firebase Storage security rules in the Firebase Console:

1. Go to Firebase Console: https://console.firebase.google.com/project/gorank-8c97f
2. Navigate to Storage → Rules
3. Update the rules to:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow authenticated users to upload profile images
    match /profile_images/{userId}_{timestamp}.{ext} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow read access to all files (for public profile images)
    match /{allPaths=**} {
      allow read: if true;
    }
  }
}
```

### Option 3: Development Workaround

For local development, you can temporarily disable web security in Chrome:

**Windows:**
```bash
"C:\Program Files\Google\Chrome\Application\chrome.exe" --disable-web-security --disable-features=VizDisplayCompositor --user-data-dir="C:\temp\chrome-dev"
```

**macOS:**
```bash
open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security
```

### Option 4: Proxy Upload Through Backend (Alternative)

If CORS continues to be an issue, the image upload can be proxied through your backend:

1. Frontend sends image data to your backend
2. Backend uploads to Firebase Storage
3. Backend returns the download URL

This approach is already prepared in `backend/src/controllers/uploadController.ts`.

## Testing the Fix

After applying any of the above solutions:

1. Start your backend: `npm start`
2. Start your frontend: `flutter run -d chrome --hot`
3. Navigate to Profile → Edit Profile
4. Try uploading a profile image

## Firebase Storage CORS Configuration File

The `firebase-storage-cors.json` file contains:
```json
[
  {
    "origin": ["*"],
    "method": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    "maxAgeSeconds": 3600,
    "responseHeader": ["Content-Type", "Authorization"]
  }
]
```

This allows uploads from any origin (including localhost) during development.

## Production Considerations

For production, consider:
1. Restricting CORS origins to your actual domains
2. Using Firebase Authentication for upload security
3. Implementing proper file size and type validation
4. Setting up proper Firebase Storage security rules
