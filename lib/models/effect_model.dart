import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Matches one card on the Home screen, e.g. "Evening Chill".
class EffectModel {
  final String id;
  final String name;        // "Evening Chill"
  final String effectType;  // "Breathe"
  final List<int> colors;   // stored as ARGB ints
  final List<String> zones; // ["Front Yard", "Back Yard", "Roofline"]
  final String upTime;      // "5:30 PM"
  final String offTime;     // "6:30 AM"
  final bool isOn;
  final bool isFavorite;
  final DateTime? lastUsedAt;

  EffectModel({
    required this.id,
    required this.name,
    required this.effectType,
    required this.colors,
    required this.zones,
    required this.upTime,
    required this.offTime,
    required this.isOn,
    required this.isFavorite,
    this.lastUsedAt,
  });

  List<Color> get colorSwatches => colors.map((c) => Color(c)).toList();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'effectType': effectType,
      'colors': colors,
      'zones': zones,
      'upTime': upTime,
      'offTime': offTime,
      'isOn': isOn,
      'isFavorite': isFavorite,
      'lastUsedAt': lastUsedAt != null ? Timestamp.fromDate(lastUsedAt!) : null,
    };
  }

  factory EffectModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return EffectModel(
      id: doc.id,
      name: data['name'] ?? '',
      effectType: data['effectType'] ?? '',
      colors: List<int>.from(data['colors'] ?? []),
      zones: List<String>.from(data['zones'] ?? []),
      upTime: data['upTime'] ?? '',
      offTime: data['offTime'] ?? '',
      isOn: data['isOn'] ?? false,
      isFavorite: data['isFavorite'] ?? false,
      lastUsedAt: (data['lastUsedAt'] as Timestamp?)?.toDate(),
    );
  }
}
