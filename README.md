# GoRank - Gamified Ranking Platform

**GoRank** is a fun, gamified ranking platform where users rate and rank items through interactive gaming experiences. Users can create lists, participate in various ranking games, and discover trending content.

## 🎮 Features

### Multiple Ranking Game Modes
- **Tournament Style** - Classic bracket-style elimination
- **Pizza Ranking** - Spin the pizza wheel to select items
- **Balloon Pop** - Tap floating balloons in order of preference  
- **Tree Ranking** - Drag ornaments on a Christmas tree for seasonal fun
- **Modern Drag & Drop** - Sleek card-based ranking with Flame game engine
- **Swipe Ranking** - Tinder-style swipe interface

### Core Functionality
- **Random Game Selection** - GoRank button provides random ranking experiences
- **List Discovery** - Browse trending and popular ranking lists
- **User Profiles** - Track personal rankings and preferences
- **Real-time Results** - Compare your rankings with other users
- **Categories** - Organize lists by topics (Food & Drink, Travel, etc.)

## 🏗️ Architecture

This is a full-stack TypeScript monorepo containing:

- **`frontend/`** — Flutter mobile/web app with Provider state management
- **`backend/`** — Node.js + TypeScript + Express REST API with Firebase Admin SDK
- **`shared/`** — Type-safe API contracts and synchronized models

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm
- Flutter SDK 3.0+
- Firebase project with Firestore database

### 1) Backend Setup
```bash
cd backend
npm install
# Configure Firebase credentials in firebase-credentials.json
npm run dev
```

**API Server:** `http://localhost:4001`

### 2) Frontend Setup  
```bash
cd frontend
flutter pub get
flutter run -d chrome  # For web development
```

### 3) Initialize Data (Optional)
```bash
cd backend
npm run init-firestore  # Populate sample categories and lists
```

## 📡 API Endpoints

### Resource Management
- **Categories:** `GET/POST/PUT/DELETE /categories`
- **Users:** `GET/POST/PUT/DELETE /users`  
- **Items:** `GET/POST/PUT/DELETE /items`
- **Lists:** `GET/POST/PUT/DELETE /lists`
- **Rankings:** `GET/POST/PUT/DELETE /rankings`
- **User Groups:** `GET/POST/PUT/DELETE /usergroups`

### Key Endpoints
- `GET /health` - Health check
- `GET /lists/trending` - Popular ranking lists
- `GET /lists/:id` - Get specific list with items
- `POST /rankings` - Submit user rankings
- `GET /categories` - Available categories

Full API documentation: [`backend/API.md`](backend/API.md)

## 🎯 Game Mechanics

### Random Selection System
The app features a dual randomization system:
1. **Random List Selection** - Picks from available trending/demo lists
2. **Random Game Mode** - Selects from 5 different ranking interfaces

### Navigation Structure  
- **Home** - Featured content and GoRank button
- **Search** - Browse and filter ranking lists
- **Profile** - User rankings and preferences

### State Management
- **ApiAppState** - Handles online/offline modes with Firebase integration
- **Local Storage** - Caches data for offline functionality
- **Provider Pattern** - Reactive state updates across the Flutter app

## 🎨 User Experience

### Interactive Games
Each ranking game provides a unique experience:
- **Visual feedback** with animations and sound effects
- **Progress tracking** showing completion status  
- **Drag and drop** reordering capabilities
- **Touch-optimized** interfaces for mobile and web

### Results & Comparison
- View your final rankings alongside popular choices
- Compare with other users' rankings
- Save rankings to your profile
- Share results with friends

## 🔧 Development

### Tech Stack
**Backend:**
- Node.js with TypeScript ES modules
- Express.js REST API framework
- Firebase Admin SDK + Firestore
- Zod for request validation
- CORS enabled for cross-origin requests

**Frontend:**
- Flutter with Dart language
- Provider for state management
- HTTP package for API communication  
- Flame game engine for modern ranking screen
- Local SQLite storage for offline mode

### Code Organization
```
backend/src/
├── controllers/     # Request handlers for each resource
├── routes/         # Express route definitions  
├── services/       # Firebase and business logic
└── models/         # TypeScript type definitions

frontend/lib/
├── models/         # Dart data models
├── screens/        # Game interfaces and main screens
├── services/       # API integration and state management
└── widgets/        # Reusable UI components

shared/
├── api_contracts.json  # OpenAPI-style endpoint definitions
├── types.ts           # TypeScript type definitions
└── models.dart        # Dart model classes
```

### Development Commands
```bash
# Backend
npm run dev          # Start development server with watch mode
npm run build        # Build TypeScript to JavaScript  
npm start           # Run production build

# Frontend  
flutter pub get     # Install dependencies
flutter run -d chrome  # Run on Chrome (web)
flutter run -d windows # Run on Windows (desktop)
flutter build web   # Build for web deployment
```

