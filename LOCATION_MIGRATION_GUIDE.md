# 🌍 Location Data Migration Guide

This guide helps you add location data to your GoRank database to enable smart location-based recommendations.

## 📋 What This Migration Does

1. **Sets `isLocationBased` flag on categories**
   - ✅ `food_drink` → `true` (restaurants, food items)
   - ✅ `local_specials` → `true` (Singapore-specific content)
   - ✅ `travel_places` → `true` (destinations)
   - ❌ `tech_gadgets` → `false` (global technology)
   - ❌ `pop_culture_trends` → `false` (global trends)

2. **Adds location coordinates to specific lists**
   - Singapore lists (hawker food, neighborhoods, landmarks)
   - Asian city lists (Tokyo, Bangkok, Seoul, etc.)
   - Other location-specific lists

## 🚀 Quick Start

### Step 1: Preview Changes (Dry Run)

Run this first to see what will be changed **WITHOUT** modifying the database:

```bash
cd backend
npm run location:dry-run
```

**Expected Output:**
```
🌍 Location Data Migration Script
============================================================

🔍 DRY RUN MODE - No changes will be made
   Use --execute flag to apply changes

📂 Step 1: Updating Categories...

🔍 [DRY RUN] Would set "food_drink" (Food & Drink) -> isLocationBased: true
🔍 [DRY RUN] Would set "tech_gadgets" (Tech & Gadgets) -> isLocationBased: false
...

📝 Step 2: Updating Lists with Location Data...

🔍 [DRY RUN] Would add location to "sg_neighborhood" (Coolest Singapore Neighbourhood):
   📍 Singapore, Singapore (1.3521, 103.8198)
...

📊 Migration Summary (DRY RUN)
============================================================

📂 Categories:
   ✅ Updated: 5
   ⏭️  Skipped: 0

📝 Lists:
   ✅ Updated: 4
   ⏭️  Skipped: 0

💡 This was a DRY RUN. No changes were made to the database.
   Run with --execute flag to apply changes.
```

### Step 2: Apply Changes

Once you're happy with the preview, apply the changes:

```bash
npm run location:migrate
```

### Step 3: Test Recommendations

Go to the **Location Test Screen** in your app:
1. Navigate to: **Profile → Menu → Test Location Feature**
2. Click **"1. Get Current Location"**
3. Click **"2. Update Backend"**
4. Click **"3. Test Recommendations"**

You should now see improved recommendations with location-based scoring! 🎉

---

## 🛠️ Available Commands

| Command | Description |
|---------|-------------|
| `npm run location:dry-run` | Preview changes without modifying database |
| `npm run location:migrate` | Apply changes to database |
| `npm run location:show-cities` | Show all available city coordinates |
| `npm run location:show-lists` | Show lists without location data |

---

## 📍 Available City Locations

The script includes coordinates for these cities:

| City | Country | Coordinates |
|------|---------|-------------|
| Singapore | Singapore | 1.3521, 103.8198 |
| Tokyo | Japan | 35.6762, 139.6503 |
| New York | United States | 40.7128, -74.0060 |
| London | United Kingdom | 51.5074, -0.1278 |
| Paris | France | 48.8566, 2.3522 |
| Los Angeles | United States | 34.0522, -118.2437 |
| Hong Kong | Hong Kong | 22.3193, 114.1694 |
| Seoul | South Korea | 37.5665, 126.9780 |
| Bangkok | Thailand | 13.7563, 100.5018 |
| Kuala Lumpur | Malaysia | 3.1390, 101.6869 |

To see the full list:
```bash
npm run location:show-cities
```

---

## 🎯 Customizing the Migration

### Adding More Cities

Edit `backend/scripts/add-location-data.ts` and add to `CITY_LOCATIONS`:

```typescript
const CITY_LOCATIONS: { [key: string]: GeoLocation } = {
  // Existing cities...
  
  'dubai': {
    latitude: 25.2048,
    longitude: 55.2708,
    city: 'Dubai',
    country: 'United Arab Emirates',
  },
  'sydney': {
    latitude: -33.8688,
    longitude: 151.2093,
    city: 'Sydney',
    country: 'Australia',
  },
  // Add more as needed...
};
```

### Mapping Lists to Locations

Edit the `LIST_LOCATION_MAPPING` in the same file:

```typescript
const LIST_LOCATION_MAPPING: { [listId: string]: string } = {
  // Singapore lists
  'sg_neighborhood': 'singapore',
  'sg_landmark': 'singapore',
  'hawker_dish_supreme': 'singapore',
  
  // Add your lists here
  'tokyo_restaurants': 'tokyo',
  'nyc_attractions': 'new_york',
  'london_pubs': 'london',
  
  // Format: 'list_id': 'city_key_from_CITY_LOCATIONS'
};
```

### Finding Lists That Need Location

To see all lists without location data:

```bash
npm run location:show-lists
```

**Example Output:**
```
📋 Lists Without Location Data:

Found 15 lists without location data:

   • fast_food_guilty              - "Best Fast Food Guilty Pleasure"
     Category: food_drink
   
   • gaming_console                - "Favorite Gaming Console"
     Category: tech_gadgets
   
   • asia_city_break               - "Best Asian City for a Quick Getaway"
     Category: travel_places
```

Review this list and add mappings for location-relevant lists.

---

## 📊 Understanding the Impact

### Before Migration

**Recommendation Score:**
```
Score = User Interests (0.4) + Popularity (0.3)
Maximum = 0.7
```

