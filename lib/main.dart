import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // ✅ Importe aqui
import 'package:app_pressao_arterial/screens/home_screen.dart';
import 'models/blood_pressure.dart'; // ✅ Importe o modelo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive
  await Hive.initFlutter();

  // Registra o adapter gerado
  Hive.registerAdapter(BloodPressureAdapter());

  // Abre a caixa (box) onde vamos salvar as leituras
  await Hive.openBox<BloodPressure>('blood_pressure');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pressão Arterial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}