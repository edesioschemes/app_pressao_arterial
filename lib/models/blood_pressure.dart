import 'package:hive/hive.dart';

part 'blood_pressure.g.dart'; // este arquivo será gerado automaticamente
@HiveType(typeId: 0)
class BloodPressure {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int systolic;

  @HiveField(2)
  final int diastolic;

  @HiveField(3)
  final int heartRate;

  BloodPressure({
    required this.date,
    required this.systolic,
    required this.diastolic,
    this.heartRate = 0,
  });

  // Para salvar no storage (conversão para Map)
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'systolic': systolic,
      'diastolic': diastolic,
      'heartRate': heartRate,
    };
  }

  // Para reconstruir a partir do Map
  static BloodPressure fromMap(Map<String, dynamic> map) {
    return BloodPressure(
      date: DateTime.parse(map['date']),
      systolic: map['systolic'],
      diastolic: map['diastolic'],
      heartRate: map['heartRate'],
    );
  }
}