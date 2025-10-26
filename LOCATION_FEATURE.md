# Location Feature Implementation Guide

## Overview

This document describes the location feature implementation in the GoRank application. The location feature enables smart, context-aware recommendations based on the user's geographic location. Location data is collected, stored, and used transparently in the background to enhance the user experience without being visible in the UI.

## Architecture

### Frontend (Flutter)
- **Location Service** (`frontend/lib/services/location_service.dart`): Handles device location detection using the `geolocator` and `geocoding` packages
- **API Integration**: Methods to update user location and fetch personalized recommendations

### Backend (Node.js/Express/Firebase)
- **Location Types**: Added to all relevant models (User, Item, ListEntity, UserGroup, Category)
- **Recommendation Engine** (`backend/src/services/recommendations.ts`): Smart algorithm for location-based recommendations
- **API Endpoints**: 
  - `PUT /users/:id/location` - Update user location
  - `POST /lists/for-you` - Get personalized recommendations

### Data Models

#### GeoLocation Interface
```typescript
interface GeoLocation {
  latitude: number;
  longitude: number;
  accuracy?: number;
  timestamp?: string;
  address?: string;
  city?: string;
  country?: string;
}
```

Location has been added to the following entities:
- **User**: Stores the user's current or last known location
- **Item**: For location-specific items (restaurants, hotels, attractions)
- **ListEntity**: For location-context lists ("Best Restaurants in Tokyo")
- **UserGroup**: For location-based groups (city-specific groups)
- **Category**: Added `isLocationBased` flag to identify categories that use location

## Location Detection Flow

### 1. Permission Request
The app requests location permission from the user:
```dart
LocationService locationService = LocationService();
bool hasPermission = await locationService.requestLocationPermission();
```

### 2. Location Capture
Location is captured automatically in the background:
```dart
GeoLocation? location = await locationService.getCurrentLocation();
```

Location data includes:
- Latitude and longitude coordinates
- Accuracy (in meters)
- Timestamp
- Reverse geocoded address (city, country)

### 3. Location Storage
User location is sent to the backend and stored in Firestore:
```dart
await ApiService.updateUserLocation(
  userId,
  location.latitude,
  location.longitude,
  accuracy: location.accuracy,
  address: location.address,
  city: location.city,
  country: location.country,
);
```

### 4. Caching
Location is cached for 15 minutes to minimize battery usage and API calls.

## Recommendation Algorithm

The "For You" recommendation system uses multiple factors:

### 1. **Location Proximity** (0-0.5 points)
- < 5 km: +0.5 points ("Very close to you")
- < 20 km: +0.3 points ("Nearby")
- < 50 km: +0.1 points ("In your area")

### 2. **Category Relevance** (0-0.9 points)
Location-based categories are scored based on user's location:
- Restaurants/Food: 0.9
- Hotels/Accommodation: 0.85
- Attractions/Tourism: 0.8
- Shopping: 0.75
- Entertainment/Parks: 0.7

### 3. **User Interests** (0-0.4 points)
Lists matching user's interests get a +0.4 boost

### 4. **Popularity** (0-0.3 points)
Popular lists get additional points (capped at 0.3)

### Final Scoring
Lists are sorted by total relevance score and the top results are returned.

## Usage Examples

### Example 1: Updating User Location
```dart
// In your app, when user opens the app or navigates
LocationService locationService = LocationService();
GeoLocation? location = await locationService.getLocationForRecommendations();

if (location != null && user != null) {
  await ApiService.updateUserLocation(
    user.id,
    location.latitude,
    location.longitude,
    city: location.city,
    country: location.country,
  );
}
```

### Example 2: Fetching "For You" Recommendations
```dart
// Get personalized recommendations based on location
List<ListEntity> recommendations = await ApiService.getForYouRecommendations(
  userId: currentUser.id,
  latitude: location?.latitude,
  longitude: location?.longitude,
  limit: 10,
);

// Display recommendations in a "For You" section
```

### Example 3: Creating Location-Based Content
```dart
// When creating a list for restaurants in Tokyo
CreateListRequest request = CreateListRequest(
  title: "Best Ramen in Tokyo",
  categoryId: restaurantCategoryId,
  items: itemIds,
  createdBy: userId,
);

// Location is automatically associated with the list
// based on the items' locations or can be manually set
```

## Privacy Considerations

