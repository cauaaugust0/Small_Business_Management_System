import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'db_logic.dart';
import 'utils.dart';

class TelaEditarEmpresas extends StatefulWidget {
  const TelaEditarEmpresas({super.key});

  @override
  State<TelaEditarEmpresas> createState() =>
      _TelaEditarEmpresasState();
}

class _TelaEditarEmpresasState
    extends State<TelaEditarEmpresas> {

  final db = BancoDeDados.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Empresas"),
      ),
      body: FutureBuilder<List<Empresa>>(
        future: db.buscarEmpresa(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final empresas = snapshot.data!;

          if (empresas.isEmpty) {
            return const Center(
              child: Text("Nenhuma empresa cadastrada"),
            );
          }

          return ListView.builder(
            itemCount: empresas.length,
            itemBuilder: (context, index) {

              final empresa = empresas[index];

              return Card(
                child: ListTile(
                  title: Text(empresa.nome),
                  subtitle: Text(empresa.cnpj),
                  onTap: () async {

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TelaEditarEmpresa(
                          empresa: empresa,
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

class TelaEditarEmpresa extends StatefulWidget {
  final Empresa empresa;

  const TelaEditarEmpresa({
    super.key,
    required this.empresa,
  });

  @override
  State<TelaEditarEmpresa> createState() =>
      _TelaEditarEmpresaState();
}

class _TelaEditarEmpresaState
    extends State<TelaEditarEmpresa> {

  final db = BancoDeDados.instance;

  late TextEditingController nomeController;
  late TextEditingController cnpjController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(
      text: widget.empresa.nome,
    );

    cnpjController = TextEditingController(
      text: widget.empresa.cnpj,
    );

    emailController = TextEditingController(
      text: widget.empresa.email,
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    cnpjController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> salvar(BuildContext context) async {

    String nome = limparNome(nomeController.text);
    String cnpj = limparDocumento(cnpjController.text);
    String email = limparEmail(emailController.text);

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite um nome"),
        ),
      );
      return;
    }

    if (cnpj.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite um CNPJ"),
        ),
      );
      return;
    }

    Empresa empresa = Empresa(
      id: widget.empresa.id,
      nome: nome,
      cnpj: cnpj,
      email: email,
    );

    await db.alterarEmpresa(empresa);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Empresa alterada com sucesso"),
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

            const Text("CNPJ"),
            TextField(
              controller: cnpjController,
            ),

            const SizedBox(height: 15),

            const Text("Email"),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
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