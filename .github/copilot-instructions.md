# GoRank Project Guidelines for GitHub Copilot

## Project Overview
GoRank is a full-stack TypeScript monorepo with a Flutter frontend and Node.js backend, deployed on Firebase. The platform provides gamified ranking experiences through multiple interactive game modes.

## Architecture & Patterns

### Repository Structure
- **`backend/`** - Node.js + TypeScript + Express API with Firebase Admin SDK
- **`frontend/`** - Flutter web/mobile app with Provider state management  
- **`shared/`** - Type-safe API contracts and synchronized models

### Type Safety & Contracts
- Always reference `shared/api_contracts.json` for endpoint definitions
- Keep TypeScript types in `shared/types.ts` synchronized with Dart models in `shared/models.dart`
- Use Zod validation in backend controllers
- Maintain type safety between frontend and backend at all times

### State Management
- **Backend:** Use controllers → services → Firebase pattern
- **Frontend:** Provider pattern with ApiAppState for centralized state
- **Environment:** Smart detection system in `lib/config/environment.dart`

## Development Guidelines

### Code Style & Quality
- Use ES modules throughout backend (`"type": "module"` in package.json)
- Follow Flutter/Dart conventions for frontend
- Implement comprehensive error handling with try-catch blocks
- Add submission state guards to prevent double-posting in ranking screens

### API Development
- All endpoints must follow the REST conventions defined in `shared/api_contracts.json`
- Implement proper CORS handling for cross-origin requests
- Use Firebase Admin SDK for Firestore operations
- Add proper validation and error responses

### Frontend Development
- **Local Development:** Always follow `.github/run_flutter.prompt.md` for Flutter setup
- Use the environment system for API URLs (dev/prod switching)
- Implement loading states and error handling for all API calls
- Add submission protection to prevent double API calls

### Security & Authentication
- JWT tokens managed via Firebase Auth
- Backend JWT secret stored in Cloud Secret Manager
- Proper authentication middleware for protected routes
- Validate user permissions for data access

## Deployment & Infrastructure

### Firebase App Hosting (Backend)
- Uses `backend/apphosting.yaml` for configuration
- TypeScript dependencies must be in `dependencies` not `devDependencies`
- Auto-deploy on main branch pushes
- Environment variables managed via Cloud Secret Manager

### Firebase Hosting (Frontend)
- Static site deployment for Flutter web builds
- GitHub Actions for automatic deployment
- Environment-aware API URL configuration
- CDN-optimized serving

### Environment Management
- **Development:** `http://localhost:4001` (automatic)
- **Production:** `https://grbackend--gorank-8c97f.asia-east1.hosted.app` (automatic)
- **Override:** Use `--dart-define=API_BASE_URL=custom-url` for custom environments

## Testing & Quality Assurance

### Pre-deployment Checklist
- [ ] Test all 6 ranking game modes for functionality
- [ ] Verify no double-posting occurs during ranking submission
- [ ] Confirm API connectivity between frontend and backend
- [ ] Test authentication flow (login/logout)
- [ ] Validate responsive design on mobile and web

### Debugging Guidelines
- Check `backend/src/services/firebase.ts` for Firestore connection issues
- Review `frontend/lib/services/api_service.dart` for API communication problems
- Use browser dev tools to monitor network requests and responses
- Verify environment configuration in browser console

## Common Patterns & Solutions

### Adding New Features
1. Update `shared/api_contracts.json` with new endpoints
2. Add TypeScript types to `shared/types.ts`
3. Mirror Dart models in `shared/models.dart`  
4. Implement backend controller and routes
5. Update frontend ApiAppState service
6. Create UI screens and test thoroughly

### Ranking Game Development
- All ranking screens must implement submission state protection
- Use consistent UI patterns across different game modes
- Implement progress tracking and visual feedback
- Test for memory leaks in game engine components

### Error Handling
- Backend: Use proper HTTP status codes and error messages
- Frontend: Show user-friendly error messages and loading states
- Log errors appropriately for debugging and monitoring

## Current Production URLs
- **Backend API:** `https://grbackend--gorank-8c97f.asia-east1.hosted.app`
- **Frontend Web:** `https://gorank-8c97f.web.app`
- **Firebase Console:** `https://console.firebase.google.com/project/gorank-8c97f`

## Git & Collaboration
- Use descriptive commit messages referencing API contracts when relevant
- Follow the established branching strategy (main for production)
- Test locally before pushing to avoid breaking production deployments
- Keep dependencies updated and security patches applied
