import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc/activity_bloc.dart';
import 'package:todo_app/model/activity_model.dart';
import 'package:todo_app/services/activity_service.dart';
import 'package:todo_app/themes.dart';
import 'package:todo_app/ui/activity_page.dart';
import 'package:todo_app/widget/activity.dart';
import 'package:todo_app/widget/button.dart';
import 'package:todo_app/widget/loading.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ActivityBloc _activityBloc = ActivityBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final CreateActivity activity = CreateActivity();

  fetchData() async {
    await _activityBloc.fetchActivity();
  }

  showAddItemActivity() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tambah Activity',
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
                  'NAMA ACTIVITY',
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
                  controller: controller,
                  maxLines: 1,
                  onSaved: (value) {
                    activity.title = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Tambahkan nama activity',
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
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        _formKey.currentState!.save();
                        activity.email = 'yoga+1@skyshi.io';
                        await ActivityService().addActivity(activity);
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

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget activityCard(
        {required ActivityModel activity,
        required int index,
        VoidCallback? callback}) {
      DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(activity.data![index].createdAt!);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd MMM yyyy ');
      var outputDate = outputFormat.format(inputDate);
      return InkWell(
        onTap: callback,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  activity.data![index].title!,
                  style: text14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      outputDate,
                      style: text12,
                    ),
                    InkWell(
                      onTap: () async {
                        await ActivityService()
                            .deleteTodo(activity.data![index].id!);
                        // Navigator.pop(context);
                        fetchData();
                      },
                      child: Container(
                        child: Image.asset(
                            'assets/images/activity-item-delete-button.png'),
                      ),
                    )
                  ],
                )
              ],
            ),
            height: 150,
            width: 150,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: primary,
          title: Text(
            'TO DO LIST APP',
            style: text18,
          )),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity',
                  style: text16,
                ),
                customButton(callback: () {
                  showAddItemActivity();
                })
              ],
            ),
            SizedBox(
              height: 44,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: StreamBuilder<ActivityModel>(
                    stream: _activityBloc.streamActivity,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.data!.isEmpty) {
                          return Image.asset(
                              'assets/images/activity-empty-state.png');
                        } else {
                          return GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, index) {
                                return activityCard(
                                    activity: snapshot.data!,
                                    index: index,
                                    callback: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddActivity(
                                                    activity: snapshot
                                                        .data!.data![index],
                                                  )));
                                    });
                              });
                        }
                      } else if (snapshot.hasError) {
                        if (snapshot.error == 'LOADING') {
                          return loadingHexagon(color: primary);
                        } else {
                          return Text('data');
                        }
                      }
                      return loadingHexagon(color: primary);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
