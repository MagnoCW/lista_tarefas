import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lista de Tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tarefas_nao_concluidas = [];
  List<String> tarefas_concluidas = [];

  final TextEditingController _editingController = TextEditingController();
  String _labelText = 'Digite a nova tarefa';
  String _alertDialogTitle = 'Adicionar Tarefa';
  int? _editingIndex;

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  Future<void> _salvarArquivo(List lista1, List lista2) async {
    Map<String, dynamic> dados = {
      "tarefas_nao_concluidas": lista1,
      "tarefas_concluidas": lista2
    };

    // Converter o mapa para JSON
    String jsonDados = jsonEncode(dados);

    // Salvar o JSON no arquivo
    var arquivo = await _getFile();
    await arquivo.writeAsString(jsonDados);
  }

  Future<void> _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      final dados = await arquivo.readAsString();
      final jsonMap = jsonDecode(dados); // Decodifica o JSON em um mapa

      setState(() {
        tarefas_nao_concluidas =
            List<String>.from(jsonMap['tarefas_nao_concluidas']);
        tarefas_concluidas = List<String>.from(jsonMap['tarefas_concluidas']);
      });
    } catch (e) {
      print("Erro ao ler o arquivo: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo();
  }

  void _changeList(int i, List lista1, List lista2) {
    setState(() {
      lista2.add(lista1[i]);
      lista1.removeAt(i);
    });
    _salvarArquivo(lista1, lista2);
  }

  void _deleteTarefa(int index, List lista1, List lista2) {
    setState(() {
      lista1.removeAt(index);
    });
    _salvarArquivo(lista1, lista2);
  }

  void _reset() {
    _editingController.clear();
    _labelText = 'Digite a nova tarefa';
    _alertDialogTitle = 'Adicionar Tarefa';
    _editingIndex = null;
  }

  void _addTarefa(List lista1, List lista2, String novaTarefa) {
    setState(() {
      if (novaTarefa.isNotEmpty) {
        if (_editingIndex != null) {
          lista1[_editingIndex!] = novaTarefa;
        } else {
          lista1.add(novaTarefa);
        }
      }
    });
    _salvarArquivo(lista1, lista2);
  }

  void _reorderTarefa(newIndex, oldIndex, List lista) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = lista.removeAt(oldIndex);
      lista.insert(newIndex, item);
    });
  }

  void _editTarefa(int index, List lista) {
    setState(() {
      _editingController.text = lista[index];
      _labelText = 'Editando a tarefa';
      _alertDialogTitle = 'Editar Tarefa';
      _editingIndex = index;
    });
  }

  void _mostrarDialogo(BuildContext context, List lista1, List lista2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            _reset();
            return true;
          },
          child: AlertDialog(
            title: Text(_alertDialogTitle),
            content: TextField(
                controller: _editingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: _labelText,
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _addTarefa(lista1, lista2, _editingController.text);
                  _reset();
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
              TextButton(
                onPressed: () {
                  _reset();
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _listas({
    String titulo = 'Tarefas',
    required List lista1,
    required List lista2,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: lista1 == tarefas_concluidas
                    ? const Color(0xFF388E3C)
                    : const Color(0xFFD32F2F))),
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              _reorderTarefa(newIndex, oldIndex, lista1);
            },
            children: [
              for (int index = 0; index < lista1.length; index++)
                Card(
                  key: ValueKey(index),
                  surfaceTintColor:
                      lista1 == tarefas_concluidas ? Colors.green : Colors.red,
                  child: ListTile(
                    title: Text(lista1[index]),
                    leading: IconButton(
                      icon: lista1 == tarefas_concluidas
                          ? const Icon(Icons.check_box)
                          : const Icon(Icons.check_box_outline_blank),
                      onPressed: () {
                        _changeList(index, lista1, lista2);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _editTarefa(index, lista1);
                            _mostrarDialogo(context, lista1, lista2);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteTarefa(index, lista1, lista2);
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(
            fontSize: 24, // Tamanho da fonte
            fontWeight: FontWeight.bold, // Estilo da fonte
            color: Colors.white, // Cor da fonte
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: _listas(
                  titulo: 'Tarefas Não Concluídas',
                  lista1: tarefas_nao_concluidas,
                  lista2: tarefas_concluidas)),
          Expanded(
              child: _listas(
                  titulo: 'Tarefas Concluídas',
                  lista1: tarefas_concluidas,
                  lista2: tarefas_nao_concluidas)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogo(context, tarefas_nao_concluidas, tarefas_concluidas);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
