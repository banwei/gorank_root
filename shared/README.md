# GoRank Shared Models & API Contracts

## Overview
This folder contains shared models and API contracts that ensure consistency between the Flutter frontend and Node.js backend.

## Files

### 1. `api_contracts.json`
**Purpose**: Complete API specification for the GoRank backend
**Contents**:
- Base URL configuration
- All API endpoints with HTTP methods, paths, and descriptions
- Request/response body schemas
- Query parameter specifications
- Model definitions

**Key Endpoints**:
- **Categories**: Full CRUD operations
- **Users**: Full CRUD operations
- **Items**: Full CRUD operations with category filtering
- **User Groups**: Full CRUD operations with member management
- **Lists**: Full CRUD operations with trending endpoint
- **Rankings**: Full CRUD operations with statistics

### 2. `types.ts`
**Purpose**: TypeScript interfaces for backend development
**Contents**:
- Core model interfaces (Category, User, Item, UserGroup, ListEntity, UserRanking)
- Request/response types for all API endpoints
- Query parameter types
- Error handling types
- Backward compatibility types

**Key Features**:
- Strict typing for all data models
- Comprehensive request/response types
- Query parameter definitions
- Error handling structures

### 3. `models.dart`
**Purpose**: Dart classes for Flutter frontend development
**Contents**:
- Core model classes with JSON serialization
- Request classes for API calls
- Factory constructors for JSON parsing
- toJson() methods for API requests

**Key Features**:
- Complete JSON serialization support
- Type-safe model definitions
- Request classes for API interactions
- Null safety support

## Usage

### Backend (TypeScript)
```typescript
import { Category, CreateCategoryRequest } from '../shared/types';

// Use interfaces for type safety
const category: Category = {
  id: 'cat1',
  name: 'Food & Drink',
  // ... other properties
};
```

### Frontend (Flutter/Dart)
```dart
import '../shared/models.dart';

// Parse JSON response
final category = Category.fromJson(jsonResponse);

// Create API request
final request = CreateCategoryRequest(
  name: 'Sports',
  description: 'Sports and athletics',
  iconName: 'sports',
  colorHex: '#FF9800',
);
```

## API Integration

### Base URL
```
http://localhost:4001
```

### Example API Calls

#### Get All Categories
```
GET /categories
```

#### Create New Category
```
POST /categories
Content-Type: application/json

{
  "name": "Sports",
  "description": "Sports and athletics",
  "iconName": "sports",
  "colorHex": "#FF9800"
}
```

#### Get Trending Lists
```
GET /lists/trending?limit=10
```

## Model Relationships

```
Category
├── Items (many-to-one)
└── Lists (many-to-one)

User
├── UserGroups (many-to-many)
├── Lists (one-to-many, as creator)
└── Rankings (one-to-many)

List
├── Items (many-to-many)
├── Category (many-to-one)
├── User (many-to-one, as creator)
└── Rankings (one-to-many)

UserGroup
├── Users (many-to-many)
└── Categories (many-to-many)

Ranking
├── User (many-to-one)
├── List (many-to-one)
└── Items (ranked order)
```

## Version Compatibility

- **Backend**: Node.js with TypeScript ES modules
- **Frontend**: Flutter with Dart null safety
- **API Version**: v1.0 (current)
- **Firebase**: Firestore for data persistence

## Development Notes

1. **Type Safety**: Both TypeScript and Dart models are strongly typed
2. **JSON Serialization**: Full support for API data exchange
3. **Backward Compatibility**: Deprecated models maintained for migration
4. **Validation**: Request types include optional parameters for flexibility
5. **Error Handling**: Standardized error response structures

## Update Protocol

When updating models:
1. Update `types.ts` for backend changes
2. Update `models.dart` for frontend changes  
3. Update `api_contracts.json` for API changes
4. Ensure all three files remain synchronized
5. Test both frontend and backend integration

This ensures type safety and consistency across the entire GoRank application stack.
