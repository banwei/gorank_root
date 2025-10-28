# Item User-Generated Content Feature

## Overview
This feature allows users to share and discover community-curated content related to items in the GoRank platform. Users can submit links to reviews, social media posts, videos, and other relevant content, creating a rich repository of information around each item.

## Features

### Content Types
Users can share 5 types of content:
1. **Reviews** - Blog posts, news articles, professional reviews
2. **Instagram** - Instagram photos and posts
3. **X/Twitter** - Twitter/X posts and threads
4. **YouTube** - YouTube videos and channels
5. **TikTok** - TikTok videos

### User Actions
- **Add Content**: Authenticated users can add new content by clicking "Add Content" button
- **Like Content**: Users can like content shared by others
- **Delete Content**: Users can delete their own submitted content
- **Browse Content**: All users can view and click through to external content

### Content Display
- Each content card shows:
  - User who submitted it (avatar + username)
  - Content type badge (color-coded)
  - Thumbnail (for YouTube videos)
  - Title and description
  - Like count with interactive like button
  - Link to external content

## Technical Implementation

### Backend (Node.js/TypeScript)

#### Data Models
```typescript
interface ItemContent {
  id: string;
  itemId: string;
  userId: string;
  username: string;
  userProfileImageUrl?: string;
  type: 'review' | 'instagram' | 'twitter' | 'youtube' | 'tiktok';
  url: string;
  title: string;
  description?: string;
  thumbnailUrl?: string;
  likeCount: number;
  likedByCurrentUser?: boolean;
  createdAt: string;
}

interface ItemContentLike {
  id: string;
  contentId: string;
  userId: string;
  createdAt: string;
}
```

#### API Endpoints

**Get Item Contents**
```
GET /items/:itemId/contents?page=1&limit=20&userId=:userId&type=:type
```
Returns all user-submitted content for an item.

**Create Item Content**
```
POST /items/:itemId/contents
Body: {
  userId: string,
  type: 'review' | 'instagram' | 'twitter' | 'youtube' | 'tiktok',
  url: string,
  title: string,
  description?: string
}
```
Creates a new content entry.

**Delete Item Content**
```
DELETE /item-contents/:id
Body: { userId: string }
```
Deletes content (only owner can delete).

**Like Item Content**
```
POST /item-contents/:id/like
Body: { userId: string }
```

**Unlike Item Content**
```
DELETE /item-contents/:id/like/:userId
```

#### Firestore Collections
- `itemContents` - Stores all user-submitted content
- `itemContentLikes` - Stores like relationships

#### Files
- `backend/src/services/itemContentService.ts` - Business logic
- `backend/src/controllers/itemContentController.ts` - API handlers
- `backend/src/routes/itemContents.ts` - Route definitions

### Frontend (Flutter/Dart)

#### API Service Methods
```dart
// Get contents for an item
Future<List<ItemContent>> getItemContents(
  String itemId, {
  int page = 1,
  int limit = 20,
  String? userId,
  ItemContentType? type
})

// Create new content
Future<ItemContent> createItemContent(
  String itemId,
  CreateItemContentRequest request
)

// Delete content
Future<void> deleteItemContent(String contentId, String userId)

// Like/Unlike content
Future<void> likeItemContent(String contentId, String userId)
Future<void> unlikeItemContent(String contentId, String userId)
```

#### UI Components

**External Links Section** (`_buildExternalLinksSection`)
- Shows title "Community Content"
- "Add Content" button (authenticated users only)
- Loading state
- Empty state with helpful message
- List of content cards

**Content Card** (`_buildContentCard`)
- User avatar and username
- Content type badge with color coding
- Thumbnail (for supported types like YouTube)
- Title and description
- Like button with count
- Delete button (own content only)
- Click to open external URL

**Add Content Dialog** (`_showAddContentDialog`)
- Content type selector (chips)
- URL input field
- Title input field
- Optional description field
- Validation before submission

#### Files
- `frontend/lib/screens/item_details_screen.dart` - Updated item details screen
- `frontend/lib/services/api_service.dart` - API integration
- `frontend/lib/models/shared_models.dart` - Data models

### Shared Types
- `shared/types.ts` - TypeScript type definitions
- `shared/models.dart` - Dart model definitions
- `shared/api_contracts.json` - API contract documentation

## Features in Detail

