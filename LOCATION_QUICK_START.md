# Location Feature - Quick Start Guide

## 🚀 Quick Setup (5 minutes)

### Step 1: Install Dependencies ✅ DONE
```bash
cd frontend
flutter pub get
```

### Step 2: Test Location Service (Flutter)

Add this to your app initialization or a test screen:

```dart
import 'package:rank_it_app/services/location_service.dart';

void testLocation() async {
  LocationService locationService = LocationService();
  
  // Request permission
  bool hasPermission = await locationService.requestLocationPermission();
  if (!hasPermission) {
    print('Location permission denied');
    return;
  }
  
  // Get location
  GeoLocation? location = await locationService.getCurrentLocation();
  if (location != null) {
    print('✅ Location: ${location.city}, ${location.country}');
    print('   Coordinates: ${location.latitude}, ${location.longitude}');
  } else {
    print('❌ Could not get location');
  }
}
```

### Step 3: Update User Location (When User Logs In)

```dart
import 'package:rank_it_app/services/location_service.dart';
import 'package:rank_it_app/services/api_service.dart';

Future<void> updateUserLocationInBackground(String userId) async {
  try {
    LocationService locationService = LocationService();
    
    // Get location (uses cache if available)
    GeoLocation? location = await locationService.getLocationForRecommendations();
    
    if (location != null) {
      // Send to backend
      await ApiService.updateUserLocation(
        userId,
        location.latitude,
        location.longitude,
        city: location.city,
        country: location.country,
      );
      print('✅ User location updated');
    }
  } catch (e) {
    print('⚠️ Could not update location: $e');
    // Don't show error to user - location is optional
  }
}
```

### Step 4: Get "For You" Recommendations

```dart
import 'package:rank_it_app/services/api_service.dart';
import 'package:rank_it_app/services/location_service.dart';

Future<List<ListEntity>> getPersonalizedLists(String userId) async {
  try {
    LocationService locationService = LocationService();
    GeoLocation? location = locationService.getLastKnownLocation();
    
    List<ListEntity> recommendations = await ApiService.getForYouRecommendations(
      userId: userId,
      latitude: location?.latitude,
      longitude: location?.longitude,
      limit: 10,
    );
    
    print('✅ Got ${recommendations.length} personalized recommendations');
    return recommendations;
  } catch (e) {
    print('❌ Error getting recommendations: $e');
    return [];
  }
}
```

## 🎯 Integration Points

### 1. App Startup (main.dart or app_state.dart)
```dart
@override
void initState() {
  super.initState();
  _initializeWithLocation();
}

Future<void> _initializeWithLocation() async {
  // ... existing initialization code ...
  
  if (currentUser != null) {
    // Update location in background
    updateUserLocationInBackground(currentUser.id);
  }
}
```

### 2. Home Screen - Add "For You" Section
```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: ListView(
      children: [
        // Existing sections...
        _buildTrendingSection(),
        
        // NEW: For You section
        _buildForYouSection(),
        
        _buildCategoriesSection(),
      ],
    ),
  );
}

Widget _buildForYouSection() {
  return FutureBuilder<List<ListEntity>>(
    future: getPersonalizedLists(currentUser.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }
      
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return SizedBox.shrink(); // Hide if no recommendations
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('For You', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          _buildListCarousel(snapshot.data!),
        ],
      );
    },
  );
}
```

### 3. Profile Screen - Location Permission
```dart
Widget _buildLocationSettings() {
  return FutureBuilder<bool>(
    future: LocationService().hasLocationPermission(),
    builder: (context, snapshot) {
      bool hasPermission = snapshot.data ?? false;
      
      return ListTile(
        leading: Icon(hasPermission ? Icons.location_on : Icons.location_off),
        title: Text('Location Services'),
        subtitle: Text(hasPermission ? 'Enabled for recommendations' : 'Disabled'),
        trailing: Switch(
          value: hasPermission,
          onChanged: (value) async {
            if (value) {
              await LocationService().requestLocationPermission();
              setState(() {});
            }
          },
        ),
      );
    },
  );
}
```

## 🧪 Testing Checklist

