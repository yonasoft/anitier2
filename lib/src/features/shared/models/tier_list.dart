import 'dart:convert';

import 'package:flutter/foundation.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
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

  TierList({
    this.uuid,
    required this.isTemplate,
    this.isPublic = false,
    required this.title,
    this.description = "",
    this.userId,
    this.tiers = const [],
    this.inventory = const [],
  }) {
    uuid ??= Uuid().v4().toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'isTemplate': isTemplate,
      'isPublic': isPublic,
      'title': title,
      'description': description,
      'userId': userId,
      'tiers': tiers?.map((x) => x.toMap()).toList(),
      'inventory': inventory,
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
      tiers: map['tiers'] != null ? List<Tier>.from(map['tiers']?.map((x) => Tier.fromMap(x))) : null,
      inventory: List<dynamic>.from(map['inventory']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TierList.fromJson(String source) => TierList.fromMap(json.decode(source));

  TierList copyWith({
    ValueGetter<String?>? uuid,
    bool? isTemplate,
    bool? isPublic,
    String? title,
    String? description,
    ValueGetter<String?>? userId,
    ValueGetter<List<Tier>?>? tiers,
    List<dynamic>? inventory,
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
    );
  }

  @override
  String toString() {
    return 'TierList(uuid: $uuid, isTemplate: $isTemplate, isPublic: $isPublic, title: $title, description: $description, userId: $userId, tiers: $tiers, inventory: $inventory)';
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
      listEquals(other.inventory, inventory);
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
      inventory.hashCode;
  }
}
