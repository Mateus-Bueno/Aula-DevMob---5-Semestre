import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Produto {
  final int id;
  final String nome;
  final String emoji;
  final String descricao;
  final double preco;

  Produto({
    required this.id,
    required this.nome,
    required this.emoji,
    required this.descricao,
    required this.preco,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      emoji: json['emoji'],
      descricao: json['descricao'],
      preco: (json['preco'] as num).toDouble(),
    );
  }
}

class CarrinhoModel extends ChangeNotifier {
  final List<Produto> _itens = [];

  List<Produto> get itens => _itens;

  void adicionar(Produto produto) {
    _itens.add(produto);
    notifyListeners();
  }

  void finalizarCompra() {
    _itens.clear();
    notifyListeners();
  }

  double get total => _itens.fold(0, (total, item) => total + item.preco);
}

const String produtosJson = '''
{
 "produtos_halloween": [
 {
 "id": 1,
 "nome": "Abóbora Decorativa Luminosa",
 "emoji": "🎃",
 "descricao": "Abóbora artificial com luz LED interna, perfeita para decorar ambientes internos e externos durante o Halloween",
 "preco": 45.90
 },
 {
 "id": 2,
 "nome": "Fantasia de Fantasma Clássico",
 "emoji": "👻",
 "descricao": "Roupa completa de fantasma com tecido branco flutuante e máscara assombrada",
 "preco": 35.50
 },
 {
 "id": 3,
 "nome": "Kit Bruxa Completo",
 "emoji": "🧙‍♀️",
 "descricao": "Conjunto com chapéu pontudo, capa preta, varinha mágica e caldeirão decorativo",
 "preco": 89.90
 },
 {
 "id": 4,
 "nome": "Capa de Vampiro Premium",
 "emoji": "🧛‍♂️",
 "descricao": "Capa elegante preta com forro vermelho, inclui dentes de vampiro e medalhão gótico",
 "preco": 125.00
 },
 {
 "id": 5,
 "nome": "Morcegos Decorativos 3D",
 "emoji": "🦇",
 "descricao": "Pack com 12 morcegos de papel 3D para colar na parede e criar ambiente assombrado",
 "preco": 22.90
 },
 {
 "id": 6,
 "nome": "Teia de Aranha Gigante",
 "emoji": "🕸️",
 "descricao": "Teia artificial extensível de até 2 metros, inclui aranha peluda realística",
 "preco": 38.50
 },
 {
 "id": 7,
 "nome": "Caveira Luminosa com Sons",
 "emoji": "💀",
 "descricao": "Caveira decorativa com efeitos sonoros assombrados e iluminação que pisca",
 "preco": 65.90
 },
 {
 "id": 8,
 "nome": "Poção Mágica Borbulhante",
 "emoji": "🧪",
 "descricao": "Kit para criar poções com efeito borbulhante e fumaça colorida, seguro para crianças",
 "preco": 42.00
 },
 {
 "id": 9,
 "nome": "Bola de Cristal Mística",
 "emoji": "🔮",
 "descricao": "Bola de cristal com base ornamentada e luz LED que cria efeitos místicos",
 "preco": 78.90
 },
 {
 "id": 10,
 "nome": "Velas Flutuantes Mágicas",
 "emoji": "🕯️",
 "descricao": "Conjunto de velas LED flutuantes com controle remoto para criar atmosfera mágica",
 "preco": 95.50
 },
 {
 "id": 11,
 "nome": "Kit Zumbi Apocalipse",
 "emoji": "🧟‍♂️",
 "descricao": "Fantasia completa de zumbi com roupas rasgadas, maquiagem e sangue artificial",
 "preco": 115.90
 },
 {
 "id": 12,
 "nome": "Máscara Assombrada Interativa",
 "emoji": "🎭",
 "descricao": "Máscara com sensores de movimento que emite sons e acende os olhos quando alguém se aproxima",
 "preco": 87.50
 },
 {
 "id": 13,
 "nome": "Caldeirão de Doces Animado",
 "emoji": "🍬",
 "descricao": "Caldeirão decorativo que faz barulhos assombrados quando crianças pegam doces",
 "preco": 58.90
 },
 {
 "id": 14,
 "nome": "Aranha Robótica Gigante",
 "emoji": "🕷️",
 "descricao": "Aranha motorizada de 30cm que se move sozinha e emite sons realísticos",
 "preco": 145.00
 },
 {
 "id": 15,
 "nome": "Lápide Decorativa Personalizada",
 "emoji": "⚰️",
 "descricao": "Lápide de jardim personalizável com frases assombradas e acabamento envelhecido",
 "preco": 72.50
 }
 ]
}
''';

final List<Produto> produtos =
    (jsonDecode(produtosJson)['produtos_halloween'] as List)
        .map((value) => Produto.fromJson(value))
        .toList();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarrinhoModel(),
      child: MaterialApp(
        title: 'Mercado Halloween Cabuloso',
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mercado Halloween Cabuloso"),
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.shopping_cart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return ListTile(
                leading: Text(
                  produto.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(produto.nome),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalhesPage(produto: produto),
                    ),
                  );
                },
              );
            },
          ),
          const CarrinhoPage(),
        ],
      ),
    );
  }
}

class DetalhesPage extends StatelessWidget {
  final Produto produto;

  const DetalhesPage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(produto.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 10),
            Text(produto.descricao),
            const SizedBox(height: 10),
            Text("Preço: R\$${produto.preco.toStringAsFixed(2)}"),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Provider.of<CarrinhoModel>(
                  context,
                  listen: false,
                ).adicionar(produto);
                Navigator.pop(context);
              },
              child: const Text("Adicionar ao carrinho"),
            ),
          ],
        ),
      ),
    );
  }
}

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarrinhoModel>(
      builder: (context, carrinho, child) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: carrinho.itens.length,
                itemBuilder: (context, index) {
                  final produto = carrinho.itens[index];
                  return ListTile(
                    title: Text(produto.nome),
                    trailing: Text("R\$${produto.preco.toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Total: R\$${carrinho.total.toStringAsFixed(2)}"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      carrinho.finalizarCompra();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Compra realizada com sucesso!"),
                        ),
                      );
                    },
                    child: const Text("Finalizar Compra"),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
