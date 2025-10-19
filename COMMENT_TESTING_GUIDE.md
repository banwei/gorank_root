# Comment System Testing Guide

## Test Scenarios

### 1. **View Comments Without Login**
**Steps:**
1. Open the app (not logged in)
2. Navigate to any ranking list
3. Scroll to see comments section

**Expected:**
- ✅ See "Community Discussion" section with total comment count
- ✅ See preview of recent comments (if any exist)
- ✅ See "Leave a Comment" section
- ✅ See "Sign in to comment" button
- ✅ NO ability to post comments

### 2. **Login and Comment**
**Steps:**
1. Click "Sign in to comment"
2. Login with credentials
3. Go back to the list
4. Click "Add comment" button (+ icon)

**Expected:**
- ✅ Comment input field appears
- ✅ Can type up to 500 characters
- ✅ See "Post" and "Cancel" buttons
- ✅ Can post comment successfully

### 3. **Comment on List (No Ranking)**
**Steps:**
1. Login
2. View a list WITHOUT creating a ranking
3. Post a comment

**Expected:**
- ✅ Comment posted successfully
- ✅ Comment appears immediately in the list
- ✅ Comment shows in "Community Discussion"
- ✅ Comment is NOT linked to a ranking (rankingId is null)

### 4. **Comment After Creating Ranking**
**Steps:**
1. Login
2. Create a ranking for a list
3. View results screen
4. Post a comment

**Expected:**
- ✅ Comment posted successfully
- ✅ Comment is linked to your ranking (rankingId is set)
- ✅ Comment shows in both "Discussion" and "Community Discussion"

### 5. **View Comments from Profile**
**Steps:**
1. View another user's profile
2. Click on one of their rankings
3. Scroll to comments section

**Expected:**
- ✅ See all comments for that list
- ✅ See "Community Discussion" with total count
- ✅ If logged in, can add comments
- ✅ Can like/unlike comments

### 6. **Like/Unlike Comments**
**Steps:**
1. Login
2. View a list with existing comments
3. Click heart icon on a comment

**Expected:**
- ✅ Heart fills in (liked)
- ✅ Like count increases
- ✅ Click again to unlike
- ✅ Heart outline (unliked)
- ✅ Like count decreases

### 7. **Delete Own Comment**
**Steps:**
1. Login
2. Post a comment
3. Click delete icon (trash) on your comment
4. Confirm deletion

**Expected:**
- ✅ Confirmation dialog appears
- ✅ Comment is deleted
- ✅ Comment disappears from list
- ✅ Total comment count decreases

### 8. **Community Discussion Dialog**
**Steps:**
1. View a list with multiple comments
2. Click on "Community Discussion" card

**Expected:**
- ✅ Dialog opens showing all comments
- ✅ Comments sorted by newest first
- ✅ Can scroll through all comments
- ✅ Can like/unlike from dialog
- ✅ Can close dialog

## API Testing (via Backend)

### Test with curl/Postman:

**Get all comments for a list:**
```bash
curl http://localhost:4001/lists/LIST_ID/comments
```

**Get comments for a specific ranking:**
```bash
curl http://localhost:4001/lists/LIST_ID/comments?rankingId=RANKING_ID
```

**Post a comment (no ranking link):**
```bash
curl -X POST http://localhost:4001/lists/LIST_ID/comments \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_ID",
    "text": "Great list!"
  }'
```

**Post a comment (with ranking link):**
```bash
curl -X POST http://localhost:4001/lists/LIST_ID/comments \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_ID",
    "text": "This is why I ranked it this way...",
    "rankingId": "RANKING_ID"
  }'
```

## Known Issues / TODO

- [ ] **Database Migration Needed**: Existing comments need listId field added
- [ ] **"View all comments" button**: Currently TODO in code
- [ ] **Real-time updates**: Comments don't auto-refresh (need to reload)
- [ ] **Pagination**: Loading all comments might be slow for popular lists

## Success Criteria

✅ Non-logged-in users can view comments  
✅ Logged-in users can comment without creating a ranking  
✅ Comments visible from all entry points (profile, direct link, etc.)  
✅ Comments can be linked to specific rankings  
✅ Community discussion shows total count and preview  
✅ Like/unlike functionality works  
✅ Delete own comment works  
✅ Clear "Sign in to comment" CTA for non-logged-in users  

## Troubleshooting

**Issue: Comments not appearing**
- Check backend is running (port 4001)
- Check listId is correct in API call
- Check browser console for errors

**Issue: "Failed to post comment"**
- Verify user is logged in
- Check backend logs for validation errors
- Verify listId exists in database

**Issue: "Sign in to comment" doesn't work**
- Check navigation to AuthScreen
- Verify auth flow is working

**Issue: Comments show from wrong list**
- Check listId parameter is correct
- Verify API is filtering by listId not rankingId