### Thumbnail Generation
The backend automatically generates thumbnails for YouTube videos:
```typescript
// YouTube URL: https://youtube.com/watch?v=ABC123
// Thumbnail: https://img.youtube.com/vi/ABC123/hqdefault.jpg
```

For other content types (Instagram, Twitter, TikTok), thumbnails require additional API integration or web scraping and are not currently implemented.

### Like System
- Users can like/unlike any content
- Like count is displayed on each card
- Visual feedback shows if current user has liked the content
- Real-time updates after like/unlike actions

### Authorization
- **View Content**: Anyone (no auth required)
- **Add Content**: Authenticated users only
- **Like Content**: Authenticated users only
- **Delete Content**: Content owner only

### Content Validation
- URL must be valid and non-empty
- Title must be non-empty
- Content type must be selected
- Description is optional

## Usage Examples

### Adding Content
1. Navigate to an item details page
2. Click "Add Content" button (top right of Community Content section)
3. Select content type (Review, Instagram, Twitter, YouTube, or TikTok)
4. Enter the URL of the content
5. Enter a descriptive title
6. Optionally add a description
7. Click "Add"

### Liking Content
1. View any content card
2. Click the heart icon at the bottom
3. The heart fills red and count increases

### Deleting Content
1. Find your own submitted content
2. Click the trash icon in the top right of the card
3. Confirm deletion in the dialog

## Color Coding

Content types are color-coded for easy identification:
- **Review**: Amber (#F59E0B)
- **YouTube**: Red (#EF4444)
- **Instagram**: Pink (#EC4899)
- **Twitter/X**: Blue (#3B82F6)
- **TikTok**: Black (#000000)

## Future Enhancements

1. **Thumbnail Scraping**: Implement web scraping or API integration for Instagram, Twitter, and TikTok thumbnails
2. **Content Moderation**: Add reporting and moderation system for inappropriate content
3. **Content Verification**: Verify URLs are valid and accessible
4. **Rich Previews**: Embed content directly in the app (e.g., YouTube player, Instagram embeds)
5. **Sorting Options**: Sort by newest, most liked, content type
6. **Search/Filter**: Search content titles and descriptions
7. **User Reputation**: Award badges or points for helpful content contributions
8. **Content Categories**: Allow subcategories within each content type
9. **Share Content**: Share content links directly from the app
10. **Bookmark Content**: Allow users to save favorite content pieces

## Testing

### Manual Testing Steps
1. Test viewing content without authentication
2. Test adding content with authentication
3. Test all 5 content types
4. Test liking/unliking content
5. Test deleting own content
6. Test cannot delete other user's content
7. Test YouTube thumbnail generation
8. Test invalid URLs
9. Test empty title validation
10. Test content persistence across sessions

### Edge Cases
- User deletes account (content should remain or be orphaned)
- Content URL becomes invalid (404)
- Very long titles/descriptions
- Special characters in URLs
- Multiple rapid like/unlike actions
- Network errors during submission

## Security Considerations

1. **URL Validation**: URLs should be validated to prevent XSS attacks
2. **Rate Limiting**: Prevent spam by limiting content submissions per user per time period
3. **Content Moderation**: Implement reporting system for inappropriate content
4. **Authorization Checks**: Always verify user owns content before deletion
5. **CORS**: Ensure external links open in new tab/browser to prevent clickjacking

## Performance Considerations

1. **Pagination**: Content is paginated (20 per page) to avoid loading too much data
2. **Lazy Loading**: Only load contents when section is visible
3. **Caching**: Consider caching popular items' content
4. **Thumbnail Storage**: Store generated YouTube thumbnails instead of regenerating
5. **Like Count Updates**: Batch update like counts to reduce database writes

## Deployment Notes

### Database Setup
No special Firestore indexes required initially. Monitor performance and add indexes as needed based on query patterns.

### Environment Variables
No new environment variables required.

### Migration
No data migration needed - this is a new feature. Existing items will simply have no content initially.

## Monitoring

Track these metrics:
1. Number of content submissions per day
2. Most popular content types
3. Like/unlike ratio
4. Average content per item
5. Failed URL validations
6. Content deletion rate

## Support & Feedback

Users can report issues with content through:
1. In-app reporting (future enhancement)
2. Contact support with content ID
3. Community moderation (future enhancement)
