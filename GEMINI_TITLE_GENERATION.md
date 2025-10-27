# Gemini AI-Powered List Creation

## Overview
The Create List feature now uses **Google Gemini 2.5 Flash AI** to intelligently analyze user ideas and provide:
- **Smart Title Generation** - Engaging, social-media friendly titles
- **Accurate Category Detection** - AI understands context to pick the right category
- **Intelligent Location Extraction** - Automatically detects cities, countries, regions
- **Relevant Item Suggestions** - AI suggests 8-10 specific items perfect for ranking

## How It Works

### 1. **Complete AI Analysis**
When a user enters an idea like "What is your favourite EV suv", Gemini AI analyzes it and returns:

```json
{
  "title": "Best Electric SUVs - Which One Wins?",
  "categoryId": "tech_gadgets",
  "location": null,
  "items": [
    "Tesla Model Y",
    "Tesla Model X", 
    "BYD Tang",
    "NIO ES6",
    "Ford Mustang Mach-E",
    "Hyundai Ioniq 5",
    "Kia EV6",
    "Volkswagen ID.4"
  ]
}
```

### 2. **Smart Fallback System**
If Gemini API is unavailable, the system falls back to:
- **Category:** Keyword-based matching with priority scoring
- **Location:** Pattern matching for location keywords (in, at, near, around)
- **Items:** Domain-specific database (universities, EVs, phones, laptops)
- **Title:** Manual enhancement with proper capitalization and engaging suffixes

### 3. **Database Integration**
The system automatically:
- Matches AI-suggested items with existing database items
- Reuses existing items to maintain consistency
- Creates placeholders for new items (auto-created when list is saved)
- Preserves existing images and descriptions

## Implementation Details

### Main Functions

#### `generateListSuggestion()` - Main AI Controller
Located in: `backend/src/controllers/aiController.ts`

**AI Prompt Strategy:**
- Provides available categories to AI for accurate matching
- Requests structured JSON response with all suggestions
- Specifies requirements for item specificity (e.g., "Tesla Model Y" not just "EV")
- Includes context about location extraction

#### `matchAIItemsWithDatabase()` - Item Matching
- Performs exact name matching first
- Falls back to partial matching (contains/is contained)
- Returns existing items with full data (image, description)
- Creates placeholders for new items

#### `generateEngagingTitle()` - Title Enhancement
- Uses Gemini to rephrase ideas into engaging titles
- Ensures titles are concise (under 60 characters)
- Maintains original meaning while adding social appeal
- Falls back to manual title case + suffixes if AI fails

### Environment Setup

**Required Environment Variable:**
```yaml
GOOGLE_AI_API_KEY
```

This is configured in:
- **Production:** `backend/apphosting.yaml` → Cloud Secret Manager
- **Development:** Set locally via `.env` file or environment variable

### Model Used
- **Model:** `gemini-2.5-flash` (latest and best price-performance)
- **Provider:** Google Generative AI
- **Shared Service:** Uses existing `genAIService` from `backend/src/services/genai.ts`

## Local Development Setup

1. **Get Your Gemini API Key:**
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create a new API key
   - Copy the key

2. **Set Environment Variable:**
   
   **Windows PowerShell:**
   ```powershell
   $env:GOOGLE_AI_API_KEY="your-api-key-here"
   ```

   **Or create a `.env` file in `backend/` folder:**
   ```
   GOOGLE_AI_API_KEY=your-api-key-here
   ```

3. **Update `backend/src/index.ts` to load .env (if not already done):**
   ```typescript
   import dotenv from 'dotenv';
   dotenv.config();
   ```

4. **Restart the backend server:**
   ```bash
   cd backend
   npm run dev
   ```

## Testing

### Test Examples:

**1. EV SUV Ranking:**
- **Input:** "What is your favourite EV suv"
- **Expected AI Response:**
  - Title: "Best Electric SUVs - Which One Wins?" (or similar engaging variation)
  - Category: tech_gadgets
  - Location: null
  - Items: Tesla Model Y, Tesla Model X, BYD Tang, NIO ES6, etc.

**2. Food Near Location:**
- **Input:** "Lunch idea near Katong"
- **Expected AI Response:**
  - Title: "Best Lunch Spots near Katong" (or similar)
  - Category: food_drink
  - Location: "Katong"
  - Items: Specific restaurants/cafes near Katong

**3. University Ranking:**
- **Input:** "Best university in Asia"
- **Expected AI Response:**
  - Title: "Top Universities in Asia - Vote for #1"
  - Category: pop_culture (or similar)
  - Location: "Asia"
  - Items: NUS, Tsinghua University, University of Tokyo, etc.

### Fallback Testing:
Set an invalid API key to test fallback logic:
- Categories should still be detected via keyword matching
- Locations should be extracted via pattern matching
- Items should come from domain-specific database
- Titles should be properly formatted with manual logic

## Benefits

✅ **Intelligent Category Detection** - AI understands context better than keyword matching  
✅ **Accurate Item Suggestions** - AI suggests real, specific items users want to rank  
✅ **Natural Language Titles** - Titles sound human-written and engaging  
✅ **Smart Location Extraction** - AI recognizes locations without strict patterns  
✅ **Consistent Experience** - Reuses existing database items when available  
✅ **Reliable Fallback** - Manual logic ensures feature always works  
✅ **Fast Performance** - Uses `gemini-2.5-flash` for sub-second responses  

## Cost Considerations

- **Model:** `gemini-2.5-flash` is highly cost-effective
- **Usage:** One API call per list creation
- **Token Usage:** ~500-1000 tokens per request (categories list + idea analysis)
- **Free Tier:** Generous free quota available from Google
- **Fallback:** Zero cost when using manual logic

## Architecture

### Data Flow:
```
User Idea Input
    ↓
[Gemini AI Analysis]
    ↓
Category + Location + Items + Title
    ↓
[Database Matching]
    ↓
Existing Items ← → New Item Placeholders
    ↓
Return Complete Suggestion
```

### Error Handling:
1. **AI Fails:** Falls back to keyword-based category detection
2. **Invalid JSON:** Uses manual parsing and fallback logic
3. **No Category Match:** Defaults to "Pop Culture" or first available category
4. **No Items Found:** Uses domain-specific database or generic templates

## Future Enhancements

- [ ] Cache AI responses for common queries (reduce API calls)
- [ ] A/B test AI vs manual suggestions for engagement metrics
- [ ] Multi-language support for international users
- [ ] Image generation suggestions for new items
- [ ] Trending topics integration
- [ ] User feedback loop to improve AI prompts
