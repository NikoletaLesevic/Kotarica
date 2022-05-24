import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model.dart';
import 'controller.dart';

class MyNote extends StatelessWidget {
  int index;
  MyNote({
    this.index
  });
  @override
  Widget build(BuildContext context) {
    final NoteController nc = Get.find();
    String text = "";
    text = index == null ? " " : nc.notes[index].title;
    TextEditingController textEditingController = new TextEditingController(text: text);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: index == null ? Text('Kreiraj novu belešku!') : Text('Izmeni belešku!'),
            ),
            body: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: < Widget > [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          //hintText: 'Kreiraj novu belesku!',
                          //labelText: 'Moja beleska',
                          border: OutlineInputBorder(
                          //    borderSide: BorderSide(color: Colors.black87),
                              //borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: < Widget > [
                          RaisedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Otkaži', style: TextStyle(color: Colors.white),),
                            color: Colors.red,
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (index == null) {
                                nc.notes.add(Note(title: textEditingController.text));
                              } else {
                                var updatenote = nc.notes[index];
                                updatenote.title = textEditingController.text;
                                nc.notes[index] = updatenote;
                              }
                              Get.back();
                            },
                            child: index == null ? Text('Dodaj', style: TextStyle(color: Colors.white),) : Text('Izmeni', style: TextStyle(color: Colors.white),),
                            color: Colors.green, )
                        ])
                  ],
                ),
              ),
            )));
  }
}