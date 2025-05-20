import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ItemList(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated ListView',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AnimatedListScreen(),
    );
  }
}

class ItemList extends ChangeNotifier {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  void addItem(String item) {
    _items.insert(0, item);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );
  }

  void removeItem(int index) {
    final removedItem = _items.removeAt(index);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: _buildItem(removedItem),
      ),
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildItem(String item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(title: Text(item)),
    );
  }
}

class AnimatedListScreen extends StatefulWidget {
  const AnimatedListScreen({Key? key}) : super(key: key);

  @override
  _AnimatedListScreenState createState() => _AnimatedListScreenState();
}

class _AnimatedListScreenState extends State<AnimatedListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemList>();

    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedList com Provider')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(labelText: 'Novo item'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isEmpty) return;
                      provider.addItem(text);
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedList(
                key: provider.listKey,
                initialItemCount: provider.items.length,
                itemBuilder: (context, index, animation) {
                  final item = provider.items[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(item),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => provider.removeItem(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
