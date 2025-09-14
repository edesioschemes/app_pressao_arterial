import 'package:hive/hive.dart';
import '../models/blood_pressure.dart';

class StorageService {
  static const String boxName = 'blood_pressure';

  Box<BloodPressure> get box => Hive.box<BloodPressure>(boxName);

  Future<void> addMeasurement(BloodPressure measurement) async {
    await box.add(measurement);
  }

  List<BloodPressure> getAllMeasurements() {
    return box.values.toList();
  }

  Future<void> deleteMeasurementAt(int key) async {
    await box.deleteAt(key);
  }
}