1. **User Consent**: Always request location permission with clear explanation
2. **Transparency**: Location data is used only for recommendations
3. **Storage**: Location is stored in user's document, not publicly visible
4. **Cache Expiration**: Location cache expires after 15 minutes
5. **Optional Feature**: Location is optional; app works without it

## Location-Based Categories

Certain categories benefit from location context:
- 🍽️ Restaurants & Food
- 🏨 Hotels & Accommodation
- 🎭 Tourist Attractions
- 🛍️ Shopping & Retail
- 🎡 Entertainment & Theme Parks
- 🏖️ Beaches & Outdoor Activities

These categories should have `isLocationBased: true` in their configuration.

## Testing

### Testing Location Service
```dart
// Test location detection
LocationService locationService = LocationService();

// Test permission
bool hasPermission = await locationService.hasLocationPermission();
print('Has permission: $hasPermission');

// Test location fetch
GeoLocation? location = await locationService.getCurrentLocation(forceRefresh: true);
print('Location: ${location?.latitude}, ${location?.longitude}');
print('City: ${location?.city}');

// Test distance calculation
double distance = locationService.calculateDistance(location1, location2);
print('Distance: $distance km');

// Test proximity check
bool isNearby = locationService.isWithinRadius(userLocation, targetLocation, 5.0);
print('Within 5km: $isNearby');
```

### Testing Recommendations
```dart
// Test recommendation API
try {
  List<ListEntity> recommendations = await ApiService.getForYouRecommendations(
    userId: 'test_user_id',
    latitude: 35.6762,  // Tokyo coordinates
    longitude: 139.6503,
    limit: 5,
  );
  
  print('Got ${recommendations.length} recommendations');
  for (var list in recommendations) {
    print('${list.title} - Relevance: ${list.relevanceScore}');
  }
} catch (e) {
  print('Error: $e');
}
```

## Future Enhancements

1. **Geofencing**: Trigger notifications when user enters specific areas
2. **Location History**: Track user's favorite locations for better recommendations
3. **Multi-location Lists**: Support lists that span multiple locations
4. **Distance Display**: Show distance to items/locations in UI
5. **Map Integration**: Display items and lists on a map view
6. **Weather-based Recommendations**: Consider weather when recommending outdoor activities
7. **Time-based Recommendations**: Morning coffee spots, lunch restaurants, evening entertainment

## Troubleshooting

### Location Permission Denied
- Ensure app has location permission in device settings
- Check if location services are enabled on device
- Gracefully handle permission denial

### Inaccurate Location
- Location accuracy depends on GPS, WiFi, and cellular signals
- Indoor locations may be less accurate
- Use accuracy field to determine reliability

### No Recommendations
- User may not have location enabled
- No location-based content in the area
- Check if categories have `isLocationBased` flag set

### Backend Errors
- Verify user exists in database
- Check if location data is valid (latitude: -90 to 90, longitude: -180 to 180)
- Ensure recommendation service has access to all required collections

## Configuration

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>GoRank needs your location to provide personalized recommendations near you</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>GoRank needs your location to provide personalized recommendations</string>
```

## Dependencies

### Flutter
- `geolocator: ^13.0.2` - Location detection
- `geocoding: ^3.0.0` - Reverse geocoding (coordinates to address)

### Backend
- Firebase Firestore - Location data storage
- Node.js - Recommendation algorithm

## API Reference

### Update User Location
```http
PUT /users/:id/location
Content-Type: application/json

{
  "latitude": 35.6762,
  "longitude": 139.6503,
  "accuracy": 10.5,
  "address": "Tokyo, Japan",
  "city": "Tokyo",
  "country": "Japan"
}
```

### Get Personalized Recommendations
```http
POST /lists/for-you
Content-Type: application/json

{
  "userId": "user_123",
  "latitude": 35.6762,
  "longitude": 139.6503,
  "limit": 10
}
```

Response:
```json
{
  "lists": [
    {
      "id": "list_456",
      "title": "Best Ramen in Tokyo",
      "categoryId": "cat_food",
      "relevanceScore": 1.4,
      "relevanceReason": "Very close to you • Popular food recommendations near you • Matches your interests",
      ...
    }
  ]
}
```

## Support

For issues or questions about the location feature:
1. Check the troubleshooting section
2. Review the API documentation
3. Check Firebase console for data consistency
4. Review logs for error messages
