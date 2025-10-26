# 🌍 Location Migration - Quick Reference

## 🚀 Run Migration (3 Steps)

### 1. Preview Changes
```bash
cd backend
npm run location:dry-run
```

### 2. Apply Changes
```bash
npm run location:migrate
```

### 3. Test in App
- Profile → Menu → Test Location Feature
- Click "1. Get Current Location" → "2. Update Backend" → "3. Test Recommendations"

---

## 📋 All Commands

```bash
npm run location:dry-run        # Preview (no changes)
npm run location:migrate        # Apply changes
npm run location:show-cities    # List available cities
npm run location:show-lists     # Show lists without location
```

---

## 🎯 What Gets Updated

### Categories (Automatic)
- ✅ `food_drink` → `isLocationBased: true`
- ✅ `local_specials` → `isLocationBased: true`
- ✅ `travel_places` → `isLocationBased: true`
- ❌ `tech_gadgets` → `isLocationBased: false`
- ❌ `pop_culture_trends` → `isLocationBased: false`

### Lists (Customizable)
Default mappings in script:
- `sg_neighborhood` → Singapore (1.3521, 103.8198)
- `sg_landmark` → Singapore
- `hawker_dish_supreme` → Singapore
- `asia_city_break` → Singapore (base location)

**Add more** by editing `LIST_LOCATION_MAPPING` in `backend/scripts/add-location-data.ts`

---

## 📍 Available Cities

| City | Coordinates |
|------|-------------|
| Singapore | 1.3521, 103.8198 |
| Tokyo | 35.6762, 139.6503 |
| New York | 40.7128, -74.0060 |
| London | 51.5074, -0.1278 |
| Paris | 48.8566, 2.3522 |
| Los Angeles | 34.0522, -118.2437 |
| Hong Kong | 22.3193, 114.1694 |
| Seoul | 37.5665, 126.9780 |
| Bangkok | 13.7563, 100.5018 |
| Kuala Lumpur | 3.1390, 101.6869 |

---

## 🔧 Customize Before Running

### 1. Add More Cities
Edit `backend/scripts/add-location-data.ts`:

```typescript
const CITY_LOCATIONS = {
  'dubai': {
    latitude: 25.2048,
    longitude: 55.2708,
    city: 'Dubai',
    country: 'United Arab Emirates',
  },
  // Add more...
};
```

### 2. Map Lists to Locations
Edit `LIST_LOCATION_MAPPING`:

```typescript
const LIST_LOCATION_MAPPING = {
  'your_list_id': 'city_key',
  'tokyo_restaurants': 'tokyo',
  'nyc_bars': 'new_york',
  // Add more...
};
```

### 3. Find Lists That Need Location
```bash
npm run location:show-lists
```

---

## ✅ Verify Migration Worked

### In Firebase Console:
1. **Firestore → categories** → Check for `isLocationBased` field
2. **Firestore → lists** → Check for `location` object

### In App:
1. Open test screen: **Profile → Menu → Test Location Feature**
2. Look for messages like:
   - ✅ "Very close to you"
   - ✅ "Popular food recommendations near you"
   - ✅ "Hotels and stays in your area"

---

## 🐛 Quick Fixes

### Script won't run?
```bash
cd backend
npm install
```

### Want to see what changed?
```bash
npm run location:dry-run
```

### Want to reset?
Delete `isLocationBased` and `location` fields in Firestore, then re-run.

### Migration complete but no location-based recommendations?
1. Check you're signed in to the app
2. Verify lists have location data: `npm run location:show-lists`
3. Make sure you added locations to lists in your area

---

## 📈 Impact

### Before:
```
Score = Interests (0.4) + Popularity (0.3) = 0.7 max
```

### After:
```
Score = Location (0.5) + Category (0.9) + Interests (0.4) + Popularity (0.3) = 2.1 max
```

**Result:** Lists near you get 3x higher scores! 🎯

---

## 📚 Full Documentation

- **Detailed Guide:** `LOCATION_MIGRATION_GUIDE.md`
- **How It Works:** `LOCATION_DATA_EXPLANATION.md`
- **Feature Overview:** `LOCATION_FEATURE.md`

---

**Ready?** Run `npm run location:dry-run` now! 🚀
