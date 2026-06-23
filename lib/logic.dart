import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class BancoDeDados {
	static final BancoDeDados instance = BancoDeDados._init();

	BancoDeDados._init();

	static Database? _db;

	Future<void> init() async {
	_db ??= await initDB();
	}

	Future<Database> get db async {
		_db ??= await initDB();
		return _db!;
	}

	Future<Database> initDB() async {
		final path = join(
			await getDatabasesPath(),
			'aplicativo.db',
		);

		return await openDatabase(
			path,
			version: 1,
			onCreate: (db, version) async {

			await db.execute('''
			CREATE TABLE empresa (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				nome TEXT,
				cnpj TEXT,
				email TEXT
			)
			''');

			await db.execute('''
			CREATE TABLE carro (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				nome TEXT,
				valor INTEGER
			)
			''');

			await db.execute('''
			CREATE TABLE servicoadicional (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				nome TEXT,
				valor INTEGER
			)
			''');

			await db.execute('''
			CREATE TABLE historico (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				empresaid INTEGER,
				placa TEXT,
				carroid INTEGER,
				data INTEGER,
				descricao TEXT,
				total INTEGER
			)
			''');           

			await db.execute('''
			CREATE TABLE historicoservico(
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			historicoid INTEGER,
			servicoid INTEGER
			)
			''');

			},
		);
  }

  Future<void> inserirEmpresa(Map<String, dynamic> dados) async {
    final db = await this.db;
    await db.insert('empresa', dados);
  }

	Future<void> inserirCarro(Map<String, dynamic> dados) async {
		final db = await this.db;
		await db.insert('carro', dados);
	}

	Future<void> inserirServicoAdicional(Map<String, dynamic> dados) async {
		final db = await this.db;
		await db.insert('servicoadicional', dados);
	}

	Future<int> inserirRegistro(Map<String, dynamic> dados) async{
		final db = await this.db;
		return await db.insert('historico', dados);
	}

	Future<void> inserirHistoricoServico(Map<String, dynamic> dados) async{
		final db = await this.db;
		await db.insert('historicoservico', dados);
	}

	Future<List<Empresa>> buscarEmpresa() async {
	final db = await this.db;
	final List<Map<String, dynamic>> maps =
		await db.query('empresa', orderBy: 'nome DESC');

		return List.generate(maps.length, (i) {
			return Empresa(
			id: maps[i]['id'],
			nome: maps[i]['nome'],
			cnpj: maps[i]['cnpj'],
			email: maps[i]['email'],
			);
		});
	}

	Future<List<Carro>> buscarCarro() async {
	final db = await this.db;
	final List<Map<String, dynamic>> maps =
		await db.query('carro', orderBy: 'nome DESC');

		return List.generate(maps.length, (i) {
			return Carro(
			id: maps[i]['id'],
			nome: maps[i]['nome'],
			valor: maps[i]['valor'],
			);
		});
	}

	Future<List<ServicoAdicional>> buscarServicoAdicional() async {
	final db = await this.db;
	final List<Map<String, dynamic>> maps =
		await db.query('servicoadicional', orderBy: 'nome DESC');

		return List.generate(maps.length, (i) {
			return ServicoAdicional(
			id: maps[i]['id'],
			nome: maps[i]['nome'],
			valor: maps[i]['valor'],
			);
		});
	}

	Future<List<Historico>> buscarHistorico() async {
	final db = await this.db;
	final List<Map<String, dynamic>> maps =
		await db.query('historico', orderBy: 'data DESC');

		return List.generate(maps.length, (i) {
			return Historico(
			id: maps[i]['id'],
			empresaid: maps[i]['empresaid'],
			placa: maps[i]['placa'],
			carroid: maps[i]['carroid'],
			data: maps[i]['data'],
			descricao: maps[i]['descricao'],
			total: maps[i]['total'],
			);
		});
	}

	Future<List<Historico_Servico>> buscarHistoricoServico() async {
		final db = await this.db;
		final List<Map<String, dynamic>> maps =
			await db.query('historicoservico', orderBy: 'id DESC');

			return List.generate(maps.length, (i){
				return Historico_Servico (
				id: maps[i]['id'],
				historicoid: maps[i]['historicoid'],
				servicoid: maps[i]['servicoid'],
				);
			});
	}

	Future<String> buscarNomeEmpresa(int empresaId) async {
	final db = await this.db;

	final resultado = await db.query(
		'empresa',
		where: 'id = ?',
		whereArgs: [empresaId],
	);

	if (resultado.isEmpty) {
		return 'Empresa não encontrada';
	}

	return resultado.first['nome'] as String;
}
}

class Empresa{
	int? id;
	String nome;
	String cnpj;
	String email;

	Empresa({this.id, required this.nome, required this.cnpj, required this.email});

	Map<String, dynamic>toMap(){
		return{'id': id, 'nome': nome, 'cnpj': cnpj, 'email': email};
	}
}

class Carro{
	int? id;
	String nome;
	int valor;

	Carro({this.id, required this.nome, required this.valor});
	Map<String, dynamic>toMap(){
		return{'id': id, 'nome': nome, 'valor': valor};
	}

	@override
	bool operator ==(Object other) =>
		identical(this, other) ||
		other is Carro &&
			runtimeType == other.runtimeType &&
			id == other.id;

	@override
	int get hashCode => id.hashCode;
}

class ServicoAdicional{
	int? id;
	String nome;
	int valor;

	ServicoAdicional({this.id, required this.nome, required this.valor});
	Map<String, dynamic>toMap(){
		return{'id': id, 'nome': nome, 'valor': valor};
	}

	@override
	bool operator ==(Object other) =>
		identical(this, other) ||
		other is ServicoAdicional &&
			runtimeType == other.runtimeType &&
			id == other.id;

	@override
	int get hashCode => id.hashCode;
}

class Historico{
	int? id;
	int? empresaid;
	String placa;
	int? carroid;
	int data;
	String descricao;
	int total;

	Historico({this.id, this.empresaid, required this.placa, this.carroid, required this.data, required this.descricao, required this.total});

	Map<String, dynamic>toMap(){
		return{'id': id, 'empresaid': empresaid, 'placa': placa, 'carroid': carroid, 'data': data, 'descricao': descricao, 'total': total};
	}
}

class Historico_Servico{
	int? id;
	int? historicoid;
	int? servicoid;

	Historico_Servico({this.id, this.historicoid, this.servicoid});

	Map<String, dynamic>toMap(){
		return{'id': id, 'historicoid': historicoid, 'servicoid': servicoid};
	}
}