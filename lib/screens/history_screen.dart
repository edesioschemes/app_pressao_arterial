import 'package:flutter/material.dart';
import 'package:app_pressao_arterial/models/blood_pressure.dart';
import 'package:app_pressao_arterial/services/storage_service.dart';
import 'package:app_pressao_arterial/utils/date_formatter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storage = StorageService();
  late Future<List<BloodPressure>> _measurementsFuture;

  @override
  void initState() {
    super.initState();
    _measurementsFuture = _loadMeasurements();
  }

  Future<List<BloodPressure>> _loadMeasurements() async {
    await _storage.init(); // garantir que o storage está iniciado
    return _storage.getAllMeasurements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histórico")),
      body: FutureBuilder<List<BloodPressure>>(
        future: _measurementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma leitura registrada."));
          }

          final measurements = snapshot.data!;

          return ListView.builder(
            itemCount: measurements.length,
            itemBuilder: (context, index) {
              final item = measurements[index];
              return ListTile(
                title: Text(
                  "${item.systolic}/${item.diastolic} mmHg",
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  "${formatDate(item.date)} • FC: ${item.heartRate} bpm",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _storage.deleteMeasurementAt(index);
                    setState(() {
                      _measurementsFuture = _loadMeasurements();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}