import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'package:anitier2/src/features/shared/models/tier.dart';

class TierList {
  String? uuid;
  final bool isTemplate;
  bool isPublic;
  String type;
  String title;
  String description;
  String? userId;
  List<Tier>? tiers;
  List<dynamic> inventory;
  int upvotes;
  int downvotes;
  int? totalVotes;

  TierList({
    this.uuid,
    this.isTemplate = false,
    this.isPublic = false,
    this.type = "anime",
    this.title = "",
    this.description = "",
    this.userId,
    this.tiers = const [],
    this.inventory = const [],
    this.upvotes = 0,
    this.downvotes = 0,
    this.totalVotes,
  }) {
    uuid ??= Uuid().v4().toString();
    totalVotes ??= upvotes - downvotes;
  }

  // Convert TierList to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'isTemplate': isTemplate,
      'isPublic': isPublic,
      'type': type,
      'title': title,
      'description': description,
      'userId': userId,
      'tiers': tiers?.map((tier) => tier.toMap()).toList(),
      'inventory': inventory.map((item) {
        if (item is Tier) {
          return item.toMap();
        } else {
          return item; // Fallback for primitive types or serializable objects
        }
      }).toList(),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'totalVotes': totalVotes,
    };
  }

  // Convert a Firestore map back to a TierList
  factory TierList.fromMap(Map<String, dynamic> map) {
    return TierList(
      uuid: map['uuid'] as String?,
      isTemplate: map['isTemplate'] as bool? ?? false,
      isPublic: map['isPublic'] as bool? ?? false,
      type: map['type'] as String,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      userId: map['userId'] as String?,
      tiers: (map['tiers'] as List<dynamic>?)
          ?.map((tierData) =>
              Tier.fromMap(tierData as Map<String, dynamic>) as Tier)
          .toList(),
      inventory: (map['inventory'] as List<dynamic>).map((itemData) {
        // Adjust casting or parsing logic based on the type of T
        return Tier.fromMap(itemData as Map<String, dynamic>);
      }).toList(),
      upvotes: map['upvotes'] as int? ?? 0,
      downvotes: map['downvotes'] as int? ?? 0,
      totalVotes: map['totalVotes'] as int?,
    );
  }

  @override
  String toString() {
    return 'TierList(uuid: $uuid, isTemplate: $isTemplate, isPublic: $isPublic, type: $type, title: $title, description: $description, userId: $userId, tiers: $tiers, inventory: $inventory, upvotes: $upvotes, downvotes: $downvotes, totalVotes: $totalVotes)';
  }

  TierList copyWith({
    ValueGetter<String?>? uuid,
    bool? isTemplate,
    bool? isPublic,
    String? type,
    String? title,
    String? description,
    ValueGetter<String?>? userId,
    ValueGetter<List<Tier>?>? tiers,
    List<dynamic>? inventory,
    int? upvotes,
    int? downvotes,
    ValueGetter<int?>? totalVotes,
  }) {
    return TierList(
      uuid: uuid != null ? uuid() : this.uuid,
      isTemplate: isTemplate ?? this.isTemplate,
      isPublic: isPublic ?? this.isPublic,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId != null ? userId() : this.userId,
      tiers: tiers != null ? tiers() : this.tiers,
      inventory: inventory ?? this.inventory,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      totalVotes: totalVotes != null ? totalVotes() : this.totalVotes,
    );
  }
}
