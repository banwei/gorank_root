# AI-Powered List Creation Feature

## Overview

A new "Create" tab has been added to the home screen, providing users with an AI-assisted workflow to create engaging ranking lists. This feature helps users brainstorm ideas, find similar lists, and automatically generate list content with smart suggestions.

## Features

### 1. **Create Tab (First Position)**
- New dedicated tab for list creation placed before the Home tab
- Always accessible from the bottom navigation bar
- Icon: Plus circle (add_circle)

### 2. **Idea Input Screen** (`CreateListScreen`)

#### User Flow:
1. **Idea Text Box**
   - Prominent text input for users to enter their ranking idea
   - Multi-line input (3 lines) for flexibility
   - Placeholder: "e.g., 'Best pizza places in NYC' or 'Top action movies of 2024'"

2. **Real-time Similar List Search**
   - Automatically searches for similar lists as user types
   - Debounced search (500ms delay) to avoid excessive API calls
   - Shows up to 5 similar lists with:
     - List title
     - Number of rankings cast
     - Tap to view the list
   - Empty state: "No similar lists found - your idea is unique!"

3. **Next Button**
   - Enabled only when text is entered
   - Fixed at bottom of screen
   - Triggers AI processing

### 3. **AI Processing**

When user clicks "Next":
- Shows loading dialog: "AI is crafting your ranking list..."
- Backend AI service analyzes the idea:
  - **Rephrases title** to make it more engaging (e.g., adds "Top" or "Best")
  - **Suggests category** based on keywords
  - **Detects location** if mentioned (e.g., "in NYC", "near Tokyo")
  - **Finds existing items** from the database
  - **Generates suggested items** if needed

### 4. **Edit Screen** (`CreateListEditScreen`)

The AI presents a fully editable list with:

#### Editable Fields:
1. **List Title**
   - Pre-filled with AI-enhanced title
   - Text input for manual editing

2. **Category**
   - Dropdown list of all categories
   - Color-coded visual indicators
   - Pre-selected by AI based on content analysis

3. **Location Badge** (if detected)
   - Blue info box showing detected location
   - Location icon for visual clarity

4. **Items List**
   - Card-based list showing all suggested items
   - Each item displays:
     - Thumbnail image (if available)
     - Item name
     - Badge: "Existing item" (green check) or "AI suggested"
     - Delete button (red)

5. **Add Your Own Item**
   - Text input at bottom of items list
   - "+" button to add
   - Searches for existing items first before creating new ones
   - Shows loading during item search/creation

#### Actions:
- **Delete items**: Remove any suggested item
- **Add custom items**: Search existing or create new
- **Edit title**: Refine the AI-generated title
- **Change category**: Override AI category selection
- **Create List**: Final action to save the list

### 5. **Backend API Endpoints**

#### New Endpoints:

1. **GET `/lists/search?query={text}`**
   - Searches for similar lists based on title
   - Returns: `[{ id, title, rankingCount }]`
   - Sorted by popularity (ranking count)
   - Limited to top 5 results

2. **POST `/ai/generate-list`**
   - Body: `{ idea: string }`
   - AI analyzes the idea and generates:
     ```json
     {
       "title": "Top Pizza Places in NYC",
       "categoryId": "food_drink",
       "location": "NYC",
       "items": [
         {
           "id": "item123",
           "name": "Joe's Pizza",
           "description": "Classic NYC pizza",
           "imageUrl": "...",
           "isExisting": true
         }
       ]
     }
     ```

3. **POST `/items/search-or-create`**
   - Body: `{ name: string, categoryId: string }`
   - Searches for existing item by name
   - Creates new item if not found
   - Returns: `Item` object

## Technical Implementation

### Frontend Files Created/Modified:

1. **`lib/screens/create_list_screen.dart`** (NEW)
   - First page of creation flow
   - Idea input and search
   - Navigation to edit screen

2. **`lib/screens/create_list_edit_screen.dart`** (NEW)
   - Second page of creation flow
   - Edit AI suggestions
   - Final list creation

3. **`lib/screens/home_screen.dart`** (MODIFIED)
   - Added 4th tab for Create
   - Updated tab controller length
   - Reordered tabs (Create, Home, Explore, Profile)

4. **`lib/services/api_service.dart`** (MODIFIED)
   - Added `searchSimilarLists()`
   - Added `generateListSuggestion()`
   - Added `searchOrCreateItem()`
   - Added helper classes: `SimilarListResult`, `AiListSuggestion`, `SuggestedItem`

### Backend Files Created/Modified:

1. **`backend/src/controllers/aiController.ts`** (NEW)
   - `generateListSuggestion()` - AI list generation logic
   - `searchOrCreateItem()` - Item search/creation
   - Helper functions for category matching and item generation

