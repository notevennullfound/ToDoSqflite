import 'package:flutter/material.dart';
import 'package:to_do_shared_preferences/database.dart';

class MyToDo extends StatefulWidget {
  const MyToDo({Key? key}) : super(key: key);

  @override
  State<MyToDo> createState() => _MyToDoState();
}

class _MyToDoState extends State<MyToDo> {
  List<Map<String, dynamic>> list = [];

  bool _isLoading = true;

  void _refreshList() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      list = data;
      _isLoading = false;
    });
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal = list.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleController,
                    minLines: 2,
                    maxLines: 2,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.orange.shade50,
                        filled: true,
                        hintText: 'ENTER TITLE HERE'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.orange.shade50,
                        filled: true,
                        hintText: 'ENTER DESC HERE'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (id != null) {
                        DatabaseHelper.updateItem(id, _titleController.text,
                            _descriptionController.text);
                      } else {
                        DatabaseHelper.createItem(
                            _titleController.text, _descriptionController.text);
                      }
                      setState(() {
                        _refreshList();
                      });
                      _titleController.clear();
                      _descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('INSERT'))
              ],
            ),
          );
        });
  }

  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();

  @override
  void initState() {
    _refreshList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('TO DO'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Colors.orange.shade100,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () {
                          _showForm(list[index]['id']);
                        },
                        child: Icon(Icons.edit, color: Colors.green)),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: (){
                        DatabaseHelper.deleteItem(list[index]['id']);
                        _refreshList();
                        },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://miro.medium.com/v2/resize:fit:640/format:webp/1*in7MRIAKfRn-qDgJKc9XVw.jpeg'),
                ),
                title: Text(list[index]['title']),
                subtitle: Text(
                  list[index]['description'],
                )),
          );
        },
        itemCount: list.length,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showForm(null);
          },
          child: Icon(Icons.add)),
    );
  }
}
