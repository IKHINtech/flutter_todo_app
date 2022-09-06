import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/model/activity_model.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/themes.dart';
import 'package:todo_app/widget/button.dart';
import 'package:todo_app/widget/loading.dart';

class AddActivity extends StatefulWidget {
  final Activity activity;
  const AddActivity({Key? key, required this.activity}) : super(key: key);

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerItem = TextEditingController();

  final TodoBloc _todoBloc = TodoBloc();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CreateTodo todo = CreateTodo();
  final Todo data = Todo();
  bool isSelected = false;

  List<String> list = <String>[
    'Very High',
    'High',
    'Normal',
    'Low',
    'Very Low'
  ];

  fetchData() async {
    await _todoBloc.fetchTodo(widget.activity.id!);
  }

  deleteTodo(int id) async {
    await TodoService().deleteTodo(id);
  }

  showDeleteDialog(Todo todo) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [
              Image.asset('assets/images/modal-delete-icon.png'),
              SizedBox(
                height: 40,
              ),
              Text(
                'Apakah anda yakin ingin menghapus activity "${todo.title}" ?',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  modalButton(
                      callback: () => Navigator.pop(context),
                      text: 'Batal',
                      fcolor: Colors.black,
                      color: Colors.grey[300]),
                  modalButton(
                      callback: () async {
                        await deleteTodo(todo.id!);
                        Navigator.pop(context);
                        await showAlert();
                        await fetchData();
                      },
                      text: 'Hapus',
                      fcolor: Colors.white,
                      color: Colors.red)
                ],
              )
            ],
          ),
        );
      },
    );
  }

  showAlert() async {
    await showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          scrollable: false,
          // contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            width: 323,
            height: 58,
            // padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 13,
                ),
                Text('Activity berhasil dihapus')
              ],
            ),
          ),
        );
      },
    );
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
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NAMA LIST ITEM',
                  style: text10,
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Fill This Fields";
                    }
                    return null;
                  },
                  controller: controllerItem,
                  maxLines: 1,
                  onSaved: (value) {
                    todo.title = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Tambahkan nama list item',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide:
                          BorderSide(color: Color.fromRGBO(229, 229, 229, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 23,
                ),
                Text(
                  'Priority',
                  style: text10,
                ),
                SizedBox(
                  height: 12,
                ),
                DropdownButtonFormField<String>(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Fill This Fields";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value == 'Very High') {
                      todo.priority = 'very-high';
                    } else if (value == 'High') {
                      todo.priority = 'high';
                    } else if (value == 'Normal') {
                      todo.priority = 'normal';
                    } else if (value == 'Low') {
                      todo.priority = 'low';
                    } else {
                      todo.priority = 'very-low';
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(229, 229, 229, 1)),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(6.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Pilih priority",
                    // fillColor: Colors.blue[200],
                  ),
                  items: list.map<DropdownMenuItem<String>>((priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: priority == 'Very High'
                                    ? Colors.red
                                    : priority == 'High'
                                        ? Colors.orange
                                        : priority == 'Normal'
                                            ? Colors.green
                                            : priority == 'Low'
                                                ? Colors.blue
                                                : Colors.purple),
                            height: 5,
                            width: 5,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(priority)
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        _formKey.currentState!.save();
                        await TodoService().saveTodo(todo: todo);
                        Navigator.pop(context, true);
                        fetchData();
                      } catch (e) {
                        Text(e.toString());
                      }
                    }
                  },
                  child: Container(
                    height: 54,
                    width: 150,
                    // padding: EdgeInsets.only(
                    //     left: 15, top: 9.5, right: 15, bottom: 9.5),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(45),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Simpan',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showEditItemTodo(Todo todoData) async {
    controllerItem.text = todoData.title!;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit List Item',
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
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NAMA LIST ITEM',
                  style: text10,
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Fill This Fields";
                    }
                    return null;
                  },
                  controller: controllerItem,
                  maxLines: 1,
                  onSaved: (value) {
                    todoData.title = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Tambahkan nama list item',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide:
                          BorderSide(color: Color.fromRGBO(229, 229, 229, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 23,
                ),
                Text(
                  'Priority',
                  style: text10,
                ),
                SizedBox(
                  height: 12,
                ),
                DropdownButtonFormField<String>(
                  // selectedItemBuilder: (context) => ,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Fill This Fields";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value == 'Very High') {
                      todoData.priority = 'very-high';
                    } else if (value == 'High') {
                      todoData.priority = 'high';
                    } else if (value == 'Normal') {
                      todoData.priority = 'normal';
                    } else if (value == 'Low') {
                      todoData.priority = 'low';
                    } else {
                      todoData.priority = 'very-low';
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(229, 229, 229, 1)),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(6.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Pilih priority",
                    // fillColor: Colors.blue[200],
                  ),
                  items: list.map<DropdownMenuItem<String>>((priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: priority == 'Very High'
                                    ? Colors.red
                                    : priority == 'High'
                                        ? Colors.orange
                                        : priority == 'Normal'
                                            ? Colors.green
                                            : priority == 'Low'
                                                ? Colors.blue
                                                : Colors.purple),
                            height: 5,
                            width: 5,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(priority)
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        _formKey.currentState!.save();
                        await TodoService()
                            .updateTodo(todo: todoData, id: todoData.id!);
                        Navigator.pop(context, true);
                        fetchData();
                      } catch (e) {
                        Text(e.toString());
                      }
                    }
                  },
                  child: Container(
                    height: 54,
                    width: 150,
                    // padding: EdgeInsets.only(
                    //     left: 15, top: 9.5, right: 15, bottom: 9.5),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(45),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Simpan',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  updateTodo(Todo todo, int id) async {
    await TodoService().updateTodo(todo: todo, id: id);
  }

  @override
  void initState() {
    controller.text = widget.activity.title!;
    fetchData();
    todo.activityGroupId = widget.activity.id;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller.dispose();
    _todoBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget todoCard(
        {required TodoModel todoData,
        required int index,
        VoidCallback? callback}) {
      return InkWell(
        onTap: callback,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          child: ListTile(
            trailing: InkWell(
                onTap: () {
                  showDeleteDialog(todoData.data![index]);
                },
                child: Image.asset(
                    'assets/images/activity-item-delete-button.png')),
            leading: Checkbox(
              value: todoData.data![index].status,
              onChanged: (value) async {
                data.activityGroupId = todoData.data![index].activityGroupId;
                data.id = todoData.data![index].id!;
                if (todoData.data![index].isActive! == 0) {
                  data.isActive = 1;
                } else {
                  data.isActive = 0;
                }

                data.priority = todoData.data![index].priority!;
                data.title = todoData.data![index].title!;
                await updateTodo(data, todoData.data![index].id!);
                fetchData();
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: todoData.data![index].priority == 'very-high'
                          ? Colors.red
                          : todoData.data![index].priority == 'high'
                              ? Colors.orange
                              : todoData.data![index].priority == 'normal'
                                  ? Colors.green
                                  : todoData.data![index].priority == 'low'
                                      ? Colors.blue
                                      : Colors.purple),
                  height: 5,
                  width: 5,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  todoData.data![index].title!,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      decoration: todoData.data![index].status
                          ? TextDecoration.lineThrough
                          : null),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () async {
                      await showEditItemTodo(todoData.data![index]);
                    },
                    child:
                        Image.asset('assets/images/todo-item-edit-button.png'))
              ],
            ),
          ),
        ),
      );
    }

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
                    callback: () async {
                      await showAddItemTodo();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 44,
              ),
              Expanded(
                child: SingleChildScrollView(
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
                                      todoData: snapshot.data!, index: index));
                            }
                          } else if (snapshot.hasError) {
                            if (snapshot.error == 'LOADING') {
                              return loadingHexagon(color: primary);
                            } else {
                              return Text('TO DO DATA');
                            }
                          }
                          return loadingHexagon(color: primary);
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
