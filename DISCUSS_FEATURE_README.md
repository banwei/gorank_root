# Discuss Section Feature

## Overview
Added a "Discuss" section to the results screen that allows users to comment on their rankings and like other users' comments.

## Features Implemented

### 1. Backend Implementation

#### New Collections
- `comments` - Stores ranking comments
- `comment_likes` - Stores likes on comments

#### API Endpoints
All endpoints follow REST conventions:

**Comments**
- `GET /rankings/:rankingId/comments` - Get all comments for a ranking (paginated)
  - Query params: `page`, `limit`, `userId` (to check if current user liked)
- `POST /rankings/:rankingId/comments` - Create a comment
  - Body: `{ userId, text }`
- `DELETE /comments/:id` - Delete a comment

**Likes**
- `POST /comments/:id/like` - Like a comment
  - Body: `{ userId }`
- `DELETE /comments/:id/like/:userId` - Unlike a comment

#### Data Models
TypeScript (backend):
```typescript
interface RankingComment {
  id: string;
  rankingId: string;
  userId: string;
  username: string;
  userProfileImageUrl?: string;
  text: string;
  likeCount: number;
  likedByCurrentUser?: boolean;
  createdAt: string;
}
```

Dart (frontend):
```dart
class RankingComment {
  final String id;
  final String rankingId;
  final String userId;
  final String username;
  final String? userProfileImageUrl;
  final String text;
  final int likeCount;
  final bool? likedByCurrentUser;
  final String createdAt;
}
```

### 2. Frontend Implementation

#### UI Components

**Discuss Section Location**
- Appears on the results screen after champion section
- Only shown when:
  - User has completed a ranking (`userRankedItems` is not null)
  - Not in view mode (`isViewMode` is false)
  - A ranking ID exists (`rankingId` is not null)

**Comment Input**
- Expandable text field (max 500 characters)
- "Add comment" button for logged-in users
- "Sign in to comment" button for guests
- Post/Cancel buttons

**Comment Display**
- Shows up to 3 most recent comments inline
- "View all X comments" link if more than 3
- Each comment shows:
  - User avatar
  - Username
  - Timestamp (e.g., "2h ago", "1d ago")
  - Comment text
  - Like button with count
  - Delete button (only for comment owner)

**Like Functionality**
- Heart icon (filled when liked, outline when not)
- Shows current like count
- Toggles on/off for logged-in users
- Prompts sign-in for guests

#### State Management
```dart
// Comment state variables
List<shared.RankingComment> _comments = [];
bool _isLoadingComments = false;
final TextEditingController _commentController = TextEditingController();
bool _showCommentInput = false;
```

#### API Service Methods
```dart
// Get comments
static Future<List<RankingComment>> getComments(
  String rankingId, 
  {int page = 1, int limit = 20, String? userId}
)

// Create comment
static Future<RankingComment> createComment(
  String rankingId, 
  CreateCommentRequest request
)

// Delete comment
static Future<void> deleteComment(String commentId)

// Like comment
static Future<int> likeComment(String commentId, String userId)

// Unlike comment
static Future<int> unlikeComment(String commentId, String userId)
```

### 3. User Flow

#### For Logged-In Users (Own Ranking)
1. User completes a ranking
2. Results screen shows champion and "Discuss Your Ranking" section
3. User can click "Add comment" button
4. Text field expands with Post/Cancel buttons
5. User types comment (max 500 chars) and clicks Post
6. Comment appears at top of list
7. User can like/unlike any comment (including their own)
8. User can delete their own comments

#### For Logged-In Users (Viewing Others)
1. Comments section is hidden when viewing another user's ranking
2. This keeps the focus on the ranking comparison

#### For Guest Users
1. See "Sign in to comment" prompt
2. Can view existing comments and like counts
3. Clicking like or comment prompts sign-in
4. After sign-in, can interact normally

### 4. Design Decisions

**Why only show for own rankings?**
- Encourages users to share their own thoughts
- Keeps the interface clean when viewing others' rankings
- Comments are tied to the specific ranking instance

**Why limit to 3 comments initially?**
- Keeps the results screen focused on the ranking comparison
- Prevents overwhelming the UI with too much content
- "View all" link available for those interested

**Why allow users to like their own comments?**
- Technically allowed to keep logic simple
- Not harmful (users can't game the system)
- Standard behavior in many platforms

**Comment character limit (500)**
- Encourages concise "shoutouts" rather than essays
- Balances expression with readability
- Standard for social commenting

### 5. Future Enhancements

Potential improvements for future iterations:

1. **Comment replies** - Nested comment threads
2. **Edit comments** - Allow users to edit their own comments
3. **Report comments** - Moderation system
4. **Sort options** - Sort by newest, most liked, etc.
5. **Rich text** - Support for mentions (@username), hashtags, emojis
6. **Notifications** - Notify users when their comments get likes or replies
7. **Comment on specific items** - Allow comments on individual ranked items
8. **Share comments** - Share individual insightful comments

### 6. Testing Checklist

- [ ] Create a comment as logged-in user
- [ ] View comments as guest user
- [ ] Like/unlike comments
- [ ] Delete own comment
- [ ] Verify character limit (500)
- [ ] Test with empty comment (should be rejected)
- [ ] Test pagination (if more than 20 comments)
- [ ] Verify comments don't show in view mode
- [ ] Test time formatting (just now, minutes, hours, days ago)
- [ ] Test with/without user profile images

### 7. Files Modified

**Backend**
- `shared/api_contracts.json` - Added comment endpoints
- `shared/types.ts` - Added comment types
- `shared/models.dart` - Added comment models
- `backend/src/controllers/commentsController.ts` - New controller
- `backend/src/routes/comments.ts` - New routes
- `backend/src/index.ts` - Registered comment routes

**Frontend**
- `frontend/lib/models/shared_models.dart` - Added comment models
- `frontend/lib/services/api_service.dart` - Added comment API methods
- `frontend/lib/screens/results_screen.dart` - Added discuss section UI

### 8. Database Structure

**Firestore Collections**

`comments`
```javascript
{
  rankingId: "ranking_123",
  userId: "user_456",
  text: "Great ranking! I totally agree with your top choice.",
  createdAt: "2025-10-18T10:30:00Z"
}
```

`comment_likes`
```javascript
{
  commentId: "comment_789",
  userId: "user_101",
  createdAt: "2025-10-18T10:35:00Z"
}
```

### 9. Security Considerations

- All comment operations require valid user ID
- Users can only delete their own comments
- Comment text is trimmed and validated
- Character limit enforced on both frontend and backend
- Ranking existence verified before allowing comments
- User existence verified before creating comments

## Summary

This feature adds social engagement to the ranking results by allowing users to share quick thoughts about their rankings and interact with others through likes. The implementation is clean, focused, and leaves room for future enhancements while providing immediate value to users who want to explain their ranking choices.
