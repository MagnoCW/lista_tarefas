import 'package:flutter/material.dart';

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

  List<String> lista = ['Escovar Dentes', 'Tomar Café', 'Almoçar', 'Jantar', 'Dormir'];

  // Botão de checagem
  late List<bool> checkedItems;

  @override
  void initState() {
    super.initState();
    checkedItems = List.generate(lista.length, (_) => false);
  }

  void _toggleCheck(int i) {
    setState(() {
      checkedItems[i] = !checkedItems[i];
    });
  }

  void _deleteTarefa (int i) {
    setState(() {
      lista.removeAt(i);
      checkedItems.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < lista.length; i++) ...[
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon( checkedItems[i] ? Icons.check_box : Icons.check_box_outline_blank), 
                  onPressed: () {
                    _toggleCheck(i);
                  }, 
                ),
                Text(
                  lista[i]
                ),
                IconButton(
                  onPressed: () {
                    _deleteTarefa(i);
                  }, 
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                )
              ],
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}