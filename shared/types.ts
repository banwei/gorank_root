// shared/types.ts
// TypeScript interfaces for backend use

// Location types
export interface GeoLocation {
  latitude: number;
  longitude: number;
  accuracy?: number;
  timestamp?: string;
  address?: string;
  city?: string;
  country?: string;
}

export interface Category {
  id: string;
  name: string;
  description: string;
  iconName: string;
  colorHex: string;
  isActive: boolean;
  createdAt: string;
  isLocationBased?: boolean; // Flag to indicate if this category uses location (e.g., restaurants, hotels)
}

export enum UserRole {
  USER = 'user',
  MODERATOR = 'moderator',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin'
}

export interface User {
  id: string;
  username: string;
  email: string;
  profileImageUrl?: string;
  interests: string[];
  createdAt: string;
  isInfluencer: boolean;
  role: UserRole;
  location?: GeoLocation; // User's current or last known location
}

export interface Item {
  id: string;
  name: string;
  description: string;
  imageUrl?: string;
  thumbnailUrl?: string; // Added thumbnail URL
  category: string;
  metadata: Record<string, any>;
  createdAt: string;
  // GenAI Enhancement fields
  tags?: string[];
  wikipediaUrl?: string;
  officialWebsite?: string;
  imagePath?: string;
  thumbnailPath?: string; // Added thumbnail path
  enhancedAt?: string;
  enhancedBy?: string;
  location?: GeoLocation; // Physical location for location-based items (restaurants, hotels, etc.)
}

export interface PopularItem extends Item {
  popularityScore: number;
  rankingCount: number;
  averagePosition: number;
}

export interface UserGroup {
  id: string;
  name: string;
  description: string;
  creatorId: string;
  memberIds: string[];
  categoryIds: string[];
  isPublic: boolean;
  createdAt: string;
  location?: GeoLocation; // Location for location-based groups (e.g., city-specific groups)
}

export interface ListEntity {
  id: string;
  title: string;
  categoryId: string;
  status: 'pending' | 'approved' | 'active' | 'closed';
  items: string[]; // Array of item IDs
  popularity?: number;
  itemsCount?: number;
  createdAt?: string;
  createdBy?: string;
  location?: GeoLocation; // Location context for the list (e.g., "Best Restaurants in Tokyo")
}

export interface UserRanking {
  id: string;
  userId: string;
  listId: string;
  rankedItemIds: string[];
  method: string;
  groupType: string;
  createdAt: string;
  updatedAt: string;
  itemRatings: Record<string, number>;
}

export interface UserFollow {
  id: string;
  followerId: string;
  followingId: string;
  createdAt: string;
}

export interface FollowStats {
  followersCount: number;
  followingCount: number;
  isFollowing?: boolean;
}

export interface RankingComment {
  id: string;
  listId: string; // Primary: comment belongs to a list
  rankingId?: string; // Optional: comment can be linked to a specific ranking
  userId: string;
  username: string;
  userProfileImageUrl?: string;
  text: string;
  likeCount: number;
  likedByCurrentUser?: boolean;
  createdAt: string;
}

export interface CommentLike {
  id: string;
  commentId: string;
  userId: string;
  createdAt: string;
}

export interface ItemContent {
  id: string;
  itemId: string;
  userId: string;
  username: string;
  userProfileImageUrl?: string;
  type: 'review' | 'instagram' | 'twitter' | 'youtube' | 'tiktok';
  url: string;
  title: string;
  description?: string;
  thumbnailUrl?: string;
  likeCount: number;
  likedByCurrentUser?: boolean;
  createdAt: string;
}

export interface ItemContentLike {
  id: string;
  contentId: string;
  userId: string;
  createdAt: string;
}

// Deprecated - keeping for backward compatibility
export interface ListItem {
  id: string;
  name: string;
  imageUrl?: string;
}

export interface RankingSubmission {
  userId: string;
  listId: string;
  ranking: string[];
  createdAt?: string;
}

