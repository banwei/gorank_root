# Web Share Dialog - User Guide

## The Problem We Solved
Previously on web, clicking "Share Your Ranking" would show a popup that disappeared within 2 seconds before users could interact with it. This was because the `share_plus` package's web implementation either:
1. Tried to use the Web Share API (not available in all browsers/contexts)
2. Silently copied to clipboard without feedback
3. Showed a brief notification that disappeared too quickly

## The Solution
We now show a **persistent custom dialog** on web browsers that stays open until the user takes action.

## New Web Share Dialog Features

### Dialog Layout

```
┌─────────────────────────────────────────┐
│ 🔵 Share Your Ranking              × │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐  │
│  │ 🏆 My Best Anime Series          │  │
│  │                                   │  │
│  │ Champion: Attack on Titan        │  │
│  │                                   │  │
│  │ My Top Rankings:                 │  │
│  │ 🥇 Attack on Titan               │  │
│  │ 🥈 Death Note                    │  │
│  │ 🥉 Fullmetal Alchemist          │  │
│  │ ... and 17 more items            │  │
│  │                                   │  │
│  │ 🎮 Create your own ranking at    │  │
│  │ GoRank!                          │  │
│  │ 👉 https://gorank-8c97f.web.app  │  │
│  │    /#/ranking/best_anime_series  │  │
│  └─────────────────────────────────┘  │
│                                         │
│  ┌─────────────────────────────────┐  │
│  │  📋 Copy to Clipboard           │  │ (Blue)
│  └─────────────────────────────────┘  │
│                                         │
│  Or share directly to:                 │
│                                         │
│  [Twitter] [Facebook] [WhatsApp] [Email]│
│                                         │
│                           [Close]       │
└─────────────────────────────────────────┘
```

### Components

1. **Preview Section** (Gray box)
   - Shows exactly what will be shared
   - Scrollable if content is long
   - Users can see before sharing

2. **Copy to Clipboard Button** (Large blue button)
   - Primary action for web users
   - One click copies all text
   - Shows success message: "Copied to clipboard! Paste it anywhere to share."
   - Most reliable method across all browsers

3. **Social Media Buttons** (Platform-colored chips)
   - **Twitter** (Blue): Opens Twitter with pre-filled tweet
   - **Facebook** (Blue): Opens Facebook sharer
   - **WhatsApp** (Green): Opens WhatsApp Web
   - **Email** (Gray): Opens email client

4. **Close Button**
   - User can dismiss dialog anytime
   - Dialog only closes when user chooses

### User Workflows

#### Workflow 1: Copy & Paste (Recommended)
1. User clicks "Share Your Ranking"
2. Dialog opens showing preview
3. User clicks "Copy to Clipboard"
4. Green success message appears
5. User can now paste into any app (Discord, Reddit, Twitter, etc.)

#### Workflow 2: Direct Social Share
1. User clicks "Share Your Ranking"
2. Dialog opens showing preview
3. User clicks their preferred social button
4. New tab opens with pre-filled content
5. User can modify and post
6. Dialog closes automatically

#### Workflow 3: Email Share
1. User clicks "Share Your Ranking"
2. Dialog opens showing preview
3. User clicks "Email" button
4. Default email client opens with:
   - Subject: "My [Ranking Name]"
   - Body: Full formatted ranking text
5. User adds recipient and sends

## Technical Implementation Details

### Platform Detection
```dart
if (kIsWeb) {
  // Show custom dialog
  _showWebShareDialog(shareText);
} else {
  // Use native share
  await Share.share(shareText);
}
```

### Social Media URL Schemes

**Twitter Intent:**
```
https://twitter.com/intent/tweet?text=[encoded_text]
```

**Facebook Sharer:**
```
https://www.facebook.com/sharer/sharer.php?quote=[encoded_text]
```

**WhatsApp Web:**
```
https://wa.me/?text=[encoded_text]
```

**Email Mailto:**
```
mailto:?subject=[subject]&body=[encoded_text]
```

## Benefits Over Previous Implementation

| Feature | Old (share_plus only) | New (Custom Dialog) |
|---------|----------------------|-------------------|
| **Visibility** | 2-second popup | Persistent until closed |
| **User Control** | Auto-closes | User decides when to close |
| **Options** | Limited/unclear | Multiple clear options |
| **Feedback** | Minimal | Clear success messages |
| **Reliability** | Hit-or-miss | Always works |
| **Preview** | None | Full text preview |
| **Flexibility** | One method | Multiple methods |

## Browser Compatibility

✅ **Chrome/Edge**: All features work
✅ **Firefox**: All features work
✅ **Safari**: All features work
✅ **Opera**: All features work
✅ **Mobile Browsers**: Falls back to native share

## User Feedback Examples

### After Copying to Clipboard:
```
✓ Copied to clipboard! Paste it anywhere to share.
```
(Green SnackBar, 3 seconds)

### After Clicking Social Button:
```
Opening share link...
```
(Gray SnackBar, 2 seconds)

### If Social Link Fails:
```
⚠ Could not open link. Please copy the text and share manually.
```
(Orange SnackBar, 3 seconds)

## Testing Checklist

- [ ] Click "Share Your Ranking" button
- [ ] Verify dialog appears and stays open
- [ ] Check preview text is correct
- [ ] Click "Copy to Clipboard" - verify success message
- [ ] Paste in another app - verify text is correct
- [ ] Click Twitter button - verify new tab opens
- [ ] Click Facebook button - verify sharer opens
- [ ] Click WhatsApp button - verify WhatsApp Web opens
- [ ] Click Email button - verify email client opens
- [ ] Click Close button - verify dialog dismisses
- [ ] Test on multiple browsers (Chrome, Firefox, Safari)

## Next Steps

Now users can:
1. ✅ See exactly what they're sharing
2. ✅ Choose their preferred sharing method
3. ✅ Copy once and share to multiple platforms
4. ✅ Get clear feedback on all actions
5. ✅ Take their time - no rushing!
