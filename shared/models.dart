// shared/models.dart
// Dart models for Flutter frontend use

class Category {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String colorHex;
  final bool isActive;
  final String createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.colorHex,
    required this.isActive,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        iconName: json['iconName'] as String,
        colorHex: json['colorHex'] as String,
        isActive: json['isActive'] as bool,
        createdAt: json['createdAt'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'iconName': iconName,
        'colorHex': colorHex,
        'isActive': isActive,
        'createdAt': createdAt,
      };
}

class User {
  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;
  final List<String> interests;
  final String createdAt;
  final bool isInfluencer;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
    required this.interests,
    required this.createdAt,
    required this.isInfluencer,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        profileImageUrl: json['profileImageUrl'] as String?,
        interests: List<String>.from(json['interests'] as List),
        createdAt: json['createdAt'] as String,
        isInfluencer: json['isInfluencer'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'interests': interests,
        'createdAt': createdAt,
        'isInfluencer': isInfluencer,
      };
}

class Item {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String category;
  final Map<String, dynamic> metadata;
  final String createdAt;

  Item({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.metadata,
    required this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
        category: json['category'] as String,
        metadata: json['metadata'] as Map<String, dynamic>,
        createdAt: json['createdAt'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'category': category,
        'metadata': metadata,
        'createdAt': createdAt,
      };
}

class UserGroup {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final List<String> memberIds;
  final List<String> categoryIds;
  final bool isPublic;
  final String createdAt;

  UserGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.memberIds,
    required this.categoryIds,
    required this.isPublic,
    required this.createdAt,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) => UserGroup(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        creatorId: json['creatorId'] as String,
        memberIds: List<String>.from(json['memberIds'] as List),
        categoryIds: List<String>.from(json['categoryIds'] as List),
        isPublic: json['isPublic'] as bool,
        createdAt: json['createdAt'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'creatorId': creatorId,
        'memberIds': memberIds,
        'categoryIds': categoryIds,
        'isPublic': isPublic,
        'createdAt': createdAt,
      };
}

class ListEntity {
  final String id;
  final String title;
  final String categoryId;
  final String status;
  final List<String> items; // Array of item IDs
  final num? popularity;
  final int? itemsCount;
  final String? createdAt;
  final String? createdBy;

  ListEntity({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.status,
    required this.items,
    this.popularity,
    this.itemsCount,
    this.createdAt,
    this.createdBy,
  });

  factory ListEntity.fromJson(Map<String, dynamic> json) => ListEntity(
        id: json['id'] as String,
        title: json['title'] as String,
        categoryId: json['categoryId'] as String,
        status: json['status'] as String,
        items: List<String>.from(json['items'] as List),
        popularity: json['popularity'] as num?,
        itemsCount: json['itemsCount'] as int?,
        createdAt: json['createdAt'] as String?,
        createdBy: json['createdBy'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'categoryId': categoryId,
        'status': status,
        'items': items,
        'popularity': popularity,
        'itemsCount': itemsCount,
        'createdAt': createdAt,
        'createdBy': createdBy,
      };
}

class UserRanking {
  final String id;
  final String userId;
  final String listId;
  final List<String> rankedItemIds;
  final String method;
  final String groupType;
  final String createdAt;
  final Map<String, double> itemRatings;

  UserRanking({
    required this.id,
    required this.userId,
    required this.listId,
    required this.rankedItemIds,
    required this.method,
    required this.groupType,
    required this.createdAt,
    required this.itemRatings,
  });

  factory UserRanking.fromJson(Map<String, dynamic> json) => UserRanking(
        id: json['id'] as String,
        userId: json['userId'] as String,
        listId: json['listId'] as String,
        rankedItemIds: List<String>.from(json['rankedItemIds'] as List),
        method: json['method'] as String,
        groupType: json['groupType'] as String,
        createdAt: json['createdAt'] as String,
        itemRatings: Map<String, double>.from(
          (json['itemRatings'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'listId': listId,
        'rankedItemIds': rankedItemIds,
        'method': method,
        'groupType': groupType,
        'createdAt': createdAt,
        'itemRatings': itemRatings,
      };
}

// Request classes for API calls
class CreateCategoryRequest {
  final String name;
  final String description;
  final String iconName;
  final String colorHex;
  final bool? isActive;

  CreateCategoryRequest({
    required this.name,
    required this.description,
    required this.iconName,
    required this.colorHex,
    this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'iconName': iconName,
        'colorHex': colorHex,
        if (isActive != null) 'isActive': isActive,
      };
}

class CreateUserRequest {
  final String username;
  final String email;
  final String? profileImageUrl;
  final List<String>? interests;
  final bool? isInfluencer;

  CreateUserRequest({
    required this.username,
    required this.email,
    this.profileImageUrl,
    this.interests,
    this.isInfluencer,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        if (interests != null) 'interests': interests,
        if (isInfluencer != null) 'isInfluencer': isInfluencer,
      };
}

class CreateListRequest {
  final String title;
  final String categoryId;
  final List<String> items;
  final String createdBy;
  final String? status;

  CreateListRequest({
    required this.title,
    required this.categoryId,
    required this.items,
    required this.createdBy,
    this.status,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'categoryId': categoryId,
        'items': items,
        'createdBy': createdBy,
        if (status != null) 'status': status,
      };
}

class SubmitRankingRequest {
  final String userId;
  final List<String> rankedItemIds;
  final String method;
  final String groupType;
  final Map<String, double>? itemRatings;

  SubmitRankingRequest({
    required this.userId,
    required this.rankedItemIds,
    required this.method,
    required this.groupType,
    this.itemRatings,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'rankedItemIds': rankedItemIds,
        'method': method,
        'groupType': groupType,
        if (itemRatings != null) 'itemRatings': itemRatings,
      };
}

class UserFollow {
  final String id;
  final String followerId;
  final String followingId;
  final String createdAt;

  UserFollow({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.createdAt,
  });

  factory UserFollow.fromJson(Map<String, dynamic> json) => UserFollow(
        id: json['id'] as String,
        followerId: json['followerId'] as String,
        followingId: json['followingId'] as String,
        createdAt: json['createdAt'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'followerId': followerId,
        'followingId': followingId,
        'createdAt': createdAt,
      };
}

class FollowStats {
  final int followersCount;
  final int followingCount;
  final bool? isFollowing;

  FollowStats({
    required this.followersCount,
    required this.followingCount,
    this.isFollowing,
  });

  factory FollowStats.fromJson(Map<String, dynamic> json) => FollowStats(
        followersCount: json['followersCount'] as int,
        followingCount: json['followingCount'] as int,
        isFollowing: json['isFollowing'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'followersCount': followersCount,
        'followingCount': followingCount,
        if (isFollowing != null) 'isFollowing': isFollowing,
      };
}

class CreateFollowRequest {
  final String followerId;

  CreateFollowRequest({
    required this.followerId,
  });

  Map<String, dynamic> toJson() => {
        'followerId': followerId,
      };
}