2. **`backend/src/controllers/listsController.ts`** (MODIFIED)
   - Added `searchLists()` function

3. **`backend/src/routes/ai.ts`** (NEW)
   - Routes for `/ai/generate-list`

4. **`backend/src/routes/lists.ts`** (MODIFIED)
   - Added `/lists/search` route

5. **`backend/src/routes/items.ts`** (MODIFIED)
   - Added `/items/search-or-create` route

6. **`backend/src/index.ts`** (MODIFIED)
   - Registered AI router

7. **`shared/api_contracts.json`** (MODIFIED)
   - Documented new API endpoints

## AI Logic (Current Implementation)

The current implementation uses rule-based AI logic:

### Category Detection:
- Keyword matching for categories (food, travel, tech, entertainment)
- Fallback to first category if no match

### Location Detection:
- Searches for keywords: "in", "at", "near", "around"
- Extracts location from text following these keywords

### Title Enhancement:
- Adds "Top" prefix if not present
- Capitalizes each word
- Makes title more social-media friendly

### Item Suggestion:
- Queries existing items in the selected category
- Generates placeholder items if insufficient existing items
- Prioritizes reusing existing items (marked with green check)

### Future Enhancement:
This can be upgraded to use Google Gemini AI or OpenAI GPT for:
- More intelligent category detection
- Better title suggestions
- Context-aware item generation
- Image suggestions
- SEO optimization

## User Experience

### Flow Summary:
1. User opens app → Sees "Create" tab
2. Taps Create → Idea input screen
3. Types idea → Real-time similar list search
4. Reviews similar lists (optional)
5. Clicks "Next" → AI processing (loading dialog)
6. AI presents edit screen with:
   - Enhanced title
   - Suggested category
   - Location (if applicable)
   - 5-8 suggested items
7. User edits/customizes:
   - Change title
   - Select different category
   - Remove unwanted items
   - Add custom items
8. Clicks "Create List" → List saved
9. Returns to home screen → See new list

### Key Benefits:
- **Reduces friction**: AI does the heavy lifting
- **Encourages reuse**: Shows existing items first
- **Social ranking optimized**: Titles are made more engaging
- **Location-aware**: Automatically detects and tags locations
- **Quality content**: Suggests relevant items based on category

## Testing the Feature

### Frontend Testing:
```bash
cd frontend
flutter run
```

1. Open app and tap "Create" tab (first position)
2. Enter an idea like "best coffee shops in Seattle"
3. Observe real-time search results
4. Click "Next"
5. Verify AI suggestions appear
6. Edit title, category, and items
7. Add a custom item
8. Create the list

### Backend Testing:
```bash
cd backend
npm run dev
```

#### Test search endpoint:
```bash
curl "http://localhost:4000/lists/search?query=pizza"
```

#### Test AI generation:
```bash
curl -X POST http://localhost:4000/ai/generate-list \
  -H "Content-Type: application/json" \
  -d '{"idea": "best sushi restaurants in Tokyo"}'
```

#### Test item search/create:
```bash
curl -X POST http://localhost:4000/items/search-or-create \
  -H "Content-Type: application/json" \
  -d '{"name": "New Restaurant", "categoryId": "food_drink"}'
```

## Future Enhancements

1. **Advanced AI Integration**
   - Google Gemini API for smarter suggestions
   - Image generation for items
   - Multi-language support

2. **Collaborative Creation**
   - Invite friends to contribute items
   - Vote on suggested items before publishing

3. **Templates**
   - Pre-built list templates by category
   - Popular list structures

4. **Smart Recommendations**
   - Suggest trending topics
   - Personalized based on user interests

5. **Draft System**
   - Save incomplete lists as drafts
   - Resume creation later

## Performance Considerations

- **Debounced Search**: 500ms delay prevents excessive API calls
- **Limited Results**: Search returns max 5 similar lists
- **Cached Items**: Reuses existing items to reduce database queries
- **Optimistic Updates**: UI updates immediately, syncs in background

## Security & Validation

- **Input Validation**: All text inputs are trimmed and validated
- **Category Validation**: Only valid category IDs accepted
- **Authentication**: User must be logged in to create lists
- **Rate Limiting**: Consider adding rate limits for AI endpoint in production

## Deployment Notes

The feature is fully integrated and ready for deployment:
- ✅ Frontend screens created
- ✅ API endpoints implemented
- ✅ Routes registered
- ✅ Error handling added
- ✅ Loading states implemented
- ✅ Documentation complete

No environment variables or additional setup required for basic functionality. For production AI integration (Google Gemini), add:
```
GOOGLE_AI_API_KEY=your-api-key
```
