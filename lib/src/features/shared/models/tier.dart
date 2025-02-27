import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Tier {
  String rank;
  String description;
  Color? color;
  List<dynamic> tierItems;
  List<int> tierItemIds;

  Tier({
    required this.rank,
    this.description = "",
    this.color,
    this.tierItems = const [],
    this.tierItemIds = const [],
  }) {
    color ??= Color.fromRGBO(88, 133, 175, 1);
  }

  Map<String, dynamic> toMap() {
    return {
      'rank': rank,
      'description': description,
      'color': color?.value,
      'tierItems': tierItems,
      'tierItemIds': tierItemIds,
    };
  }

  factory Tier.fromMap(Map<String, dynamic> map) {
    return Tier(
      rank: map['rank'] ?? '',
      description: map['description'] ?? '',
      color: map['color'] != null ? Color(map['color']) : null,
      tierItems: List<dynamic>.from(map['tierItems']),
      tierItemIds: List<int>.from(map['tierItemIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tier.fromJson(String source) => Tier.fromMap(json.decode(source));

  Tier copyWith({
    String? rank,
    String? description,
    ValueGetter<Color?>? color,
    List<dynamic>? tierItems,
    List<int>? tierItemIds,
  }) {
    return Tier(
      rank: rank ?? this.rank,
      description: description ?? this.description,
      color: color != null ? color() : this.color,
      tierItems: tierItems ?? this.tierItems,
      tierItemIds: tierItemIds ?? this.tierItemIds,
    );
  }

  @override
  String toString() {
    return 'Tier(rank: $rank, description: $description, color: $color, tierItems: $tierItems, tierItemIds: $tierItemIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Tier &&
      other.rank == rank &&
      other.description == description &&
      other.color == color &&
      listEquals(other.tierItems, tierItems) &&
      listEquals(other.tierItemIds, tierItemIds);
  }

  @override
  int get hashCode {
    return rank.hashCode ^
      description.hashCode ^
      color.hashCode ^
      tierItems.hashCode ^
      tierItemIds.hashCode;
  }
}
