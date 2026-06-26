import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'db_logic.dart';
import 'utils.dart';
import 'tela_menu.dart';
import 'tela_editar_empresas.dart';

class TelaEmpresas extends StatefulWidget {
  const TelaEmpresas({super.key});

  @override
  State<TelaEmpresas> createState() => _TelaEmpresasState();
}

class _TelaEmpresasState extends State<TelaEmpresas> {
  final db = BancoDeDados.instance;

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Empresas'),
        actions:[
          IconButton(icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TelaEditarEmpresas(),
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

            const Text('CNPJ/CPF'),
            TextField(controller: cpfController),

            const SizedBox(height: 10),

            const Text('Email'),
            TextField(controller: emailController),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                String nome = nomeController.text;
                String ln = limparNome(nome);

                String cpf = cpfController.text;
                String ld = limparDocumento(cpf);

                String email = emailController.text;
                String le = limparEmail(email);

                if (ln.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digite um nome'),
                    ),
                  );
                  return;
                }

                if (ld.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digite um cnpj'),
                    ),
                  );
                  return;
                }

                Empresa emp = Empresa(
                  nome: ln,
                  cnpj: ld,
                  email: le,
                );

                await db.inserirEmpresa(emp.toMap());

                nomeController.clear();
                cpfController.clear();
                emailController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registro salvo'),
                  ),
                );
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
