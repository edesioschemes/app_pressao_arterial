import 'package:flutter/material.dart';
import 'package:app_pressao_arterial/models/blood_pressure.dart';
import 'package:app_pressao_arterial/services/storage_service.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({Key? key}) : super(key: key);

  @override
  _AddMeasurementScreenState createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();

  final StorageService _storage = StorageService();

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  void _saveMeasurement() async {
    final systolic = int.tryParse(_systolicController.text);
    final diastolic = int.tryParse(_diastolicController.text);
    final heartRate = int.tryParse(_heartRateController.text) ?? 0;

    if (systolic == null || diastolic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira valores válidos.")),
      );
      return;
    }

    if (systolic <= 0 || diastolic <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Os valores devem ser maiores que zero.")),
      );
      return;
    }

    final measurement = BloodPressure(
      date: DateTime.now(),
      systolic: systolic,
      diastolic: diastolic,
      heartRate: heartRate,
    );

    await _storage.addMeasurement(measurement);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Leitura salva com sucesso!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Leitura")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _systolicController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Pressão Sistólica (ex: 120)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _diastolicController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Pressão Diastólica (ex: 80)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _heartRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Frequência Cardíaca (opcional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveMeasurement,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}