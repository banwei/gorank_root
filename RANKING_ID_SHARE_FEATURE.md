# Ranking ID in Share Feature

## Summary
Enhanced the share ranking feature to include the specific ranking ID in the share link, allowing recipients to view the exact ranking that was shared with them.

## Problem Solved
Previously, when users shared their rankings, the link only included the list ID (e.g., `#/ranking/fast_food_guilty`). This would show the most recent ranking for that list, which might not be the one that was actually shared. Now, the share link includes both the list ID and the specific ranking ID (e.g., `#/ranking/fast_food_guilty/abc123`), ensuring recipients see exactly what was shared.

## Changes Made

### 1. Updated `ResultsScreen` (`frontend/lib/screens/results_screen.dart`)

#### Added ranking ID parameter:
```dart
class ResultsScreen extends StatefulWidget {
  final String? rankingId; // ID of the specific ranking being viewed/shared
  
  const ResultsScreen({
    // ... other parameters
    this.rankingId,
  });
}
```

#### Updated share text generation:
```dart
String _generateShareText() {
  final listId = widget.rankingList?.id ?? '';
  final rankingId = widget.rankingId ?? '';
  // ...
  
  // Include both list ID and ranking ID in the URL
  if (listId.isNotEmpty && rankingId.isNotEmpty) {
    buffer.writeln('👉 $appUrl/#/ranking/$listId/$rankingId');
  } else if (listId.isNotEmpty) {
    buffer.writeln('👉 $appUrl/#/ranking/$listId');
  }
}
```

### 2. Updated `main.dart` Routing

#### Enhanced route handler to parse ranking ID:
```dart
Route<dynamic>? _generateRoute(RouteSettings settings) {
  // Supports: /ranking/listId or /ranking/listId/rankingId
  if (settings.name != null && settings.name!.startsWith('/ranking/')) {
    final pathParts = settings.name!.substring('/ranking/'.length).split('/');
    final listId = pathParts[0];
    final rankingId = pathParts.length > 1 ? pathParts[1] : null;
    
    return MaterialPageRoute(
      builder: (_) => SharedRankingScreen(
        listId: listId,
        rankingId: rankingId,
      ),
    );
  }
}
```

### 3. Updated `SharedRankingScreen` (`frontend/lib/screens/shared_ranking_screen.dart`)

#### Enhanced to load specific ranking and pass ID to ResultsScreen:
```dart
Future<void> _loadAndNavigate() async {
  // ... load list and items ...
  
  if (specificRanking != null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          // ... other parameters ...
          rankingId: specificRanking.id, // Pass the ranking ID for sharing
        ),
      ),
    );
  }
}
```

### 4. Updated `ApiAppState` (`frontend/lib/services/api_app_state.dart`)

#### Modified to return ranking ID after save:
```dart
// Returns the ranking ID if successful
Future<String?> saveUserRanking(String listId, List<String> rankedItemIds, Map<String, double>? ratings) async {
  // ...
  
  if (existingRanking != null) {
    await ApiService.updateUserRanking(listId, _currentUser!.id, request);
    return existingRanking.id; // Return the existing ranking ID
  } else {
    await ApiService.submitRanking(listId, request);
    // Fetch the newly created ranking to get its ID
    final newRanking = await getUserRankingForList(listId);
    return newRanking?.id;
  }
}

Future<String?> saveUserRankingObject(UserRanking userRanking) async {
  return await saveUserRanking(...);
}
```

### 5. Updated Ranking Screens (Example: `modern_ranking_screen.dart`)

#### Capture ranking ID and pass to ResultsScreen:
```dart
void _completeRanking() async {
  // ...
  
  // Save ranking and get the ranking ID
  final rankingId = await appState.saveUserRankingObject(userRanking);
  
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => ResultsScreen(
        // ... other parameters ...
        rankingId: rankingId, // Pass the ranking ID for sharing
      ),
    ),
  );
}
```

## User Journey

### Before:
1. User A creates ranking → shares link: `#/ranking/fast_food_guilty`
2. User B clicks link → sees **most recent ranking** (might be User C's ranking, not User A's!)
3. ❌ **User B doesn't see the specific ranking User A shared**

### After:
1. User A creates ranking → shares link: `#/ranking/fast_food_guilty/abc123`
2. User B clicks link → sees **User A's specific ranking** (ID: abc123)
3. ✅ **User B sees exactly what User A shared!**

## Technical Benefits

1. **Precise Sharing**: Recipients see the exact ranking that was shared
2. **Tracking**: Can track which specific rankings are being shared and viewed
3. **History**: Users can share old rankings, not just their most recent one
4. **Viral Loop**: Each shared ranking is a unique link that drives engagement

## Example Share URLs

### With Ranking ID (New):
```
https://gorank-8c97f.web.app/#/ranking/fast_food_guilty/abc123
```
- Opens the specific ranking with ID `abc123`
- Shows "Viewing John's Ranking" at the top
- Allows recipient to create their own ranking and compare

### Without Ranking ID (Fallback):
```
https://gorank-8c97f.web.app/#/ranking/fast_food_guilty
```
- Opens the most recent ranking for this list
- Still functional for backward compatibility

## Notes for Other Ranking Screens

All ranking screens have been updated to capture and pass the ranking ID:

Screens updated:
- ✅ `modern_ranking_screen.dart` 
- ✅ `swipe_ranking_screen.dart`
- ✅ `balloon_ranking_screen.dart`
- ✅ `galaxy_attack_ranking_screen.dart`
- ✅ `pizza_ranking_screen.dart`
- ✅ `jigsaw_puzzle_ranking_screen.dart`
- ✅ `tree_ranking_screen.dart`
- ✅ `tournament_game_screen.dart`

All screens now:
1. Capture ranking ID: `final rankingId = await appState.saveUserRankingObject(userRanking);`
2. Pass it to ResultsScreen: `rankingId: rankingId`

## Testing Checklist

- [ ] Share link includes ranking ID (format: `#/ranking/{listId}/{rankingId}`)
- [ ] Clicking shared link loads specific ranking
- [ ] "Viewing [Username]'s Ranking" displays correctly
- [ ] Share button shows correct URL with ranking ID
- [ ] Works on both web and mobile
- [ ] Backward compatibility: URLs without ranking ID still work
- [ ] Copy-to-clipboard includes ranking ID
- [ ] Social media share buttons include ranking ID
- [ ] All 8 ranking game modes pass ranking ID correctly

### How to Test:
1. Complete a ranking in any game mode
2. Click "Share Your Ranking" button
3. Check the share text - should include: `👉 https://gorank-8c97f.web.app/#/ranking/{listId}/{rankingId}`
4. Copy the link and open in a new incognito tab
5. Verify you see the exact ranking you shared (with your username at the top)
6. Test with different game modes to ensure consistency
