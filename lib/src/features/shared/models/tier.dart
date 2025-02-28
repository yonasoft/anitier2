import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Tier {
  String rank;
  String description;
  Color? color;
  List<dynamic> tierItems;

  Tier({
    required this.rank,
    this.description = "",
    this.color,
    this.tierItems = const [],
  });

  // Convert Tier to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'rank': rank,
      'description': description,
      'color': color?.value,
      'tierItems': tierItems,
    };
  }

  // Convert a Firestore map back to a Tier
  factory Tier.fromMap(Map<String, dynamic> map) {
    return Tier(
      rank: map['rank'] ?? '',
      description: map['description'] ?? '',
      color: map['color'] != null ? Color(map['color']) : null,
      tierItems: List<dynamic>.from(map['tierItems']),
    );
  }

  @override
  String toString() {
    return 'Tier(rank: $rank, description: $description, color: $color, tierItems: $tierItems)';
  }

  Tier copyWith({
    String? rank,
    String? description,
    ValueGetter<Color?>? color,
    List<dynamic>? tierItems,
  }) {
    return Tier(
      rank: rank ?? this.rank,
      description: description ?? this.description,
      color: color != null ? color() : this.color,
      tierItems: tierItems ?? this.tierItems,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tier.fromJson(String source) => Tier.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Tier &&
      other.rank == rank &&
      other.description == description &&
      other.color == color &&
      listEquals(other.tierItems, tierItems);
  }

  @override
  int get hashCode {
    return rank.hashCode ^
      description.hashCode ^
      color.hashCode ^
      tierItems.hashCode;
  }
}
