import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'db_logic.dart';
import 'utils.dart';
import 'tela_menu.dart';
import 'tela_editar_carros.dart';

class TelaCarros extends StatefulWidget {
  const TelaCarros({super.key});

  @override
  State<TelaCarros> createState() => _TelaCarrosState();
}

class _TelaCarrosState extends State<TelaCarros> {
  final db = BancoDeDados.instance;

  final nomeController = TextEditingController();
  final valorController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Carros'),
        actions:[
          IconButton(icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TelaEditarCarros(),
              ),
            );
          },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text('Nome'),
            TextField(controller: nomeController),

            const SizedBox(height: 10),

            const Text('Valor'),
            TextField(controller: valorController),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                String nome = nomeController.text;
                String ln = limparNome(nome);

                String valor = valorController.text;
                if (valor.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Digite um valor'),
                      ),
                    );
                    return;
                }
                int cv = converterValor(valor);
                if(cv <= 0){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digite um valor válido'),
                    ),
                  );
                  return;
                }

                if (ln.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digite um nome'),
                    ),
                  );
                  return;
                }

                Carro car = Carro(
                  nome: ln,
                  valor: cv,
                );

                await db.inserirCarro(car.toMap());

                nomeController.clear();
                valorController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registro salvo'),
                  ),
                );

                print('$ln');
                print('$cv');
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
