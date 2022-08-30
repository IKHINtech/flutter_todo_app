import 'package:flutter/material.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/model/activity_model.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/themes.dart';
import 'package:todo_app/widget/button.dart';
import 'package:todo_app/widget/loading.dart';
import 'package:todo_app/widget/todo.dart';

class AddActivity extends StatefulWidget {
  final Activity activity;
  const AddActivity({Key? key, required this.activity}) : super(key: key);

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final TextEditingController controller = TextEditingController();
  final TodoBloc _todoBloc = TodoBloc();
  final ScrollController _scrollController = ScrollController();

  fetchData() async {
    await _todoBloc.fetchTodo(widget.activity.id!);
  }

  showAddItemTodo() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tambah List Item',
                style: text16,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.clear))
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.fromLTRB(22, 18, 22, 18),
          titlePadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    controller.text = widget.activity.title!;
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back_ios)),
          backgroundColor: primary,
          title: Text(
            widget.activity.title!,
            style: text18,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    suffixIcon:
                        Image.asset('assets/images/todo-item-edit-button.png'),
                    // labelText: 'label',
                    floatingLabelStyle: TextStyle(color: Colors.blue),
                    labelStyle: TextStyle(color: Colors.black45),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(216, 216, 216, 1),
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(216, 216, 216, 1)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 44,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(229, 229, 229, 1),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(45),
                      ),
                    ),
                    child: Image.asset('assets/images/Group.png'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  customButton(
                    callback: () {
                      showAddItemTodo();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 44,
              ),
              SingleChildScrollView(
                child: Container(
                  child: StreamBuilder<TodoModel>(
                      stream: _todoBloc.streamTodo,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.data!.isEmpty) {
                            return Image.asset(
                                'assets/images/todo-empty-state.png');
                          } else {
                            return ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: (context, index) => todoCard(
                                    todo: snapshot.data!, index: index));
                          }
                        } else if (snapshot.hasError) {
                          if (snapshot.error == 'LOADING') {
                            return Text('LOADING');
                          } else {
                            return Text('data');
                          }
                        }
                        return loadingHexagon(color: primary);
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
