import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget{
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}




class _AddPageState extends State<AddPage> {
  String newWord = "";//変数を作る

  Future _addFirebaseData() async {
    await FirebaseFirestore.instance.collection("posts").add(
        {
          "name": "John",
          "text": newWord,
          "createdAt": DateTime.now(),
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)
                  ))
              ),
              onChanged: (value) {
                print(value);
                newWord = value;
              }),
            ElevatedButton(
                onPressed: (){
              // Firebaseに値を追加
                  _addFirebaseData();
                  Navigator.pop(context);//前の画面に戻る
            },
                child: const Text("追加"))
          ],
        ),
      )
    );
  }
}