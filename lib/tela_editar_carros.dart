import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'db_logic.dart';
import 'utils.dart';

class TelaEditarCarros extends StatefulWidget {
  const TelaEditarCarros({super.key});

  @override
  State<TelaEditarCarros> createState() => _TelaEditarCarrosState();
}

class _TelaEditarCarrosState extends State<TelaEditarCarros> {
  final db = BancoDeDados.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Carros"),
      ),
      body: FutureBuilder<List<Carro>>(
        future: db.buscarCarro(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final carros = snapshot.data!;

          if (carros.isEmpty) {
            return const Center(
              child: Text("Nenhum carro cadastrado"),
            );
          }

          return ListView.builder(
            itemCount: carros.length,
            itemBuilder: (context, index) {
              final carro = carros[index];

              return Card(
                child: ListTile(
                  title: Text(carro.nome),
                  subtitle: Text(
                    "R\$ ${(carro.valor / 100).toStringAsFixed(2)}",
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TelaEditarCarro(
                          carro: carro,
                        ),
                      ),
                    );

                    setState(() {});
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

class TelaEditarCarro extends StatefulWidget {
  final Carro carro;

  const TelaEditarCarro({
    super.key,
    required this.carro,
  });

  @override
  State<TelaEditarCarro> createState() =>
      _TelaEditarCarroState();
}

class _TelaEditarCarroState
    extends State<TelaEditarCarro> {

  final db = BancoDeDados.instance;

  late TextEditingController nomeController;
  late TextEditingController valorController;

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(
      text: widget.carro.nome,
    );

    valorController = TextEditingController(
      text: (widget.carro.valor / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    valorController.dispose();
    super.dispose();
  }

  Future<void> salvar(BuildContext context) async {

    String nome = limparNome(nomeController.text);
    int valor = converterValor(valorController.text);

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite um nome"),
        ),
      );
      return;
    }

    if (valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite um valor"),
        ),
      );
      return;
    }

    Carro carro = Carro(
      id: widget.carro.id,
      nome: nome,
      valor: valor,
    );

    await db.alterarCarro(carro);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Carro alterado com sucesso"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text("Nome"),
            TextField(
              controller: nomeController,
            ),

            const SizedBox(height: 15),

            const Text("Valor"),
            TextField(
              controller: valorController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () => salvar(context),
              child: const Text("Salvar Alterações"),
            ),
          ],
        ),
      ),
    );
  }
}