// Request/Response types for API endpoints
export interface CreateCategoryRequest {
  name: string;
  description: string;
  iconName: string;
  colorHex: string;
  isActive?: boolean;
}

export interface UpdateCategoryRequest {
  name?: string;
  description?: string;
  iconName?: string;
  colorHex?: string;
  isActive?: boolean;
}

export interface CreateUserRequest {
  username: string;
  email: string;
  profileImageUrl?: string;
  interests?: string[];
  isInfluencer?: boolean;
  role?: UserRole;
}

export interface UpdateUserRequest {
  username?: string;
  email?: string;
  profileImageUrl?: string;
  interests?: string[];
  isInfluencer?: boolean;
  role?: UserRole;
}

export interface CreateItemRequest {
  name: string;
  description: string;
  imageUrl?: string;
  category: string;
  metadata?: Record<string, any>;
}

export interface UpdateItemRequest {
  name?: string;
  description?: string;
  imageUrl?: string;
  category?: string;
  metadata?: Record<string, any>;
}

export interface CreateUserGroupRequest {
  name: string;
  description: string;
  creatorId: string;
  memberIds?: string[];
  categoryIds?: string[];
  isPublic?: boolean;
}

export interface UpdateUserGroupRequest {
  name?: string;
  description?: string;
  memberIds?: string[];
  categoryIds?: string[];
  isPublic?: boolean;
}

export interface AddMemberRequest {
  userId: string;
}

export interface CreateListRequest {
  title: string;
  categoryId: string;
  items: string[]; // Array of item IDs
  createdBy: string;
  status?: 'pending' | 'approved' | 'active' | 'closed';
}

export interface UpdateListRequest {
  title?: string;
  categoryId?: string;
  items?: string[];
  status?: 'pending' | 'approved' | 'active' | 'closed';
}

export interface CreateRankingRequest {
  userId: string;
  listId: string;
  rankedItemIds: string[];
  method: string;
  groupType: string;
  itemRatings?: Record<string, number>;
}

export interface CreateFollowRequest {
  followerId: string;
}

export interface FollowQueryParams {
  page?: number;
  limit?: number;
}

export interface CreateCommentRequest {
  userId: string;
  text: string;
  rankingId?: string; // Optional: link comment to a specific ranking
}

export interface LikeCommentRequest {
  userId: string;
}

export interface CreateItemContentRequest {
  userId: string;
  type: 'review' | 'instagram' | 'twitter' | 'youtube' | 'tiktok';
  url: string;
  title: string;
  description?: string;
}

export interface LikeItemContentRequest {
  userId: string;
}

export interface ItemContentsQueryParams {
  page?: number;
  limit?: number;
  type?: 'review' | 'instagram' | 'twitter' | 'youtube' | 'tiktok';
}

// Response types

export interface CommentsQueryParams {
  page?: number;
  limit?: number;
}

export interface UpdateRankingRequest {
  rankedItemIds?: string[];
  method?: string;
  groupType?: string;
  itemRatings?: Record<string, number>;
}

export interface SubmitRankingRequest {
  userId: string;
  rankedItemIds: string[];
  method: string;
  groupType: string;
  itemRatings?: Record<string, number>;
}

// Query parameter types
export interface ListsQueryParams {
  categoryId?: string;
  status?: 'pending' | 'approved' | 'active' | 'closed';
}

export interface ItemsQueryParams {
  category?: string;
}

export interface PopularItemsQueryParams {
  limit?: number;
  category?: string;
}

export interface RankingsQueryParams {
  listId?: string;
  userId?: string;
}

export interface TrendingQueryParams {
  limit?: number;
}

// Response types
export interface ApiResponse<T> {
  data?: T;
  error?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  page?: number;
  limit?: number;
  total?: number;
  hasMore?: boolean;
}

export interface RankingStats {
  listId: string;
  totalRankings: number;
  averageRatings: Record<string, number>;
  popularityOrder: string[];
  lastUpdated: string;
}

// Error types
export interface ApiError {
  message: string;
  code?: string;
  details?: any;
}
