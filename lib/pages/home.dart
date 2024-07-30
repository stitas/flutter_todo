import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/pages/add_todo.dart';
import 'package:todo/widgets/custom_app_bar.dart';
import 'package:todo/widgets/custom_btn.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  String searchString = '';

  Future<void> _onDelete(TodoModel todo) async {
    await _databaseService.deleteTodo(todo.id);
    setState(() {});
  }

  Future<void> _onUpdate(List<TodoModel> list, int index) async {
    await _databaseService.updateTodo(TodoModel(
        id: list[index].id,
        title: list[index].title,
        description: list[index].description,
        creationDate: list[index].creationDate,
        isCompleted: list[index].isCompleted == 1 ? 0 : 1));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const CustomAppBar(),
            _searchField(),
            _todoList(),
            CustomBtn(
              text: 'Add TODO',
              callback: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTodo(btnText: 'Add',))).then((value) => setState(() {}));
              },
            )
          ],
        ));
  }

  Expanded _todoList() {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: FutureBuilder(
              future: _databaseService.retrieveTodos(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TodoModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) { 
                      if(snapshot.data![index].title.contains(searchString) || searchString == ''){
                        return SizedBox(
                          height: 15,
                        );
                      }
                      else {
                        return SizedBox(
                          height: 0,
                        );
                      }
                    },
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if(snapshot.data![index].title.contains(searchString) || searchString == ''){
                        return Container(
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    _onUpdate(snapshot.data!, index);
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          snapshot.data![index].isCompleted == 1
                                              ? Colors.green[200]
                                              : Colors.red[200],
                                    ),
                                    child: Text(
                                      snapshot.data![index].isCompleted == 1
                                          ? '✔'
                                          : '❌',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      snapshot.data![index].title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      snapshot.data![index].creationDate,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddTodo(
                                                  btnText: 'Update',
                                                  id: snapshot.data![index].id,
                                                  title: snapshot
                                                      .data![index].title,
                                                  description: snapshot
                                                      .data![index].description,
                                                  creationDate: snapshot
                                                      .data![index]
                                                      .creationDate,
                                                  isCompleted: snapshot
                                                      .data![index].isCompleted,
                                                ))).then((value) => setState(() {}));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    height: 40,
                                    width: 40,
                                    color: Colors.deepPurple,
                                    child: SvgPicture.asset(
                                        'assets/icons/edit.svg'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _onDelete(snapshot.data![index]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    height: 40,
                                    width: 40,
                                    color: Colors.red,
                                    child: SvgPicture.asset(
                                        'assets/icons/trash-can.svg'),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }
                    else {
                      return Container(
                        height: 0,
                        width: 0,  
                      );
                    }  
                    },
                  );
                }
                if (snapshot.hasError) return Text("error");
                return CircularProgressIndicator();
              },
            )));
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/Search.svg'),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
        onChanged: (value) {
          searchString = value;
          setState(() {});
        },
      ),
    );
  }
}