**Example:**
- "Best Restaurants in NYC" → Score: 0.6 (interests + popularity)
- "Best Hawker Food in Singapore" → Score: 0.6 (interests + popularity)
- Both ranked equally, regardless of user location ❌

### After Migration

**Recommendation Score:**
```
Score = Location Proximity (0.5) +    ← NEW!
        Category Relevance (0.9) +    ← NEW!
        User Interests (0.4) +
        Popularity (0.3)
Maximum = 2.1
```

**Example (User in Singapore):**
- "Best Restaurants in NYC" → Score: 0.6 (no location bonus)
- "Best Hawker Food in Singapore" → Score: 2.0 (+ 0.5 proximity + 0.9 category)
- Singapore lists prioritized! ✅

---

## ✅ Verification Steps

### 1. Check Categories in Firestore

After migration:
1. Open Firebase Console
2. Navigate to **Firestore Database**
3. Go to `categories` collection
4. Verify categories have `isLocationBased` field:
   - `food_drink` → `isLocationBased: true`
   - `tech_gadgets` → `isLocationBased: false`

### 2. Check Lists in Firestore

1. Go to `lists` collection
2. Find lists like `sg_neighborhood`
3. Verify they have a `location` object:
   ```json
   {
     "location": {
       "latitude": 1.3521,
       "longitude": 103.8198,
       "city": "Singapore",
       "country": "Singapore"
     }
   }
   ```

### 3. Test Recommendations

1. Open app → **Profile → Menu → Test Location Feature**
2. Get your location
3. Update backend
4. Test recommendations
5. Look for messages like:
   - ✅ "Very close to you" (< 5 km)
   - ✅ "Nearby" (< 20 km)
   - ✅ "In your area" (< 50 km)
   - ✅ "Popular food recommendations near you"

---

## 🔄 Re-running the Migration

The script is **idempotent** - it's safe to run multiple times:

- ✅ Skips categories that already have `isLocationBased` flag
- ✅ Skips lists that already have location data
- ✅ Only updates new or missing data

**Example:**
```bash
npm run location:migrate
```

**Output:**
```
⏭️  Skipping "food_drink" - already has isLocationBased flag: true
⏭️  Skipping "sg_neighborhood" - already has location
✅ Updated "new_restaurant_list" (New Restaurants) -> ...
```

---

## 🐛 Troubleshooting

### Issue: Script fails with "Cannot find module"

**Solution:** Make sure you're in the backend directory:
```bash
cd backend
npm install
npm run location:dry-run
```

### Issue: "User not found" error in test screen

**Solution:** Make sure you're signed in:
1. Go to **Profile** tab
2. Click **Sign In with Google**
3. Return to **Test Location Feature**

### Issue: No location-based recommendations showing

**Possible Causes:**
1. ✅ Migration didn't add location to any lists → Check with `npm run location:show-lists`
2. ✅ You're far from all list locations → Try adding location to more lists
3. ✅ Categories don't have `isLocationBased: true` → Re-run migration

**Debug:**
```bash
npm run location:show-lists    # See which lists need location
npm run location:dry-run       # Preview what will be changed
```

### Issue: Want to reset and start over

**Manually remove flags in Firestore:**
1. Open Firebase Console → Firestore
2. Select `categories` collection
3. For each category, delete the `isLocationBased` field
4. For lists with wrong locations, delete the `location` field
5. Re-run migration: `npm run location:migrate`

---

## 📚 Next Steps

After migration:

1. **Test thoroughly** with different user locations
2. **Add more list locations** based on your content
3. **Monitor recommendation quality** in production
4. **Adjust scoring weights** in `backend/src/services/recommendations.ts` if needed

---

## 💡 Advanced: Custom Location Assignment

For lists that don't fit predefined cities, you can add location directly:

### Method 1: Via Script (Recommended)

Add to `LIST_LOCATION_MAPPING` and create custom entry in `CITY_LOCATIONS`.

### Method 2: Via Firebase Console (Quick Fix)

1. Open Firestore → `lists` collection
2. Select a list document
3. Add field: `location` (map)
4. Add sub-fields:
   - `latitude` (number): e.g., `1.3521`
   - `longitude` (number): e.g., `103.8198`
   - `city` (string): e.g., `"Singapore"`
   - `country` (string): e.g., `"Singapore"`

### Method 3: Via API (For Batch Updates)

Create a custom script or use the admin panel to bulk update lists.

---

## 📖 Related Documentation

- **Location Feature Overview:** `LOCATION_FEATURE.md`
- **Location Implementation:** `LOCATION_IMPLEMENTATION_SUMMARY.md`
- **How Recommendations Work:** `LOCATION_DATA_EXPLANATION.md`
- **Quick Start Guide:** `LOCATION_QUICK_START.md`
- **Web Testing:** `LOCATION_WEB_TESTING.md`

---

## 🎉 Success Criteria

You'll know the migration worked when:

1. ✅ Categories in Firestore have `isLocationBased` field
2. ✅ Location-relevant lists have `location` object
3. ✅ Test recommendations show location-based reasons:
   - "Very close to you"
   - "Popular food recommendations near you"
   - "Hotels and stays in your area"
4. ✅ Recommendations are more relevant to your location
5. ✅ Lists near you rank higher than distant lists

---

**Questions or issues?** Check `LOCATION_DATA_EXPLANATION.md` for detailed algorithm explanation.

**Ready to migrate?** Run `npm run location:dry-run` to get started! 🚀
