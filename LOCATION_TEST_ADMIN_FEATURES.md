# 🎯 Location Test Screen - Admin Features

## 📍 Location

**File:** `frontend/lib/screens/admin/location_test_screen.dart`

**Access:**
- Profile → Menu → Test Location Feature
- Route: `/test-location`

---

## ✨ New Features Added

### 1. **Custom Location Testing** 🌍

Admin users can now test recommendations for different locations without physically being there!

#### Features:
- **Search Input:** Type city name to filter locations
- **12 Predefined Cities:**
  - 🇸🇬 Singapore
  - 🇯🇵 Tokyo, Japan
  - 🇺🇸 New York, USA
  - 🇺🇸 Los Angeles, USA
  - 🇬🇧 London, UK
  - 🇫🇷 Paris, France
  - 🇭🇰 Hong Kong
  - 🇰🇷 Seoul, South Korea
  - 🇹🇭 Bangkok, Thailand
  - 🇲🇾 Kuala Lumpur, Malaysia
  - 🇦🇪 Dubai, UAE
  - 🇦🇺 Sydney, Australia

- **Real-time Search:** Type to filter cities (e.g., "tok" shows "Tokyo, Japan")
- **One-click Selection:** Click any city to set it as test location
- **Coordinate Display:** Shows lat/lng for each city
- **Visual Indicator:** Purple badge shows when using custom location

---

## 🎮 How to Use

### Test with Custom Location:

1. **Open Test Screen**
   - Navigate: Profile → Menu → Test Location Feature

2. **Search for a City**
   - Type in the search box: "Tokyo", "New York", "Singapore", etc.
   - See filtered results in dropdown

3. **Select a City**
   - Click on any city from the dropdown
   - Location is immediately set
   - See confirmation message

4. **Test Recommendations**
   - Click "2. Update Backend" (saves to your user profile)
   - Click "3. Test Recommendations" (get recommendations for that city)
   - See how recommendations differ by location!

5. **Switch Locations**
   - Search and select a different city
   - Test again to compare recommendations

### Test with GPS Location:

1. **Click "1. Get Current Location"**
   - Uses your actual GPS coordinates
   - Clears custom location flag
   - Shows "Real GPS Location" in results

---

## 🔍 Visual Indicators

### Custom Location Active:
```
┌────────────────────────────────────────┐
│ 📍 Custom location set: Tokyo, Japan   │
│                                        │
│ Latitude: 35.6762                      │
│ Longitude: 139.6503                    │
│ City: Tokyo                            │
│ Country: Japan                         │
│ Type: Test Location (not from GPS)    │
└────────────────────────────────────────┘

ℹ️  Using custom test location. Click "Get 
    Current Location" to use GPS instead.
```

### GPS Location Active:
```
┌────────────────────────────────────────┐
│ ✅ Location detected successfully!     │
│                                        │
│ Latitude: 1.3521                       │
│ Longitude: 103.8198                    │
│ Accuracy: 10000.0 meters               │
│ City: Singapore                        │
│ Country: Singapore                     │
│ Type: Real GPS Location                │
└────────────────────────────────────────┘
```

---

## 🧪 Testing Scenarios

### Scenario 1: Test Singapore Recommendations
1. Search: "Singapore"
2. Select: "Singapore"
3. Update Backend
4. Test Recommendations
5. **Expected:** Singapore lists (hawker food, neighborhoods) score high (1.5-2.0)

### Scenario 2: Test Tokyo Recommendations
1. Search: "Tokyo"
2. Select: "Tokyo, Japan"
3. Update Backend
4. Test Recommendations
5. **Expected:** Singapore lists score lower (0.6-0.8), Tokyo-specific lists would score higher

### Scenario 3: Compare Cities
1. Test with Singapore → Note scores
2. Clear cache
3. Test with New York → Note scores
4. **Expected:** Different recommendations based on location

---

## 📊 Use Cases

### For Developers:
- Test location-based algorithm without traveling
- Verify recommendations work for different regions
- Debug location-specific issues
- Compare scoring across cities

### For Product Managers:
- Validate content relevance for different markets
- Test user experience in various locations
- Check if location-based recommendations make sense
- Demo feature to stakeholders

