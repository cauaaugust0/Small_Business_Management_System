import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'logic.dart';
import 'utils.dart';
import 'tela_menu.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  final db = BancoDeDados.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
      ),

      body: FutureBuilder<List<Historico>>(
        future: db.buscarHistorico(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!;

          if (lista.isEmpty) {
            return const Center(
              child: Text("Nenhum registro encontrado"),
            );
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {

              final item = lista[index];

              final data = DateTime.fromMillisecondsSinceEpoch(item.data);

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                elevation: 3,
                child: ListTile(
                  title: FutureBuilder<String>(
                  future: db.buscarNomeEmpresa(item.empresaid!),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return const Text('Carregando...');
                    }

                    return Text(snapshot.data!);
                  },
                ),
                  subtitle: Text(item.placa),
                  trailing: Text(
                    "R\$ ${(item.total / 100)}",
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TelaDetalhesHistorico(item: item),
                      ),
                    );
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

class TelaDetalhesHistorico extends StatelessWidget {
  final db = BancoDeDados.instance;
  
  final Historico item;

  TelaDetalhesHistorico({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    final data =
        DateTime.fromMillisecondsSinceEpoch(item.data);

    return Scaffold(

      appBar: AppBar(
        title: 
        FutureBuilder<String>(
          future: db.buscarNomeEmpresa(item.empresaid!),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const Text('Carregando...');
            }

            return Text(snapshot.data!);
          },
        ),
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nome',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              FutureBuilder<String>(
                future: db.buscarNomeEmpresa(item.empresaid!),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Text('Carregando...');
                  }

                  return Text(snapshot.data!);
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Placa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(item.placa),
              const SizedBox(height: 20),

              const Text(
                'total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text("R\$ ${(item.total / 100)}"),
              const SizedBox(height: 20),

              const Text(
                'Descrição',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(item.descricao),
              const SizedBox(height: 20),

              const Text(
                'Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                "${data.day}/${data.month}/${data.year} "
                "${data.hour}:${data.minute}",
              ),

            ],
          ),
        ),
      ),
    );
  }
}