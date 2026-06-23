import 'package:sqflite/sqflite.dart';
import 'package:diacritic/diacritic.dart';
import 'logic.dart';

int calcularTotal(Carro? carroSelecionado, List<ServicoAdicional> saSelecionados){
    int vtotal = 0;
    
    if(carroSelecionado != null){
        vtotal += carroSelecionado!.valor;
    }
    for(final servico in saSelecionados){
        vtotal += servico.valor;
    }

    return vtotal;
}

String limparNome(String texto) {
    texto = removeDiacritics(texto);

    texto = texto.toUpperCase();

    texto = texto.replaceAll(RegExp(r'[^A-Z0-9 ]'), '');

    return texto;
}

String limparPlaca(String texto) {
    texto = removeDiacritics(texto);

    texto = texto.toUpperCase();

    texto = texto.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    return texto.trim();
}

String limparDocumento(String texto) {
    texto = texto.replaceAll(RegExp(r'[^0-9]'), '');

    return texto;
}

int converterValor(String texto) {

    texto = texto.trim();

    texto = texto.replaceAll(RegExp(r'[^0-9,.]'), '');

    texto = texto.replaceAll(',', '.');

    double? valor = double.tryParse(texto);

    if(valor == null){
        return 0;
    }

    return (valor * 100).round();
}

String limparEmail(String email) {

    email = email.trim();

    email = email.toLowerCase();

    return email;
}

String limparDescricao(String descricao){
    descricao = removeDiacritics(descricao);

    return descricao.trim().toUpperCase(); 
}