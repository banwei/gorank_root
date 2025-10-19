# UpdatedAt Field Implementation

## Overview
This document describes the implementation of the `updatedAt` field for `UserRanking` to track when rankings are last modified by users.

## Changes Made

### 1. Backend TypeScript Types
**Files Modified:**
- `shared/types.ts`
- `backend/src/models/types.ts`

**Changes:**
```typescript
export interface UserRanking {
  id: string;
  userId: string;
  listId: string;
  rankedItemIds: string[];
  method: string;
  groupType: string;
  createdAt: string;
  updatedAt: string;  // ✅ ADDED
  itemRatings: Record<string, number>;
}
```

### 2. Backend Controller
**File Modified:** `backend/src/controllers/rankingsController.ts`

**Changes:**
- **`createRanking()`**: Sets both `createdAt` and `updatedAt` to the current timestamp when creating a new ranking
- **`updateRanking()`**: Automatically sets `updatedAt` to the current timestamp when updating a ranking

```typescript
// Creating a ranking
const now = new Date().toISOString();
const newRanking: UserRanking = {
  // ... other fields
  createdAt: now,
  updatedAt: now,  // ✅ ADDED
};

// Updating a ranking
const dataToUpdate = {
  ...updateData,
  updatedAt: new Date().toISOString()  // ✅ ADDED
};
```

### 3. Dart Models
**Files Modified:**
- `shared/models.dart`
- `frontend/lib/models/shared_models.dart`

**Changes:**
```dart
class UserRanking {
  final String id;
  final String userId;
  final String listId;
  final List<String> rankedItemIds;
  final String method;
  final String groupType;
  final String createdAt;
  final String updatedAt;  // ✅ ADDED
  final Map<String, double> itemRatings;

  factory UserRanking.fromJson(Map<String, dynamic> json) => UserRanking(
    // ... other fields
    updatedAt: (json['updatedAt'] ?? json['createdAt']) as String,  // ✅ Fallback for backward compatibility
  );
}
```

### 4. Frontend Profile Screen
**File Modified:** `frontend/lib/screens/profile_screen.dart`

**Changes:**
- Updated sorting in `_calculateUserStats()` to use `updatedAt` instead of `createdAt`
- Updated sorting in `_buildRecentRankingsTab()` to use `updatedAt` instead of `createdAt`

```dart
// Before
final sortedRankings = _userRankings
  ..sort((a, b) => DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

// After
final sortedRankings = List<api_models.UserRanking>.from(_userRankings)
  ..sort((a, b) => DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt)));
```

## Migration

### Running the Migration Script
A migration script has been created to add `updatedAt` to existing rankings in the database:

**Prerequisites:**
- Ensure `firebase-credentials.json` exists in the `backend/` directory
- The script automatically sets the credentials path

**Run the script:**
```bash
cd backend
npx tsx scripts/add-updated-at-to-rankings.ts
```

**What the script does:**
1. Fetches all rankings from Firestore
2. For each ranking without an `updatedAt` field:
   - Sets `updatedAt` to the value of `createdAt` (for consistency)
   - Updates the document in Firestore
3. Skips rankings that already have `updatedAt`
4. Uses batched writes for efficiency (500 documents per batch)

**Expected output:**
```
Starting migration to add updatedAt field to rankings...
Found 150 rankings to update
Progress: 50 rankings updated...
Progress: 100 rankings updated...
Progress: 150 rankings updated...

✅ Migration complete!
   Updated: 150 rankings
   Skipped: 0 rankings (already had updatedAt)
   Total:   150 rankings
```

## Backward Compatibility

The implementation includes backward compatibility measures:

1. **Dart Models**: The `fromJson` method uses a fallback:
   ```dart
   updatedAt: (json['updatedAt'] ?? json['createdAt']) as String
   ```
   This ensures that old rankings without `updatedAt` will use `createdAt` as the value.

2. **Migration Script**: Existing rankings are updated to have `updatedAt = createdAt`, ensuring data consistency.

## Deployment Steps

1. **Deploy Backend First:**
   ```bash
   cd backend
   # Deploy to Firebase App Hosting
   git push origin main  # Auto-deploys via GitHub Actions
   ```

2. **Run Migration:**
   ```bash
   cd backend
   npx tsx scripts/add-updated-at-to-rankings.ts
   ```

3. **Deploy Frontend:**
   ```bash
   cd frontend
   flutter build web
   firebase deploy --only hosting
   ```

## Testing

### Test New Rankings
1. Create a new ranking
2. Verify it has both `createdAt` and `updatedAt` fields
3. Check that both timestamps are the same

### Test Ranking Updates
1. Update an existing ranking
2. Verify `updatedAt` is newer than `createdAt`
3. Check that the profile screen shows the ranking in the correct order

### Test Profile Screen Sorting
1. Create multiple rankings at different times
2. Update one of the older rankings
3. Verify it appears at the top of "Recent Rankings" tab
4. Verify the "Active" stat reflects the most recent `updatedAt`

## API Impact

### Affected Endpoints

**`POST /rankings`** - Create ranking
- Now returns rankings with `updatedAt` field

**`PUT /rankings/:id`** - Update ranking
- Automatically sets `updatedAt` to current timestamp
- Returns updated ranking with new `updatedAt`

**`GET /rankings`** - List rankings
- All rankings now include `updatedAt` field

**`GET /rankings/:id`** - Get ranking by ID
- Returns ranking with `updatedAt` field

## Benefits

1. **Accurate Activity Tracking**: Users' recent activity is now based on when they last modified rankings, not just created them
2. **Better Sorting**: Rankings can be sorted by most recently updated, providing a more dynamic view
3. **Future Features**: Opens up possibilities for "recently updated" feeds, activity timelines, etc.

## Notes

- The `updatedAt` field is automatically managed by the backend
- Frontend code should not attempt to set `updatedAt` manually
- All date/time values are stored as ISO 8601 strings in UTC
- The migration script is idempotent and can be run multiple times safely
