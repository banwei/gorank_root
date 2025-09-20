# Flutter Local Development Setup for GoRank

## Quick Start Commands

### Initial Setup (First Time)
```bash
# Navigate to frontend directory
cd frontend

# Install Flutter dependencies
flutter pub get

# Verify Flutter installation and web support
flutter doctor
flutter config --enable-web

# Run on Chrome for web development
flutter run -d chrome
```

### Daily Development Workflow
```bash
# Start backend first (in separate terminal)
cd backend
npm run dev  # Backend runs on http://localhost:4001

# Then start frontend (in another terminal)
cd frontend
flutter run -d chrome  # Frontend auto-detects localhost backend
```

## Environment Configuration

### Automatic Environment Detection
The app automatically detects your environment:
- **Development Mode:** Uses `http://localhost:4001` when running `flutter run`
- **Production Mode:** Uses `https://grbackend--gorank-8c97f.asia-east1.hosted.app` when building for deployment

### Manual Environment Override
```bash
# Force production API in development
flutter run -d chrome --dart-define=API_BASE_URL=https://grbackend--gorank-8c97f.asia-east1.hosted.app

# Use custom backend URL
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

## Platform-Specific Commands

### Web Development (Recommended)
```bash
flutter run -d chrome           # Chrome with hot reload
flutter run -d chrome --release # Production build in Chrome
```

### Desktop Development
```bash
flutter run -d windows          # Windows desktop app
flutter run -d macos           # macOS desktop app (on Mac)
flutter run -d linux           # Linux desktop app (on Linux)
```

### Mobile Development
```bash
flutter run -d android         # Android emulator/device
flutter run -d ios            # iOS simulator/device (on Mac)
```

## Build Commands

### Web Production Build
```bash
# Standard production build
flutter build web --release

# Production build with custom API URL
flutter build web --release --dart-define=API_BASE_URL=https://custom-backend.com

# Build output: frontend/build/web/
```

### Desktop Builds
```bash
flutter build windows --release  # Windows executable
flutter build macos --release   # macOS app bundle
flutter build linux --release   # Linux executable
```

## Development Tools

### VS Code Setup
Recommended VS Code extensions:
- **Flutter** - Official Flutter extension
- **Dart** - Dart language support
- **GitHub Copilot** - AI pair programming (follows `.github/copilot-instructions.md`)

### Debugging
```bash
# Run with debug info
flutter run -d chrome --debug

# Profile mode (performance testing)
flutter run -d chrome --profile

# Verbose logging
flutter run -d chrome -v
```

### Hot Reload
- **`r`** - Hot reload (fastest, preserves state)
- **`R`** - Hot restart (resets app state)
- **`q`** - Quit debug session

## Common Issues & Solutions

### Backend Connection Issues
```bash
# 1. Verify backend is running
curl http://localhost:4001/health

# 2. Check CORS settings in backend/src/index.ts
# 3. Ensure frontend uses correct environment detection
```

### Flutter Web Issues
```bash
# Clear Flutter web cache
flutter clean
flutter pub get

# Regenerate web files
flutter create --platforms web .
```

### Environment Variable Problems
```bash
# Debug current environment detection
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:4001

# Check environment in browser console (should show environment info)
```

### Dependencies Issues
```bash
# Reset all dependencies
flutter clean
flutter pub get
flutter pub upgrade

# Check for Flutter version issues
flutter doctor
flutter channel stable
flutter upgrade
```

## Testing Workflow

### Local Testing Checklist
- [ ] Backend health check: `curl http://localhost:4001/health`
- [ ] Frontend loads without errors in Chrome DevTools
- [ ] Authentication flow works (login/logout)
- [ ] API calls reach backend (check Network tab)
- [ ] All 6 ranking game modes function properly
- [ ] No double-posting when submitting rankings

### Performance Testing
```bash
# Profile mode for performance analysis
flutter run -d chrome --profile

# Release mode testing
flutter run -d chrome --release
```

## Project Structure Context

### Key Files for Local Development
- **`lib/config/environment.dart`** - Environment detection logic
- **`lib/services/api_service.dart`** - API communication layer
- **`lib/main.dart`** - App entry point with Provider setup
- **`pubspec.yaml`** - Flutter dependencies and configuration

### Backend Integration
- **Base URL:** Automatically switches between localhost and production
- **Authentication:** JWT tokens from Firebase Auth
- **API Endpoints:** RESTful endpoints defined in `shared/api_contracts.json`

## Deployment Testing

### Pre-deployment Local Testing
```bash
# Test production build locally
flutter build web --release --dart-define=API_BASE_URL=https://grbackend--gorank-8c97f.asia-east1.hosted.app

# Serve locally to test production build
cd build/web
python -m http.server 8000  # Or use any static file server
# Visit http://localhost:8000
```

### Firebase Hosting Deployment
```bash
# Deploy to Firebase Hosting
firebase deploy --only hosting

# Deploy with custom API URL
flutter build web --release --dart-define=API_BASE_URL=https://custom-backend.com
firebase deploy --only hosting
```

## Support & Troubleshooting

If you encounter issues:
1. Check this guide first for common solutions
2. Review the main `README.md` for architecture overview
3. Consult `.github/copilot-instructions.md` for AI assistance patterns
4. Use Flutter's extensive debugging tools and VS Code integration

Remember: The environment system is designed to "just work" - you shouldn't need to manually configure API URLs in most cases!
