// shared/types.ts
// TypeScript interfaces for backend use

export interface Category {
  id: string;
  name: string;
  description: string;
  iconName: string;
  colorHex: string;
  isActive: boolean;
  createdAt: string;
}

export interface User {
  id: string;
  username: string;
  email: string;
  profileImageUrl?: string;
  interests: string[];
  createdAt: string;
  isInfluencer: boolean;
}

export interface Item {
  id: string;
  name: string;
  description: string;
  imageUrl?: string;
  category: string;
  metadata: Record<string, any>;
  createdAt: string;
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
}

export interface UserRanking {
  id: string;
  userId: string;
  listId: string;
  rankedItemIds: string[];
  method: string;
  groupType: string;
  createdAt: string;
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
}

export interface UpdateUserRequest {
  username?: string;
  email?: string;
  profileImageUrl?: string;
  interests?: string[];
  isInfluencer?: boolean;
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
