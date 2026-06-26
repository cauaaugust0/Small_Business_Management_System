import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'tela_menu.dart';
import 'db_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BancoDeDados.instance.init();

  try {
    await BancoDeDados.instance.init();
    print('BANCO INICIADO');
  } catch (e, stack) {
    print('ERRO AO INICIAR DB: $e');
    print(stack);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Menu Inicial',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          ),
          home: const TelaMenu(title: 'Menu Inicial'),
      );
    }
}
