import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String title,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    @Default(1) int memberCount,
    String? iconName,
    int? colorValue,
    @Default([]) List<TripActivity> activities,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}

@freezed
class TripActivity with _$TripActivity {
  const factory TripActivity({
    required String id,
    required String time,
    required String title,
    required String subtitle,
    required String iconName,
    Map<String, String>? personalInfo,
    @Default(false) bool isFirst,
    @Default(false) bool isLast,
  }) = _TripActivity;

  factory TripActivity.fromJson(Map<String, dynamic> json) => _$TripActivityFromJson(json);
}
