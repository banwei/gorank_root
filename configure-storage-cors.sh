#!/bin/bash

# Script to configure Firebase Storage CORS rules
# This allows web uploads from localhost and other domains

echo "Configuring Firebase Storage CORS rules..."

# Apply CORS configuration to Firebase Storage bucket
gsutil cors set firebase-storage-cors.json gs://gorank-8c97f.firebasestorage.app

echo "CORS configuration applied successfully!"
echo "Your Firebase Storage bucket now allows uploads from web browsers."
