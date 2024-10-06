import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_app/post.dart';


class UpdatePage extends StatefulWidget{
 const UpdatePage(this.post, {super.key});

 final Post post;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
 String updatedWord = "";

  Future _updateFirebaseData() async {
    await FirebaseFirestore.instance.collection("posts").doc(widget.post.id).update(
        {
          "name": "John",
          "text": updatedWord,
          "updatedAt": DateTime.now(),
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update"),),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                  initialValue: widget.post.text,//StatefulWidgetのこと。初期値をとる
                  maxLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)
                          ))
                  ),
                  onChanged: (value) {
                    print(value);
                    updatedWord = value;
                    setState(() {

                    });
                  }),
              ElevatedButton(
                  onPressed: updatedWord.isEmpty ? null : (){//からだったら押せない
                    // Firebaseに値を追加
                    _updateFirebaseData();
                    Navigator.pop(context);//前の画面に戻る
                  },
                  child: const Text("更新"))
            ],
          ),
        )
    );
  }
}