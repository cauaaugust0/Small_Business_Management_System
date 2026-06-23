import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'logic.dart';
import 'utils.dart';
import 'tela_menu.dart';
import 'tela_historico.dart';
import 'tela_empresas.dart';
import 'tela_carros.dart';
import 'tela_servicosadicionais.dart';


class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key, required this.title});

  final String title;

  @override
  State<TelaMenu> createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  final db = BancoDeDados.instance;

  List<Empresa> empresas = [];
  final placaController = TextEditingController();
  final descricaoController = TextEditingController();
  List<Carro> carros = [];
  List<ServicoAdicional> servicos = [];

  Empresa? empresaSelecionada;
  Carro? carroSelecionado;
  List<ServicoAdicional> saSelecionados = [];

  int vtotal = 0;

  @override
  void dispose() {
    placaController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  Future<void> carregarDados() async {

    empresas = await db.buscarEmpresa();

    carros = await db.buscarCarro();

    servicos = await db.buscarServicoAdicional();

    setState(() {
      carroSelecionado = null;
      saSelecionados.clear();
      empresaSelecionada = null;
    });
  }

  @override
  void initState() {
    super.initState();

    carregarDados();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Cadastrar Empresas'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaEmpresas(),
                  ),
                );
                await carregarDados();
              },
            ),

            ListTile(
              leading: const Icon(Icons.car_rental),
              title: const Text('Cadastrar Carro'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaCarros(),
                  ),
                );
                await carregarDados();
              },
            ),

            ListTile(
              leading: const Icon(Icons.miscellaneous_services),
              title: const Text('Cadastrar Outros Serviços'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const TelaServicosAdicionais(),
                  ),
                );
                await carregarDados();
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historico'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const TelaHistorico(),
                  ),
                );
              },
            ),            
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<Empresa>(
                value: empresaSelecionada,
                hint: const Text('Selecione uma empresa'),
                isExpanded: true,
                items: empresas.map((empresa) {
                  return DropdownMenuItem<Empresa>(
                    value: empresa,
                    child: Text(
                      empresa.nome,
                    ),
                  );
                }).toList(),
                onChanged: (Empresa? novaEmpresa) {

                  setState(() {
                    empresaSelecionada = novaEmpresa;
                  });
                },
              ),   

              const Text('Placa'),
              TextField(controller: placaController),
              const SizedBox(height: 10),

              const Text('Carro'),
              DropdownButton<Carro>(
                value: carroSelecionado,
                hint: const Text('Selecione um carro'),
                isExpanded: true,
                items: carros.map((carro) {
                  return DropdownMenuItem<Carro>(
                    value: carro,
                    child: Text(
                      "${carro.nome} | ${(carro.valor / 100).toStringAsFixed(2)}",
                    ),
                  );
                }).toList(),
                onChanged: (Carro? novoCarro) {

                  setState(() {
                    carroSelecionado = novoCarro;
                    vtotal = calcularTotal(carroSelecionado, saSelecionados);
                  });
                },
              ),          

              Column(
                children: servicos.map((servico) {
                  return CheckboxListTile(
                    title: Text("${servico.nome} | ${(servico.valor / 100).toStringAsFixed(2)}"),
                    value: saSelecionados.contains(servico),
                    onChanged: (bool? marcado) {
                      setState(() {
                        if (marcado == true) {
                          if(!saSelecionados.contains(servico)){
                            saSelecionados.add(servico);
                          }
                        } else {
                          saSelecionados.remove(servico);
                        }
                        vtotal = calcularTotal(carroSelecionado, saSelecionados);
                      });
                    },
                  );
                }).toList(),
              ),

              const Text('Descrição'),
              TextField(controller: descricaoController),
              const SizedBox(height: 20),

              Text(
                "Total: R\$ ${(vtotal / 100).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  String placa = placaController.text.trim().toUpperCase();
                  String lp = limparPlaca(placa);
                  
                  int dataehora = DateTime.now().millisecondsSinceEpoch;
                  
                  String descricao = descricaoController.text;
                  String ld = limparDescricao(descricao);

                  if (empresaSelecionada == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selecione uma empresa'),
                      ),
                    );
                    return;
                  }

                  if (lp.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Digite a placa'),
                      ),
                    );
                    return;
                  }

                  if (carroSelecionado == null &&
                      saSelecionados.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Selecione um carro ou serviço',
                        ),
                      ),
                    );
                    return;
                  }

                  int? carroId = carroSelecionado?.id;
                  int? empresaId = empresaSelecionada?.id;

                  Historico his = Historico(
                    empresaid: empresaId,
                    placa: lp,
                    carroid: carroId,
                    data: dataehora,
                    descricao: ld,
                    total: vtotal,
                  );

                  int historicoId = await db.inserirRegistro(his.toMap());
                  
                  for (final servico in saSelecionados) {
                    Historico_Servico hs = Historico_Servico(
                      historicoid: historicoId,
                      servicoid: servico.id,
                    );

                    await db.inserirHistoricoServico(
                      hs.toMap(),
                    );
                  }

                  placaController.clear();
                  descricaoController.clear();
                  setState(() {
                    empresaSelecionada = null;
                    carroSelecionado = null;
                    saSelecionados.clear();
                    vtotal = 0;
                  });

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
      ),
    );
  }
}