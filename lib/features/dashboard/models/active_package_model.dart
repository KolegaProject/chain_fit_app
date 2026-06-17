import 'package:intl/intl.dart';

class ActivePackageModel {
  final int id;
  final int gymId;
  final String packageName;
  final String gymName;
  final DateTime endDate;
  final String status;

  ActivePackageModel({
    required this.id,
    required this.gymId,
    required this.packageName,
    required this.gymName,
    required this.endDate,
    required this.status,
  });

  factory ActivePackageModel.fromJson(Map<String, dynamic> json) {
    final packageData = json['package'] ?? {};
    final gymData = json['gym'] ?? {};

    return ActivePackageModel(
      id: json['id'] ?? 0,
      gymId: int.tryParse(gymData['id']?.toString() ?? '') ?? 0,
      packageName: packageData['name'] ?? 'Unknown Package',
      gymName: gymData['name'] ?? 'Unknown Gym',
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : DateTime.now(),
      status: json['status'] ?? 'INACTIVE',
    );
  }

  String get formattedExpiryDate {
    return DateFormat('d MMM yyyy').format(endDate);
  }
}