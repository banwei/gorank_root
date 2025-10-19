# Comment System Redesign

## Overview
Redesigned the comment system to be list-centric rather than ranking-centric, allowing more flexible commenting functionality.

## Key Changes

### Architecture
- **Before**: Comments belonged to rankings only
- **After**: Comments belong to lists first, with optional links to specific rankings

### New Features
1. ✅ Users can comment on a list without needing to create a ranking
2. ✅ Comments can optionally be linked to a specific ranking
3. ✅ Logged-in users can leave comments anywhere in the app
4. ✅ Non-logged-in users can view all comments but are prompted to login to comment
5. ✅ All comments for a list are visible regardless of where they're viewed (profile page, direct link, etc.)

## Technical Implementation

### Backend Changes

#### 1. Updated Comment Schema (`backend/src/models/types.ts`)
```typescript
export interface RankingComment {
  id: string;
  listId: string;          // NEW: Primary - comment belongs to a list
  rankingId?: string;      // CHANGED: Optional - can be linked to a ranking
  userId: string;
  username: string;
  userProfileImageUrl?: string;
  text: string;
  likeCount: number;
  likedByCurrentUser?: boolean;
  createdAt: string;
}

export interface CreateCommentRequest {
  userId: string;
  text: string;
  rankingId?: string;      // NEW: Optional ranking link
}
```

#### 2. Updated API Endpoints (`backend/src/routes/comments.ts`)
```typescript
// OLD: GET /rankings/:rankingId/comments
// NEW: GET /lists/:listId/comments?rankingId=optional

// OLD: POST /rankings/:rankingId/comments
// NEW: POST /lists/:listId/comments (with optional rankingId in body)
```

#### 3. Updated Controller (`backend/src/controllers/commentsController.ts`)
- `getComments()`: Now fetches by listId with optional rankingId filter
- `createComment()`: Now creates comment for listId with optional rankingId link

### Frontend Changes

#### 1. Updated Dart Models (`frontend/lib/models/shared_models.dart`)
```dart
class RankingComment {
  final String id;
  final String listId;        // NEW: Primary
  final String? rankingId;    // CHANGED: Optional
  // ... other fields
}

class CreateCommentRequest {
  final String userId;
  final String text;
  final String? rankingId;    // NEW: Optional
}
```

#### 2. Updated API Service (`frontend/lib/services/api_service.dart`)
```dart
// Updated method signatures
static Future<List<RankingComment>> getComments(
  String listId,          // CHANGED: from rankingId to listId
  {
    int page = 1,
    int limit = 20,
    String? userId,
    String? rankingId,    // NEW: Optional filter
  }
)

static Future<RankingComment> createComment(
  String listId,          // CHANGED: from rankingId to listId
  CreateCommentRequest request  // Now includes optional rankingId
)
```

#### 3. Updated UI (`frontend/lib/screens/results_screen.dart`)
- Comments section now shows for all lists, not just when rankingId exists
- Non-logged-in users see "Sign in to comment" button
- Logged-in users can comment anytime with "+" button
- Comments can be posted with or without a ranking context
- All list comments are visible in the community discussion section

### Database Schema

#### Firestore `comments` Collection
```json
{
  "id": "auto-generated",
  "listId": "required-string",
  "rankingId": "optional-string",
  "userId": "required-string",
  "text": "required-string",
  "createdAt": "ISO-timestamp"
}
```

#### Indexes Needed
1. `listId` (for fetching all comments for a list)
2. `listId + rankingId` (for filtering comments by specific ranking)
3. `listId + createdAt` (for sorting)

## User Flows

### Flow 1: Viewing Comments (Non-Logged-In)
1. User views any list/ranking
2. Sees "Community Discussion" section with all list comments
3. Sees "Leave a Comment" section
4. Clicks to comment → Prompted to sign in

### Flow 2: Commenting on a List (Logged-In, No Ranking)
1. User views a list without creating a ranking
2. Clicks "+" to add comment
3. Types comment (linked to listId only, no rankingId)
4. Posts successfully

### Flow 3: Commenting on Own Ranking (Logged-In)
1. User completes a ranking
2. On results screen, clicks "+" to add comment
3. Types comment (linked to both listId and rankingId)
4. Posts successfully

### Flow 4: Commenting on Someone Else's Ranking (Logged-In)
1. User views another user's ranking from profile
2. Clicks "+" to add comment
3. Types comment (linked to listId, can reference the ranking)
4. Posts successfully

## API Contract Updates

### Updated `shared/api_contracts.json`
```json
{
  "comments": {
    "list": {
      "method": "GET",
      "path": "/lists/:listId/comments",
      "queryParams": {
        "rankingId": "string?",
        "userId": "string?",
        "page": "number?",
        "limit": "number?"
      }
    },
    "create": {
      "method": "POST",
      "path": "/lists/:listId/comments",
      "body": {
        "userId": "string",
        "text": "string",
        "rankingId": "string?"
      }
    }
  }
}
```

## Migration Notes

### Existing Data
If you have existing comments in the database with `rankingId` but no `listId`, you'll need to run a migration:

```typescript
// Migration script (run once)
const migrateComments = async () => {
  const firestore = db();
  const commentsSnapshot = await firestore.collection('comments').get();
  
  for (const commentDoc of commentsSnapshot.docs) {
    const data = commentDoc.data();
    
    if (!data.listId && data.rankingId) {
      // Get the ranking to find the listId
      const rankingDoc = await firestore.collection('rankings').doc(data.rankingId).get();
      const rankingData = rankingDoc.data();
      
      if (rankingData?.listId) {
        // Update comment with listId
        await commentDoc.ref.update({
          listId: rankingData.listId
        });
      }
    }
  }
};
```

## Testing Checklist

- [ ] Non-logged-in user can view comments
- [ ] Non-logged-in user is prompted to login when trying to comment
- [ ] Logged-in user can comment on a list without creating a ranking
- [ ] Logged-in user can comment on their own ranking
- [ ] Logged-in user can comment on someone else's ranking
- [ ] Comments appear in both the individual section and community discussion
- [ ] Like/unlike functionality works for all comments
- [ ] Delete functionality works for own comments
- [ ] Comments are properly filtered by rankingId when specified
- [ ] All comments for a list are visible in community discussion

## Benefits

1. **More Engagement**: Users don't need to create a ranking to participate in discussions
2. **Flexibility**: Comments can be list-wide or ranking-specific
3. **Better UX**: Clear call-to-action for non-logged-in users
4. **Scalability**: Easier to aggregate and display all list discussions
5. **Social Features**: Encourages community interaction at all levels

## Future Enhancements

- Add comment threading/replies
- Add mentions (@username)
- Add comment reactions (beyond just likes)
- Add comment reporting/moderation
- Add comment notifications
- Add comment search/filtering
