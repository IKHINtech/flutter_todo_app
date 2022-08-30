import 'package:flutter/material.dart';
import 'package:todo_app/bloc/activity_bloc.dart';
import 'package:todo_app/model/activity_model.dart';
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

  fetchData() async {
    await _activityBloc.fetchActivity();
  }

  fetchDetail() async {}

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                customButton()
              ],
            ),
            SizedBox(
              height: 44,
            ),
            SingleChildScrollView(
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
            )
          ],
        ),
      ),
    );
  }
}
