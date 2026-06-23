import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'logic.dart';
import 'utils.dart';
import 'tela_menu.dart';

class TelaServicosAdicionais extends StatefulWidget {
  const TelaServicosAdicionais({super.key});

  @override
  State<TelaServicosAdicionais> createState() => _TelaServicosAdicionaisState();
}

class _TelaServicosAdicionaisState extends State<TelaServicosAdicionais> {
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
        title: const Text('Cadastrar Outros Serviços'),
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

                ServicoAdicional sa = ServicoAdicional(
                  nome: ln,
                  valor: cv,
                );

                await db.inserirServicoAdicional(sa.toMap());

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