### For Content Creators:
- See how lists perform in different locations
- Verify if location data is set correctly
- Test if your Singapore content shows up for Singapore users

---

## 🎨 UI Components

### Search Box:
```dart
TextField with:
- Placeholder: "Search city (e.g., Tokyo, New York, Singapore)..."
- Real-time filtering
- Clear button (X icon)
- Purple theme matching admin panel
```

### Dropdown Results:
```dart
ListView showing:
- City icon (🏙️)
- City name (e.g., "Tokyo, Japan")
- Coordinates (e.g., "35.6762, 139.6503")
- Click to select
```

### Status Badge:
```dart
Purple container showing:
- Info icon
- "Using custom test location. Click 'Get Current Location' to use GPS instead."
```

---

## 🔧 Technical Details

### Data Structure:
```dart
Map<String, Map<String, dynamic>> _testLocations = {
  'Singapore': {
    'lat': 1.3521,
    'lng': 103.8198,
    'city': 'Singapore',
    'country': 'Singapore'
  },
  // ... more cities
};
```

### State Variables:
```dart
TextEditingController _citySearchController;  // Search input
bool _useCustomLocation;                      // Custom vs GPS flag
List<String> _filteredLocations;              // Search results
```

### Methods:
```dart
void _filterLocations(String query)           // Filter search results
void _setCustomLocation(String locationName)  // Set test location
void _getCurrentLocation()                    // Get GPS location (resets custom flag)
void _clearCache()                           // Clear all state
```

---

## ✅ Features Summary

| Feature | Description |
|---------|-------------|
| **Custom Location** | Set any predefined city as test location |
| **Search** | Filter cities by typing |
| **12+ Cities** | Major cities across Asia, US, Europe, Middle East |
| **Visual Indicators** | Clear badges showing custom vs GPS location |
| **One-click Switch** | Easy to switch between cities |
| **GPS Fallback** | Can always return to real GPS location |
| **State Management** | Proper cleanup on cache clear |

---

## 🚀 Quick Start

```bash
# 1. Open app
flutter run -d chrome --hot

# 2. Navigate to test screen
Profile → Menu → Test Location Feature

# 3. Search for a city
Type "sing" → Select "Singapore"

# 4. Test recommendations
Update Backend → Test Recommendations

# 5. Compare with another city
Search "tokyo" → Select "Tokyo, Japan"
Update Backend → Test Recommendations

# 6. Compare results!
```

---

## 📝 Example Test Flow

### Test 1: Singapore User
```
1. Search: "singapore"
2. Select: Singapore
3. Update Backend
4. Test Recommendations
5. Results:
   ✅ "Hawker Food Supreme" - Score: 2.0
      Reasons: "Very close to you • Popular food recommendations"
   ✅ "Singapore Neighborhoods" - Score: 1.8
      Reasons: "In your area • Local content"
   ✅ "Best Asian Cities" - Score: 1.5
      Reasons: "Nearby • Travel recommendations"
```

### Test 2: New York User
```
1. Search: "new york"
2. Select: New York, USA
3. Update Backend
4. Test Recommendations
5. Results:
   ❌ "Hawker Food Supreme" - Score: 0.6
      Reasons: "Matches your interests"
   ❌ "Singapore Neighborhoods" - Score: 0.4
      Reasons: "Popular list"
   ✅ "Best Smartphones 2025" - Score: 0.7
      Reasons: "Matches your interests"
```

**Result:** Location makes a huge difference! 🎯

---

## 🎓 Next Steps

1. **Add More Cities:** Edit `_testLocations` map to add more test locations
2. **Custom Coordinates:** Add input fields for manual lat/lng entry
3. **Location Presets:** Add "Test All Major Cities" button
4. **Results Comparison:** Side-by-side comparison of different locations
5. **Export Test Results:** Save test results for analysis

---

## 📚 Related Documentation

- **Migration Complete:** `MIGRATION_COMPLETE.md`
- **How Recommendations Work:** `LOCATION_DATA_EXPLANATION.md`
- **Feature Overview:** `LOCATION_FEATURE.md`

---

**Status:** ✅ Implemented and ready to test!

**Location:** `frontend/lib/screens/admin/location_test_screen.dart`

**Access:** Profile → Menu → Test Location Feature