### Frontend Testing
- [ ] Run app on real device (not emulator)
- [ ] Location permission dialog appears
- [ ] Grant permission successfully
- [ ] Location detected (check console logs)
- [ ] City/country displayed correctly
- [ ] Location cached for 15 minutes
- [ ] No errors in console

### Backend Testing
```bash
# Terminal 1: Start backend
cd backend
npm run dev

# Terminal 2: Test location update
curl -X PUT http://localhost:4001/users/USER_ID/location \
  -H "Content-Type: application/json" \
  -d '{"latitude": 35.6762, "longitude": 139.6503}'

# Test recommendations
curl -X POST http://localhost:4001/lists/for-you \
  -H "Content-Type: application/json" \
  -d '{"userId": "USER_ID", "latitude": 35.6762, "longitude": 139.6503}'
```

### Firestore Verification
1. Open Firebase Console
2. Go to Firestore Database
3. Find a user document
4. Verify `location` field exists with:
   - latitude (number)
   - longitude (number)
   - city (string, optional)
   - country (string, optional)

## 🐛 Common Issues

### Issue: "Location permission denied"
**Solution**: 
- Check device settings → App permissions → Location
- On iOS: Settings → Privacy → Location Services
- On Android: Settings → Apps → [Your App] → Permissions

### Issue: "Location not updating"
**Solution**:
- Ensure GPS is enabled on device
- Try outdoors for better GPS signal
- Check internet connection (for geocoding)
- Clear cache: `LocationService().clearCache()`

### Issue: "No recommendations returned"
**Solution**:
- Check if backend is running
- Verify user ID is correct
- Check if lists have location data
- Review backend console logs

### Issue: "Inaccurate location"
**Solution**:
- Move outdoors for better GPS signal
- Check location accuracy value
- Indoor locations may be less accurate
- Consider using WiFi for better accuracy

## 📋 Quick Reference

### LocationService Methods
```dart
// Get current location
GeoLocation? location = await locationService.getCurrentLocation();

// Get cached location
GeoLocation? cached = locationService.getLastKnownLocation();

// Check permission
bool hasPermission = await locationService.hasLocationPermission();

// Request permission
bool granted = await locationService.requestLocationPermission();

// Calculate distance (km)
double distance = locationService.calculateDistance(loc1, loc2);

// Check if within radius
bool nearby = locationService.isWithinRadius(userLoc, targetLoc, 5.0);

// Clear cache
locationService.clearCache();
```

### API Methods
```dart
// Update user location
await ApiService.updateUserLocation(userId, lat, lng, city: city);

// Get recommendations
List<ListEntity> lists = await ApiService.getForYouRecommendations(
  userId: userId,
  latitude: lat,
  longitude: lng,
  limit: 10,
);
```

## 🎨 UI Examples

### Minimal "For You" Section
```dart
if (isAuthenticated) {
  FutureBuilder<List<ListEntity>>(
    future: ApiService.getForYouRecommendations(userId: user.id),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        return _buildListSection('For You', snapshot.data!);
      }
      return SizedBox.shrink();
    },
  ),
}
```

### Location Indicator (Optional)
```dart
FutureBuilder<GeoLocation?>(
  future: LocationService().getCurrentLocation(),
  builder: (context, snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      return Chip(
        avatar: Icon(Icons.location_on, size: 16),
        label: Text(snapshot.data!.city ?? 'Current Location'),
      );
    }
    return SizedBox.shrink();
  },
)
```

## 🔗 Related Files

- **Documentation**: `LOCATION_FEATURE.md`
- **Summary**: `LOCATION_IMPLEMENTATION_SUMMARY.md`
- **Location Service**: `frontend/lib/services/location_service.dart`
- **API Service**: `frontend/lib/services/api_service.dart`
- **Backend Recommendations**: `backend/src/services/recommendations.ts`

## ✅ Ready to Ship

Once you've completed the integration:
1. Test on both iOS and Android devices
2. Verify location permission flow
3. Test "For You" recommendations
4. Check privacy policy mentions location usage
5. Add to release notes: "New: Personalized recommendations based on your location"

---

**Need Help?** Check `LOCATION_FEATURE.md` for detailed documentation or review the implementation summary.
