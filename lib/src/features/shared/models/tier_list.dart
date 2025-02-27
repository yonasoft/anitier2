import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:anitier2/src/features/shared/models/tier.dart';

class TierList {
  String? uuid;
  final bool isTemplate;
  bool isPublic;
  String title;
  String description;
  String? userId;
  List<Tier>? tiers;
  List<dynamic> inventory;
  int upvotes;
  int downvotes;
  int? totalVotes;

  TierList(
      {this.uuid,
      this.isTemplate = false,
      this.isPublic = false,
      this.title = "",
      this.description = "",
      this.userId,
      this.tiers = const [],
      this.inventory = const [],
      this.upvotes = 0,
      this.downvotes = 0,
      this.totalVotes}) {
    uuid ??= Uuid().v4().toString();
    totalVotes ??= upvotes - downvotes;
  }

  TierList copyWith({
    ValueGetter<String?>? uuid,
    bool? isTemplate,
    bool? isPublic,
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

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'isTemplate': isTemplate,
      'isPublic': isPublic,
      'title': title,
      'description': description,
      'userId': userId,
      'tiers': tiers?.map((x) => x?.toMap())?.toList(),
      'inventory': inventory,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'totalVotes': totalVotes,
    };
  }

  factory TierList.fromMap(Map<String, dynamic> map) {
    return TierList(
      uuid: map['uuid'],
      isTemplate: map['isTemplate'] ?? false,
      isPublic: map['isPublic'] ?? false,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'],
      tiers: map['tiers'] != null
          ? List<Tier>.from(map['tiers']?.map((x) => Tier.fromMap(x)))
          : null,
      inventory: List<dynamic>.from(map['inventory']),
      upvotes: map['upvotes']?.toInt() ?? 0,
      downvotes: map['downvotes']?.toInt() ?? 0,
      totalVotes: map['totalVotes']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TierList.fromJson(String source) =>
      TierList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TierList(uuid: $uuid, isTemplate: $isTemplate, isPublic: $isPublic, title: $title, description: $description, userId: $userId, tiers: $tiers, inventory: $inventory, upvotes: $upvotes, downvotes: $downvotes, totalVotes: $totalVotes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TierList &&
        other.uuid == uuid &&
        other.isTemplate == isTemplate &&
        other.isPublic == isPublic &&
        other.title == title &&
        other.description == description &&
        other.userId == userId &&
        listEquals(other.tiers, tiers) &&
        listEquals(other.inventory, inventory) &&
        other.upvotes == upvotes &&
        other.downvotes == downvotes &&
        other.totalVotes == totalVotes;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        isTemplate.hashCode ^
        isPublic.hashCode ^
        title.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        tiers.hashCode ^
        inventory.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        totalVotes.hashCode;
  }
}