## 🔄 Shared Contracts

The `shared/` folder maintains type safety between frontend and backend:

- **`api_contracts.json`** - Centralized API endpoint definitions
- **`types.ts`** - TypeScript interfaces for backend
- **`models.dart`** - Dart classes for frontend
- **`models_new.dart`** - Updated models synchronized with backend

### Adding New Features
1. Update `shared/api_contracts.json` with new endpoints
2. Add TypeScript types to `shared/types.ts` 
3. Mirror Dart models in `shared/models.dart`
4. Implement backend controller and routes
5. Update frontend ApiAppState service
6. Create UI screens for new functionality

## 🚦 Current Status

### ✅ Completed Features
- Full CRUD API for all resources (categories, users, items, lists, rankings, usergroups)
- 5 unique ranking game interfaces with animations
- Random game selection system  
- Navigation with Home/Search/Profile structure
- GoRank button for instant random ranking experiences
- User ranking persistence and results comparison
- Responsive design for mobile and web

### 🔄 In Progress  
- Enhanced user authentication system
- Advanced ranking algorithms and analytics  
- Social features (following, sharing, commenting)
- Push notifications for new trending lists

### 🎯 Planned Features
- Multi-language support
- Offline-first PWA capabilities  
- Real-time multiplayer ranking competitions
- Machine learning for personalized recommendations
- Migration from Firebase to Supabase

## 🚀 Production Deployment

### Firebase App Hosting (Backend)
The backend is deployed using Firebase App Hosting with automatic builds from the main repository:

**Live Backend:** `https://grbackend--gorank-8c97f.asia-east1.hosted.app`

#### Deployment Steps:
1. **Configure App Hosting:**
   ```bash
   cd backend
   firebase apphosting:backends:create --project=gorank-8c97f
   # Select region: asia-east1
   # Name: grbackend
   # Repository: banwei/gorank
   # Branch: main
   # Root directory: /backend
   ```

2. **Environment Setup:**
   - JWT secret managed via Cloud Secret Manager
   - Firebase credentials configured automatically
   - TypeScript dependencies moved to `dependencies` (not `devDependencies`) for Cloud Build

3. **Auto-deployment:**
   - Triggered on every push to main branch
   - Uses `apphosting.yaml` configuration
   - Build process: `npm install` → `npm run build` → serve on port 8080

### Firebase Hosting (Frontend)
The frontend is deployed using Firebase Hosting for optimal static site serving:

**Live Frontend:** `https://gorank-8c97f.web.app`

#### Deployment Steps:
1. **Initialize Hosting:**
   ```bash
   cd frontend
   firebase init hosting
   # Public directory: build/web
   # Single-page app: Yes
   # GitHub automatic builds: Yes
   ```

2. **Environment Configuration:**
   - API baseUrl automatically switches between dev/prod environments
   - Development: `http://localhost:4001`
   - Production: `https://grbackend--gorank-8c97f.asia-east1.hosted.app`
   - Build-time override: `flutter build web --dart-define=API_BASE_URL=custom-url`

3. **GitHub Actions Deployment:**
   - Automatic deployment on push to main
   - Flutter web build with production API URL
   - Hosted at Firebase Hosting domain

#### Manual Deployment:
```bash
cd frontend
flutter build web --release --dart-define=API_BASE_URL=https://grbackend--gorank-8c97f.asia-east1.hosted.app
firebase deploy --only hosting
```

### Environment Management
The app uses a smart environment detection system in `frontend/lib/config/environment.dart`:

- **Development Mode:** Automatically uses localhost backend when running `flutter run`
- **Production Build:** Uses production backend URL when building for deployment
- **Configurable:** Can override with `--dart-define=API_BASE_URL=custom-url`

### Testing Deployment
After deployment, test the complete flow:
1. **Frontend:** Visit `https://gorank-8c97f.web.app`
2. **Authentication:** Test login/logout flow
3. **API Connectivity:** Create rankings and verify backend communication
4. **Ranking Games:** Test all 6 ranking interfaces for submission protection (no double-posting)

## 🤝 Contributing

This project uses VS Code with GitHub Copilot for enhanced development experience:

- Keep API changes synchronized between `shared/` contracts
- Reference JSON contracts in commit messages for better AI suggestions
- Use TypeScript/Dart type safety throughout the codebase
- Follow the established patterns for controllers, services, and state management
- **Local Development:** Follow `.github/run_flutter.prompt.md` for Flutter setup guidelines

## 📄 License

This project is private and not intended for public distribution.
