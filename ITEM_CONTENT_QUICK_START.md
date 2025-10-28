# Quick Start: Item User-Generated Content

## For Users

### How to Add Content
1. Open any item details page
2. Scroll to "Community Content" section
3. Click **"Add Content"** button (login required)
4. Select content type: Review, YouTube, Instagram, Twitter, or TikTok
5. Paste the URL
6. Enter a title
7. Add description (optional)
8. Click **"Add"**

### How to Like Content
- Click the ❤️ icon on any content card
- Click again to unlike

### How to Delete Your Content
- Find content you submitted
- Click the 🗑️ icon
- Confirm deletion

## For Developers

### Backend Structure
```
backend/src/
├── controllers/itemContentController.ts    # API handlers
├── services/itemContentService.ts          # Business logic
└── routes/itemContents.ts                 # Route definitions
```

### Frontend Structure
```
frontend/lib/
├── screens/item_details_screen.dart       # UI implementation
├── services/api_service.dart              # API calls
└── models/shared_models.dart              # Data models
```

### Quick API Reference

**Get Contents**
```bash
GET /items/{itemId}/contents?userId={userId}
```

**Add Content**
```bash
POST /items/{itemId}/contents
{
  "userId": "user123",
  "type": "youtube",
  "url": "https://youtube.com/watch?v=abc",
  "title": "Great Video Review",
  "description": "Optional description"
}
```

**Like Content**
```bash
POST /item-contents/{contentId}/like
{ "userId": "user123" }
```

**Delete Content**
```bash
DELETE /item-contents/{contentId}
{ "userId": "user123" }
```

### Content Types & Colors

| Type      | Icon              | Color  | Hex Code |
|-----------|-------------------|--------|----------|
| Review    | 📄 article        | Amber  | #F59E0B  |
| YouTube   | ▶️ play_circle    | Red    | #EF4444  |
| Instagram | 📷 camera_alt     | Pink   | #EC4899  |
| Twitter   | 💬 chat_bubble    | Blue   | #3B82F6  |
| TikTok    | 🎵 music_note     | Black  | #000000  |

### Database Collections

**itemContents**
```javascript
{
  id: "auto-generated",
  itemId: "item_123",
  userId: "user_456",
  username: "John Doe",
  userProfileImageUrl: "https://...",
  type: "youtube",
  url: "https://youtube.com/watch?v=abc",
  title: "Great Review",
  description: "This is amazing!",
  thumbnailUrl: "https://img.youtube.com/vi/abc/hqdefault.jpg",
  likeCount: 5,
  createdAt: "2025-10-28T10:30:00Z"
}
```

**itemContentLikes**
```javascript
{
  id: "auto-generated",
  contentId: "content_789",
  userId: "user_456",
  createdAt: "2025-10-28T11:00:00Z"
}
```

## Testing Checklist

- [ ] View item details page
- [ ] See "Community Content" section
- [ ] Click "Add Content" (must be logged in)
- [ ] Select each content type
- [ ] Add valid URL and title
- [ ] Submit successfully
- [ ] See new content appear
- [ ] Click to open external link
- [ ] Like the content
- [ ] Unlike the content
- [ ] Delete own content
- [ ] Cannot delete others' content
- [ ] View without authentication
- [ ] YouTube thumbnails display correctly

## Common Issues

**"Add Content" button not showing**
- Make sure you're logged in

**Content not appearing after submission**
- Check browser console for errors
- Verify backend is running
- Check network tab for failed requests

**YouTube thumbnail not showing**
- Verify URL format is correct
- Check that video ID is being extracted

**Cannot delete content**
- Ensure you're the content owner
- Verify userId matches in request

## File Locations

| File | Purpose |
|------|---------|
| `backend/src/services/itemContentService.ts` | Content business logic |
| `backend/src/controllers/itemContentController.ts` | API endpoints |
| `frontend/lib/screens/item_details_screen.dart` | UI implementation |
| `shared/types.ts` | TypeScript type definitions |
| `shared/models.dart` | Dart model definitions |
| `ITEM_CONTENT_FEATURE.md` | Full documentation |
| `ITEM_CONTENT_IMPLEMENTATION_SUMMARY.md` | Implementation details |

## Quick Commands

**Start Backend**
```bash
cd backend
npm run dev
```

**Start Frontend**
```bash
cd frontend
flutter run -d chrome
```

**View Firestore Data**
```bash
# Open Firebase Console
# Navigate to Firestore Database
# Look for 'itemContents' and 'itemContentLikes' collections
```

## Support

- 📚 Full docs: `ITEM_CONTENT_FEATURE.md`
- 🔧 Implementation: `ITEM_CONTENT_IMPLEMENTATION_SUMMARY.md`
- 📋 API contracts: `shared/api_contracts.json`

---

**Status**: ✅ Ready to use
**Last Updated**: October 28, 2025
