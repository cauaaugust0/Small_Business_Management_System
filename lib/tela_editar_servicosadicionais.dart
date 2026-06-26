import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'db_logic.dart';
import 'utils.dart';

class TelaEditarServicosAdicionais extends StatefulWidget {
  const TelaEditarServicosAdicionais({super.key});

  @override
  State<TelaEditarServicosAdicionais> createState() =>
      _TelaEditarServicosAdicionaisState();
}

class _TelaEditarServicosAdicionaisState
    extends State<TelaEditarServicosAdicionais> {

  final db = BancoDeDados.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Serviços"),
      ),
      body: FutureBuilder<List<ServicoAdicional>>(
        future: db.buscarServicoAdicional(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final servicos = snapshot.data!;

          if (servicos.isEmpty) {
            return const Center(
              child: Text("Nenhum serviço cadastrado"),
            );
          }

          return ListView.builder(
            itemCount: servicos.length,
            itemBuilder: (context, index) {

              final servico = servicos[index];

              return Card(
                child: ListTile(
                  title: Text(servico.nome),
                  subtitle: Text(
                    "R\$ ${(servico.valor / 100).toStringAsFixed(2)}",
                  ),
                  onTap: () async {

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TelaEditarServicoAdicional(
                          servico: servico,
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

class TelaEditarServicoAdicional extends StatefulWidget {
  final ServicoAdicional servico;

  const TelaEditarServicoAdicional({
    super.key,
    required this.servico,
  });

  @override
  State<TelaEditarServicoAdicional> createState() =>
      _TelaEditarServicoAdicionalState();
}

class _TelaEditarServicoAdicionalState
    extends State<TelaEditarServicoAdicional> {

  final db = BancoDeDados.instance;

  late TextEditingController nomeController;
  late TextEditingController valorController;

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(
      text: widget.servico.nome,
    );

    valorController = TextEditingController(
      text: (widget.servico.valor / 100).toStringAsFixed(2),
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
          content: Text("Digite um valor válido"),
        ),
      );
      return;
    }

    ServicoAdicional servico = ServicoAdicional(
      id: widget.servico.id,
      nome: nome,
      valor: valor,
    );

    await db.alterarServicoAdicional(servico);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Serviço alterado com sucesso"),
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