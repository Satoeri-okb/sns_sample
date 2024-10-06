import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sns_app/update_page.dart';
import 'firebase_options.dart';
import 'next_page.dart';
import 'package:sns_app/post.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SNS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SNS Demo App'),
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
  final String _firebaseData = ""; //変数を作っている。ここにどんどん追加される
  List<Post> posts =[]; //配列の形の変数を作る。ぉちらにすると、＋を押すたびにテキストウィジェットがどんどん増える

  @override
  void initState() {//画面を開いた瞬間にこれが動く
    super.initState();
    _fetchFirebaseData();
  }

 Future _fetchFirebaseData() async { //voidからFutreに変更。
    await FirebaseFirestore.instance
        .collection("posts")
        .orderBy("createdAt")
        .get()
        .then((event) {
          final docs = event.docs;
          setState(() {
            posts = docs.map((doc) {
              final data = doc.data();
              final id = doc.id;
              final text = data['text'];
              final createdAt =data['createdAt'].toDate();
              final updatedAt = data['updatedAt']?.toDate();
              return Post(
                id: id,
                text: text,
                createdAt: createdAt,
                updatedAt: updatedAt,
              );
            },
            ).toList(); //mapは配列を違う形に変換する。postをとりだしたものに変わる
          });
    });
  }

  Future _delete(String id) async {
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 30,
            fontFamily: "ヒラギノ角ゴシック",
            fontWeight: FontWeight.bold,
            color: Color(0xFFffffff),
          )
        ),
      ),
      body: Center(
        child: ListView
          (children: posts
            .map((post) => InkWell(
              onTap: () async {
                  //画面遷移
                  await Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context) =>
                          UpdatePage(post),
                      )
                  );
                  await _fetchFirebaseData();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person,
                    size: 40,
                    color: Colors.purple),
              
                    Text(
                      post.text,
                      style: const TextStyle(
                        fontSize:20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "ヒラギノ角ゴシック",
                        color: Color(0xFF666666),
                    ),
                    ),
                    const Spacer(),//いい感じに間を埋める
                    IconButton(
                        onPressed: () async{
                          //削除
                          await _delete(post.id);
                          await _fetchFirebaseData();
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Color(0xFF666666))
                    ),
                  ],
                ),
              ),
            )).toList(),
        )//
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async{
          //画面遷移
          await Navigator.push(
            context,
            MaterialPageRoute(builder:(context) => const AddPage())
          );
          await _fetchFirebaseData();
        },

        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
