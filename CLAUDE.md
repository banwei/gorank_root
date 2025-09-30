# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Backend (Node.js + TypeScript)
```bash
cd backend
npm install
npm run dev          # Start development server with hot reload
npm run build        # Compile TypeScript to JavaScript
npm start           # Run production build
npm run lint        # (placeholder - add eslint if needed)

# Data management scripts
npm run init-firestore      # Initialize Firestore with sample data
npm run seed-examples       # Seed database from examples
npm run test-auth          # Test authentication functionality
```

### Frontend (Flutter)
```bash
cd frontend
flutter pub get             # Install dependencies
flutter run -d chrome      # Run web app (auto-detects localhost:4001 backend)
flutter run -d windows     # Run Windows desktop app
flutter build web --release # Build for production

# With custom API endpoint
flutter run -d chrome --dart-define=API_BASE_URL=custom-url
```

## Architecture Overview

This is a **full-stack TypeScript/Dart monorepo** for a gamified ranking platform:

- **`backend/`** - Node.js + Express REST API with Firebase Firestore
- **`frontend/`** - Flutter web/desktop app with Provider state management
- **`shared/`** - Type-safe API contracts synchronized between frontend/backend

### Key Technologies
- **Backend**: TypeScript ES modules, Express.js, Firebase Admin SDK, Zod validation
- **Frontend**: Flutter/Dart with Provider pattern, HTTP client, Flame game engine
- **Database**: Firebase Firestore with structured collections
- **Deployment**: Firebase App Hosting (backend) + Firebase Hosting (frontend)

## Code Structure

### Backend (`backend/src/`)
```
controllers/     # Request handlers for each resource (categories, users, items, lists, rankings)
routes/         # Express route definitions
services/       # Firebase integration and business logic
models/         # TypeScript type definitions
```

### Frontend (`frontend/lib/`)
```
models/         # Dart data models with JSON serialization
screens/        # UI screens including 6 different ranking game modes
services/       # API integration and state management (ApiAppState)
widgets/        # Reusable UI components
config/         # Environment detection (dev/prod API endpoints)
```

### Shared Contracts (`shared/`)
- **`api_contracts.json`** - Complete API specification
- **`types.ts`** - TypeScript interfaces for backend
- **`models.dart`** - Dart classes for frontend
- **Keep all three synchronized when making API changes**

## Important Development Notes

### Environment Detection
The frontend automatically switches between environments:
- **Development**: `http://localhost:4001` (when running `flutter run`)
- **Production**: `https://grbackend--gorank-8c97f.asia-east1.hosted.app` (when building)

### API Architecture
Full CRUD operations for all resources:
- Categories, Users, Items, Lists, Rankings, UserGroups
- Key endpoints: `/health`, `/lists/trending`, `/categories`
- Firebase Firestore backend with structured collections

### Game Features
6 unique ranking game modes:
- Tournament Style, Pizza Ranking, Balloon Pop, Tree Ranking
- Modern Drag & Drop (with Flame engine), Swipe Ranking
- Random game selection system for variety

### Type Safety
- Backend uses Zod for request validation
- Frontend/backend share synchronized types via `shared/` folder
- Always update all three contract files together: `api_contracts.json`, `types.ts`, `models.dart`

### Firebase Configuration
- Backend requires `firebase-credentials.json` file
- Frontend uses Firebase Auth, Firestore, and Storage
- Storage rules configured in `storage.rules` and `storage-dev.rules`

## Production Deployment

### Backend
- **Platform**: Firebase App Hosting
- **URL**: `https://grbackend--gorank-8c97f.asia-east1.hosted.app`
- **Auto-deploy**: On main branch pushes via `apphosting.yaml`

### Frontend
- **Platform**: Firebase Hosting
- **URL**: `https://gorank-8c97f.web.app`
- **Auto-deploy**: GitHub Actions on main branch pushes

## Development Workflow

1. **API Changes**: Update `shared/api_contracts.json`, `types.ts`, and `models.dart`
2. **Backend**: Implement controllers/routes, test with scripts in `backend/scripts/`
3. **Frontend**: Update `ApiAppState` service and UI screens
4. **Testing**: Use health check endpoint and ranking game submission protection
5. **Type Safety**: Ensure contracts stay synchronized across all environments